<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<title>Faculty Dashboard</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="../css/style.css" rel="stylesheet">
</head>

<body>
	<nav class="navbar navbar-dark bg-secondary mb-4">
		<div class="container">
			<a class="navbar-brand" href="#">Faculty Dashboard</a> <a
				href="../index.jsp" class="btn btn-outline-light btn-sm">Logout</a>
		</div>
	</nav>

	<div class="container">
		<div class="card p-4">
			<h2>Welcome, Faculty Member</h2>
			<p class="text-muted">Below is your teaching schedule for the
				week.</p>

			<div class="alert alert-warning">Note: This is a placeholder
				view. In a real system, you would see only your assigned lectures
				here. Currently, please ask Admin to view the Master Timetable.</div>

			<!-- Placeholder for individual timetable -->
			<table class="table table-bordered mt-3">
				<thead class="table-light">
					<tr>
						<th>Day</th>
						<th>Time</th>
						<th>Subject</th>
						<th>Group/Class</th>
						<th>Room</th>
					</tr>
				</thead>
				<tbody>
					<!-- Iterate over faculty-specific schedules here -->
					<tr>
						<td colspan="5" class="text-center">No schedule assigned yet
							or view not implemented for specific faculty ID.</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>