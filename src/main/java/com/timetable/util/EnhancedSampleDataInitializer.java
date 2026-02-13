package com.timetable.util;

import com.timetable.dao.*;
import com.timetable.model.*;

import java.time.DayOfWeek;
import java.time.LocalTime;

public class EnhancedSampleDataInitializer {

    public static void initialize() {
        System.out.println("=== Starting Enhanced Sample Data Initialization ===");
        try {
            // Initialize DAOs
            BranchDao branchDao = new BranchDao();
            DivisionDao divisionDao = new DivisionDao();
            BatchDao batchDao = new BatchDao();
            FacultyDao facultyDao = new FacultyDao();
            SubjectDao subjectDao = new SubjectDao();
            RoomDao roomDao = new RoomDao();
            StudentGroupDao groupDao = new StudentGroupDao();
            TimeSlotDao timeSlotDao = new TimeSlotDao();
            WorkloadDao workloadDao = new WorkloadDao();

            // 1. Create Branch
            System.out.println("Creating branch...");
            Branch csBranch = new Branch("CS", "Computer Science", "Science");
            branchDao.save(csBranch);
            System.out.println("Branch created: " + csBranch.getName());

            // 2. Create Divisions (TY CS - Div A, B, C)
            System.out.println("Creating divisions...");
            Division divA = new Division("A", csBranch, YearLevel.TY);
            divA.setCapacity(60);
            divA.setClassroom("206");
            divisionDao.save(divA);

            Division divB = new Division("B", csBranch, YearLevel.TY);
            divB.setCapacity(60);
            divB.setClassroom("301");
            divisionDao.save(divB);

            Division divC = new Division("C", csBranch, YearLevel.TY);
            divC.setCapacity(60);
            divC.setClassroom("302");
            divisionDao.save(divC);
            System.out.println("Divisions created: 3");

            // 3. Create Batches for each division
            System.out.println("Creating batches...");
            // Div A batches
            batchDao.save(new Batch("A01-A30", divA, 1, 30));
            batchDao.save(new Batch("A31-A60", divA, 31, 60));

            // Div B batches
            batchDao.save(new Batch("B01-B30", divB, 1, 30));
            batchDao.save(new Batch("B31-B60", divB, 31, 60));

            // Div C batches
            batchDao.save(new Batch("C01-C30", divC, 1, 30));
            batchDao.save(new Batch("C31-C60", divC, 31, 60));
            System.out.println("Batches created: 6");

            // 4. Create Theory Time Slots (Mon-Sat, 3 slots)
            System.out.println("Creating theory time slots...");
            LocalTime[] theoryTimes = {
                    LocalTime.of(8, 45),
                    LocalTime.of(9, 30),
                    LocalTime.of(10, 15)
            };

            for (DayOfWeek day : DayOfWeek.values()) {
                if (day == DayOfWeek.SUNDAY)
                    continue;
                for (LocalTime start : theoryTimes) {
                    TimeSlot ts = new TimeSlot();
                    ts.setDayOfWeek(day);
                    ts.setStartTime(start);
                    ts.setEndTime(start.plusMinutes(45));
                    ts.setDurationMinutes(45);
                    ts.setSessionType(SessionType.THEORY);
                    ts.setIsBreak(false);
                    timeSlotDao.save(ts);
                }
            }
            System.out.println("Theory time slots created");

            // 5. Create Practical Time Slots (Mon-Sat, 12:30-15:00)
            System.out.println("Creating practical time slots...");
            for (DayOfWeek day : DayOfWeek.values()) {
                if (day == DayOfWeek.SUNDAY)
                    continue;
                TimeSlot practicalSlot = new TimeSlot();
                practicalSlot.setDayOfWeek(day);
                practicalSlot.setStartTime(LocalTime.of(12, 30));
                practicalSlot.setEndTime(LocalTime.of(15, 0));
                practicalSlot.setDurationMinutes(150);
                practicalSlot.setSessionType(SessionType.PRACTICAL);
                practicalSlot.setIsBreak(false);
                timeSlotDao.save(practicalSlot);
            }
            System.out.println("Practical time slots created");

            // 6. Create Faculty
            System.out.println("Creating faculty...");
            Faculty shubham = createFaculty(facultyDao, "Shubham B.(A)", "shubham@college.edu", "Computer Science");
            Faculty suwarna = createFaculty(facultyDao, "Suwarna K.(A)", "suwarna@college.edu", "Computer Science");
            Faculty shilpa = createFaculty(facultyDao, "Shilpa P.(A,B,C)", "shilpa@college.edu", "Computer Science");
            Faculty sarita = createFaculty(facultyDao, "Sarita B.(A)", "sarita@college.edu", "Computer Science");
            Faculty neha = createFaculty(facultyDao, "Neha K.(B)", "neha@college.edu", "Computer Science");
            Faculty dhruvi = createFaculty(facultyDao, "Dhruvi J.(C)", "dhruvi@college.edu", "Computer Science");
            Faculty monali = createFaculty(facultyDao, "Monali C.(C)", "monali@college.edu", "Computer Science");
            System.out.println("Faculty created: " + facultyDao.findAll().size());

            // 7. Create Subjects
            System.out.println("Creating subjects...");
            Subject osII = createSubject(subjectDao, "OS-II", "Operating System II", "Computer Science", 4, false);
            Subject advJava = createSubject(subjectDao, "ADV. JAVA", "Advanced Java", "Computer Science", 4, false);
            Subject wtII = createSubject(subjectDao, "WT-II", "Web Technology II", "Computer Science", 4, false);
            Subject da = createSubject(subjectDao, "DA", "Data Analytics", "Computer Science", 4, false);
            Subject cc = createSubject(subjectDao, "CC", "Cloud Computing", "Computer Science", 4, false);
            Subject stt = createSubject(subjectDao, "STT", "Software Testing Tools", "Computer Science", 4, false);

            // Practical subjects
            Subject osLab = createSubject(subjectDao, "OS (Lab2)", "OS Lab", "Computer Science", 3, true);
            Subject javaLab = createSubject(subjectDao, "JAVA (Lab3)", "Java Lab", "Computer Science", 3, true);
            System.out.println("Subjects created: " + subjectDao.findAll().size());

            // 8. Create Rooms
            System.out.println("Creating rooms...");
            Room room206 = createRoom(roomDao, "Room 206", 60, Room.RoomType.CLASSROOM);
            Room room301 = createRoom(roomDao, "Room 301", 60, Room.RoomType.CLASSROOM);
            Room room302 = createRoom(roomDao, "Room 302", 60, Room.RoomType.CLASSROOM);
            Room lab1 = createRoom(roomDao, "Lab 1", 30, Room.RoomType.LAB);
            Room lab2 = createRoom(roomDao, "Lab 2", 30, Room.RoomType.LAB);
            System.out.println("Rooms created: " + roomDao.findAll().size());

            // 9. Create Student Groups (one per division)
            System.out.println("Creating student groups...");
            StudentGroup groupA = createGroup(groupDao, "TY BSc CS - Div A");
            StudentGroup groupB = createGroup(groupDao, "TY BSc CS - Div B");
            StudentGroup groupC = createGroup(groupDao, "TY BSc CS - Div C");
            System.out.println("Student groups created: " + groupDao.findAll().size());

            // 10. Create Workloads (Theory - Division based)
            System.out.println("Creating theory workloads...");
            // Division A
            createWorkload(workloadDao, shubham, osII, groupA, divA, null, SessionType.THEORY);
            createWorkload(workloadDao, suwarna, advJava, groupA, divA, null, SessionType.THEORY);
            createWorkload(workloadDao, shilpa, wtII, groupA, divA, null, SessionType.THEORY);
            createWorkload(workloadDao, sarita, da, groupA, divA, null, SessionType.THEORY);
            createWorkload(workloadDao, shilpa, cc, groupA, divA, null, SessionType.THEORY);
            createWorkload(workloadDao, suwarna, stt, groupA, divA, null, SessionType.THEORY);

            // Division B
            createWorkload(workloadDao, shubham, osII, groupB, divB, null, SessionType.THEORY);
            createWorkload(workloadDao, suwarna, advJava, groupB, divB, null, SessionType.THEORY);
            createWorkload(workloadDao, shilpa, wtII, groupB, divB, null, SessionType.THEORY);
            createWorkload(workloadDao, neha, da, groupB, divB, null, SessionType.THEORY);
            createWorkload(workloadDao, neha, cc, groupB, divB, null, SessionType.THEORY);
            createWorkload(workloadDao, suwarna, stt, groupB, divB, null, SessionType.THEORY);

            // Division C
            createWorkload(workloadDao, shubham, osII, groupC, divC, null, SessionType.THEORY);
            createWorkload(workloadDao, suwarna, advJava, groupC, divC, null, SessionType.THEORY);
            createWorkload(workloadDao, shilpa, wtII, groupC, divC, null, SessionType.THEORY);
            createWorkload(workloadDao, dhruvi, da, groupC, divC, null, SessionType.THEORY);
            createWorkload(workloadDao, monali, cc, groupC, divC, null, SessionType.THEORY);
            createWorkload(workloadDao, suwarna, stt, groupC, divC, null, SessionType.THEORY);

            System.out.println("Theory workloads created: 18");

            System.out.println("=== Enhanced Sample Data Initialization Completed ===");
        } catch (Exception e) {
            System.err.println("ERROR in EnhancedSampleDataInitializer:");
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize enhanced sample data", e);
        }
    }

    private static Faculty createFaculty(FacultyDao dao, String name, String email, String department) {
        Faculty f = new Faculty();
        f.setName(name);
        f.setEmail(email);
        f.setDepartment(department);
        dao.save(f);
        return f;
    }

    private static Subject createSubject(SubjectDao dao, String code, String name, String department, int lectures,
            boolean isPractical) {
        Subject s = new Subject();
        s.setCode(code);
        s.setName(name);
        s.setDepartment(department);
        s.setLecturesPerWeek(lectures);
        s.setPractical(isPractical);
        dao.save(s);
        return s;
    }

    private static Room createRoom(RoomDao dao, String name, int capacity, Room.RoomType type) {
        Room r = new Room();
        r.setName(name);
        r.setCapacity(capacity);
        r.setType(type);
        dao.save(r);
        return r;
    }

    private static StudentGroup createGroup(StudentGroupDao dao, String name) {
        StudentGroup g = new StudentGroup();
        g.setName(name);
        dao.save(g);
        return g;
    }

    private static Workload createWorkload(WorkloadDao dao, Faculty faculty, Subject subject, StudentGroup group,
            Division division, Batch batch, SessionType sessionType) {
        Workload w = new Workload();
        w.setFaculty(faculty);
        w.setSubject(subject);
        w.setStudentGroup(group);
        w.setDivision(division);
        w.setBatch(batch);
        w.setSessionType(sessionType);
        dao.save(w);
        return w;
    }
}
