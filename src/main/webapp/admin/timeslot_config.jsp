<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Time Slot Configuration</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	background-color: #f5f7fa;
}

.config-card {
	background: white;
	border-radius: 10px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
	padding: 30px;
	margin-bottom: 20px;
}

.section-header {
	background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
	color: white;
	padding: 15px 20px;
	border-radius: 8px;
	margin-bottom: 20px;
	font-weight: bold;
}

.form-label {
	font-weight: 600;
	color: #333;
}

.day-checkbox {
	margin-right: 15px;
}

.preview-box {
	background: #f8f9fa;
	border: 2px dashed #dee2e6;
	border-radius: 8px;
	padding: 20px;
	margin-top: 20px;
}

.time-slot-item {
	background: white;
	border-left: 4px solid #667eea;
	padding: 10px 15px;
	margin-bottom: 8px;
	border-radius: 4px;
}

.break-slot {
	border-left-color: #28a745;
	background: #f0fff4;
}
</style>
</head>

<body>
	<nav class="navbar navbar-dark bg-dark mb-4">
		<div class="container-fluid">
			<span class="navbar-brand">⚙️ Time Slot Configuration</span> <a
				href="${pageContext.request.contextPath}/admin"
				class="btn btn-outline-light btn-sm"> ← Back to Dashboard </a>
		</div>
	</nav>

	<div class="container">
		<c:if test="${not empty message}">
			<div class="alert alert-info alert-dismissible fade show">
				${message}
				<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
			</div>
		</c:if>

		<div class="config-card">
			<h4 class="mb-4">📅 Configure Lecture Time Slots</h4>
			<p class="text-muted">Set up your lecture schedule once and it
				will apply to the entire semester.</p>

			<form method="post" action="timeslot-config" id="configForm">
				<!-- Section 1: Basic Time Settings -->
				<div class="section-header">1️⃣ Basic Time Settings</div>

				<div class="row">
					<div class="col-md-4 mb-3">
						<label for="startTime" class="form-label">First Lecture
							Start Time</label> <input type="time" class="form-control" id="startTime"
							name="startTime"
							value="${activeConfig != null ? activeConfig.firstLectureStartTime : '08:45'}"
							required> <small class="text-muted">When does the
							first lecture begin?</small>
					</div>

					<div class="col-md-4 mb-3">
						<label for="duration" class="form-label">Lecture Duration
							(minutes)</label> <select class="form-select" id="duration"
							name="duration" required>
							<option value="30"
								${activeConfig !=null && activeConfig.lectureDurationMinutes==30
                                        ? 'selected' : '' }>30
								minutes</option>
							<option value="45"
								${activeConfig !=null && activeConfig.lectureDurationMinutes==45
                                        ? 'selected' : 'selected' }>45
								minutes</option>
							<option value="60"
								${activeConfig !=null && activeConfig.lectureDurationMinutes==60
                                        ? 'selected' : '' }>60
								minutes</option>
							<option value="90"
								${activeConfig !=null && activeConfig.lectureDurationMinutes==90
                                        ? 'selected' : '' }>90
								minutes</option>
						</select> <small class="text-muted">How long is each lecture?</small>
					</div>

					<div class="col-md-4 mb-3">
						<label for="lecturesPerDay" class="form-label">Lectures
							Per Day</label> <select class="form-select" id="lecturesPerDay"
							name="lecturesPerDay" required>
							<option value="3"
								${activeConfig !=null && activeConfig.lecturesPerDay==3
                                        ? 'selected' : 'selected' }>3
								lectures</option>
							<option value="4"
								${activeConfig !=null && activeConfig.lecturesPerDay==4
                                        ? 'selected' : '' }>4
								lectures</option>
							<option value="5"
								${activeConfig !=null && activeConfig.lecturesPerDay==5
                                        ? 'selected' : '' }>5
								lectures</option>
							<option value="6"
								${activeConfig !=null && activeConfig.lecturesPerDay==6
                                        ? 'selected' : '' }>6
								lectures</option>
							<option value="7"
								${activeConfig !=null && activeConfig.lecturesPerDay==7
                                        ? 'selected' : '' }>7
								lectures</option>
							<option value="8"
								${activeConfig !=null && activeConfig.lecturesPerDay==8
                                        ? 'selected' : '' }>8
								lectures</option>
						</select> <small class="text-muted">How many lectures each day?</small>
					</div>
				</div>

				<!-- Section 2: Break Configuration -->
				<div class="section-header">2️⃣ Break Configuration</div>

				<div class="mb-3">
					<div class="form-check">
						<input class="form-check-input" type="checkbox" id="hasBreak"
							name="hasBreak"
							${activeConfig !=null && activeConfig.hasBreak ? 'checked' : '' }>
						<label class="form-check-label" for="hasBreak"> <strong>Include
								Break</strong>
						</label>
					</div>
				</div>

				<div id="breakOptions"
					style="display: ${activeConfig != null && activeConfig.hasBreak ? 'block' : 'none'};">
					<div class="row">
						<div class="col-md-6 mb-3">
							<label for="breakDuration" class="form-label">Break
								Duration (minutes)</label> <select class="form-select"
								id="breakDuration" name="breakDuration">
								<option value="10"
									${activeConfig !=null &&
                                            activeConfig.breakDurationMinutes==10 ? 'selected' : '' }>10
									minutes</option>
								<option value="15"
									${activeConfig !=null &&
                                            activeConfig.breakDurationMinutes==15 ? 'selected' : 'selected' }>15
									minutes</option>
								<option value="20"
									${activeConfig !=null &&
                                            activeConfig.breakDurationMinutes==20 ? 'selected' : '' }>20
									minutes</option>
								<option value="30"
									${activeConfig !=null &&
                                            activeConfig.breakDurationMinutes==30 ? 'selected' : '' }>30
									minutes</option>
							</select>
						</div>

						<div class="col-md-6 mb-3">
							<label for="breakAfter" class="form-label">Break After
								Lecture Number</label> <select class="form-select" id="breakAfter"
								name="breakAfter">
								<option value="1"
									${activeConfig !=null &&
                                            activeConfig.breakAfterLectureNumber==1 ? 'selected' : '' }>After
									1st lecture</option>
								<option value="2"
									${activeConfig !=null &&
                                            activeConfig.breakAfterLectureNumber==2 ? 'selected' : 'selected' }>After
									2nd lecture</option>
								<option value="3"
									${activeConfig !=null &&
                                            activeConfig.breakAfterLectureNumber==3 ? 'selected' : '' }>After
									3rd lecture</option>
								<option value="4"
									${activeConfig !=null &&
                                            activeConfig.breakAfterLectureNumber==4 ? 'selected' : '' }>After
									4th lecture</option>
								<option value="5"
									${activeConfig !=null &&
                                            activeConfig.breakAfterLectureNumber==5 ? 'selected' : '' }>After
									5th lecture</option>
								<option value="6"
									${activeConfig !=null &&
                                            activeConfig.breakAfterLectureNumber==6 ? 'selected' : '' }>After
									6th lecture</option>
							</select>
						</div>
					</div>
				</div>

				<!-- Section 3: Working Days -->
				<div class="section-header">3️⃣ Working Days</div>

				<div class="mb-3">
					<div class="row">
						<div class="col-md-4 day-checkbox">
							<div class="form-check">
								<input class="form-check-input" type="checkbox" id="monday"
									name="monday" checked> <label class="form-check-label"
									for="monday">Monday</label>
							</div>
						</div>
						<div class="col-md-4 day-checkbox">
							<div class="form-check">
								<input class="form-check-input" type="checkbox" id="tuesday"
									name="tuesday" checked> <label class="form-check-label"
									for="tuesday">Tuesday</label>
							</div>
						</div>
						<div class="col-md-4 day-checkbox">
							<div class="form-check">
								<input class="form-check-input" type="checkbox" id="wednesday"
									name="wednesday" checked> <label
									class="form-check-label" for="wednesday">Wednesday</label>
							</div>
						</div>
						<div class="col-md-4 day-checkbox">
							<div class="form-check">
								<input class="form-check-input" type="checkbox" id="thursday"
									name="thursday" checked> <label
									class="form-check-label" for="thursday">Thursday</label>
							</div>
						</div>
						<div class="col-md-4 day-checkbox">
							<div class="form-check">
								<input class="form-check-input" type="checkbox" id="friday"
									name="friday" checked> <label class="form-check-label"
									for="friday">Friday</label>
							</div>
						</div>
						<div class="col-md-4 day-checkbox">
							<div class="form-check">
								<input class="form-check-input" type="checkbox" id="saturday"
									name="saturday" checked> <label
									class="form-check-label" for="saturday">Saturday</label>
							</div>
						</div>
						<div class="col-md-4 day-checkbox">
							<div class="form-check">
								<input class="form-check-input" type="checkbox" id="sunday"
									name="sunday"> <label class="form-check-label"
									for="sunday">Sunday</label>
							</div>
						</div>
					</div>
				</div>

				<!-- Submit Button -->
				<div class="d-grid gap-2 mt-4">
					<button type="submit" class="btn btn-primary btn-lg">💾
						Save Configuration & Generate Time Slots</button>
				</div>
			</form>

			<!-- Preview Section -->
			<div class="preview-box" id="previewBox" style="display: none;">
				<h5>📋 Preview: Generated Time Slots</h5>
				<p class="text-muted">This is how your schedule will look:</p>
				<div id="previewContent"></div>
			</div>
		</div>

		<!-- Current Configuration Display -->
		<c:if test="${activeConfig != null}">
			<div class="config-card">
				<h5>✅ Current Active Configuration</h5>
				<div class="row mt-3">
					<div class="col-md-3">
						<strong>Start Time:</strong><br />
						${activeConfig.firstLectureStartTime}
					</div>
					<div class="col-md-3">
						<strong>Duration:</strong><br />
						${activeConfig.lectureDurationMinutes} minutes
					</div>
					<div class="col-md-3">
						<strong>Lectures/Day:</strong><br />
						${activeConfig.lecturesPerDay}
					</div>
					<div class="col-md-3">
						<strong>Break:</strong><br /> ${activeConfig.hasBreak ? activeConfig.breakDurationMinutes + ' min after ' +
                                activeConfig.breakAfterLectureNumber : 'No'}
					</div>
				</div>
			</div>
		</c:if>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
	<script>
                // Toggle break options
                document.getElementById('hasBreak').addEventListener('change', function () {
                    document.getElementById('breakOptions').style.display = this.checked ? 'block' : 'none';
                });

                // Preview functionality
                document.getElementById('configForm').addEventListener('input', updatePreview);

                function updatePreview() {
                    const startTime = document.getElementById('startTime').value;
                    const duration = parseInt(document.getElementById('duration').value);
                    const lecturesPerDay = parseInt(document.getElementById('lecturesPerDay').value);
                    const hasBreak = document.getElementById('hasBreak').checked;
                    const breakDuration = parseInt(document.getElementById('breakDuration').value);
                    const breakAfter = parseInt(document.getElementById('breakAfter').value);

                    if (!startTime) return;

                    let html = '<div class="mb-2"><strong>Sample Day Schedule:</strong></div>';
                    let currentTime = parseTime(startTime);

                    for (let i = 1; i <= lecturesPerDay; i++) {
                        const endTime = addMinutes(currentTime, duration);
                        html += `<div class="time-slot-item">
                    <strong>Lecture \${i}:</strong> \${formatTime(currentTime)} - \${formatTime(endTime)}
                </div>`;
                        currentTime = endTime;

                        if (hasBreak && i === breakAfter) {
                            const breakEnd = addMinutes(currentTime, breakDuration);
                            html += `<div class="time-slot-item break-slot">
                        <strong>BREAK:</strong> \${formatTime(currentTime)} - \${formatTime(breakEnd)}
                    </div>`;
                            currentTime = breakEnd;
                        }
                    }

                    document.getElementById('previewContent').innerHTML = html;
                    document.getElementById('previewBox').style.display = 'block';
                }

                function parseTime(timeStr) {
                    const [hours, minutes] = timeStr.split(':').map(Number);
                    return hours * 60 + minutes;
                }

                function addMinutes(time, minutes) {
                    return time + minutes;
                }

                function formatTime(minutes) {
                    const hours = Math.floor(minutes / 60);
                    const mins = minutes % 60;
                    return `${String(hours).padStart(2, '0')}:${String(mins).padStart(2, '0')}`;
                }

                // Initial preview
                updatePreview();
            </script>
</body>

</html>