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
import jakarta.servlet.http.HttpSession;

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
        // ─── AUTH GUARD ─────────────────────────────────────────────
        HttpSession authSession = req.getSession(false);
        if (authSession == null || authSession.getAttribute("adminUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/?loginError=admin&msg=Please+login+first");
            return;
        }

        try {
            String action = req.getParameter("action");
            String page = req.getParameter("page");

            // ─── ACTIONS ───────────────────────────────────────────
            if ("logout".equals(action)) {
                req.getSession().invalidate();
                resp.sendRedirect(req.getContextPath() + "/");
                return;
            } else if ("generate_ai".equals(action)) {
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

            } else if ("load_fy_sample_data".equals(action)) {
                try {
                    com.timetable.util.FYSampleDataInitializer.initialize();
                    req.setAttribute("message", "✅ FY BSc CS Sample Data Loaded! (3 Divisions, 2:00 PM start)");
                } catch (Exception e) {
                    e.printStackTrace();
                    req.setAttribute("message", "Error loading FY sample data: " + e.getMessage());
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
                if (resourceService.getFaculty(id) != null) {
                    req.setAttribute("message", "Error: Faculty cannot be deleted because they are assigned to workloads.");
                } else {
                    req.setAttribute("message", "Faculty deleted.");
                }
                page = "faculty";

            } else if ("delete_subject".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                resourceService.deleteSubject(id);
                if (resourceService.getSubject(id) != null) {
                    req.setAttribute("message", "Error: Subject cannot be deleted because it is assigned to workloads.");
                } else {
                    req.setAttribute("message", "Subject deleted.");
                }
                page = "subjects";

            } else if ("delete_room".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                resourceService.deleteRoom(id);
                if (resourceService.getAllRooms().stream().anyMatch(r -> r.getId().equals(id))) {
                    req.setAttribute("message", "Error: Room cannot be deleted because it may be used as a default classroom.");
                } else {
                    req.setAttribute("message", "Room deleted.");
                }
                page = "rooms";

            } else if ("delete_group".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                resourceService.deleteStudentGroup(id);
                if (resourceService.getStudentGroup(id) != null) {
                    req.setAttribute("message", "Error: Student Group cannot be deleted because it is assigned to workloads.");
                } else {
                    req.setAttribute("message", "Group deleted.");
                }
                page = "groups";

            } else if ("delete_division".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                
                // Manually cascade delete associated Schedules to prevent FK constraints
                com.timetable.dao.ScheduleDao sDao = new com.timetable.dao.ScheduleDao();
                sDao.findAll().stream()
                    .filter(s -> s.getDivision() != null && s.getDivision().getId().equals(id))
                    .forEach(s -> sDao.delete(s.getId()));

                // Manually cascade delete associated Workloads
                com.timetable.dao.WorkloadDao wDao = new com.timetable.dao.WorkloadDao();
                wDao.findAll().stream()
                    .filter(w -> w.getDivision() != null && w.getDivision().getId().equals(id))
                    .forEach(w -> wDao.delete(w.getId()));
                
                // Manually cascade delete associated Batches
                com.timetable.dao.BatchDao bDao = new com.timetable.dao.BatchDao();
                bDao.findAll().stream()
                    .filter(b -> b.getDivision() != null && b.getDivision().getId().equals(id))
                    .forEach(b -> bDao.delete(b.getId()));

                com.timetable.dao.DivisionDao dDao = new com.timetable.dao.DivisionDao();
                dDao.delete(id);
                if (dDao.findById(id) != null) {
                    req.setAttribute("message", "Error: Division cannot be deleted. Please check for other dependencies in the database.");
                } else {
                    req.setAttribute("message", "Division and its related Batches, Workloads, and Schedules deleted successfully.");
                }
                page = "groups";

            } else if ("delete_workload".equals(action)) {
                Long id = Long.parseLong(req.getParameter("id"));
                resourceService.deleteWorkload(id);
                if (resourceService.getAllWorkloads().stream().anyMatch(w -> w.getId().equals(id))) {
                    req.setAttribute("message", "Error: Workload could not be deleted.");
                } else {
                    req.setAttribute("message", "Workload deleted.");
                }
                page = "workload";

            } else if ("configure_timeslots".equals(action)) {
                TimetableConfig activeConfig = configDao.getActiveConfig(com.timetable.model.YearLevel.FY);
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
        // ─── AUTH GUARD ─────────────────────────────────────────────
        HttpSession authSession = req.getSession(false);
        if (authSession == null || authSession.getAttribute("adminUser") == null) {
            resp.sendRedirect(req.getContextPath() + "/?loginError=admin&msg=Please+login+first");
            return;
        }

        String action = req.getParameter("action");
        String redirectPage = "dashboard";

        if ("add_faculty".equals(action)) {
            String name = req.getParameter("name");
            String email = req.getParameter("email");
            String dept = req.getParameter("department");

            // Backend validation
            if (name == null || name.trim().isEmpty() || !name.trim().matches("^[A-Za-z. \\-]{2,100}$")) {
                req.getSession().setAttribute("flashMessage", "❌ Valid Faculty name is required (letters, spaces, dots, dashes; min 2 chars).");
            } else if (email == null || !email.matches("^[\\w.+-]+@[\\w-]+\\.[\\w.]+$")) {
                req.getSession().setAttribute("flashMessage", "❌ Please provide a valid email address.");
            } else if (dept == null || dept.trim().isEmpty() || !dept.trim().matches("^[A-Za-z \\-]{2,100}$")) {
                req.getSession().setAttribute("flashMessage", "❌ Valid Department is required (letters, spaces, dashes; min 2 chars).");
            } else {
                com.timetable.dao.FacultyDao fDao = new com.timetable.dao.FacultyDao();
                if (fDao.findByEmail(email.trim()) != null) {
                    req.getSession().setAttribute("flashMessage",
                        "❌ Duplicate: A faculty member with email \"" + email + "\" already exists.");
                } else {
                    Faculty f = new Faculty();
                    f.setName(name.trim());
                    f.setEmail(email.trim());
                    f.setDepartment(dept.trim());
                    resourceService.addFaculty(f);
                    req.getSession().setAttribute("flashMessage", "✅ Faculty \"" + f.getName() + "\" added successfully!");
                }
            }
            redirectPage = "faculty";

        } else if ("add_subject".equals(action)) {
            String code = req.getParameter("code");
            String sname = req.getParameter("name");
            String sdept = req.getParameter("department");
            String lecturesStr = req.getParameter("lectures");

            if (code == null || code.trim().isEmpty() || !code.trim().matches("^[A-Za-z0-9_\\-]{2,10}$")) {
                req.getSession().setAttribute("flashMessage", "❌ Valid Subject code is required (2-10 alphanumeric chars).");
            } else if (sname == null || sname.trim().isEmpty() || !sname.trim().matches("^[A-Za-z0-9. \\-]{3,100}$")) {
                req.getSession().setAttribute("flashMessage", "❌ Valid Subject name is required (min 3 chars).");
            } else if (sdept == null || sdept.trim().isEmpty() || !sdept.trim().matches("^[A-Za-z \\-]{2,100}$")) {
                req.getSession().setAttribute("flashMessage", "❌ Valid Department is required (letters, spaces, dashes).");
            } else if (lecturesStr == null || lecturesStr.trim().isEmpty()) {
                req.getSession().setAttribute("flashMessage", "❌ Lectures per week is required.");
            } else {
                com.timetable.dao.SubjectDao sDao = new com.timetable.dao.SubjectDao();
                if (sDao.existsByCode(code.trim())) {
                    req.getSession().setAttribute("flashMessage",
                        "❌ Duplicate: Subject code \"" + code.trim() + "\" already exists.");
                } else if (sDao.existsByName(sname.trim())) {
                    req.getSession().setAttribute("flashMessage",
                        "❌ Duplicate: Subject \"" + sname.trim() + "\" already exists.");
                } else {
                    Subject s = new Subject();
                    s.setCode(code.trim().toUpperCase());
                    s.setName(sname.trim());
                    s.setDepartment(sdept.trim());
                    s.setLecturesPerWeek(Integer.parseInt(lecturesStr.trim()));
                    s.setPractical(req.getParameter("isPractical") != null);
                    resourceService.addSubject(s);
                    req.getSession().setAttribute("flashMessage", "✅ Subject \"" + s.getName() + "\" added successfully!");
                }
            }
            redirectPage = "subjects";

        } else if ("add_room".equals(action)) {
            String rname = req.getParameter("name");
            String capStr = req.getParameter("capacity");
            String typeStr = req.getParameter("type");

            if (rname == null || rname.trim().isEmpty() || !rname.trim().matches("^[A-Za-z0-9 \\-]{2,50}$")) {
                req.getSession().setAttribute("flashMessage", "❌ Valid Room name is required (alphanumeric, spaces, dashes; min 2 chars).");
            } else if (capStr == null || capStr.trim().isEmpty()) {
                req.getSession().setAttribute("flashMessage", "❌ Room capacity is required.");
            } else {
                com.timetable.dao.RoomDao rDao = new com.timetable.dao.RoomDao();
                if (rDao.existsByName(rname.trim())) {
                    req.getSession().setAttribute("flashMessage",
                        "❌ Duplicate: Room \"" + rname.trim() + "\" already exists.");
                } else {
                    Room r = new Room();
                    r.setName(rname.trim());
                    r.setCapacity(Integer.parseInt(capStr.trim()));
                    r.setType(Room.RoomType.valueOf(typeStr));
                    resourceService.addRoom(r);
                    req.getSession().setAttribute("flashMessage", "✅ Room \"" + r.getName() + "\" added successfully!");
                }
            }
            redirectPage = "rooms";

        } else if ("add_group".equals(action)) {
            String gname = req.getParameter("name");
            if (gname == null || gname.trim().isEmpty() || !gname.trim().matches("^[A-Za-z0-9 \\-]{2,50}$")) {
                req.getSession().setAttribute("flashMessage", "❌ Valid Group name is required (min 2 chars, letters/numbers).");
            } else {
                // Check for duplicate group name
                boolean duplicate = resourceService.getAllStudentGroups().stream()
                    .anyMatch(g -> g.getName().equalsIgnoreCase(gname.trim()));
                if (duplicate) {
                    req.getSession().setAttribute("flashMessage",
                        "❌ Duplicate: Group \"" + gname.trim() + "\" already exists.");
                } else {
                    StudentGroup g = new StudentGroup();
                    g.setName(gname.trim());
                    resourceService.addStudentGroup(g);
                    req.getSession().setAttribute("flashMessage", "✅ Group \"" + g.getName() + "\" added successfully!");
                }
            }
            redirectPage = "groups";

        } else if ("add_branch".equals(action)) {
            try {
                String bcode = req.getParameter("code");
                String bname = req.getParameter("name");
                String bdept = req.getParameter("department_name");

                if (bcode == null || bcode.trim().isEmpty() || !bcode.trim().matches("^[A-Za-z0-9]{2,10}$")) {
                    req.getSession().setAttribute("flashMessage", "❌ Valid Branch code is required (2-10 alphanumeric chars).");
                } else if (bname == null || bname.trim().isEmpty() || !bname.trim().matches("^[A-Za-z0-9. \\-]{3,100}$")) {
                    req.getSession().setAttribute("flashMessage", "❌ Valid Branch name is required (min 3 chars).");
                } else if (bdept == null || bdept.trim().isEmpty() || !bdept.trim().matches("^[A-Za-z \\-]{2,50}$")) {
                    req.getSession().setAttribute("flashMessage", "❌ Valid Department name is required (letters/spaces, min 2 chars).");
                } else {
                    com.timetable.dao.BranchDao branchDao = new com.timetable.dao.BranchDao();
                    boolean dupCode = branchDao.findAll().stream()
                        .anyMatch(b -> b.getCode().equalsIgnoreCase(bcode.trim()));
                    boolean dupName = branchDao.findAll().stream()
                        .anyMatch(b -> b.getName().equalsIgnoreCase(bname.trim()));
                    if (dupCode) {
                        req.getSession().setAttribute("flashMessage",
                            "❌ Duplicate: Branch code \"" + bcode.trim() + "\" already exists.");
                    } else if (dupName) {
                        req.getSession().setAttribute("flashMessage",
                            "❌ Duplicate: Branch \"" + bname.trim() + "\" already exists.");
                    } else {
                        Branch branch = new Branch();
                        branch.setCode(bcode.trim().toUpperCase());
                        branch.setName(bname.trim());
                        branch.setDepartment(bdept.trim());
                        branchDao.save(branch);
                        req.getSession().setAttribute("flashMessage",
                            "✅ Branch \"" + branch.getName() + "\" added successfully!");
                    }
                }
            } catch (Exception e) {
                req.getSession().setAttribute("flashMessage", "❌ Error creating branch: " + e.getMessage());
            }
            redirectPage = "groups";

        } else if ("add_division".equals(action)) {
            try {
                String name = req.getParameter("name");
                String yearStr = req.getParameter("year");
                int capacity = 0;
                if(req.getParameter("capacity") != null && !req.getParameter("capacity").trim().isEmpty()){
                     capacity = Integer.parseInt(req.getParameter("capacity"));
                }
                String classroom = req.getParameter("classroom");
                Long branchId = Long.parseLong(req.getParameter("branch_id"));

                Division div = new Division();
                div.setName(name);
                
                // Convert string "FY", "SY", "TY" to the YearLevel enum
                YearLevel yearLevel = YearLevel.valueOf(yearStr);
                div.setYear(yearLevel);
                
                div.setCapacity(capacity);
                div.setClassroom(classroom);
                
                // Fetch the actual Branch object to avoid detached entity problems
                com.timetable.dao.BranchDao branchDao = new com.timetable.dao.BranchDao();
                Branch branch = branchDao.findById(branchId);
                
                if (branch == null) {
                    throw new Exception("Branch with ID " + branchId + " not found in the database. Please create it first.");
                }
                
                div.setBranch(branch);

                divisionDao.save(div);
                req.getSession().setAttribute("flashMessage", "✅ Division created successfully!");
            } catch (Exception e) {
                req.getSession().setAttribute("flashMessage", "❌ Error creating division: " + e.getMessage());
            }
            redirectPage = "groups";

        } else if ("add_workload".equals(action)) {
            try {
                Long facultyId = Long.parseLong(req.getParameter("faculty_id"));
                Long subjectId = Long.parseLong(req.getParameter("subject_id"));
                Long groupId = Long.parseLong(req.getParameter("group_id"));
                Long divisionId = Long.parseLong(req.getParameter("division_id"));

                Workload w = new Workload();
                w.setFaculty(resourceService.getFaculty(facultyId));
                w.setSubject(resourceService.getSubject(subjectId));
                w.setStudentGroup(resourceService.getStudentGroup(groupId));
                w.setDivision(divisionDao.findById(divisionId));
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
                config.setYearLevel(com.timetable.model.YearLevel.valueOf(req.getParameter("yearLevel")));
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
            com.timetable.dao.BranchDao branchDao = new com.timetable.dao.BranchDao();
            req.setAttribute("branches", branchDao.findAll());
            req.getRequestDispatcher("admin/student_groups.jsp").forward(req, resp);

        } else if ("workload".equals(page)) {
            req.setAttribute("workloads", resourceService.getAllWorkloads());
            req.setAttribute("faculties", resourceService.getAllFaculty());
            req.setAttribute("subjects", resourceService.getAllSubjects());
            req.setAttribute("groups", resourceService.getAllStudentGroups());
            req.setAttribute("divisions", divisionDao.findAll());
            req.getRequestDispatcher("admin/workload.jsp").forward(req, resp);

        } else if ("timetable".equals(page)) {
            req.setAttribute("schedules", scheduleDao.findAll());
            req.setAttribute("groups", resourceService.getAllStudentGroups());
            req.getRequestDispatcher("admin/view_timetable.jsp").forward(req, resp);

        } else if ("constraints".equals(page)) {
            TimetableConfig activeConfig = configDao.getActiveConfig(com.timetable.model.YearLevel.FY);
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
