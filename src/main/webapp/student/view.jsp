<%@ page contentType="text/html;charset=UTF-8" language="java" %>
	<%@ page
		import="com.timetable.model.Schedule,com.timetable.model.StudentGroup,java.util.*,java.time.DayOfWeek,java.time.LocalTime"
		%>
		<%@ taglib prefix="c" uri="jakarta.tags.core" %>
			<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
				<!DOCTYPE html>
				<html lang="en">

				<head>
					<meta charset="utf-8" />
					<meta name="viewport" content="width=device-width, initial-scale=1.0" />
					<title>Student Timetable | Timetable Pro</title>
					<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
					<script
						src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
					<link
						href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;600;700&display=swap"
						rel="stylesheet" />
					<link
						href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
						rel="stylesheet" />
					<script id="tailwind-config">
						tailwind.config = {
							theme: {
								extend: {
									colors: {
										"primary": "#2D5A27",
										"primary-light": "#E8F5E9",
										"primary-dark": "#1e3e1a",
										"background-light": "#F4F1EA",
										"border-color": "#E5E7EB"
									},
									fontFamily: {
										sans: ['Inter', 'sans-serif'],
										serif: ['Playfair Display', 'serif']
									}
								}
							}
						}
					</script>
					<style>
						.material-symbols-outlined {
							font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
						}

						.slot-pill {
							transition: box-shadow .15s, transform .15s;
							display: block;
						}

						.slot-pill:hover {
							box-shadow: 0 4px 12px rgba(30, 64, 175, .15);
							transform: translateY(-1px);
						}

						@media print {
							.no-print {
								display: none !important;
							}
						}
					</style>
				</head>

				<body class="bg-background-light font-sans text-gray-900 min-h-screen flex flex-col">

					<!-- Top Navigation -->
					<nav
						class="bg-white border-b border-primary/10 shadow-sm text-gray-800 px-6 py-4 flex items-center justify-between sticky top-0 z-50 no-print">
						<div class="flex items-center gap-3">
							<div class="size-10 rounded-lg bg-primary/10 flex items-center justify-center">
								<span class="material-symbols-outlined text-2xl text-primary">event_note</span>
							</div>
							<div>
								<h1 class="text-xl font-bold font-serif leading-tight">Student Portal</h1>
								<p class="text-xs text-gray-500 font-medium tracking-wide">Timetable Pro</p>
							</div>
						</div>
						<div>
							<a href="${pageContext.request.contextPath}/"
								class="text-gray-600 hover:text-primary transition-colors flex items-center gap-1.5 font-semibold text-sm">
								<span class="material-symbols-outlined text-[18px]">home</span> Return Home
							</a>
						</div>
					</nav>

					<main class="flex-1 max-w-7xl w-full mx-auto p-4 sm:p-6 lg:p-8 flex flex-col gap-6">

						<!-- Header and Selection Card -->
						<div
							class="bg-white rounded-2xl shadow-sm border border-gray-200 p-6 flex flex-col md:flex-row items-start md:items-center justify-between gap-6 no-print">
							<div>
								<h2 class="text-2xl font-bold font-serif text-gray-900">Find Your Schedule</h2>
								<p class="text-gray-500 text-sm mt-1">Select your class grouping from the dropdown
									below.</p>
							</div>

							<form action="student" method="get"
								class="w-full md:w-auto flex flex-col sm:flex-row gap-3">
								<div class="relative min-w-[300px]">
									<select name="group_id"
										class="w-full pl-4 pr-10 py-3 rounded-xl border border-gray-300 focus:border-primary focus:ring-2 focus:ring-primary/20 appearance-none font-medium text-gray-800 bg-white shadow-sm"
										onchange="this.form.submit()">
										<option value="">-- Select Your Class Group --</option>
										<c:forEach var="g" items="${groups}">
											<option value="${g.id}" ${selectedGroupId==g.id ? 'selected' : '' }>
												${g.name}
											</option>
										</c:forEach>
									</select>
									<div
										class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-4 text-gray-500">
										<span class="material-symbols-outlined text-xl">expand_more</span>
									</div>
								</div>
							</form>
						</div>

						<!-- Timetable View Area -->
						<div class="flex-1">
							<c:choose>
								<c:when test="${empty selectedGroupId}">
									<div
										class="bg-white rounded-2xl border border-gray-200 p-16 flex flex-col items-center justify-center text-center shadow-sm h-full no-print">
										<div
											class="size-20 rounded-full bg-blue-50 flex items-center justify-center mb-6">
											<span class="material-symbols-outlined text-4xl text-primary">search</span>
										</div>
										<h3 class="text-xl font-bold font-serif mb-2">No Class Selected</h3>
										<p class="text-gray-500 text-sm max-w-md">Please use the dropdown menu above to
											select your student group and view your timetable for the week.</p>
									</div>
								</c:when>

								<c:when test="${empty schedules}">
									<div
										class="bg-yellow-50 rounded-2xl border border-yellow-200 p-16 flex flex-col items-center justify-center text-center shadow-sm no-print">
										<div
											class="size-20 rounded-full bg-yellow-100 flex items-center justify-center mb-6">
											<span
												class="material-symbols-outlined text-4xl text-yellow-600">event_busy</span>
										</div>
										<h3 class="text-xl font-bold font-serif mb-2 text-yellow-800">No Schedule Found
										</h3>
										<p class="text-yellow-700 text-sm max-w-md">There doesn't seem to be a saved
											master timetable for this group. The administrator may not have generated it
											yet.</p>
									</div>
								</c:when>

								<c:otherwise>
									<% List<Schedule> allSched = (List<Schedule>) request.getAttribute("schedules");
											TreeSet<LocalTime> startSet = new TreeSet<>();
													LinkedHashMap<LocalTime,LocalTime> endMap = new LinkedHashMap<>();
															if (allSched != null) {
															for (Schedule sc : allSched) {
															if (sc.getTimeSlot() != null) {
															LocalTime s = sc.getTimeSlot().getStartTime();
															LocalTime e = sc.getTimeSlot().getEndTime();
															startSet.add(s);
															endMap.put(s, e);
															}
															}
															}
															List<LocalTime> startList = new ArrayList<>(startSet);
																	DayOfWeek[] days = {
																	DayOfWeek.MONDAY, DayOfWeek.TUESDAY,
																	DayOfWeek.WEDNESDAY,
																	DayOfWeek.THURSDAY, DayOfWeek.FRIDAY,
																	DayOfWeek.SATURDAY
																	};
																	request.setAttribute("startList", startList);
																	request.setAttribute("endMap", endMap);
																	request.setAttribute("gridDays", days);
																	request.setAttribute("allSchedList", allSched);
																	%>

																	<div
																		class="flex items-center justify-between mb-4 no-print">
																		<div class="flex flex-col">
																			<h3
																				class="text-2xl font-bold font-serif text-primary">
																				${selectedGroupName}</h3>
																			<p class="text-sm text-gray-500">Showing all
																				weekly lectures</p>
																		</div>
																		<button onclick="exportPDF()"
																			class="flex items-center gap-2 px-4 py-2 bg-white border border-gray-300 text-gray-800 rounded-lg shadow-sm hover:bg-gray-50 text-sm font-semibold transition-colors">
																			<span
																				class="material-symbols-outlined text-[18px]">download</span>
																			Export PDF
																		</button>
																	</div>

																	<%-- PDF Grid Container --%>
																		<div id="timetableGridContainer"
																			class="rounded-xl border border-gray-200 shadow-sm bg-white p-2 overflow-x-auto">

																			<%-- Hidden Header for PDF Output --%>
																				<div class="mb-4 text-center hidden pb-2 border-b border-primary/10"
																					id="pdfHeader">
																					<h2
																						class="text-2xl font-bold text-gray-900 font-serif">
																						Timetable</h2>
																					<p
																						class="text-md font-semibold text-primary mt-1">
																						${selectedGroupName}</p>
																				</div>

																				<table
																					class="w-full border-collapse bg-white text-xs"
																					style="min-width: 900px;">
																					<thead>
																						<tr
																							class="bg-gray-50 border-b border-gray-200">
																							<th
																								class="border-r border-gray-200 px-3 py-4 text-center w-28 text-gray-500 font-bold uppercase tracking-wider">
																								Time</th>
																							<c:forEach var="d"
																								items="${gridDays}">
																								<th
																									class="border-r last:border-r-0 border-gray-200 px-3 py-4 text-center font-bold text-gray-600 uppercase tracking-wider w-[14%]">
																									${fn:substring(d.toString(),0,3)}
																								</th>
																							</c:forEach>
																						</tr>
																					</thead>
																					<tbody>
																						<c:forEach var="st"
																							items="${startList}">
																							<tr
																								class="border-b border-gray-100 last:border-b-0 hover:bg-gray-50/30 transition-colors">
																								<%-- Time Column --%>
																									<td
																										class="border-r border-gray-200 px-3 py-3 text-center bg-gray-50/50 align-middle">
																										<p
																											class="font-bold text-gray-800 text-sm">
																											${st}</p>
																										<p
																											class="text-gray-500 text-[10px] mt-0.5 font-medium">
																											to
																											${endMap[st]}
																										</p>
																									</td>

																									<%-- Day Columns
																										--%>
																										<c:forEach
																											var="d"
																											items="${gridDays}">
																											<td
																												class="border-r last:border-r-0 border-gray-200 px-2 py-2 align-top h-[90px]">
																												<c:forEach
																													var="sc"
																													items="${allSchedList}">
																													<c:if
																														test="${sc.timeSlot.startTime == st and sc.timeSlot.dayOfWeek == d}">
																														<div
																															class="slot-pill rounded-lg p-3 h-full border bg-primary-light/40 border-primary/20 flex flex-col">

																															<div
																																class="flex-1">
																																<p class="font-bold text-primary-dark text-sm leading-tight mb-1"
																																	title="${sc.workload.subject.name}">
																																	${sc.workload.subject.name}
																																</p>
																																<p
																																	class="text-xs font-medium text-gray-600 truncate">
																																	${sc.workload.faculty.name}
																																</p>
																															</div>

																															<div
																																class="flex items-center gap-1 mt-2 pt-2 border-t border-primary/10">
																																<span
																																	class="material-symbols-outlined text-[14px] text-primary">meeting_room</span>
																																<p
																																	class="text-[11px] font-bold text-primary-dark">
																																	${sc.room.name}
																																</p>
																															</div>
																														</div>
																													</c:if>
																												</c:forEach>
																											</td>
																										</c:forEach>
																							</tr>
																						</c:forEach>
																					</tbody>
																				</table>
																		</div>
								</c:otherwise>
							</c:choose>
						</div>
					</main>

					<script>
						function exportPDF() {
							var element = document.getElementById('timetableGridContainer');
							var header = document.getElementById('pdfHeader');

							// Show header for PDF
							if (header) header.classList.remove('hidden');

							var filename = 'Student_Timetable.pdf';

							// Modern PDF Generation
							var opt = {
								margin: 0.3,
								filename: filename,
								image: { type: 'jpeg', quality: 0.98 },
								html2canvas: { scale: 2, useCORS: true },
								jsPDF: { unit: 'in', format: 'a4', orientation: 'landscape' }
							};

							// Generate PDF, then hide header again
							html2pdf().set(opt).from(element).save().then(function () {
								if (header) header.classList.add('hidden');
							});
						}
					</script>
				</body>

				</html>