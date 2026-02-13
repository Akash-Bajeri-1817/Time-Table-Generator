package com.timetable.controller;

import com.timetable.model.Faculty;
import com.timetable.service.ResourceService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/faculty")
public class FacultyServlet extends HttpServlet {
    private final ResourceService resourceService = new ResourceService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Mock Login: Assume Faculty ID 1 for now or get from session
        // In real app, get Principal

        req.getRequestDispatcher("faculty/dashboard.jsp").forward(req, resp);
    }
}
