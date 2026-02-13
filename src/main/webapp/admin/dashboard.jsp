<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Admin Dashboard - Timetable Generator</title>
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
        </head>

        <body>
            <nav class="navbar navbar-dark bg-primary mb-4">
                <div class="container">
                    <a class="navbar-brand" href="#">Admin Dashboard</a>
                    <a href="../index.jsp" class="btn btn-outline-light btn-sm">Logout</a>
                </div>
            </nav>

            <div class="container">
                <c:if test="${not empty message}">
                    <div class="alert alert-info alert-dismissible fade show">
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <div class="row">
                    <div class="col-md-3">
                        <div class="list-group" id="list-tab" role="tablist">
                            <a class="list-group-item list-group-item-action active" id="list-faculty-list"
                                data-bs-toggle="list" href="#list-faculty">Manage Faculty</a>
                            <a class="list-group-item list-group-item-action" id="list-subject-list"
                                data-bs-toggle="list" href="#list-subject">Manage Subjects</a>
                            <a class="list-group-item list-group-item-action" id="list-room-list" data-bs-toggle="list"
                                href="#list-room">Manage Rooms</a>
                            <a class="list-group-item list-group-item-action" id="list-group-list" data-bs-toggle="list"
                                href="#list-group">Student Groups</a>
                            <a class="list-group-item list-group-item-action" id="list-workload-list"
                                data-bs-toggle="list" href="#list-workload">Assign Workload</a>

                            <!-- Enhanced Timetable Actions -->
                            <div class="mt-3 mb-2 text-muted small px-3">TIMETABLE ACTIONS</div>
                            <a class="list-group-item list-group-item-action bg-info text-white"
                                href="admin?action=load_enhanced_data">📊 Load Sample Data</a>
                            <a class="list-group-item list-group-item-action bg-primary text-white mt-1"
                                href="admin?action=generate_enhanced">⚡ Generate Timetable</a>
                            <a class="list-group-item list-group-item-action bg-success text-white mt-1"
                                href="division-timetable">📅 View Timetable</a>
                        </div>
                    </div>
                    <div class="col-md-9">
                        <div class="tab-content" id="nav-tabContent">

                            <!-- FACULTY TAB -->
                            <div class="tab-pane fade show active" id="list-faculty" role="tabpanel">
                                <h3>Add Faculty</h3>
                                <form action="admin" method="post" class="card p-3 bg-light">
                                    <input type="hidden" name="action" value="add_faculty">
                                    <div class="row g-3">
                                        <div class="col-md-4"><input type="text" name="name" class="form-control"
                                                placeholder="Name" required></div>
                                        <div class="col-md-4"><input type="email" name="email" class="form-control"
                                                placeholder="Email" required></div>
                                        <div class="col-md-4"><input type="text" name="department" class="form-control"
                                                placeholder="Department" required></div>
                                        <div class="col-12"><button type="submit" class="btn btn-primary w-100">Add
                                                Faculty</button></div>
                                    </div>
                                </form>
                                <h4 class="mt-4">Existing Faculty</h4>
                                <ul class="list-group">
                                    <c:forEach var="f" items="${faculties}">
                                        <li class="list-group-item">${f.name} (${f.department})</li>
                                    </c:forEach>
                                </ul>
                            </div>

                            <!-- SUBJECT TAB -->
                            <div class="tab-pane fade" id="list-subject" role="tabpanel">
                                <h3>Add Subject</h3>
                                <form action="admin" method="post" class="card p-3 bg-light">
                                    <input type="hidden" name="action" value="add_subject">
                                    <div class="row g-3">
                                        <div class="col-md-2"><input type="text" name="code" class="form-control"
                                                placeholder="Code" required></div>
                                        <div class="col-md-4"><input type="text" name="name" class="form-control"
                                                placeholder="Subject Name" required></div>
                                        <div class="col-md-3"><input type="number" name="lectures" class="form-control"
                                                placeholder="Lectures/Week" required></div>
                                        <div class="col-md-3">
                                            <div class="form-check pt-2">
                                                <input class="form-check-input" type="checkbox" name="isPractical"
                                                    id="isPractical">
                                                <label class="form-check-label" for="isPractical">Is Practical</label>
                                            </div>
                                        </div>
                                        <div class="col-md-4"><input type="text" name="department" class="form-control"
                                                placeholder="Department" required></div>
                                        <div class="col-12"><button type="submit" class="btn btn-primary w-100">Add
                                                Subject</button></div>
                                    </div>
                                </form>
                                <h4 class="mt-4">Existing Subjects</h4>
                                <ul class="list-group">
                                    <c:forEach var="s" items="${subjects}">
                                        <li class="list-group-item">${s.code} - ${s.name} (${s.lecturesPerWeek} lec/wk)
                                            <c:if test="${s.practical}"><span class="badge bg-info">Practical</span>
                                            </c:if>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>

                            <!-- ROOM TAB -->
                            <div class="tab-pane fade" id="list-room" role="tabpanel">
                                <h3>Add Room</h3>
                                <form action="admin" method="post" class="card p-3 bg-light">
                                    <input type="hidden" name="action" value="add_room">
                                    <div class="row g-3">
                                        <div class="col-md-5"><input type="text" name="name" class="form-control"
                                                placeholder="Room Name/Number" required></div>
                                        <div class="col-md-3"><input type="number" name="capacity" class="form-control"
                                                placeholder="Capacity" required></div>
                                        <div class="col-md-4">
                                            <select name="type" class="form-select">
                                                <option value="CLASSROOM">Classroom</option>
                                                <option value="LAB">Lab</option>
                                            </select>
                                        </div>
                                        <div class="col-12"><button type="submit" class="btn btn-primary w-100">Add
                                                Room</button></div>
                                    </div>
                                </form>
                                <h4 class="mt-4">Existing Rooms</h4>
                                <ul class="list-group">
                                    <c:forEach var="r" items="${rooms}">
                                        <li class="list-group-item">${r.name} - ${r.type} (Cap: ${r.capacity})</li>
                                    </c:forEach>
                                </ul>
                            </div>

                            <!-- GROUP TAB -->
                            <div class="tab-pane fade" id="list-group" role="tabpanel">
                                <h3>Add Student Group</h3>
                                <form action="admin" method="post" class="card p-3 bg-light">
                                    <input type="hidden" name="action" value="add_group">
                                    <div class="row g-3">
                                        <div class="col-md-8"><input type="text" name="name" class="form-control"
                                                placeholder="Group Name (e.g. TY BSc CS - Div A)" required></div>
                                        <div class="col-12"><button type="submit" class="btn btn-primary w-100">Add
                                                Group</button></div>
                                    </div>
                                </form>
                                <h4 class="mt-4">Existing Groups</h4>
                                <ul class="list-group">
                                    <c:forEach var="g" items="${groups}">
                                        <li class="list-group-item">${g.name}</li>
                                    </c:forEach>
                                </ul>
                            </div>

                            <!-- WORKLOAD TAB -->
                            <div class="tab-pane fade" id="list-workload" role="tabpanel">
                                <h3>Assign Workload</h3>
                                <form action="admin" method="post" class="card p-3 bg-light">
                                    <input type="hidden" name="action" value="add_workload">
                                    <div class="row g-3">
                                        <div class="col-md-4">
                                            <label>Faculty</label>
                                            <select name="faculty_id" class="form-select">
                                                <c:forEach var="f" items="${faculties}">
                                                    <option value="${f.id}">${f.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label>Subject</label>
                                            <select name="subject_id" class="form-select">
                                                <c:forEach var="s" items="${subjects}">
                                                    <option value="${s.id}">${s.name} (${s.code})</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-4">
                                            <label>Class/Group</label>
                                            <select name="group_id" class="form-select">
                                                <c:forEach var="g" items="${groups}">
                                                    <option value="${g.id}">${g.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-12"><button type="submit"
                                                class="btn btn-primary w-100">Assign</button></div>
                                    </div>
                                </form>
                                <h4 class="mt-4">Current Assignments</h4>
                                <ul class="list-group">
                                    <c:forEach var="w" items="${workloads}">
                                        <li class="list-group-item">
                                            <strong>${w.faculty.name}</strong> teaches
                                            <strong>${w.subject.name}</strong> to
                                            <strong>${w.studentGroup.name}</strong>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>

                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        </body>

        </html>