package com.timetable.util;

import com.timetable.dao.*;
import com.timetable.model.*;

import java.time.DayOfWeek;
import java.time.LocalTime;

/**
 * TY BSc CS — Realistic Sample Data Initializer
 *
 * Scenario: Third Year BSc Computer Science, 3 Divisions (A, B, C)
 *
 * Subjects : 6 theory papers, 4 lectures/week each
 * Divisions : A, B, C — each with its own classroom
 * Faculty : 6 teachers — each owns one subject, teaches all 3 divisions
 * Time Slots : Monday–Saturday, 6 slots/day = 36 weekly slots per division
 * Workloads : 18 (6 subjects × 3 divisions)
 * Total AI : 72 lectures to schedule (18 workloads × 4 lectures each)
 *
 * Key constraints the AI must satisfy:
 * - Dr. Sharma cannot teach OS-II to Div A and Div B at the same time
 * - Div A cannot have two subjects in the same slot (student conflict)
 * - Room 206 cannot host two classes simultaneously (room conflict)
 */
public class SampleDataInitializer {

    public static void initialize() {
        System.out.println("=== Starting TY BSc CS Sample Data Initialization ===");
        try {
            BranchDao branchDao = new BranchDao();
            DivisionDao divisionDao = new DivisionDao();
            FacultyDao facultyDao = new FacultyDao();
            SubjectDao subjectDao = new SubjectDao();
            RoomDao roomDao = new RoomDao();
            StudentGroupDao groupDao = new StudentGroupDao();
            TimeSlotDao slotDao = new TimeSlotDao();
            WorkloadDao workloadDao = new WorkloadDao();

            // Skip if data already seeded
            if (!facultyDao.findAll().isEmpty()) {
                System.out.println("Data already exists. Skipping initialization.");
                return;
            }

            // ─────────────────────────────────────────────────────
            // 1. BRANCH
            // ─────────────────────────────────────────────────────
            System.out.println("[1/8] Creating branch...");
            Branch cs = new Branch("BSC-CS", "BSc Computer Science", "Science");
            branchDao.save(cs);

            // ─────────────────────────────────────────────────────
            // 2. DIVISIONS (TY = Third Year)
            // ─────────────────────────────────────────────────────
            System.out.println("[2/8] Creating divisions...");
            Division divA = new Division("A", cs, YearLevel.TY);
            divA.setCapacity(65);
            divA.setClassroom("206");
            divisionDao.save(divA);

            Division divB = new Division("B", cs, YearLevel.TY);
            divB.setCapacity(65);
            divB.setClassroom("301");
            divisionDao.save(divB);

            Division divC = new Division("C", cs, YearLevel.TY);
            divC.setCapacity(65);
            divC.setClassroom("302");
            divisionDao.save(divC);

            // ─────────────────────────────────────────────────────
            // 3. CLASSROOMS (one per division)
            // ─────────────────────────────────────────────────────
            System.out.println("[3/8] Creating rooms...");
            mkRoom(roomDao, "Room 206", 65, Room.RoomType.CLASSROOM);
            mkRoom(roomDao, "Room 301", 65, Room.RoomType.CLASSROOM);
            mkRoom(roomDao, "Room 302", 65, Room.RoomType.CLASSROOM);

            // ─────────────────────────────────────────────────────
            // 4. FACULTY (one dedicated teacher per subject)
            // ─────────────────────────────────────────────────────
            System.out.println("[4/8] Creating faculty...");
            Faculty sharma = mkFaculty(facultyDao, "Dr. Priya Sharma", "priya.sharma@college.edu", "Computer Science");
            Faculty mehta = mkFaculty(facultyDao, "Prof. Rahul Mehta", "rahul.mehta@college.edu", "Computer Science");
            Faculty singh = mkFaculty(facultyDao, "Dr. Anjali Singh", "anjali.singh@college.edu", "Computer Science");
            Faculty kumar = mkFaculty(facultyDao, "Prof. Suresh Kumar", "suresh.kumar@college.edu", "Computer Science");
            Faculty patil = mkFaculty(facultyDao, "Dr. Meena Patil", "meena.patil@college.edu", "Computer Science");
            Faculty desai = mkFaculty(facultyDao, "Prof. Amit Desai", "amit.desai@college.edu", "Computer Science");

            // ─────────────────────────────────────────────────────
            // 5. SUBJECTS (4 lectures / week each)
            // ─────────────────────────────────────────────────────
            System.out.println("[5/8] Creating subjects...");
            Subject osII = mkSubject(subjectDao, "OS-II", "Operating System II", 4);
            Subject javaII = mkSubject(subjectDao, "JAVA-II", "Advanced Java", 4);
            Subject wtII = mkSubject(subjectDao, "WT-II", "Web Technology II", 4);
            Subject tcsII = mkSubject(subjectDao, "TCS-II", "Theory of Computation", 4);
            Subject da = mkSubject(subjectDao, "DA", "Data Analysis", 4);
            Subject st = mkSubject(subjectDao, "ST", "Software Testing", 4);

            // ─────────────────────────────────────────────────────
            // 6. STUDENT GROUPS (one per division)
            // ─────────────────────────────────────────────────────
            System.out.println("[6/8] Creating student groups...");
            StudentGroup grpA = mkGroup(groupDao, "TY BSc CS - Div A");
            StudentGroup grpB = mkGroup(groupDao, "TY BSc CS - Div B");
            StudentGroup grpC = mkGroup(groupDao, "TY BSc CS - Div C");

            // ─────────────────────────────────────────────────────
            // 7. TIME SLOTS — Mon to Sat, EXACTLY 4 slots / day
            //
            // 6 days x 4 slots = 24 total slots per division.
            // 6 subjects x 4 lec/week = 24 lectures needed per division.
            // 24 slots x 3 rooms = 72 total capacity = 72 total lectures.
            //
            // With zero slack the solver MUST fill every slot, which means
            // all 3 divisions are always in class at the same times.
            // College start = 08:45, end = 12:00 — same for every division.
            // ─────────────────────────────────────────────────────
            System.out.println("[7/8] Creating time slots (4 per day, Mon-Sat)...");
            LocalTime[] startTimes = {
                    LocalTime.of(8, 45), // Slot 1: 08:45 – 09:30
                    LocalTime.of(9, 30), // Slot 2: 09:30 – 10:15
                    LocalTime.of(10, 15), // Slot 3: 10:15 – 11:00
                    LocalTime.of(11, 15) // Slot 4: 11:15 – 12:00 (15-min break after slot 3)
            };

            for (DayOfWeek day : DayOfWeek.values()) {
                if (day == DayOfWeek.SUNDAY)
                    continue; // Mon–Sat
                for (LocalTime start : startTimes) {
                    TimeSlot ts = new TimeSlot();
                    ts.setDayOfWeek(day);
                    ts.setStartTime(start);
                    ts.setEndTime(start.plusMinutes(45));
                    ts.setDurationMinutes(45);
                    ts.setSessionType(SessionType.THEORY);
                    ts.setIsBreak(false);
                    slotDao.save(ts);
                }
            }
            System.out.println("   -> 24 theory time slots created (6 days x 4 slots each)");

            // ─────────────────────────────────────────────────────
            // 8. WORKLOADS — 18 total (6 subjects × 3 divisions)
            // Each teacher owns one subject and teaches all 3 divs.
            // The AI solver must ensure no teacher teaches two
            // divisions at the same time slot.
            // ─────────────────────────────────────────────────────
            System.out.println("[8/8] Creating workloads...");

            // Dr. Priya Sharma → OS-II (all divisions)
            mkWorkload(workloadDao, sharma, osII, grpA, divA);
            mkWorkload(workloadDao, sharma, osII, grpB, divB);
            mkWorkload(workloadDao, sharma, osII, grpC, divC);

            // Prof. Rahul Mehta → Advanced Java (all divisions)
            mkWorkload(workloadDao, mehta, javaII, grpA, divA);
            mkWorkload(workloadDao, mehta, javaII, grpB, divB);
            mkWorkload(workloadDao, mehta, javaII, grpC, divC);

            // Dr. Anjali Singh → Web Technology II (all divisions)
            mkWorkload(workloadDao, singh, wtII, grpA, divA);
            mkWorkload(workloadDao, singh, wtII, grpB, divB);
            mkWorkload(workloadDao, singh, wtII, grpC, divC);

            // Prof. Suresh Kumar → Theory of Computation (all divisions)
            mkWorkload(workloadDao, kumar, tcsII, grpA, divA);
            mkWorkload(workloadDao, kumar, tcsII, grpB, divB);
            mkWorkload(workloadDao, kumar, tcsII, grpC, divC);

            // Dr. Meena Patil → Data Analysis (all divisions)
            mkWorkload(workloadDao, patil, da, grpA, divA);
            mkWorkload(workloadDao, patil, da, grpB, divB);
            mkWorkload(workloadDao, patil, da, grpC, divC);

            // Prof. Amit Desai → Software Testing (all divisions)
            mkWorkload(workloadDao, desai, st, grpA, divA);
            mkWorkload(workloadDao, desai, st, grpB, divB);
            mkWorkload(workloadDao, desai, st, grpC, divC);

            System.out.println("   → 18 workloads created (6 subjects × 3 divisions)");
            System.out.println("   → AI will schedule 72 lectures (18 × 4 lectures/week)");
            System.out.println("=== TY BSc CS Sample Data Initialized Successfully ===");

        } catch (Exception e) {
            System.err.println("ERROR in SampleDataInitializer:");
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize sample data", e);
        }
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    private static Faculty mkFaculty(FacultyDao dao, String name, String email, String dept) {
        Faculty f = new Faculty();
        f.setName(name);
        f.setEmail(email);
        f.setDepartment(dept);
        dao.save(f);
        return f;
    }

    private static Subject mkSubject(SubjectDao dao, String code, String name, int lectures) {
        Subject s = new Subject();
        s.setCode(code);
        s.setName(name);
        s.setDepartment("Computer Science");
        s.setLecturesPerWeek(lectures);
        s.setPractical(false);
        dao.save(s);
        return s;
    }

    private static Room mkRoom(RoomDao dao, String name, int cap, Room.RoomType type) {
        Room r = new Room();
        r.setName(name);
        r.setCapacity(cap);
        r.setType(type);
        dao.save(r);
        return r;
    }

    private static StudentGroup mkGroup(StudentGroupDao dao, String name) {
        StudentGroup g = new StudentGroup();
        g.setName(name);
        dao.save(g);
        return g;
    }

    private static void mkWorkload(WorkloadDao dao, Faculty faculty, Subject subject,
            StudentGroup group, Division division) {
        Workload w = new Workload();
        w.setFaculty(faculty);
        w.setSubject(subject);
        w.setStudentGroup(group);
        w.setDivision(division);
        w.setSessionType(SessionType.THEORY);
        dao.save(w);
    }
}
