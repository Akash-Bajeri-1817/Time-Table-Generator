package com.timetable.controller;

import com.timetable.dao.DivisionDao;
import com.timetable.dao.ScheduleDao;
import com.timetable.model.Division;
import com.timetable.model.Faculty;
import com.timetable.model.Schedule;
import com.timetable.service.ResourceService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/faculty")
public class FacultyServlet extends HttpServlet {
    private final ResourceService resourceService = new ResourceService();
    private final ScheduleDao scheduleDao = new ScheduleDao();
    private final DivisionDao divisionDao = new DivisionDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Faculty facultyUser = (session != null) ? (Faculty) session.getAttribute("facultyUser") : null;

        if (facultyUser == null) {
            resp.sendRedirect(req.getContextPath() + "/faculty_login");
            return;
        }

        String action = req.getParameter("action");
        if ("logout".equals(action)) {
            session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        // Fetch user-specific schedules
        List<Schedule> mySchedules = scheduleDao.findByFacultyId(facultyUser.getId());
        List<Division> allDivisions = divisionDao.findAll();

        req.setAttribute("schedules", mySchedules);
        req.setAttribute("divisions", allDivisions);
        req.setAttribute("facultyUser", facultyUser);

        req.getRequestDispatcher("faculty/dashboard.jsp").forward(req, resp);
    }
}
