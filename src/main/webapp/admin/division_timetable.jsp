<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Division-Wise Timetable - TY BSc CS</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        font-size: 14px;
                        background-color: #f5f5f5;
                    }

                    .page-header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        padding: 20px;
                        margin-bottom: 30px;
                        border-radius: 8px;
                    }

                    .division-card {
                        background: white;
                        border-radius: 8px;
                        padding: 20px;
                        margin-bottom: 30px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                    }

                    .division-header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        color: white;
                        padding: 12px 20px;
                        border-radius: 6px;
                        margin-bottom: 15px;
                        font-size: 18px;
                        font-weight: bold;
                    }

                    .timetable-grid {
                        width: 100%;
                        border-collapse: collapse;
                        margin-bottom: 20px;
                    }

                    .timetable-grid th {
                        background-color: #495057;
                        color: white;
                        padding: 12px 8px;
                        text-align: center;
                        border: 2px solid #dee2e6;
                        font-weight: 600;
                    }

                    .timetable-grid td {
                        border: 2px solid #dee2e6;
                        padding: 10px 8px;
                        text-align: center;
                        vertical-align: middle;
                        min-height: 60px;
                    }

                    .time-column {
                        background-color: #6c757d;
                        color: white;
                        font-weight: bold;
                        min-width: 100px;
                    }

                    .subject-code {
                        font-weight: bold;
                        color: #0d6efd;
                        font-size: 15px;
                        display: block;
                        margin-bottom: 4px;
                    }

                    .faculty-name {
                        color: #6c757d;
                        font-size: 12px;
                        display: block;
                    }

                    .room-info {
                        color: #198754;
                        font-size: 11px;
                        display: block;
                        margin-top: 2px;
                    }

                    .empty-slot {
                        background-color: #f8f9fa;
                        color: #adb5bd;
                    }

                    .practical-section {
                        margin-top: 40px;
                    }

                    .practical-header {
                        background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                        color: white;
                        padding: 12px 20px;
                        border-radius: 6px;
                        margin-bottom: 15px;
                        font-size: 16px;
                        font-weight: bold;
                    }

                    .info-box {
                        background: #e7f3ff;
                        border-left: 4px solid #0d6efd;
                        padding: 15px;
                        margin-bottom: 20px;
                        border-radius: 4px;
                    }

                    .legend {
                        display: flex;
                        gap: 20px;
                        margin-top: 20px;
                        flex-wrap: wrap;
                    }

                    .legend-item {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                    }

                    .legend-box {
                        width: 20px;
                        height: 20px;
                        border: 2px solid #dee2e6;
                    }

                    @media print {
                        .no-print {
                            display: none;
                        }

                        .division-card {
                            page-break-after: always;
                        }

                        body {
                            background: white;
                        }
                    }
                </style>
            </head>

            <body>
                <!-- Navigation -->
                <nav class="navbar navbar-dark bg-dark mb-3 no-print">
                    <div class="container-fluid">
                        <span class="navbar-brand">📅 Division-Wise Timetable</span>
                        <div>
                            <a href="${pageContext.request.contextPath}/admin" class="btn btn-outline-light btn-sm">
                                ← Back to Dashboard
                            </a>
                            <button onclick="window.print()" class="btn btn-light btn-sm">
                                🖨️ Print
                            </button>
                        </div>
                    </div>
                </nav>

                <div class="container-fluid">
                    <!-- Page Header -->
                    <div class="page-header text-center">
                        <h2 class="mb-2">TY B.Sc (Computer Science) - Semester VI</h2>
                        <p class="mb-0">Academic Year 2025-2026 | Division-Wise Time Table</p>
                    </div>

                    <c:if test="${empty divisions}">
                        <div class="alert alert-warning">
                            <strong>⚠️ No Data Found!</strong><br />
                            Please follow these steps:
                            <ol class="mb-0 mt-2">
                                <li>Go back to Admin Dashboard</li>
                                <li>Click "Load Enhanced Data (TY CS)" button</li>
                                <li>Click "Generate Enhanced TT (Divisions)" button</li>
                                <li>Return to this page</li>
                            </ol>
                        </div>
                    </c:if>

                    <c:if test="${not empty divisions}">
                        <!-- Info Box -->
                        <div class="info-box no-print">
                            <strong>📖 How to Read This Timetable:</strong>
                            <ul class="mb-0 mt-2">
                                <li><strong>Rows</strong> = Time slots (08:45, 09:30, 10:15)</li>
                                <li><strong>Columns</strong> = Days of the week (Monday to Saturday)</li>
                                <li><strong>Each Cell</strong> shows: Subject Code, Faculty Name, and Room</li>
                                <li><strong>Theory Classes</strong>: Morning sessions (08:45 - 11:00)</li>
                                <li><strong>Practical Classes</strong>: Afternoon sessions (12:30 - 15:00)</li>
                            </ul>
                        </div>

                        <!-- Theory Timetables for Each Division -->
                        <c:forEach var="division" items="${divisions}">
                            <div class="division-card">
                                <div class="division-header">
                                    📚 Division ${division.name} - Theory Classes
                                    <span style="float: right; font-size: 14px;">
                                        📍 Classroom: ${division.classroom}
                                    </span>
                                </div>

                                <table class="timetable-grid">
                                    <thead>
                                        <tr>
                                            <th class="time-column">Time / Day</th>
                                            <c:forEach var="day" items="${days}">
                                                <th>${day}</th>
                                            </c:forEach>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Get unique time slots -->
                                        <c:set var="uniqueTimes" value="${[]}" />
                                        <c:forEach var="entry" items="${timeSlotsByDay}">
                                            <c:forEach var="time" items="${entry.value}">
                                                <c:if test="${!uniqueTimes.contains(time)}">
                                                    <c:set var="uniqueTimes" value="${uniqueTimes}" />
                                                </c:if>
                                            </c:forEach>
                                        </c:forEach>

                                        <!-- Time slots: 08:45, 09:30, 10:15 -->
                                        <c:set var="timeSlots" value="${['08:45', '09:30', '10:15']}" />
                                        <c:forEach var="timeStr" items="${timeSlots}">
                                            <tr>
                                                <td class="time-column">${timeStr}</td>
                                                <c:forEach var="day" items="${days}">
                                                    <c:set var="foundSchedule" value="${false}" />
                                                    <c:forEach var="entry" items="${scheduleMap}">
                                                        <c:set var="schedule" value="${entry.value}" />
                                                        <c:if test="${schedule.division.id == division.id && 
                                                        schedule.timeSlot.dayOfWeek == day && 
                                                        schedule.timeSlot.startTime.toString().startsWith(timeStr)}">
                                                            <td>
                                                                <span
                                                                    class="subject-code">${schedule.workload.subject.code}</span>
                                                                <span
                                                                    class="faculty-name">${schedule.workload.faculty.name}</span>
                                                                <span class="room-info">📍 ${schedule.room.name}</span>
                                                            </td>
                                                            <c:set var="foundSchedule" value="${true}" />
                                                        </c:if>
                                                    </c:forEach>
                                                    <c:if test="${!foundSchedule}">
                                                        <td class="empty-slot">-</td>
                                                    </c:if>
                                                </c:forEach>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:forEach>

                        <!-- Practical Timetable Section -->
                        <div class="practical-section">
                            <div class="division-card">
                                <div class="practical-header">
                                    🔬 Practical Time Table - All Divisions
                                    <span style="float: right; font-size: 14px;">
                                        ⏰ Time: 12:30 PM to 03:00 PM
                                    </span>
                                </div>

                                <c:if test="${not empty practicalScheduleMap}">
                                    <table class="timetable-grid">
                                        <thead>
                                            <tr>
                                                <th class="time-column">Division / Day</th>
                                                <c:forEach var="day" items="${practicalDays}">
                                                    <th>${day}</th>
                                                </c:forEach>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="division" items="${divisions}">
                                                <tr>
                                                    <td class="time-column">Div ${division.name}</td>
                                                    <c:forEach var="day" items="${practicalDays}">
                                                        <c:set var="daySchedules"
                                                            value="${practicalScheduleMap[day.toString()]}" />
                                                        <c:set var="foundPractical" value="${false}" />
                                                        <td>
                                                            <c:forEach var="schedule" items="${daySchedules}">
                                                                <c:if test="${schedule.division.id == division.id}">
                                                                    <span
                                                                        class="subject-code">${schedule.workload.subject.code}</span>
                                                                    <span
                                                                        class="faculty-name">${schedule.workload.faculty.name}</span>
                                                                    <c:if test="${schedule.batch != null}">
                                                                        <span class="room-info">👥
                                                                            ${schedule.batch.name}</span>
                                                                    </c:if>
                                                                    <c:set var="foundPractical" value="${true}" />
                                                                </c:if>
                                                            </c:forEach>
                                                            <c:if test="${!foundPractical}">
                                                                <span class="empty-slot">-</span>
                                                            </c:if>
                                                        </td>
                                                    </c:forEach>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:if>

                                <c:if test="${empty practicalScheduleMap}">
                                    <div class="alert alert-info">
                                        No practical sessions scheduled yet.
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Legend -->
                        <div class="legend no-print">
                            <div class="legend-item">
                                <div class="legend-box" style="background: white;"></div>
                                <span>Regular Class</span>
                            </div>
                            <div class="legend-item">
                                <div class="legend-box" style="background: #f8f9fa;"></div>
                                <span>Free Period</span>
                            </div>
                            <div class="legend-item">
                                <span><strong>📚</strong> = Theory Class</span>
                            </div>
                            <div class="legend-item">
                                <span><strong>🔬</strong> = Practical Class</span>
                            </div>
                        </div>
                    </c:if>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>