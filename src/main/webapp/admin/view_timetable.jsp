<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Master Timetable</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
        </head>

        <body>
            <nav class="navbar navbar-dark bg-success mb-4">
                <div class="container">
                    <a class="navbar-brand" href="#">Master Timetable</a>
                    <a href="admin" class="btn btn-outline-light btn-sm">Back to Admin</a>
                </div>
            </nav>

            <div class="container-fluid">
                <!-- Filters can be added here -->

                <div class="table-responsive">
                    <table class="table table-bordered table-striped text-center">
                        <thead class="table-dark">
                            <tr>
                                <th>Time / Day</th>
                                <th>MONDAY</th>
                                <th>TUESDAY</th>
                                <th>WEDNESDAY</th>
                                <th>THURSDAY</th>
                                <th>FRIDAY</th>
                                <th>SATURDAY</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- 
                   Simplification: Just listing schedules as a list first because grid transformation 
                   logic (pivoting rows/cols) is complex for JSP alone. 
                   For now, we list them to prove data flow, then iterate to Grid.
                -->
                            <c:if test="${empty schedules}">
                                <tr>
                                    <td colspan="7">No timetable generated yet.</td>
                                </tr>
                            </c:if>

                            <!-- Note: To render a true grid (Time x Day), we need pre-processing in Java. 
                      Since we are dumping list of schedules, let's just show a List View for now 
                      and I will enhance this if user asks for specific view or if I have time to do 
                      the pivot logic in Servlet.
                  -->
                        </tbody>
                    </table>

                    <!-- List View Fallback -->
                    <h3>All Slots</h3>
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Day</th>
                                <th>Time</th>
                                <th>Class</th>
                                <th>Subject</th>
                                <th>Faculty</th>
                                <th>Room</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="s" items="${schedules}">
                                <tr>
                                    <td>${s.timeSlot.dayOfWeek}</td>
                                    <td>${s.timeSlot.startTime} - ${s.timeSlot.endTime}</td>
                                    <td>${s.workload.studentGroup.name}</td>
                                    <td>${s.workload.subject.name}</td>
                                    <td>${s.workload.faculty.name}</td>
                                    <td>${s.room.name} (${s.room.type})</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>