package com.timetable.controller;

import com.timetable.dao.*;
import com.timetable.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/division-timetable")
public class DivisionTimetableServlet extends HttpServlet {
    private final ScheduleDao scheduleDao = new ScheduleDao();
    private final DivisionDao divisionDao = new DivisionDao();
    private final TimeSlotDao timeSlotDao = new TimeSlotDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Fetch all data
            List<Schedule> allSchedules = scheduleDao.findAll();
            List<Division> allDivisions = divisionDao.findAll();
            List<TimeSlot> allTimeSlots = timeSlotDao.findAll();

            // Separate theory and practical time slots
            List<TimeSlot> theorySlots = allTimeSlots.stream()
                    .filter(ts -> ts.getSessionType() == SessionType.THEORY)
                    .sorted(Comparator.comparing(TimeSlot::getDayOfWeek)
                            .thenComparing(TimeSlot::getStartTime))
                    .collect(Collectors.toList());

            List<TimeSlot> practicalSlots = allTimeSlots.stream()
                    .filter(ts -> ts.getSessionType() == SessionType.PRACTICAL)
                    .sorted(Comparator.comparing(TimeSlot::getDayOfWeek))
                    .collect(Collectors.toList());

            // Get unique days
            Set<DayOfWeek> days = theorySlots.stream()
                    .map(TimeSlot::getDayOfWeek)
                    .collect(Collectors.toCollection(LinkedHashSet::new));

            // Get unique theory time slots per day
            Map<DayOfWeek, List<LocalTime>> timeSlotsByDay = new LinkedHashMap<>();
            for (DayOfWeek day : days) {
                List<LocalTime> times = theorySlots.stream()
                        .filter(ts -> ts.getDayOfWeek() == day)
                        .map(TimeSlot::getStartTime)
                        .distinct()
                        .sorted()
                        .collect(Collectors.toList());
                timeSlotsByDay.put(day, times);
            }

            // Sort divisions by name
            allDivisions.sort(Comparator.comparing(Division::getName));

            // Create a map for quick schedule lookup
            // Key: "divisionId_day_time" -> Schedule
            Map<String, Schedule> scheduleMap = new HashMap<>();
            for (Schedule schedule : allSchedules) {
                if (schedule.getDivision() != null && schedule.getSessionType() == SessionType.THEORY) {
                    String key = schedule.getDivision().getId() + "_" +
                            schedule.getTimeSlot().getDayOfWeek() + "_" +
                            schedule.getTimeSlot().getStartTime();
                    scheduleMap.put(key, schedule);
                }
            }

            // Create practical schedule map
            Map<String, List<Schedule>> practicalScheduleMap = new HashMap<>();
            for (Schedule schedule : allSchedules) {
                if (schedule.getSessionType() == SessionType.PRACTICAL) {
                    String key = schedule.getTimeSlot().getDayOfWeek().toString();
                    practicalScheduleMap.computeIfAbsent(key, k -> new ArrayList<>()).add(schedule);
                }
            }

            // Set attributes
            req.setAttribute("divisions", allDivisions);
            req.setAttribute("days", new ArrayList<>(days));
            req.setAttribute("timeSlotsByDay", timeSlotsByDay);
            req.setAttribute("scheduleMap", scheduleMap);
            req.setAttribute("practicalScheduleMap", practicalScheduleMap);
            req.setAttribute("practicalDays", practicalSlots.stream()
                    .map(TimeSlot::getDayOfWeek)
                    .distinct()
                    .sorted()
                    .collect(Collectors.toList()));

            req.getRequestDispatcher("/admin/division_timetable.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading timetable: " + e.getMessage());
        }
    }
}
