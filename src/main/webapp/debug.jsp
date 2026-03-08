<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.timetable.dao.*"%>
<%@ page import="com.timetable.model.*"%>
<%@ page import="java.util.List"%>
<!DOCTYPE html>
<html>

<head>
<title>Debug Info</title>
</head>

<body>
	<h1>Database Debug Information</h1>

	<% try { FacultyDao facultyDao=new FacultyDao(); SubjectDao subjectDao=new SubjectDao(); RoomDao
                        roomDao=new RoomDao(); StudentGroupDao groupDao=new StudentGroupDao(); WorkloadDao
                        workloadDao=new WorkloadDao(); TimeSlotDao timeSlotDao=new TimeSlotDao(); ScheduleDao
                        scheduleDao=new ScheduleDao(); List<Faculty> faculties = facultyDao.findAll();
                        List<Subject> subjects = subjectDao.findAll();
                            List<Room> rooms = roomDao.findAll();
                                List<StudentGroup> groups = groupDao.findAll();
                                    List<Workload> workloads = workloadDao.findAll();
                                        List<TimeSlot> timeSlots = timeSlotDao.findAll();
                                            List<Schedule> schedules = scheduleDao.findAll();
                                                %>

	<h2>Data Counts:</h2>
	<ul>
		<li>Faculties: <%= faculties.size() %>
		</li>
		<li>Subjects: <%= subjects.size() %>
		</li>
		<li>Rooms: <%= rooms.size() %>
		</li>
		<li>Student Groups: <%= groups.size() %>
		</li>
		<li>Workloads: <%= workloads.size() %>
		</li>
		<li>Time Slots: <%= timeSlots.size() %>
		</li>
		<li>Schedules: <%= schedules.size() %>
		</li>
	</ul>

	<h2>Faculties:</h2>
	<ul>
		<% for (Faculty f : faculties) { %>
		<li><%= f.getName() %> - <%= f.getEmail() %></li>
		<% } %>
	</ul>

	<h2>Subjects:</h2>
	<ul>
		<% for (Subject s : subjects) { %>
		<li><%= s.getCode() %> - <%= s.getName() %> (Lectures: <%=
                                                                        s.getLecturesPerWeek() %>,
			Practical: <%=
                                                                            s.isPractical() %>)
		</li>
		<% } %>
	</ul>

	<h2>Rooms:</h2>
	<ul>
		<% for (Room r : rooms) { %>
		<li><%= r.getName() %> - <%= r.getType() %> (Capacity: <%=
                                                                        r.getCapacity() %>)
		</li>
		<% } %>
	</ul>

	<h2>Student Groups:</h2>
	<ul>
		<% for (StudentGroup g : groups) { %>
		<li><%= g.getName() %></li>
		<% } %>
	</ul>

	<h2>Workloads:</h2>
	<ul>
		<% for (Workload w : workloads) { %>
		<li><%= w.getFaculty().getName() %> teaches <%=
                                                                    w.getSubject().getName() %>
			to <%=
                                                                        w.getStudentGroup().getName() %>
		</li>
		<% } %>
	</ul>

	<h2>Time Slots:</h2>
	<ul>
		<% for (TimeSlot ts : timeSlots) { %>
		<li><%= ts.getDayOfWeek() %> <%= ts.getStartTime() %> - <%= ts.getEndTime() %>
		</li>
		<% } %>
	</ul>

	<h2>Generated Schedules:</h2>
	<ul>
		<% for (Schedule sch : schedules) { %>
		<li><%= sch.getTimeSlot().getDayOfWeek() %> <%= sch.getTimeSlot().getStartTime() %>:
			<%= sch.getWorkload().getSubject().getName() %> by <%= sch.getWorkload().getFaculty().getName()
                                                                            %>
			for <%=
                                                                                sch.getWorkload().getStudentGroup().getName()
                                                                                %>
			in <%= sch.getRoom().getName() %></li>
		<% } %>
	</ul>

	<% } catch (Exception e) { out.println("<h2 style='color:red;'>Error: "
                                                    + e.getMessage() + "</h2>");
                                                    e.printStackTrace();
                                                    }
                                                    %>

	<br>
	<br>
	<a href="admin">Back to Admin Dashboard</a>
</body>

</html>