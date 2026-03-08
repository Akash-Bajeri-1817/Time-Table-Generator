package com.timetable.service;

import ai.timefold.solver.core.api.solver.Solver;
import ai.timefold.solver.core.api.solver.SolverFactory;
import ai.timefold.solver.core.config.solver.SolverConfig;
import ai.timefold.solver.core.config.solver.termination.TerminationConfig;

import com.timetable.model.*;
import com.timetable.solver.Timetable;
import com.timetable.solver.TimetableConstraintProvider;
import com.timetable.util.HibernateUtil;

import org.hibernate.Session;
import org.hibernate.Transaction;

import java.time.Duration;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

/**
 * AI-powered scheduler using Timefold.
 *
 * Room Assignment Policy:
 * Each division has ONE fixed room for the whole semester.
 * Room is pre-assigned before solving (NOT a planning variable).
 * The solver only decides WHICH TIME SLOT each lecture goes into.
 *
 * The room is matched by: division.classroom (e.g. "206") vs room.name (e.g.
 * "Room 206").
 * If no exact match, the first available CLASSROOM room is used as fallback.
 */
public class AiSchedulerService {

        public boolean generateTimetable() {
                System.out.println("\n========== AI TIMETABLE GENERATION START ==========");
                try {

                        // ── STEP 1: Load all problem facts ────────────────────────────────
                        List<TimeSlot> timeSlots;
                        List<Room> rooms;
                        List<Workload> workloads;

                        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
                                timeSlots = s.createQuery(
                                                "FROM com.timetable.model.TimeSlot ts " +
                                                                "WHERE (ts.isBreak IS NULL OR ts.isBreak = false) " +
                                                                "AND (ts.sessionType = :t OR ts.sessionType IS NULL)",
                                                TimeSlot.class)
                                                .setParameter("t", SessionType.THEORY)
                                                .list();

                                rooms = s.createQuery(
                                                "FROM com.timetable.model.Room r WHERE r.type = :type",
                                                Room.class)
                                                .setParameter("type", Room.RoomType.CLASSROOM)
                                                .list();

                                workloads = s.createQuery(
                                                "SELECT DISTINCT w FROM com.timetable.model.Workload w " +
                                                                "LEFT JOIN FETCH w.faculty " +
                                                                "LEFT JOIN FETCH w.subject " +
                                                                "LEFT JOIN FETCH w.studentGroup " +
                                                                "LEFT JOIN FETCH w.division " +
                                                                "LEFT JOIN FETCH w.batch " +
                                                                "WHERE (w.sessionType = :t OR w.sessionType IS NULL)",
                                                Workload.class)
                                                .setParameter("t", SessionType.THEORY)
                                                .list();
                        }

                        System.out.println("[STEP 1] Loaded — TimeSlots: " + timeSlots.size()
                                        + ", Classrooms: " + rooms.size()
                                        + ", Workloads: " + workloads.size());

                        if (timeSlots.isEmpty()) {
                                System.err.println("[ERROR] No theory time slots found. Load sample data first.");
                                return false;
                        }
                        if (rooms.isEmpty()) {
                                System.err.println("[ERROR] No CLASSROOM rooms found. Add rooms first.");
                                return false;
                        }
                        if (workloads.isEmpty()) {
                                System.err.println("[ERROR] No theory workloads found. Load sample data first.");
                                return false;
                        }

                        // ── STEP 2: Build division → fixed Room map ────────────────────────
                        //
                        // Division.classroom stores a room identifier like "206".
                        // Room.name stores "Room 206". We match by checking if name contains
                        // the division's classroom string.
                        // Fallback: first CLASSROOM room in the list.
                        Map<Long, Room> divisionRoomMap = new HashMap<>();
                        Room fallbackRoom = rooms.get(0);

                        for (Workload w : workloads) {
                                Division div = w.getDivision();
                                if (div == null || divisionRoomMap.containsKey(div.getId()))
                                        continue;

                                Room matched = fallbackRoom;
                                if (div.getClassroom() != null && !div.getClassroom().isEmpty()) {
                                        for (Room r : rooms) {
                                                if (r.getName() != null && r.getName().contains(div.getClassroom())) {
                                                        matched = r;
                                                        break;
                                                }
                                        }
                                }
                                divisionRoomMap.put(div.getId(), matched);
                                System.out.println("  [ROOM] Division " + div.getName()
                                                + " => " + matched.getName() + " (fixed for semester)");
                        }

                        // ── STEP 3: Clear old schedules ───────────────────────────────────
                        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
                                Transaction tx = s.beginTransaction();
                                int deleted = s.createQuery("DELETE FROM com.timetable.model.Schedule").executeUpdate();
                                tx.commit();
                                System.out.println("[STEP 3] Cleared " + deleted + " old schedule(s).");
                        }

                        // ── STEP 4: Build in-memory placeholders with ARTIFICIAL IDs ──────
                        //
                        // Timefold requires @PlanningId to be non-null before solve().
                        // We assign negative IDs (no DB insert) as temporary identifiers.
                        // Room is pre-assigned here — solver only assigns timeSlot.
                        List<Schedule> schedulesToSolve = new ArrayList<>();
                        AtomicLong tempId = new AtomicLong(-1L);

                        for (Workload workload : workloads) {
                                int count = workload.getSubject().getLecturesPerWeek();
                                Division div = workload.getDivision();

                                // Look up the pre-assigned room for this division
                                Room assignedRoom = (div != null && divisionRoomMap.containsKey(div.getId()))
                                                ? divisionRoomMap.get(div.getId())
                                                : fallbackRoom;

                                System.out.println("  [INFO] " + count + " lecture(s): "
                                                + workload.getSubject().getCode()
                                                + " | " + workload.getFaculty().getName()
                                                + " | Room=" + assignedRoom.getName());

                                for (int i = 0; i < count; i++) {
                                        Schedule placeholder = new Schedule();
                                        placeholder.setId(tempId.getAndDecrement()); // e.g. -1, -2, -3 …
                                        placeholder.setWorkload(workload);
                                        placeholder.setRoom(assignedRoom); // FIXED — solver won't change this
                                        placeholder.setDivision(div);
                                        placeholder.setBatch(workload.getBatch());
                                        placeholder.setSessionType(workload.getSessionType());
                                        // timeSlot stays NULL — Timefold assigns it
                                        schedulesToSolve.add(placeholder);
                                }
                        }
                        System.out.println("[STEP 4] Built " + schedulesToSolve.size()
                                        + " placeholder(s) with pre-assigned rooms.");

                        // ── STEP 5: Run the Timefold Solver ───────────────────────────────
                        SolverConfig config = new SolverConfig()
                                        .withSolutionClass(Timetable.class)
                                        .withEntityClasses(Schedule.class)
                                        .withConstraintProviderClass(TimetableConstraintProvider.class)
                                        .withTerminationConfig(new TerminationConfig()
                                                        .withSpentLimit(Duration.ofSeconds(30)));

                        System.out.println("[STEP 5] Starting Timefold AI solver (30 sec)...");
                        // Room is no longer a value range — pass only timeSlots
                        Timetable problem = new Timetable(timeSlots, schedulesToSolve);
                        Solver<Timetable> solver = SolverFactory.<Timetable>create(config).buildSolver();
                        Timetable solution = solver.solve(problem);

                        System.out.println("[STEP 5] Solver done! Hard: "
                                        + solution.getScore().hardScore()
                                        + " | Soft: " + solution.getScore().softScore());

                        // ── STEP 6: INSERT only fully-solved schedules as new DB rows ──────
                        //
                        // Create BRAND NEW Schedule objects (id = null) so Hibernate treats
                        // them as inserts and PostgreSQL generates real IDs.
                        int savedCount = 0;
                        int skippedCount = 0;

                        try (Session s = HibernateUtil.getSessionFactory().openSession()) {
                                Transaction tx = s.beginTransaction();

                                for (Schedule solved : solution.getScheduleList()) {
                                        if (solved.getTimeSlot() == null) {
                                                // Room is always pre-set; only timeSlot can be null after solving
                                                skippedCount++;
                                                System.out.println("  [WARN] Unassigned timeslot: "
                                                                + solved.getWorkload().getSubject().getCode());
                                                continue;
                                        }

                                        Schedule row = new Schedule();
                                        row.setWorkload(s.get(Workload.class, solved.getWorkload().getId()));
                                        row.setTimeSlot(s.get(TimeSlot.class, solved.getTimeSlot().getId()));
                                        row.setRoom(s.get(Room.class, solved.getRoom().getId()));
                                        row.setSessionType(solved.getSessionType());

                                        if (solved.getDivision() != null)
                                                row.setDivision(s.get(Division.class, solved.getDivision().getId()));
                                        if (solved.getBatch() != null)
                                                row.setBatch(s.get(Batch.class, solved.getBatch().getId()));

                                        s.persist(row);
                                        savedCount++;
                                }

                                tx.commit();
                        }

                        System.out.println("[STEP 6] Saved " + savedCount
                                        + " schedule(s). Skipped: " + skippedCount);
                        System.out.println("========== AI TIMETABLE GENERATION COMPLETE ==========\n");

                        return solution.getScore().hardScore() >= 0;

                } catch (Exception e) {
                        System.err.println("[FATAL] AiSchedulerService.generateTimetable() threw an exception:");
                        e.printStackTrace();
                        return false;
                }
        }
}
