package com.timetable.util;

import com.timetable.dao.*;
import com.timetable.model.*;

import java.time.DayOfWeek;
import java.time.LocalTime;

/**
 * FY BSc CS — First Year Sample Data Initializer
 *
 * Scenario: First Year BSc Computer Science, 3 Divisions (A, B, C)
 *
 * Subjects  : 6 theory papers, 4 lectures/week each
 * Divisions : A, B, C — each with its own classroom
 * Faculty   : 6 teachers — each owns one subject, teaches all 3 divisions
 * Time Slots: Monday–Saturday, 4 slots/day starting at 14:00 (2:00 PM), no break
 *             14:00–14:45, 14:45–15:30, 15:30–16:15, 16:15–17:00
 * Total     : 6 days × 4 slots = 24 weekly theory slots
 * Workloads : 18 (6 subjects × 3 divisions)
 * Total AI  : 72 lectures (18 workloads × 4 lectures each)
 */
public class FYSampleDataInitializer {

    public static void initialize() {
        System.out.println("=== Starting FY BSc CS Sample Data Initialization ===");
        try {
            BranchDao branchDao     = new BranchDao();
            DivisionDao divisionDao = new DivisionDao();
            FacultyDao facultyDao   = new FacultyDao();
            SubjectDao subjectDao   = new SubjectDao();
            RoomDao roomDao         = new RoomDao();
            StudentGroupDao groupDao = new StudentGroupDao();
            TimeSlotDao slotDao     = new TimeSlotDao();
            WorkloadDao workloadDao = new WorkloadDao();

            // Skip if FY division already seeded
            boolean fyAlreadyExists = divisionDao.findAll().stream()
                    .anyMatch(d -> "FY".equals(d.getYear()));
            if (fyAlreadyExists) {
                System.out.println("FY data already exists. Skipping initialization.");
                return;
            }

            // ─────────────────────────────────────────────────────
            // 1. BRANCH
            // ─────────────────────────────────────────────────────
            System.out.println("[1/8] Creating branch...");
            Branch cs = new Branch("BSC-CS", "BSc Computer Science", "Science");
            branchDao.save(cs);

            // ─────────────────────────────────────────────────────
            // 2. DIVISIONS (FY = First Year)
            // Using separate classroom numbers (101, 102, 103)
            // ─────────────────────────────────────────────────────
            System.out.println("[2/8] Creating FY divisions...");
            Division divA = new Division("A", cs, YearLevel.FY);
            divA.setCapacity(70);
            divA.setClassroom("101");
            divisionDao.save(divA);

            Division divB = new Division("B", cs, YearLevel.FY);
            divB.setCapacity(70);
            divB.setClassroom("102");
            divisionDao.save(divB);

            Division divC = new Division("C", cs, YearLevel.FY);
            divC.setCapacity(70);
            divC.setClassroom("103");
            divisionDao.save(divC);

            // ─────────────────────────────────────────────────────
            // 3. CLASSROOMS
            // ─────────────────────────────────────────────────────
            System.out.println("[3/8] Creating rooms...");
            mkRoom(roomDao, "Room 101", 70, Room.RoomType.CLASSROOM);
            mkRoom(roomDao, "Room 102", 70, Room.RoomType.CLASSROOM);
            mkRoom(roomDao, "Room 103", 70, Room.RoomType.CLASSROOM);

            // ─────────────────────────────────────────────────────
            // 4. FACULTY
            // ─────────────────────────────────────────────────────
            System.out.println("[4/8] Creating faculty...");
            Faculty mishra  = mkFaculty(facultyDao, "Prof. Kavita Mishra",   "kavita.mishra@college.edu",   "Computer Science");
            Faculty joshi   = mkFaculty(facultyDao, "Dr. Nitin Joshi",       "nitin.joshi@college.edu",     "Computer Science");
            Faculty rao     = mkFaculty(facultyDao, "Prof. Sunita Rao",      "sunita.rao@college.edu",      "Computer Science");
            Faculty verma   = mkFaculty(facultyDao, "Dr. Anil Verma",        "anil.verma@college.edu",      "Computer Science");
            Faculty patel   = mkFaculty(facultyDao, "Prof. Deepika Patel",   "deepika.patel@college.edu",   "Computer Science");
            Faculty nair    = mkFaculty(facultyDao, "Dr. Rajesh Nair",       "rajesh.nair@college.edu",     "Mathematics");

            // ─────────────────────────────────────────────────────
            // 5. SUBJECTS (FY — Semester 2 typical papers)
            // ─────────────────────────────────────────────────────
            System.out.println("[5/8] Creating FY subjects...");
            Subject c         = mkSubject(subjectDao, "C-PROG",   "C Programming",                4);
            Subject discrete  = mkSubject(subjectDao, "DM",       "Discrete Mathematics",         4);
            Subject dbms      = mkSubject(subjectDao, "DBMS",     "Database Management Systems",  4);
            Subject digital   = mkSubject(subjectDao, "DE",       "Digital Electronics",          4);
            Subject ds        = mkSubject(subjectDao, "DS",       "Data Structures",              4);
            Subject english   = mkSubject(subjectDao, "ENG",      "English & Communication",      4);

            // ─────────────────────────────────────────────────────
            // 6. STUDENT GROUPS (one per FY division)
            // ─────────────────────────────────────────────────────
            System.out.println("[6/8] Creating student groups...");
            StudentGroup grpA = mkGroup(groupDao, "FY BSc CS - Div A");
            StudentGroup grpB = mkGroup(groupDao, "FY BSc CS - Div B");
            StudentGroup grpC = mkGroup(groupDao, "FY BSc CS - Div C");

            // ─────────────────────────────────────────────────────
            // 7. TIME SLOTS — 2:00 PM onwards, 4 slots/day, NO break
            //    14:00–14:45, 14:45–15:30, 15:30–16:15, 16:15–17:00
            //    YearLevel = FY (so AI knows these belong to First Year)
            // ─────────────────────────────────────────────────────
            System.out.println("[7/8] Creating FY time slots (2:00 PM start, 4 per day, Mon-Sat)...");
            LocalTime[] startTimes = {
                    LocalTime.of(14, 0),   // Slot 1: 14:00 – 14:45
                    LocalTime.of(14, 45),  // Slot 2: 14:45 – 15:30
                    LocalTime.of(15, 30),  // Slot 3: 15:30 – 16:15
                    LocalTime.of(16, 15)   // Slot 4: 16:15 – 17:00
            };

            for (DayOfWeek day : DayOfWeek.values()) {
                if (day == DayOfWeek.SUNDAY) continue; // Mon–Sat
                for (LocalTime start : startTimes) {
                    TimeSlot ts = new TimeSlot();
                    ts.setDayOfWeek(day);
                    ts.setStartTime(start);
                    ts.setEndTime(start.plusMinutes(45));
                    ts.setDurationMinutes(45);
                    ts.setSessionType(SessionType.THEORY);
                    ts.setIsBreak(false);
                    ts.setYearLevel(YearLevel.FY);   // ← Tag as FY timeslot
                    slotDao.save(ts);
                }
            }
            System.out.println("   -> 24 FY theory time slots created (6 days x 4 slots each, starting 14:00)");

            // ─────────────────────────────────────────────────────
            // 8. WORKLOADS — 18 total (6 subjects × 3 divisions)
            // ─────────────────────────────────────────────────────
            System.out.println("[8/8] Creating FY workloads...");

            mkWorkload(workloadDao, mishra, c,        grpA, divA);
            mkWorkload(workloadDao, mishra, c,        grpB, divB);
            mkWorkload(workloadDao, mishra, c,        grpC, divC);

            mkWorkload(workloadDao, nair,   discrete, grpA, divA);
            mkWorkload(workloadDao, nair,   discrete, grpB, divB);
            mkWorkload(workloadDao, nair,   discrete, grpC, divC);

            mkWorkload(workloadDao, joshi,  dbms,     grpA, divA);
            mkWorkload(workloadDao, joshi,  dbms,     grpB, divB);
            mkWorkload(workloadDao, joshi,  dbms,     grpC, divC);

            mkWorkload(workloadDao, verma,  digital,  grpA, divA);
            mkWorkload(workloadDao, verma,  digital,  grpB, divB);
            mkWorkload(workloadDao, verma,  digital,  grpC, divC);

            mkWorkload(workloadDao, rao,    ds,       grpA, divA);
            mkWorkload(workloadDao, rao,    ds,       grpB, divB);
            mkWorkload(workloadDao, rao,    ds,       grpC, divC);

            mkWorkload(workloadDao, patel,  english,  grpA, divA);
            mkWorkload(workloadDao, patel,  english,  grpB, divB);
            mkWorkload(workloadDao, patel,  english,  grpC, divC);

            System.out.println("   -> 18 FY workloads created (6 subjects x 3 divisions)");
            System.out.println("   -> AI will schedule 72 FY lectures (18 x 4 lectures/week)");
            System.out.println("=== FY BSc CS Sample Data Initialized Successfully ===");

        } catch (Exception e) {
            System.err.println("ERROR in FYSampleDataInitializer:");
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize FY sample data", e);
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
