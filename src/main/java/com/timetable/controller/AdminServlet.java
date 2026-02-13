package com.timetable.controller;

import java.io.IOException;
import java.util.List;

import com.timetable.model.Faculty;
import com.timetable.model.Room;
import com.timetable.model.StudentGroup;
import com.timetable.model.Subject;
import com.timetable.model.Workload;
import com.timetable.service.ResourceService;
import com.timetable.service.SchedulerService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {
    private final ResourceService resourceService = new ResourceService();
    private final SchedulerService schedulerService = new SchedulerService();
    private final com.timetable.service.EnhancedSchedulerService enhancedSchedulerService = new com.timetable.service.EnhancedSchedulerService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String action = req.getParameter("action");

            if ("view_timetable".equals(action)) {
                // Forward to timetable view
                req.getRequestDispatcher("admin/view_timetable.jsp").forward(req, resp);
                return;
            } else if ("generate".equals(action)) {
                System.out.println("=== GENERATE ACTION TRIGGERED ===");
                try {
                    boolean success = schedulerService.generateTimetable();
                    req.setAttribute("message", success ? "Timetable Generated Successfully!" : "Generation Failed!");
                    System.out.println("Generation result: " + success);
                } catch (Exception e) {
                    System.err.println("ERROR in generateTimetable:");
                    e.printStackTrace();
                    req.setAttribute("message", "Error during generation: " + e.getMessage());
                }
            } else if ("load_sample_data".equals(action)) {
                System.out.println("=== LOAD SAMPLE DATA ACTION TRIGGERED ===");
                try {
                    com.timetable.util.SampleDataInitializer.initialize();
                    req.setAttribute("message", "Sample Data Loaded Successfully!");
                    System.out.println("Sample data loaded successfully");
                } catch (Exception e) {
                    System.err.println("ERROR in SampleDataInitializer:");
                    e.printStackTrace();
                    req.setAttribute("message", "Error loading sample data: " + e.getMessage());
                }
            } else if ("load_enhanced_data".equals(action)) {
                System.out.println("=== LOAD ENHANCED SAMPLE DATA ACTION TRIGGERED ===");
                try {
                    com.timetable.util.EnhancedSampleDataInitializer.initialize();
                    req.setAttribute("message",
                            "Enhanced Sample Data Loaded Successfully! (TY BSc CS with 3 Divisions)");
                    System.out.println("Enhanced sample data loaded successfully");
                } catch (Exception e) {
                    System.err.println("ERROR in EnhancedSampleDataInitializer:");
                    e.printStackTrace();
                    req.setAttribute("message", "Error loading enhanced data: " + e.getMessage());
                }
            } else if ("generate_enhanced".equals(action)) {
                System.out.println("=== GENERATE ENHANCED TIMETABLE ACTION TRIGGERED ===");
                try {
                    boolean success = enhancedSchedulerService.generateDivisionBasedTimetable();
                    req.setAttribute("message",
                            success ? "Division-Based Timetable Generated Successfully!" : "Generation Failed!");
                    System.out.println("Enhanced generation result: " + success);
                } catch (Exception e) {
                    System.err.println("ERROR in generateDivisionBasedTimetable:");
                    e.printStackTrace();
                    req.setAttribute("message", "Error during enhanced generation: " + e.getMessage());
                }
            }

            // Default: Load Dashboard Data
            req.setAttribute("faculties", resourceService.getAllFaculty());
            req.setAttribute("subjects", resourceService.getAllSubjects());
            req.setAttribute("rooms", resourceService.getAllRooms());
            req.setAttribute("groups", resourceService.getAllStudentGroups());
            req.setAttribute("workloads", resourceService.getAllWorkloads());

            req.getRequestDispatcher("admin/dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            System.err.println("CRITICAL ERROR in AdminServlet.doGet:");
            e.printStackTrace();
            throw new ServletException("Error in AdminServlet: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("add_faculty".equals(action)) {
            Faculty f = new Faculty();
            f.setName(req.getParameter("name"));
            f.setEmail(req.getParameter("email"));
            f.setDepartment(req.getParameter("department"));
            resourceService.addFaculty(f);
        } else if ("add_subject".equals(action)) {
            Subject s = new Subject();
            s.setCode(req.getParameter("code"));
            s.setName(req.getParameter("name"));
            s.setDepartment(req.getParameter("department"));
            s.setLecturesPerWeek(Integer.parseInt(req.getParameter("lectures")));
            s.setPractical(req.getParameter("isPractical") != null);
            resourceService.addSubject(s);
        } else if ("add_room".equals(action)) {
            Room r = new Room();
            r.setName(req.getParameter("name"));
            r.setCapacity(Integer.parseInt(req.getParameter("capacity")));
            r.setType(Room.RoomType.valueOf(req.getParameter("type")));
            resourceService.addRoom(r);
        } else if ("add_group".equals(action)) {
            StudentGroup g = new StudentGroup();
            g.setName(req.getParameter("name"));
            resourceService.addStudentGroup(g);
        } else if ("add_workload".equals(action)) {
            Workload w = new Workload();
            Long facultyId = Long.parseLong(req.getParameter("faculty_id"));
            Long subjectId = Long.parseLong(req.getParameter("subject_id"));
            Long groupId = Long.parseLong(req.getParameter("group_id"));

            Faculty f = resourceService.getFaculty(facultyId);
            Subject s = resourceService.getSubject(subjectId);
            StudentGroup g = resourceService.getStudentGroup(groupId);

            if (f != null && s != null && g != null) {
                w.setFaculty(f);
                w.setSubject(s);
                w.setStudentGroup(g);
                resourceService.addWorkload(w);
            }
        } else if ("generate".equals(action)) {
            boolean success = schedulerService.generateTimetable();
            req.setAttribute("message", success ? "Timetable Generated Successfully!" : "Generation Failed!");
        } else if ("load_sample_data".equals(action)) {
            com.timetable.util.SampleDataInitializer.initialize();
            req.setAttribute("message", "Sample Data Loaded Successfully!");
        }

        resp.sendRedirect("admin");
    }
}
