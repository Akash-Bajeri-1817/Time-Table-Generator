package com.timetable.util;

import com.timetable.dao.*;
import com.timetable.model.*;
import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.Arrays;
import java.util.List;

public class SampleDataInitializer {

    public static void initialize() {
        System.out.println("=== Starting SampleDataInitializer ===");
        try {
            FacultyDao facultyDao = new FacultyDao();
            SubjectDao subjectDao = new SubjectDao();
            RoomDao roomDao = new RoomDao();
            StudentGroupDao groupDao = new StudentGroupDao();
            TimeSlotDao timeSlotDao = new TimeSlotDao();
            WorkloadDao workloadDao = new WorkloadDao();

            // 1. Create TimeSlots (Mon-Fri, 4 slots a day)
            if (timeSlotDao.findAll().isEmpty()) {
                System.out.println("Creating time slots...");
                LocalTime[] startTimes = { LocalTime.of(9, 0), LocalTime.of(10, 0), LocalTime.of(11, 0),
                        LocalTime.of(12, 0) };
                for (DayOfWeek day : DayOfWeek.values()) {
                    if (day == DayOfWeek.SATURDAY || day == DayOfWeek.SUNDAY)
                        continue;
                    for (LocalTime start : startTimes) {
                        TimeSlot ts = new TimeSlot();
                        ts.setDayOfWeek(day);
                        ts.setStartTime(start);
                        ts.setEndTime(start.plusHours(1));
                        timeSlotDao.save(ts);
                    }
                }
                System.out.println("Time slots created: " + timeSlotDao.findAll().size());
            }

            // 2. Create Faculty
            if (facultyDao.findAll().isEmpty()) {
                System.out.println("Creating faculty...");
                createFaculty(facultyDao, "Dr. Smith", "smith@college.edu", "Computer Science");
                createFaculty(facultyDao, "Prof. Johnson", "johnson@college.edu", "Computer Science");
                createFaculty(facultyDao, "Dr. Williams", "williams@college.edu", "Mathematics");
                System.out.println("Faculty created: " + facultyDao.findAll().size());
            }

            // 3. Create Subjects
            if (subjectDao.findAll().isEmpty()) {
                System.out.println("Creating subjects...");
                createSubject(subjectDao, "CS101", "Intro to Java", "Computer Science", 3, false);
                createSubject(subjectDao, "CS101L", "Java Lab", "Computer Science", 2, true);
                createSubject(subjectDao, "MATH201", "Calculus", "Mathematics", 4, false);
                System.out.println("Subjects created: " + subjectDao.findAll().size());
            }

            // 4. Create Rooms
            if (roomDao.findAll().isEmpty()) {
                System.out.println("Creating rooms...");
                createRoom(roomDao, "Room 101", 60, Room.RoomType.CLASSROOM);
                createRoom(roomDao, "Room 102", 60, Room.RoomType.CLASSROOM);
                createRoom(roomDao, "Lab 201", 30, Room.RoomType.LAB);
                System.out.println("Rooms created: " + roomDao.findAll().size());
            }

            // 5. Create Student Groups
            if (groupDao.findAll().isEmpty()) {
                System.out.println("Creating student groups...");
                createGroup(groupDao, "FY BSc CS");
                createGroup(groupDao, "SY BSc CS");
                System.out.println("Student groups created: " + groupDao.findAll().size());
            }

            // 6. Create Workloads (Assigning subjects to faculty and groups)
            if (workloadDao.findAll().isEmpty()) {
                System.out.println("Creating workloads...");
                Faculty smith = facultyDao.findAll().stream().filter(f -> f.getName().contains("Smith")).findFirst()
                        .orElse(null);
                Faculty johnson = facultyDao.findAll().stream().filter(f -> f.getName().contains("Johnson"))
                        .findFirst().orElse(null);

                Subject java = subjectDao.findAll().stream().filter(s -> s.getCode().equals("CS101")).findFirst()
                        .orElse(null);
                Subject javaLab = subjectDao.findAll().stream().filter(s -> s.getCode().equals("CS101L")).findFirst()
                        .orElse(null);

                StudentGroup fy = groupDao.findAll().stream().filter(g -> g.getName().contains("FY")).findFirst()
                        .orElse(null);

                if (smith != null && java != null && fy != null) {
                    Workload w1 = new Workload();
                    w1.setFaculty(smith);
                    w1.setSubject(java);
                    w1.setStudentGroup(fy);
                    workloadDao.save(w1);
                    System.out.println("Created workload: Smith -> Java -> FY");
                }

                if (johnson != null && javaLab != null && fy != null) {
                    Workload w2 = new Workload();
                    w2.setFaculty(johnson);
                    w2.setSubject(javaLab);
                    w2.setStudentGroup(fy);
                    workloadDao.save(w2);
                    System.out.println("Created workload: Johnson -> Java Lab -> FY");
                }
                System.out.println("Workloads created: " + workloadDao.findAll().size());
            }

            System.out.println("=== SampleDataInitializer completed successfully ===");
        } catch (Exception e) {
            System.err.println("ERROR in SampleDataInitializer:");
            e.printStackTrace();
            throw new RuntimeException("Failed to initialize sample data", e);
        }
    }

    private static void createFaculty(FacultyDao dao, String name, String email, String dept) {
        Faculty f = new Faculty();
        f.setName(name);
        f.setEmail(email);
        f.setDepartment(dept);
        dao.save(f);
    }

    private static void createSubject(SubjectDao dao, String code, String name, String dept, int lectures,
            boolean isPractical) {
        Subject s = new Subject();
        s.setCode(code);
        s.setName(name);
        s.setDepartment(dept);
        s.setLecturesPerWeek(lectures);
        s.setPractical(isPractical);
        dao.save(s);
    }

    private static void createRoom(RoomDao dao, String name, int capacity, Room.RoomType type) {
        Room r = new Room();
        r.setName(name);
        r.setCapacity(capacity);
        r.setType(type);
        dao.save(r);
    }

    private static void createGroup(StudentGroupDao dao, String name) {
        StudentGroup g = new StudentGroup();
        g.setName(name);
        dao.save(g);
    }
}
