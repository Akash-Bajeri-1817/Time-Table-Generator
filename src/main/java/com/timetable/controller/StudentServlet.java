package com.timetable.controller;

import com.timetable.dao.ScheduleDao;
import com.timetable.model.Schedule;
import com.timetable.model.StudentGroup;
import com.timetable.service.ResourceService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/student")
public class StudentServlet extends HttpServlet {
    private final ResourceService resourceService = new ResourceService();
    private final ScheduleDao scheduleDao = new ScheduleDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String groupIdParam = req.getParameter("group_id");
        List<StudentGroup> allGroups = resourceService.getAllStudentGroups();
        req.setAttribute("groups", allGroups);

        if (groupIdParam != null && !groupIdParam.trim().isEmpty()) {
            try {
                Long groupId = Long.parseLong(groupIdParam);
                List<Schedule> groupSchedules = scheduleDao.findByStudentGroupId(groupId);
                req.setAttribute("schedules", groupSchedules);
                req.setAttribute("selectedGroupId", groupId);

                // Find and pass the name of the selected group for the UI
                for (StudentGroup group : allGroups) {
                    if (group.getId().equals(groupId)) {
                        req.setAttribute("selectedGroupName", group.getName());
                        break;
                    }
                }
            } catch (NumberFormatException e) {
                // Invalid group ID format, ignore
            }
        }

        req.getRequestDispatcher("student/view.jsp").forward(req, resp);
    }
}
