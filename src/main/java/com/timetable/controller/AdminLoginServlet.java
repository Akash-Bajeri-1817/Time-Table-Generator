package com.timetable.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Handles Admin login via username + password.
 * Credentials are   username: admin   password: admin123
 * On success sets session attribute "adminUser" = "admin" and redirects to /admin.
 * On failure, forwards back to the landing page (index) with an error flag.
 */
@WebServlet("/admin_login")
public class AdminLoginServlet extends HttpServlet {

    // Hardcoded admin credentials (change as needed)
    private static final String ADMIN_USERNAME = "admin";
    private static final String ADMIN_PASSWORD = "admin123";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // If already logged in, send directly to dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/admin");
            return;
        }
        // Otherwise redirect to home page (modal will open if needed)
        resp.sendRedirect(req.getContextPath() + "/");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (ADMIN_USERNAME.equals(username) && ADMIN_PASSWORD.equals(password)) {
            HttpSession session = req.getSession(true);
            session.setAttribute("adminUser", username);
            session.setMaxInactiveInterval(60 * 60); // 1 hour
            resp.sendRedirect(req.getContextPath() + "/admin");
        } else {
            // Wrong credentials — return to landing page with error param
            resp.sendRedirect(req.getContextPath() + "/?loginError=admin&msg=Invalid+credentials");
        }
    }
}
