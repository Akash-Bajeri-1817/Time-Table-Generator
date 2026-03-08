<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<title>Student Timetable</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link href="../css/style.css" rel="stylesheet">
</head>

<body>
	<nav class="navbar navbar-dark bg-info mb-4">
		<div class="container">
			<a class="navbar-brand" href="#">Student Timetable</a> <a
				href="../index.jsp" class="btn btn-outline-light btn-sm">Home</a>
		</div>
	</nav>

	<div class="container">
		<div class="row mb-4">
			<div class="col-md-6 offset-md-3">
				<div class="card p-3">
					<form action="student" method="get">
						<label class="form-label fw-bold">Select Your Class /
							Group:</label>
						<div class="input-group">
							<select name="group_id" class="form-select">
								<c:forEach var="g" items="${groups}">
									<option value="${g.id}">${g.name}</option>
								</c:forEach>
							</select>
							<button type="submit" class="btn btn-primary">View
								Schedule</button>
						</div>
					</form>
				</div>
			</div>
		</div>

		<!-- Timetable Display -->
		<div class="card p-4">
			<h3 class="text-center mb-3">Weekly Schedule</h3>
			<div class="alert alert-warning">Note: Selection logic to
				filter by Group ID is pending in Servlet. Currently, please ask
				Admin to view the Master Timetable.</div>

			<table class="table table-bordered text-center">
				<thead class="table-dark">
					<tr>
						<th>Time / Day</th>
						<th>MON</th>
						<th>TUE</th>
						<th>WED</th>
						<th>THU</th>
						<th>FRI</th>
						<th>SAT</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td colspan="7">Select a group to view timetable.</td>
					</tr>
				</tbody>
			</table>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>