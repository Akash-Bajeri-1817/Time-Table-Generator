package com.timetable.controller;

import com.timetable.dao.TimetableConfigDao;
import com.timetable.model.TimetableConfig;
import com.timetable.service.TimeSlotGeneratorService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.HashSet;
import java.util.Set;

@WebServlet("/timeslot-config")
public class TimeslotConfigServlet extends HttpServlet {
    private final TimetableConfigDao configDao = new TimetableConfigDao();
    private final TimeSlotGeneratorService slotGeneratorService = new TimeSlotGeneratorService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Get active configuration if exists
        TimetableConfig activeConfig = configDao.getActiveConfig();
        req.setAttribute("activeConfig", activeConfig);

        // Forward to configuration page
        req.getRequestDispatcher("admin/timeslot_config.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Parse form data
            String startTimeStr = req.getParameter("startTime");
            int duration = Integer.parseInt(req.getParameter("duration"));
            int lecturesPerDay = Integer.parseInt(req.getParameter("lecturesPerDay"));
            boolean hasBreak = req.getParameter("hasBreak") != null;

            // Create config
            TimetableConfig config = new TimetableConfig();
            config.setConfigName("Default Config");
            config.setFirstLectureStartTime(LocalTime.parse(startTimeStr));
            config.setLectureDurationMinutes(duration);
            config.setLecturesPerDay(lecturesPerDay);
            config.setHasBreak(hasBreak);

            if (hasBreak) {
                config.setBreakDurationMinutes(Integer.parseInt(req.getParameter("breakDuration")));
                config.setBreakAfterLectureNumber(Integer.parseInt(req.getParameter("breakAfter")));
            }

            // Parse working days
            Set<DayOfWeek> workingDays = new HashSet<>();
            if (req.getParameter("monday") != null)
                workingDays.add(DayOfWeek.MONDAY);
            if (req.getParameter("tuesday") != null)
                workingDays.add(DayOfWeek.TUESDAY);
            if (req.getParameter("wednesday") != null)
                workingDays.add(DayOfWeek.WEDNESDAY);
            if (req.getParameter("thursday") != null)
                workingDays.add(DayOfWeek.THURSDAY);
            if (req.getParameter("friday") != null)
                workingDays.add(DayOfWeek.FRIDAY);
            if (req.getParameter("saturday") != null)
                workingDays.add(DayOfWeek.SATURDAY);
            if (req.getParameter("sunday") != null)
                workingDays.add(DayOfWeek.SUNDAY);

            config.setWorkingDaysFromSet(workingDays);

            // Save config
            configDao.saveAsActive(config);

            // Generate time slots
            boolean success = slotGeneratorService.generateAndSaveTimeSlots(config);

            req.setAttribute("message",
                    success ? "Time slots configured and generated successfully!" : "Failed to generate time slots!");
            req.setAttribute("activeConfig", config);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("message", "Error saving configuration: " + e.getMessage());
        }

        // Forward back to configuration page
        req.getRequestDispatcher("admin/timeslot_config.jsp").forward(req, resp);
    }
}
