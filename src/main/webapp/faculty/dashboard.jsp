<%@ page contentType="text/html;charset=UTF-8" language="java" %>
	<%@ page
		import="com.timetable.model.Schedule,com.timetable.model.Faculty,java.util.*,java.time.DayOfWeek,java.time.LocalTime"
		%>
		<%@ taglib prefix="c" uri="jakarta.tags.core" %>
			<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
				<!DOCTYPE html>
				<html lang="en">

				<head>
					<meta charset="utf-8" />
					<meta content="width=device-width, initial-scale=1.0" name="viewport" />
					<title>Faculty Dashboard | Timetable Pro</title>
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
										primary: "#2D5A27",
										"primary-light": "#E8F5E9",
										"background-light": "#F4F1EA",
										"text-header": "#111827",
										"text-body": "#4B5563",
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
							box-shadow: 0 4px 12px rgba(45, 90, 39, .18);
							transform: translateY(-1px);
						}
					</style>
				</head>

				<body class="bg-background-light font-sans text-text-header flex overflow-hidden h-screen">

					<!-- Sidebar -->
					<aside
						class="w-72 bg-white border-r border-slate-200 flex flex-col justify-between shrink-0 overflow-y-auto">
						<div class="flex flex-col gap-6 p-6">
							<!-- Logo -->
							<div class="flex items-center gap-3">
								<div
									class="size-10 rounded-lg bg-primary/10 flex items-center justify-center text-primary">
									<span class="material-symbols-outlined text-2xl">school</span>
								</div>
								<div>
									<h1 class="text-base font-bold text-slate-900">Faculty Portal</h1>
									<p class="text-xs text-slate-500">Timetable Pro</p>
								</div>
							</div>

							<!-- Nav Links -->
							<nav class="flex flex-col gap-1">
								<a href="${pageContext.request.contextPath}/faculty"
									class="relative flex items-center gap-3 px-4 py-3 rounded-lg bg-primary/10 text-primary font-semibold">
									<div
										class="absolute left-0 top-1/2 -translate-y-1/2 h-8 w-1 bg-primary rounded-r-full">
									</div>
									<span class="material-symbols-outlined text-xl">dashboard</span>
									<span class="text-sm">My Schedule</span>
								</a>
							</nav>
						</div>

						<!-- User Profile + Logout -->
						<div class="p-6 border-t border-slate-100">
							<div class="flex items-center gap-3 px-2 mb-4">
								<div
									class="size-10 rounded-full bg-primary/20 flex items-center justify-center text-primary font-bold text-sm uppercase">
									${fn:substring(facultyUser.name, 0, 2)}
								</div>
								<div class="flex flex-col overflow-hidden">
									<span class="text-sm font-bold text-slate-900 truncate"
										title="${facultyUser.name}">${facultyUser.name}</span>
									<span
										class="text-[10px] text-slate-500 uppercase tracking-tight truncate">${facultyUser.department}</span>
								</div>
							</div>
							<a href="${pageContext.request.contextPath}/faculty?action=logout"
								class="flex items-center gap-3 px-4 py-2.5 rounded-lg text-red-600 hover:bg-red-50 transition-colors font-medium w-full group">
								<span
									class="material-symbols-outlined text-xl group-hover:scale-110 transition-transform">logout</span>
								<span class="text-sm">Logout</span>
							</a>
						</div>
					</aside>

					<main class="flex-1 flex flex-col overflow-hidden">
						<header
							class="bg-white border-b border-border-color px-8 py-4 flex items-center justify-between shrink-0">
							<div>
								<nav class="flex items-center gap-2 text-sm text-text-body mb-1">
									<a href="${pageContext.request.contextPath}/faculty"
										class="hover:text-primary">Faculty</a>
									<span class="material-symbols-outlined text-sm text-gray-400">chevron_right</span>
									<span class="font-semibold text-primary">My Schedule</span>
								</nav>
								<h1 class="font-serif text-2xl font-bold text-primary">Your Timetable</h1>
							</div>

							<div class="flex items-center gap-3">
								<span class="text-sm bg-primary-light px-3 py-1 rounded-full font-medium text-primary">
									<span id="lectureCount">${schedules.size()}</span> assigned lectures
								</span>
								<button onclick="exportPDF()"
									class="flex items-center gap-2 px-5 py-2.5 bg-white border border-gray-300 text-text-header rounded-lg shadow-sm hover:bg-gray-50 text-sm font-medium transition-colors">
									<span class="material-symbols-outlined text-lg">download</span> Export PDF
								</button>
							</div>
						</header>

						<div class="flex-1 overflow-auto p-6">
							<c:choose>
								<c:when test="${empty schedules}">
									<div class="flex flex-col items-center justify-center py-20 gap-6">
										<div
											class="size-24 rounded-full bg-primary-light flex items-center justify-center">
											<span
												class="material-symbols-outlined text-5xl text-primary">event_busy</span>
										</div>
										<div class="text-center">
											<h2 class="font-serif text-2xl font-bold mb-2">No Lectures Assigned</h2>
											<p class="text-text-body max-w-md text-sm">You do not have any lectures
												scheduled at this time. Please contact the administrator if this is an
												error.</p>
										</div>
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

																	<%-- Legend --%>
																		<div
																			class="flex items-center gap-5 mb-4 flex-wrap text-sm text-text-body">
																			<div class="flex items-center gap-2">
																				<span
																					class="material-symbols-outlined text-primary">verified_user</span>
																				<strong>Personalized View</strong>
																				&mdash; This grid only shows lectures
																				assigned to you.
																			</div>
																		</div>

																		<%-- Grid --%>
																			<div id="timetableGridContainer"
																				class="overflow-auto rounded-xl border border-border-color shadow-sm bg-white p-2">
																				<div class="mb-4 text-center hidden"
																					id="pdfHeader">
																					<h2
																						class="text-xl font-bold text-gray-900 font-serif">
																						Timetable - ${facultyUser.name}
																					</h2>
																					<p class="text-sm text-gray-500">
																						${facultyUser.department}</p>
																				</div>
																				<table
																					class="w-full border-collapse bg-white text-xs"
																					style="min-width:960px;">
																					<thead>
																						<tr class="bg-gray-50">
																							<th
																								class="border border-border-color px-3 py-3 text-left w-28 text-text-body font-semibold uppercase tracking-wide">
																								Time</th>
																							<c:forEach var="d"
																								items="${gridDays}">
																								<th
																									class="border border-border-color px-3 py-3 text-center font-semibold text-text-body uppercase tracking-wide">
																									${fn:substring(d.toString(),0,3)}
																								</th>
																							</c:forEach>
																						</tr>
																					</thead>
																					<tbody>
																						<c:forEach var="st"
																							items="${startList}">
																							<tr
																								class="hover:bg-gray-50/30">
																								<%-- Time column --%>
																									<td
																										class="border border-border-color px-3 py-3 text-center bg-gray-50 align-middle">
																										<p
																											class="font-bold text-primary text-xs">
																											${st}</p>
																										<p
																											class="text-gray-400 text-[10px] mt-0.5">
																											to
																											${endMap[st]}
																										</p>
																									</td>

																									<%-- Day columns
																										--%>
																										<c:forEach
																											var="d"
																											items="${gridDays}">
																											<td class="border border-border-color px-2 py-2 align-top"
																												style="min-width:135px;min-height:72px;">
																												<c:forEach
																													var="sc"
																													items="${allSchedList}">
																													<c:if
																														test="${sc.timeSlot.startTime == st and sc.timeSlot.dayOfWeek == d}">
																														<div
																															class="slot-pill rounded-lg p-3 mb-1 border bg-primary/5 border-primary/20">
																															<div
																																class="flex justify-between items-start mb-1">
																																<span
																																	class="inline-block px-2 py-0.5 rounded text-[10px] font-bold bg-white text-primary border border-primary/20 uppercase">
																																	${sc.workload.studentGroup.name}
																																</span>
																															</div>
																															<p class="font-bold text-primary-dark text-sm truncate"
																																title="${sc.workload.subject.name}">
																																${sc.workload.subject.name}
																															</p>
																															<p
																																class="text-xs font-mono text-gray-600 mt-0.5">
																																${sc.workload.subject.code}
																															</p>
																															<div
																																class="flex items-center gap-1.5 mt-2 pt-2 border-t border-primary/10">
																																<span
																																	class="material-symbols-outlined text-xs text-primary">meeting_room</span>
																																<p
																																	class="text-xs font-semibold text-text-body">
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

							var filename = 'Faculty_Timetable_${fn:replace(facultyUser.name, " ", "_")}.pdf';

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