package com.timetable.controller;

import com.timetable.dao.FacultyDao;
import com.timetable.model.Faculty;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/faculty_login")
public class FacultyLoginServlet extends HttpServlet {

    private final FacultyDao facultyDao = new FacultyDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("faculty_login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");

        Faculty faculty = facultyDao.findByEmail(email);

        if (faculty != null) {
            HttpSession session = req.getSession();
            session.setAttribute("facultyUser", faculty);
            resp.sendRedirect(req.getContextPath() + "/faculty");
        } else {
            req.setAttribute("error", "Invalid or unregistered email address.");
            req.getRequestDispatcher("faculty_login.jsp").forward(req, resp);
        }
    }
}
