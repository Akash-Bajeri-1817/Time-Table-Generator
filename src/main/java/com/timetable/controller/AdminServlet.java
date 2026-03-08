package com.timetable.controller;

import java.io.IOException;
import java.util.List;

import com.timetable.dao.DivisionDao;
import com.timetable.dao.ScheduleDao;
import com.timetable.dao.TimetableConfigDao;
import com.timetable.model.*;
import com.timetable.service.ResourceService;
import com.timetable.service.SchedulerService;
import com.timetable.service.TimeSlotGeneratorService;

import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.HashSet;
import java.util.Set;

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
    private final com.timetable.service.AiSchedulerService aiSchedulerService = new com.timetable.service.AiSchedulerService();
    private final TimetableConfigDao configDao = new TimetableConfigDao();
    private final TimeSlotGeneratorService slotGeneratorService = new TimeSlotGeneratorService();
    private final DivisionDao divisionDao = new DivisionDao();
    private final ScheduleDao scheduleDao = new ScheduleDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String action = req.getParameter("action");
            String page = req.getParameter("page");

            // ─── ACTIONS ───────────────────────────────────────────
            if ("generate_ai".equals(action)) {
                System.out.println("=== AI TIMETABLE GENERATION (TIMEFOLD) TRIGGERED ===");
                try {
                    boolean success = aiSchedulerService.generateTimetable();
                    req.setAttribute("message", success
                            ? "✅ AI Timetable Generated Successfully! (Zero clashes detected)"
                            : "⚠️ AI Generation complete but some lectures could not be scheduled. Check server logs.");
                } catch (Exception e) {
                    e.printStackTrace();
                    req.setAttribute("message", "❌ Error during AI generation: " + e.getMessage());
                }
                page = "timetable"; // After generating, show timetable

            } else if ("generate".equals(action)) {
                try {
                    boolean success = schedulerService.generateTimetable();
                    req.setAttribute("message", success ? "Timetable Generated Successfully!" : "Generation Failed!");
                } catch (Exception e) {
                    e.printStackTrace();
                    req.setAttribute("message", "Error during generation: " + e.getMessage());
                }

            } else if ("generate_enhanced".equals(action)) {
                try {
                    boolean success = enhancedSchedulerService.generateDivisionBasedTimetable();
                    req.setAttribute("message", success ? "Division-Based Timetable Generated!" : "Generation Failed!");
                } catch (Exception e) {
                    e.printStackTrace();
                    req.setAttribute("message", "Error: " + e.getMessage());
                }

            } else if ("load_sample_data".equals(action)) {
                try {
                    com.timetable.util.SampleDataInitializer.initialize();
                    req.setAttribute("message", "Sample Data Loaded Successfully!");
                } catch (Exception e) {
                    e.printStackTrace();
                    req.setAttribute("message", "Error loading sample data: " + e.getMessage());
                }

            } else if ("load_enhanced_data".equals(action)) {
                try {
                    com.timetable.util.EnhancedSampleDataInitializer.initialize();
                    req.setAttribute("message", "Enhanced Sample Data Loaded! (TY BSc CS — 3 Divisions)");
                } catch (Exception e) {
                    e.printStackTrace();
                    req.setAttribute("message", "Error loading enhanced data: " + e.getMessage());
                }

            } else if ("clear_all_data".equals(action)) {
                try {
                    // Delete in FK-safe order (children first)
                    scheduleDao.findAll().forEach(s -> scheduleDao.delete(s.getId()));

                    com.timetable.dao.WorkloadDao wDao = new com.timetable.dao.WorkloadDao();
                    wDao.findAll().forEach(w -> wDao.delete(w.getId()));

                    com.timetable.dao.TimeSlotDao tsDao = new com.timetable.dao.TimeSlotDao();
                    tsDao.findAll().forEach(ts -> tsDao.delete(ts.getId()));

                    com.timetable.dao.StudentGroupDao sgDao = new com.timetable.dao.StudentGroupDao();
                    sgDao.findAll().forEach(sg -> sgDao.delete(sg.getId()));

                    com.timetable.dao.SubjectDao subjDao = new com.timetable.dao.SubjectDao();
                    subjDao.findAll().forEach(s -> subjDao.delete(s.getId()));

                    com.timetable.dao.FacultyDao facDao = new com.timetable.dao.FacultyDao();
                    facDao.findAll().forEach(f -> facDao.delete(f.getId()));

                    com.timetable.dao.RoomDao rDao = new com.timetable.dao.RoomDao();
                    rDao.findAll().forEach(r -> rDao.delete(r.getId()));

                    com.timetable.dao.DivisionDao divDao = new com.timetable.dao.DivisionDao();
                    divDao.findAll().forEach(d -> divDao.delete(d.getId()));

                    com.timetable.dao.BranchDao brDao = new com.timetable.dao.BranchDao();
                    brDao.findAll().forEach(b -> brDao.delete(b.getId()));

                    com.timetable.dao.TimetableConfigDao cfgDao = new com.timetable.dao.TimetableConfigDao();
                    cfgDao.findAll().forEach(c -> cfgDao.delete(c.getId()));

                    req.getSession().setAttribute("flashMessage",
                            "✅ All data cleared successfully. Database is now empty.");
                    System.out.println("=== ALL DATA CLEARED FROM DATABASE ===");
                } catch (Exception e) {
                    e.printStackTrace();
                    req.getSession().setAttribute("flashMessage", "❌ Error clearing data: " + e.getMessage());
                }
                resp.sendRedirect(req.getContextPath() + "/admin");
                return;

            } else if ("delete_faculty".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                resourceService.deleteFaculty(id);
                req.setAttribute("message", "Faculty deleted.");
                page = "faculty";

            } else if ("delete_subject".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                resourceService.deleteSubject(id);
                req.setAttribute("message", "Subject deleted.");
                page = "subjects";

            } else if ("delete_room".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                resourceService.deleteRoom(id);
                req.setAttribute("message", "Room deleted.");
                page = "rooms";

            } else if ("delete_group".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                resourceService.deleteStudentGroup(id);
                req.setAttribute("message", "Group deleted.");
                page = "groups";

            } else if ("delete_workload".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                resourceService.deleteWorkload(id);
                req.setAttribute("message", "Workload deleted.");
                page = "workload";

            } else if ("configure_timeslots".equals(action)) {
                TimetableConfig activeConfig = configDao.getActiveConfig();
                req.setAttribute("activeConfig", activeConfig);
                req.getRequestDispatcher("admin/timeslot_config.jsp").forward(req, resp);
                return;

            } else if ("view_timetable".equals(action)) {
                page = "timetable";
            }

            // ─── PAGE ROUTING ───────────────────────────────────────
            loadDataAndForward(req, resp, page);

        } catch (Exception e) {
            System.err.println("CRITICAL ERROR in AdminServlet.doGet:");
            e.printStackTrace();
            throw new ServletException("Error in AdminServlet: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String redirectPage = "dashboard";

        if ("add_faculty".equals(action)) {
            Faculty f = new Faculty();
            f.setName(req.getParameter("name"));
            f.setEmail(req.getParameter("email"));
            f.setDepartment(req.getParameter("department"));
            resourceService.addFaculty(f);
            req.getSession().setAttribute("flashMessage", "✅ Faculty \"" + f.getName() + "\" added successfully!");
            redirectPage = "faculty";

        } else if ("add_subject".equals(action)) {
            Subject s = new Subject();
            s.setCode(req.getParameter("code"));
            s.setName(req.getParameter("name"));
            s.setDepartment(req.getParameter("department"));
            s.setLecturesPerWeek(Integer.parseInt(req.getParameter("lectures")));
            s.setPractical(req.getParameter("isPractical") != null);
            resourceService.addSubject(s);
            req.getSession().setAttribute("flashMessage", "✅ Subject \"" + s.getName() + "\" added successfully!");
            redirectPage = "subjects";

        } else if ("add_room".equals(action)) {
            Room r = new Room();
            r.setName(req.getParameter("name"));
            r.setCapacity(Integer.parseInt(req.getParameter("capacity")));
            r.setType(Room.RoomType.valueOf(req.getParameter("type")));
            resourceService.addRoom(r);
            req.getSession().setAttribute("flashMessage", "✅ Room \"" + r.getName() + "\" added successfully!");
            redirectPage = "rooms";

        } else if ("add_group".equals(action)) {
            StudentGroup g = new StudentGroup();
            g.setName(req.getParameter("name"));
            resourceService.addStudentGroup(g);
            req.getSession().setAttribute("flashMessage", "✅ Group \"" + g.getName() + "\" added successfully!");
            redirectPage = "groups";

        } else if ("add_workload".equals(action)) {
            try {
                Long facultyId = Long.parseLong(req.getParameter("faculty_id"));
                Long subjectId = Long.parseLong(req.getParameter("subject_id"));
                Long groupId = Long.parseLong(req.getParameter("group_id"));

                Workload w = new Workload();
                w.setFaculty(resourceService.getFaculty(facultyId));
                w.setSubject(resourceService.getSubject(subjectId));
                w.setStudentGroup(resourceService.getStudentGroup(groupId));
                w.setSessionType(SessionType.THEORY);
                resourceService.addWorkload(w);
                req.getSession().setAttribute("flashMessage", "✅ Workload assigned successfully!");
            } catch (Exception e) {
                req.getSession().setAttribute("flashMessage", "❌ Error assigning workload: " + e.getMessage());
            }
            redirectPage = "workload";

        } else if ("save_timeslot_config".equals(action)) {
            try {
                TimetableConfig config = new TimetableConfig();
                config.setConfigName("Default Config");
                config.setFirstLectureStartTime(LocalTime.parse(req.getParameter("startTime")));
                config.setLectureDurationMinutes(Integer.parseInt(req.getParameter("duration")));
                config.setLecturesPerDay(Integer.parseInt(req.getParameter("lecturesPerDay")));
                boolean hasBreak = req.getParameter("hasBreak") != null;
                config.setHasBreak(hasBreak);
                if (hasBreak) {
                    config.setBreakDurationMinutes(Integer.parseInt(req.getParameter("breakDuration")));
                    config.setBreakAfterLectureNumber(Integer.parseInt(req.getParameter("breakAfter")));
                }
                Set<DayOfWeek> workingDays = new HashSet<>();
                for (String day : new String[] { "monday", "tuesday", "wednesday", "thursday", "friday", "saturday",
                        "sunday" }) {
                    if (req.getParameter(day) != null)
                        workingDays.add(DayOfWeek.valueOf(day.toUpperCase()));
                }
                config.setWorkingDaysFromSet(workingDays);
                configDao.saveAsActive(config);
                slotGeneratorService.generateAndSaveTimeSlots(config);
                req.getSession().setAttribute("flashMessage", "✅ Time slots configured and generated!");
            } catch (Exception e) {
                req.getSession().setAttribute("flashMessage", "❌ Error: " + e.getMessage());
            }
            resp.sendRedirect(req.getContextPath() + "/admin?page=constraints");
            return;

        } else if ("load_sample_data".equals(action)) {
            com.timetable.util.SampleDataInitializer.initialize();
            req.getSession().setAttribute("flashMessage", "Sample Data Loaded Successfully!");
        }

        resp.sendRedirect(req.getContextPath() + "/admin?page=" + redirectPage);
    }

    // ─── Helper: load data for specific page and forward ───────────
    private void loadDataAndForward(HttpServletRequest req, HttpServletResponse resp, String page)
            throws ServletException, IOException {

        // Transfer session flash message to request
        String flash = (String) req.getSession().getAttribute("flashMessage");
        if (flash != null) {
            req.setAttribute("message", flash);
            req.getSession().removeAttribute("flashMessage");
        }

        if ("faculty".equals(page)) {
            req.setAttribute("faculties", resourceService.getAllFaculty());
            req.setAttribute("subjects", resourceService.getAllSubjects());
            req.setAttribute("rooms", resourceService.getAllRooms());
            req.setAttribute("groups", resourceService.getAllStudentGroups());
            req.setAttribute("workloads", resourceService.getAllWorkloads());
            req.getRequestDispatcher("admin/faculty_management.jsp").forward(req, resp);

        } else if ("rooms".equals(page)) {
            req.setAttribute("rooms", resourceService.getAllRooms());
            req.getRequestDispatcher("admin/room_allocation.jsp").forward(req, resp);

        } else if ("subjects".equals(page)) {
            req.setAttribute("subjects", resourceService.getAllSubjects());
            req.getRequestDispatcher("admin/subjects.jsp").forward(req, resp);

        } else if ("groups".equals(page)) {
            req.setAttribute("groups", resourceService.getAllStudentGroups());
            req.setAttribute("divisions", divisionDao.findAll());
            req.getRequestDispatcher("admin/student_groups.jsp").forward(req, resp);

        } else if ("workload".equals(page)) {
            req.setAttribute("workloads", resourceService.getAllWorkloads());
            req.setAttribute("faculties", resourceService.getAllFaculty());
            req.setAttribute("subjects", resourceService.getAllSubjects());
            req.setAttribute("groups", resourceService.getAllStudentGroups());
            req.getRequestDispatcher("admin/workload.jsp").forward(req, resp);

        } else if ("timetable".equals(page)) {
            req.setAttribute("schedules", scheduleDao.findAll());
            req.setAttribute("groups", resourceService.getAllStudentGroups());
            req.getRequestDispatcher("admin/view_timetable.jsp").forward(req, resp);

        } else if ("constraints".equals(page)) {
            TimetableConfig activeConfig = configDao.getActiveConfig();
            req.setAttribute("activeConfig", activeConfig);
            req.getRequestDispatcher("admin/constraints.jsp").forward(req, resp);

        } else {
            // Default: Dashboard
            List<Faculty> faculties = resourceService.getAllFaculty();
            List<Subject> subjects = resourceService.getAllSubjects();
            List<Room> rooms = resourceService.getAllRooms();
            List<StudentGroup> groups = resourceService.getAllStudentGroups();
            List<Workload> workloads = resourceService.getAllWorkloads();
            List<Schedule> schedules = scheduleDao.findAll();

            req.setAttribute("faculties", faculties);
            req.setAttribute("subjects", subjects);
            req.setAttribute("rooms", rooms);
            req.setAttribute("groups", groups);
            req.setAttribute("workloads", workloads);
            req.setAttribute("schedules", schedules);

            // Stats for dashboard cards
            req.setAttribute("facultyCount", faculties.size());
            req.setAttribute("subjectCount", subjects.size());
            req.setAttribute("roomCount", rooms.size());
            req.setAttribute("groupCount", groups.size());
            req.setAttribute("workloadCount", workloads.size());
            req.setAttribute("scheduleCount", schedules.size());

            req.getRequestDispatcher("admin/dashboard.jsp").forward(req, resp);
        }
    }
}
