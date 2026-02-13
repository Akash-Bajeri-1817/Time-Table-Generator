package com.timetable.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import com.timetable.dao.RoomDao;
import com.timetable.dao.ScheduleDao;
import com.timetable.dao.TimeSlotDao;
import com.timetable.dao.WorkloadDao;
import com.timetable.model.Room;
import com.timetable.model.Schedule;
import com.timetable.model.TimeSlot;
import com.timetable.model.Workload;

public class SchedulerService {
    private final WorkloadDao workloadDao = new WorkloadDao();
    private final RoomDao roomDao = new RoomDao();
    private final TimeSlotDao timeSlotDao = new TimeSlotDao();
    private final ScheduleDao scheduleDao = new ScheduleDao();

    public boolean generateTimetable() {
        try {
            System.out.println("=== Starting generateTimetable ===");
            // 1. Clear existing schedules
            scheduleDao.deleteAll();
            System.out.println("Cleared existing schedules");

            // 2. Fetch all necessary data
            List<Workload> workloads = workloadDao.findAll();
            List<Room> allRooms = roomDao.findAll();
            List<TimeSlot> allTimeSlots = timeSlotDao.findAll();

            System.out.println("Fetched data - Workloads: " + workloads.size() + ", Rooms: " + allRooms.size()
                    + ", TimeSlots: " + allTimeSlots.size());

            // Auto-initialize TimeSlots if missing (Common manual testing pitfall)
            if (allTimeSlots.isEmpty()) {
                System.out.println("No time slots found. Initializing default slots...");
                initializeDefaultTimeSlots();
                allTimeSlots = timeSlotDao.findAll();
                System.out.println("After initialization, TimeSlots: " + allTimeSlots.size());
            }

            if (workloads.isEmpty() || allRooms.isEmpty() || allTimeSlots.isEmpty()) {
                System.out
                        .println("Insufficient data to generate timetable. Workloads: " + workloads.size() + ", Rooms: "
                                + allRooms.size() + ", Slots: " + allTimeSlots.size());
                return false;
            }

            System.out.println("Starting Timetable Generation...");
            System.out.println("Workloads: " + workloads.size());
            System.out.println("Rooms: " + allRooms.size());
            System.out.println("TimeSlots: " + allTimeSlots.size());

            // 3. Sort workloads (Optional heuristic: Schedule hard tasks first, e.g.,
            // Practicals)
            workloads.sort((w1, w2) -> Boolean.compare(w2.getSubject().isPractical(), w1.getSubject().isPractical()));

            // 4. Initialize Schedule Map
            List<Schedule> finalSchedule = new ArrayList<>();

            // Track allocations to prevent conflicts
            // Map<TimeSlotID, Set<ResourceID>>
            Map<Long, Set<Long>> facultyOccupancy = new HashMap<>(); // Faculty ID -> occupied slots
            Map<Long, Set<Long>> roomOccupancy = new HashMap<>(); // Room ID -> occupied slots
            Map<Long, Set<Long>> groupOccupancy = new HashMap<>(); // Group ID -> occupied slots

            for (Workload workload : workloads) {
                System.out.println("Processing Workload: " + workload.getSubject().getName() + " for "
                        + workload.getStudentGroup().getName());
                int requiredLectures = workload.getSubject().getLecturesPerWeek();
                boolean isPractical = workload.getSubject().isPractical();
                Room.RoomType requiredType = isPractical ? Room.RoomType.LAB : Room.RoomType.CLASSROOM;

                List<Room> suitableRooms = allRooms.stream()
                        .filter(r -> r.getType() == requiredType)
                        .collect(Collectors.toList());

                if (suitableRooms.isEmpty()) {
                    System.out.println("No suitable room found for " + workload.getSubject().getName() + " (Requires "
                            + requiredType + ")");
                    continue;
                }

                for (int i = 0; i < requiredLectures; i++) {
                    boolean assigned = false;

                    // Shuffle slots and rooms to distribute load logic
                    // For a real generic algorithm, we might want to be deterministic or smarter

                    for (TimeSlot slot : allTimeSlots) {
                        if (assigned)
                            break;

                        for (Room room : suitableRooms) {
                            if (isSafe(workload, slot, room, facultyOccupancy, roomOccupancy, groupOccupancy)) {
                                // Assign
                                Schedule schedule = new Schedule();
                                schedule.setWorkload(workload);
                                schedule.setTimeSlot(slot);
                                schedule.setRoom(room);
                                finalSchedule.add(schedule);

                                System.out.println("  -> Assigned to " + slot.toString() + " in " + room.getName());

                                // Book resources
                                bookResource(facultyOccupancy, workload.getFaculty().getId(), slot.getId());
                                bookResource(roomOccupancy, room.getId(), slot.getId());
                                bookResource(groupOccupancy, workload.getStudentGroup().getId(), slot.getId());

                                assigned = true;
                                break;
                            }
                        }
                    }

                    if (!assigned) {
                        System.out.println("Could not assign slot for " + workload.getSubject().getName() + " - "
                                + workload.getStudentGroup().getName());
                    }
                }
            }

            System.out.println("Final Schedule Size: " + finalSchedule.size());

            // 5. Persist Schedule
            for (Schedule s : finalSchedule) {
                scheduleDao.save(s);
            }
            System.out.println("Schedule persisted to database.");

            return true;
        } catch (Exception e) {
            System.err.println("CRITICAL ERROR in generateTimetable:");
            e.printStackTrace();
            return false;
        }
    }

    private boolean isSafe(Workload workload, TimeSlot slot, Room room,
            Map<Long, Set<Long>> facultyOcc,
            Map<Long, Set<Long>> roomOcc,
            Map<Long, Set<Long>> groupOcc) {

        // Check Faculty
        if (isOccupied(facultyOcc, workload.getFaculty().getId(), slot.getId()))
            return false;

        // Check Room
        if (isOccupied(roomOcc, room.getId(), slot.getId()))
            return false;

        // Check Student Group
        // TODO: Handle Parallel Batches logic here (if batch, check parent; if parent,
        // check batches?)
        // For now, strict check
        if (isOccupied(groupOcc, workload.getStudentGroup().getId(), slot.getId()))
            return false;

        return true;
    }

    private boolean isOccupied(Map<Long, Set<Long>> occupancyMap, Long resourceId, Long slotId) {
        return occupancyMap.containsKey(resourceId) && occupancyMap.get(resourceId).contains(slotId);
    }

    private void bookResource(Map<Long, Set<Long>> occupancyMap, Long resourceId, Long slotId) {
        occupancyMap.computeIfAbsent(resourceId, k -> new HashSet<>()).add(slotId);
    }

    private void initializeDefaultTimeSlots() {
        java.time.LocalTime[] startTimes = {
                java.time.LocalTime.of(9, 0), java.time.LocalTime.of(10, 0), java.time.LocalTime.of(11, 0),
                java.time.LocalTime.of(12, 0),
                java.time.LocalTime.of(14, 0), java.time.LocalTime.of(15, 0)
        };
        for (java.time.DayOfWeek day : java.time.DayOfWeek.values()) {
            if (day == java.time.DayOfWeek.SATURDAY || day == java.time.DayOfWeek.SUNDAY)
                continue;
            for (java.time.LocalTime start : startTimes) {
                TimeSlot ts = new TimeSlot();
                ts.setDayOfWeek(day);
                ts.setStartTime(start);
                ts.setEndTime(start.plusHours(1));
                timeSlotDao.save(ts);
            }
        }
    }
}
