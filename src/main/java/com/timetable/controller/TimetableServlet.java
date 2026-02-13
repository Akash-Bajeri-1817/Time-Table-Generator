package com.timetable.controller;

import com.timetable.dao.ScheduleDao;
import com.timetable.model.Schedule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/timetable")
public class TimetableServlet extends HttpServlet {
    private final ScheduleDao scheduleDao = new ScheduleDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Schedule> allSchedules = scheduleDao.findAll();

        // Transform data for Grid View
        // Key: Day -> Map<TimeSlot, List<Schedule>> ??
        // Or leave transformation to JSP

        req.setAttribute("schedules", allSchedules);
        req.getRequestDispatcher("/admin/view_timetable.jsp").forward(req, resp);
    }
}
