package com.timetable.service;

import java.time.DayOfWeek;
import java.util.*;
import java.util.stream.Collectors;

import com.timetable.dao.*;
import com.timetable.model.*;

/**
 * Enhanced Scheduler Service with Subject Variety Optimization
 * Ensures students don't get bored with back-to-back lectures of same subject
 */
public class EnhancedSchedulerService {
    private final WorkloadDao workloadDao = new WorkloadDao();
    private final RoomDao roomDao = new RoomDao();
    private final TimeSlotDao timeSlotDao = new TimeSlotDao();
    private final ScheduleDao scheduleDao = new ScheduleDao();
    private final DivisionDao divisionDao = new DivisionDao();

    public boolean generateDivisionBasedTimetable() {
        try {
            System.out.println("=== Starting Division-Based Timetable Generation ===");

            // 1. Clear existing schedules
            scheduleDao.deleteAll();
            System.out.println("Cleared existing schedules");

            // 2. Fetch all data
            List<Workload> allWorkloads = workloadDao.findAll();
            List<Room> allRooms = roomDao.findAll();
            List<TimeSlot> allTimeSlots = timeSlotDao.findAll();
            List<Division> allDivisions = divisionDao.findAll();

            System.out.println("Fetched - Workloads: " + allWorkloads.size() +
                    ", Rooms: " + allRooms.size() +
                    ", TimeSlots: " + allTimeSlots.size() +
                    ", Divisions: " + allDivisions.size());

            if (allWorkloads.isEmpty() || allRooms.isEmpty() || allTimeSlots.isEmpty()) {
                System.out.println("Insufficient data to generate timetable");
                return false;
            }

            // 3. Get theory time slots only
            List<TimeSlot> theorySlots = allTimeSlots.stream()
                    .filter(ts -> ts.getSessionType() == SessionType.THEORY)
                    .sorted(Comparator.comparing(TimeSlot::getDayOfWeek)
                            .thenComparing(TimeSlot::getStartTime))
                    .collect(Collectors.toList());

            System.out.println("Theory slots: " + theorySlots.size());

            // 4. Get classrooms only
            List<Room> classrooms = allRooms.stream()
                    .filter(r -> r.getType() == Room.RoomType.CLASSROOM)
                    .collect(Collectors.toList());

            // 5. Get theory workloads only
            List<Workload> theoryWorkloads = allWorkloads.stream()
                    .filter(w -> w.getSessionType() == SessionType.THEORY)
                    .collect(Collectors.toList());

            System.out.println("Processing " + theoryWorkloads.size() + " theory workloads...");

            // 6. Group time slots by day
            Map<DayOfWeek, List<TimeSlot>> slotsByDay = theorySlots.stream()
                    .collect(Collectors.groupingBy(TimeSlot::getDayOfWeek));

            // 7. Track occupancy
            Map<String, Set<String>> facultyOccupancy = new HashMap<>();
            Map<String, Set<String>> roomOccupancy = new HashMap<>();
            Map<String, Set<String>> divisionOccupancy = new HashMap<>();

            // Track what subject was scheduled for division on each day/slot
            Map<String, String> divisionDaySlotSubject = new HashMap<>(); // "divId_day_slotIndex" -> subjectId

            // 8. Process each division separately
            for (Division division : allDivisions) {
                System.out.println("\n=== Scheduling Division " + division.getName() + " ===");

                // Get workloads for this division
                List<Workload> divisionWorkloads = theoryWorkloads.stream()
                        .filter(w -> w.getDivision() != null && w.getDivision().getId().equals(division.getId()))
                        .collect(Collectors.toList());

                System.out.println("Division " + division.getName() + " has " + divisionWorkloads.size() + " subjects");

                // Track lectures scheduled per subject
                Map<Long, Integer> lecturesScheduled = new HashMap<>();
                for (Workload w : divisionWorkloads) {
                    lecturesScheduled.put(w.getSubject().getId(), 0);
                }

                // Process each day
                for (DayOfWeek day : DayOfWeek.values()) {
                    if (day == DayOfWeek.SUNDAY)
                        continue;

                    List<TimeSlot> daySlots = slotsByDay.get(day);
                    if (daySlots == null || daySlots.isEmpty())
                        continue;

                    System.out.println("\n  Scheduling " + day + ":");

                    // Track subjects used today for this division
                    Set<Long> subjectsUsedToday = new HashSet<>();
                    String lastScheduledSubjectId = null;
                    int consecutiveCount = 0;

                    // Sort slots by time
                    daySlots.sort(Comparator.comparing(TimeSlot::getStartTime));

                    for (int slotIndex = 0; slotIndex < daySlots.size(); slotIndex++) {
                        TimeSlot slot = daySlots.get(slotIndex);

                        // Find best workload to schedule
                        Workload bestWorkload = findBestWorkload(
                                divisionWorkloads,
                                lecturesScheduled,
                                subjectsUsedToday,
                                lastScheduledSubjectId,
                                consecutiveCount,
                                slot,
                                classrooms,
                                facultyOccupancy,
                                roomOccupancy,
                                divisionOccupancy,
                                division);

                        if (bestWorkload != null) {
                            // Find available room
                            Room availableRoom = findAvailableRoom(classrooms, slot, roomOccupancy);

                            if (availableRoom != null && isSlotAvailable(slot, availableRoom, bestWorkload,
                                    facultyOccupancy, roomOccupancy, divisionOccupancy)) {

                                // Create schedule
                                Schedule schedule = new Schedule();
                                schedule.setWorkload(bestWorkload);
                                schedule.setTimeSlot(slot);
                                schedule.setRoom(availableRoom);
                                schedule.setDivision(division);
                                schedule.setSessionType(SessionType.THEORY);

                                scheduleDao.save(schedule);

                                // Mark as occupied
                                markOccupied(slot, availableRoom, bestWorkload, facultyOccupancy, roomOccupancy,
                                        divisionOccupancy);

                                // Update tracking
                                Long subjectId = bestWorkload.getSubject().getId();
                                lecturesScheduled.put(subjectId, lecturesScheduled.get(subjectId) + 1);
                                subjectsUsedToday.add(subjectId);

                                // Track consecutive lectures
                                if (lastScheduledSubjectId != null
                                        && lastScheduledSubjectId.equals(subjectId.toString())) {
                                    consecutiveCount++;
                                } else {
                                    consecutiveCount = 1;
                                    lastScheduledSubjectId = subjectId.toString();
                                }

                                System.out.println("    ✓ " + slot.getStartTime() + " - " +
                                        bestWorkload.getSubject().getCode() + " (" +
                                        bestWorkload.getFaculty().getName() + ") in " +
                                        availableRoom.getName());
                            }
                        }
                    }
                }

                // Print summary for this division
                System.out.println("\n  Summary for Division " + division.getName() + ":");
                for (Workload w : divisionWorkloads) {
                    int scheduled = lecturesScheduled.get(w.getSubject().getId());
                    int required = w.getSubject().getLecturesPerWeek();
                    System.out.println(
                            "    " + w.getSubject().getCode() + ": " + scheduled + "/" + required + " lectures");
                }
            }

            System.out.println("\n=== Timetable Generation Complete ===");
            System.out.println("Total schedules created: " + scheduleDao.findAll().size());
            return true;

        } catch (Exception e) {
            System.err.println("ERROR in generateDivisionBasedTimetable:");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Find best workload to schedule based on variety and constraints
     */
    private Workload findBestWorkload(List<Workload> workloads, Map<Long, Integer> lecturesScheduled,
            Set<Long> subjectsUsedToday, String lastScheduledSubjectId,
            int consecutiveCount, TimeSlot slot, List<Room> classrooms,
            Map<String, Set<String>> facultyOcc, Map<String, Set<String>> roomOcc,
            Map<String, Set<String>> divisionOcc, Division division) {

        // Priority 1: Subjects not used today (for variety)
        List<Workload> notUsedToday = workloads.stream()
                .filter(w -> !subjectsUsedToday.contains(w.getSubject().getId()))
                .filter(w -> lecturesScheduled.get(w.getSubject().getId()) < w.getSubject().getLecturesPerWeek())
                .collect(Collectors.toList());

        if (!notUsedToday.isEmpty()) {
            // Try to find one that's available
            for (Workload w : notUsedToday) {
                if (isWorkloadAvailable(w, slot, classrooms, facultyOcc, roomOcc, divisionOcc)) {
                    return w;
                }
            }
        }

        // Priority 2: Different from last subject (avoid back-to-back if possible)
        if (lastScheduledSubjectId != null) {
            List<Workload> differentSubject = workloads.stream()
                    .filter(w -> !w.getSubject().getId().toString().equals(lastScheduledSubjectId))
                    .filter(w -> lecturesScheduled.get(w.getSubject().getId()) < w.getSubject().getLecturesPerWeek())
                    .collect(Collectors.toList());

            for (Workload w : differentSubject) {
                if (isWorkloadAvailable(w, slot, classrooms, facultyOcc, roomOcc, divisionOcc)) {
                    return w;
                }
            }
        }

        // Priority 3: Allow back-to-back but max 2 consecutive
        if (consecutiveCount < 2) {
            for (Workload w : workloads) {
                if (lecturesScheduled.get(w.getSubject().getId()) < w.getSubject().getLecturesPerWeek()) {
                    if (isWorkloadAvailable(w, slot, classrooms, facultyOcc, roomOcc, divisionOcc)) {
                        return w;
                    }
                }
            }
        }

        return null;
    }

    private boolean isWorkloadAvailable(Workload workload, TimeSlot slot, List<Room> classrooms,
            Map<String, Set<String>> facultyOcc,
            Map<String, Set<String>> roomOcc,
            Map<String, Set<String>> divisionOcc) {
        for (Room room : classrooms) {
            if (isSlotAvailable(slot, room, workload, facultyOcc, roomOcc, divisionOcc)) {
                return true;
            }
        }
        return false;
    }

    private Room findAvailableRoom(List<Room> rooms, TimeSlot slot, Map<String, Set<String>> roomOcc) {
        String slotKey = slot.getDayOfWeek() + "_" + slot.getId();
        Set<String> occupiedRooms = roomOcc.getOrDefault(slotKey, new HashSet<>());

        for (Room room : rooms) {
            if (!occupiedRooms.contains(room.getId().toString())) {
                return room;
            }
        }
        return rooms.isEmpty() ? null : rooms.get(0);
    }

    private boolean isSlotAvailable(TimeSlot slot, Room room, Workload workload,
            Map<String, Set<String>> facultyOcc,
            Map<String, Set<String>> roomOcc,
            Map<String, Set<String>> divisionOcc) {
        String slotKey = slot.getDayOfWeek() + "_" + slot.getId();

        // Check faculty availability
        Set<String> occupiedFaculty = facultyOcc.getOrDefault(slotKey, new HashSet<>());
        if (occupiedFaculty.contains(workload.getFaculty().getId().toString())) {
            return false;
        }

        // Check room availability
        Set<String> occupiedRooms = roomOcc.getOrDefault(slotKey, new HashSet<>());
        if (occupiedRooms.contains(room.getId().toString())) {
            return false;
        }

        // Check division availability
        if (workload.getDivision() != null) {
            Set<String> occupiedDivisions = divisionOcc.getOrDefault(slotKey, new HashSet<>());
            if (occupiedDivisions.contains(workload.getDivision().getId().toString())) {
                return false;
            }
        }

        return true;
    }

    private void markOccupied(TimeSlot slot, Room room, Workload workload,
            Map<String, Set<String>> facultyOcc,
            Map<String, Set<String>> roomOcc,
            Map<String, Set<String>> divisionOcc) {
        String slotKey = slot.getDayOfWeek() + "_" + slot.getId();

        facultyOcc.computeIfAbsent(slotKey, k -> new HashSet<>())
                .add(workload.getFaculty().getId().toString());

        roomOcc.computeIfAbsent(slotKey, k -> new HashSet<>())
                .add(room.getId().toString());

        if (workload.getDivision() != null) {
            divisionOcc.computeIfAbsent(slotKey, k -> new HashSet<>())
                    .add(workload.getDivision().getId().toString());
        }
    }
}
