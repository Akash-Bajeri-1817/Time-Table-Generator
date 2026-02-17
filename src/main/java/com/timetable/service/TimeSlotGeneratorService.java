package com.timetable.service;

import com.timetable.dao.TimeSlotDao;
import com.timetable.model.SessionType;
import com.timetable.model.TimeSlot;
import com.timetable.model.TimetableConfig;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * Service to generate time slots automatically from configuration
 */
public class TimeSlotGeneratorService {
    private final TimeSlotDao timeSlotDao = new TimeSlotDao();

    /**
     * Generate time slots from configuration and save to database
     * Deletes all existing theory time slots first
     */
    public boolean generateAndSaveTimeSlots(TimetableConfig config) {
        try {
            System.out.println("=== Generating Time Slots from Configuration ===");

            // Validate configuration
            if (!validateConfig(config)) {
                System.err.println("Invalid configuration");
                return false;
            }

            // Delete all existing theory time slots
            System.out.println("Deleting existing theory time slots...");
            deleteExistingTheorySlots();

            // Generate new time slots
            List<TimeSlot> newSlots = generateTimeSlots(config);

            // Save to database
            System.out.println("Saving " + newSlots.size() + " new time slots...");
            for (TimeSlot slot : newSlots) {
                timeSlotDao.save(slot);
            }

            System.out.println("=== Time Slot Generation Complete ===");
            System.out.println("Total slots created: " + newSlots.size());
            printSummary(newSlots);

            return true;
        } catch (Exception e) {
            System.err.println("ERROR in generateAndSaveTimeSlots:");
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Generate time slots from configuration (without saving)
     * Useful for preview
     */
    public List<TimeSlot> generateTimeSlots(TimetableConfig config) {
        List<TimeSlot> slots = new ArrayList<>();
        Set<DayOfWeek> workingDays = config.getWorkingDaysSet();

        System.out.println("Configuration:");
        System.out.println("  Start Time: " + config.getFirstLectureStartTime());
        System.out.println("  Duration: " + config.getLectureDurationMinutes() + " minutes");
        System.out.println("  Lectures/Day: " + config.getLecturesPerDay());
        System.out.println("  Has Break: " + config.getHasBreak());
        if (config.getHasBreak()) {
            System.out.println("  Break Duration: " + config.getBreakDurationMinutes() + " minutes");
            System.out.println("  Break After Lecture: " + config.getBreakAfterLectureNumber());
        }
        System.out.println("  Working Days: " + workingDays);

        for (DayOfWeek day : workingDays) {
            LocalTime currentTime = config.getFirstLectureStartTime();

            for (int lectureNum = 1; lectureNum <= config.getLecturesPerDay(); lectureNum++) {
                // Create lecture slot
                TimeSlot lecture = new TimeSlot();
                lecture.setDayOfWeek(day);
                lecture.setStartTime(currentTime);
                lecture.setEndTime(currentTime.plusMinutes(config.getLectureDurationMinutes()));
                lecture.setDurationMinutes(config.getLectureDurationMinutes());
                lecture.setSessionType(SessionType.THEORY);
                lecture.setIsBreak(false);
                slots.add(lecture);

                // Move to next time
                currentTime = currentTime.plusMinutes(config.getLectureDurationMinutes());

                // Add break if configured
                if (config.getHasBreak() && lectureNum == config.getBreakAfterLectureNumber()) {
                    TimeSlot breakSlot = new TimeSlot();
                    breakSlot.setDayOfWeek(day);
                    breakSlot.setStartTime(currentTime);
                    breakSlot.setEndTime(currentTime.plusMinutes(config.getBreakDurationMinutes()));
                    breakSlot.setDurationMinutes(config.getBreakDurationMinutes());
                    breakSlot.setSessionType(SessionType.THEORY); // Break is still part of theory session
                    breakSlot.setIsBreak(true);
                    slots.add(breakSlot);

                    // Move time forward by break duration
                    currentTime = currentTime.plusMinutes(config.getBreakDurationMinutes());
                }
            }
        }

        return slots;
    }

    /**
     * Delete all existing theory time slots
     */
    private void deleteExistingTheorySlots() {
        List<TimeSlot> allSlots = timeSlotDao.findAll();
        int deletedCount = 0;
        for (TimeSlot slot : allSlots) {
            if (slot.getSessionType() == SessionType.THEORY) {
                timeSlotDao.delete(slot.getId());
                deletedCount++;
            }
        }
        System.out.println("Deleted " + deletedCount + " existing theory time slots");
    }

    /**
     * Validate configuration
     */
    private boolean validateConfig(TimetableConfig config) {
        if (config == null) {
            System.err.println("Configuration is null");
            return false;
        }

        if (config.getFirstLectureStartTime() == null) {
            System.err.println("Start time is required");
            return false;
        }

        if (config.getLectureDurationMinutes() == null || config.getLectureDurationMinutes() <= 0) {
            System.err.println("Valid lecture duration is required");
            return false;
        }

        if (config.getLecturesPerDay() == null || config.getLecturesPerDay() <= 0) {
            System.err.println("Valid lectures per day is required");
            return false;
        }

        if (config.getWorkingDaysSet().isEmpty()) {
            System.err.println("At least one working day is required");
            return false;
        }

        if (config.getHasBreak()) {
            if (config.getBreakDurationMinutes() == null || config.getBreakDurationMinutes() <= 0) {
                System.err.println("Valid break duration is required when break is enabled");
                return false;
            }
            if (config.getBreakAfterLectureNumber() == null ||
                    config.getBreakAfterLectureNumber() <= 0 ||
                    config.getBreakAfterLectureNumber() >= config.getLecturesPerDay()) {
                System.err.println("Break position must be between 1 and lectures per day - 1");
                return false;
            }
        }

        return true;
    }

    /**
     * Print summary of generated slots
     */
    private void printSummary(List<TimeSlot> slots) {
        long lectureCount = slots.stream().filter(s -> !s.getIsBreak()).count();
        long breakCount = slots.stream().filter(TimeSlot::getIsBreak).count();

        System.out.println("Summary:");
        System.out.println("  Lecture slots: " + lectureCount);
        System.out.println("  Break slots: " + breakCount);

        // Print sample day
        if (!slots.isEmpty()) {
            DayOfWeek sampleDay = slots.get(0).getDayOfWeek();
            System.out.println("\nSample schedule for " + sampleDay + ":");
            slots.stream()
                    .filter(s -> s.getDayOfWeek() == sampleDay)
                    .forEach(s -> {
                        String type = s.getIsBreak() ? "BREAK" : "LECTURE";
                        System.out.println("  " + s.getStartTime() + " - " + s.getEndTime() + " (" + type + ")");
                    });
        }
    }
}
