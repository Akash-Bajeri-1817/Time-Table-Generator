<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Automated Timetable Generator</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="#">TimetableGen</a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item"><a class="nav-link" href="admin">Admin Login</a></li>
                <li class="nav-item"><a class="nav-link" href="faculty">Faculty Login</a></li>
                <li class="nav-item"><a class="nav-link" href="student">Student View</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-5 text-center">
    <h1 class="display-4 fw-bold">Smart College Scheduling</h1>
    <p class="lead text-muted">Automated conflict-free timetable generation for Faculties, Students, and Resources.</p>
    
    <div class="row mt-5">
        <div class="col-md-4">
            <div class="card p-4">
                <h3>Administrator</h3>
                <p>Manage Resources, Workloads, and Generate Schedules.</p>
                <a href="admin" class="btn btn-outline-primary">Go to Admin</a>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-4">
                <h3>Faculty</h3>
                <p>View your personal teaching schedule and workload.</p>
                <a href="faculty" class="btn btn-outline-primary">Go to Faculty</a>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card p-4">
                <h3>Student</h3>
                <p>Check your class timetable and upcoming lectures.</p>
                <a href="student" class="btn btn-outline-primary">Go to Student</a>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
