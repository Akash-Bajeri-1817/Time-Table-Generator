<%@ page contentType="text/html;charset=UTF-8" language="java" %>
	<%@ page import="com.timetable.model.Schedule,java.util.*,java.time.DayOfWeek,java.time.LocalTime" %>
		<%@ taglib prefix="c" uri="jakarta.tags.core" %>
			<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
				<!DOCTYPE html>
				<html lang="en">

				<head>
					<meta charset="utf-8" />
					<meta content="width=device-width, initial-scale=1.0" name="viewport" />
					<title>Generated Timetable</title>
					<link
						href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;600;700&display=swap"
						rel="stylesheet" />
					<link
						href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
						rel="stylesheet" />
					<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
					<script>tailwind.config = { theme: { extend: { colors: { primary: "#2D5A27", "primary-light": "#E8F5E9", "background-light": "#F4F1EA", "text-header": "#111827", "text-body": "#4B5563", "border-color": "#E5E7EB" }, fontFamily: { sans: ['Inter', 'sans-serif'], serif: ['Playfair Display', 'serif'] } } } }}</script>
					<style>
						.material-symbols-outlined {
							font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24
						}

						.slot-pill {
							transition: box-shadow .15s, transform .15s;
							display: block;
						}

						.slot-pill:hover {
							box-shadow: 0 4px 12px rgba(45, 90, 39, .18);
							transform: translateY(-1px);
						}

						.slot-pill.hidden-pill {
							display: none !important;
						}

						.tab-btn {
							cursor: pointer;
							transition: all .2s;
							border: 1px solid #E5E7EB;
						}

						.tab-btn.active {
							background: #2D5A27 !important;
							color: white !important;
							border-color: #2D5A27 !important;
						}
					</style>
				</head>

				<body class="bg-background-light font-sans text-text-header flex overflow-hidden h-screen">
					<c:set var="currentPage" value="timetable" />
					<jsp:include page="_sidebar.jsp" />

					<main class="flex-1 flex flex-col overflow-hidden">

						<header
							class="bg-white border-b border-border-color px-8 py-4 flex items-center justify-between shrink-0">
							<div>
								<nav class="flex items-center gap-2 text-sm text-text-body mb-1">
									<a href="${pageContext.request.contextPath}/admin"
										class="hover:text-primary">Admin</a>
									<span class="material-symbols-outlined text-sm text-gray-400">chevron_right</span>
									<span class="font-semibold text-primary">Timetable</span>
								</nav>
								<h1 class="font-serif text-2xl font-bold text-primary">Generated Timetable</h1>
							</div>
							<div class="flex items-center gap-3">
								<span class="text-sm bg-primary-light px-3 py-1 rounded-full font-medium text-primary">
									<span id="lectureCount">${schedules.size()}</span> lectures
								</span>
								<a href="${pageContext.request.contextPath}/admin?action=generate_ai"
									class="flex items-center gap-2 px-5 py-2.5 bg-primary text-white rounded-lg shadow-sm hover:bg-primary/90 font-medium text-sm transition-colors">
									<span class="material-symbols-outlined text-lg">auto_awesome</span>
									<c:choose>
										<c:when test="${schedules.size() gt 0}">Re-Generate AI</c:when>
										<c:otherwise>Generate AI Timetable</c:otherwise>
									</c:choose>
								</a>
							</div>
						</header>

						<div class="flex-1 overflow-auto p-6">

							<c:if test="${not empty message}">
								<div
									class="mb-4 border rounded-xl p-4 flex items-center gap-3 bg-green-50 border-green-200 text-green-800">
									<span class="material-symbols-outlined">check_circle</span>
									<p class="text-sm font-medium">${message}</p>
								</div>
							</c:if>

							<c:choose>
								<c:when test="${empty schedules}">
									<div class="flex flex-col items-center justify-center py-20 gap-6">
										<div
											class="size-24 rounded-full bg-primary-light flex items-center justify-center">
											<span
												class="material-symbols-outlined text-5xl text-primary">table_chart</span>
										</div>
										<div class="text-center">
											<h2 class="font-serif text-2xl font-bold mb-2">No Timetable Generated Yet
											</h2>
											<p class="text-text-body max-w-md text-sm">Load sample data, then click
												Generate AI Timetable.</p>
										</div>
										<div class="flex gap-3 flex-wrap justify-center">
											<a href="${pageContext.request.contextPath}/admin?action=load_sample_data"
												class="flex items-center gap-2 px-5 py-2.5 border border-border-color bg-white rounded-lg text-sm font-medium hover:bg-gray-50">
												<span class="material-symbols-outlined text-lg">database</span>Load
												Sample Data
											</a>
											<a href="${pageContext.request.contextPath}/admin?action=generate_ai"
												class="flex items-center gap-2 px-5 py-2.5 bg-primary text-white rounded-lg text-sm font-medium hover:bg-primary/90">
												<span
													class="material-symbols-outlined text-lg">auto_awesome</span>Generate
												AI Timetable
											</a>
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

																	<%-- Division tabs --%>
																		<div
																			class="flex items-center gap-2 mb-5 flex-wrap">
																			<span
																				class="text-xs font-semibold text-text-body uppercase tracking-wide mr-1">View:</span>
																			<button
																				class="tab-btn active px-4 py-2 rounded-lg text-sm font-semibold bg-white"
																				onclick="filterGroup('all', this)">All
																				Divisions</button>
																			<c:forEach var="grp" items="${groups}">
																				<c:choose>
																					<c:when
																						test="${fn:contains(grp.name,'Div A')}">
																						<c:set var="tabCls"
																							value="text-blue-700 border-blue-200" />
																						<c:set var="tabIcon"
																							value="🔵" />
																					</c:when>
																					<c:when
																						test="${fn:contains(grp.name,'Div B')}">
																						<c:set var="tabCls"
																							value="text-green-700 border-green-200" />
																						<c:set var="tabIcon"
																							value="🟢" />
																					</c:when>
																					<c:when
																						test="${fn:contains(grp.name,'Div C')}">
																						<c:set var="tabCls"
																							value="text-orange-700 border-orange-200" />
																						<c:set var="tabIcon"
																							value="🟠" />
																					</c:when>
																					<c:otherwise>
																						<c:set var="tabCls"
																							value="text-text-body" />
																						<c:set var="tabIcon"
																							value="📋" />
																					</c:otherwise>
																				</c:choose>
																				<button
																					class="tab-btn px-4 py-2 rounded-lg text-sm font-semibold bg-white ${tabCls}"
																					data-gid="${grp.id}"
																					onclick="filterGroup('${grp.id}', this)">
																					${tabIcon} ${grp.name}
																				</button>
																			</c:forEach>
																		</div>

																		<%-- Legend --%>
																			<div
																				class="flex items-center gap-5 mb-4 flex-wrap text-xs text-text-body">
																				<div class="flex items-center gap-1.5">
																					<div
																						class="size-3 rounded bg-blue-200">
																					</div>Div A
																				</div>
																				<div class="flex items-center gap-1.5">
																					<div
																						class="size-3 rounded bg-green-200">
																					</div>Div B
																				</div>
																				<div class="flex items-center gap-1.5">
																					<div
																						class="size-3 rounded bg-orange-200">
																					</div>Div C
																				</div>
																				<div
																					class="ml-auto flex items-center gap-1.5">
																					<span
																						class="material-symbols-outlined text-primary text-sm">check_circle</span>
																					<strong
																						class="text-primary">${schedules.size()}
																						lectures</strong>&nbsp;&mdash;
																					AI-generated, zero conflicts
																				</div>
																			</div>

																			<%-- Grid --%>
																				<div
																					class="overflow-auto rounded-xl border border-border-color shadow-sm">
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
																									<%-- Time column:
																										show start and
																										end time --%>
																										<td
																											class="border border-border-color px-3 py-3 text-center bg-gray-50 align-middle">
																											<p
																												class="font-bold text-primary text-xs">
																												${st}
																											</p>
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
																															<c:choose>
																																<c:when
																																	test="${fn:contains(sc.workload.studentGroup.name,'Div A')}">
																																	<c:set
																																		var="cardBg"
																																		value="bg-blue-50 border-blue-200" />
																																	<c:set
																																		var="badgeCls"
																																		value="bg-blue-100 text-blue-700" />
																																	<c:set
																																		var="badgeTxt"
																																		value="DIV A" />
																																	<c:set
																																		var="nameCls"
																																		value="text-blue-800" />
																																</c:when>
																																<c:when
																																	test="${fn:contains(sc.workload.studentGroup.name,'Div B')}">
																																	<c:set
																																		var="cardBg"
																																		value="bg-green-50 border-green-200" />
																																	<c:set
																																		var="badgeCls"
																																		value="bg-green-100 text-green-700" />
																																	<c:set
																																		var="badgeTxt"
																																		value="DIV B" />
																																	<c:set
																																		var="nameCls"
																																		value="text-green-800" />
																																</c:when>
																																<c:otherwise>
																																	<c:set
																																		var="cardBg"
																																		value="bg-orange-50 border-orange-200" />
																																	<c:set
																																		var="badgeCls"
																																		value="bg-orange-100 text-orange-700" />
																																	<c:set
																																		var="badgeTxt"
																																		value="DIV C" />
																																	<c:set
																																		var="nameCls"
																																		value="text-orange-800" />
																																</c:otherwise>
																															</c:choose>
																															<div class="slot-pill rounded-lg p-2 mb-1 border ${cardBg}"
																																data-gid="${sc.workload.studentGroup.id}">
																																<span
																																	class="inline-block px-1.5 py-0.5 rounded text-[9px] font-bold mb-1 ${badgeCls}">${badgeTxt}</span>
																																<p class="font-bold ${nameCls} text-xs truncate"
																																	title="${sc.workload.subject.name}">
																																	${sc.workload.subject.name}
																																</p>
																																<p
																																	class="text-[10px] font-mono text-gray-500 mt-0.5">
																																	${sc.workload.subject.code}
																																</p>
																																<div
																																	class="flex items-center gap-1 mt-1">
																																	<span
																																		class="material-symbols-outlined text-[10px] text-gray-400">person</span>
																																	<p class="text-[10px] text-text-body truncate"
																																		title="${sc.workload.faculty.name}">
																																		${sc.workload.faculty.name}
																																	</p>
																																</div>
																																<div
																																	class="flex items-center gap-1 mt-0.5">
																																	<span
																																		class="material-symbols-outlined text-[10px] text-gray-400">meeting_room</span>
																																	<p
																																		class="text-[10px] text-text-body">
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
																							<c:if
																								test="${empty startList}">
																								<tr>
																									<td colspan="7"
																										class="border border-border-color text-center py-12 text-text-body">
																										No schedules
																										found.
																										<a href="${pageContext.request.contextPath}/admin?action=generate_ai"
																											class="text-primary underline">Generate
																											timetable</a>.
																									</td>
																								</tr>
																							</c:if>
																						</tbody>
																					</table>
																				</div>
								</c:otherwise>
							</c:choose>
						</div>
					</main>

					<script>
						function filterGroup(gid, btn) {
							document.querySelectorAll('.tab-btn').forEach(function (b) { b.classList.remove('active'); });
							btn.classList.add('active');
							var pills = document.querySelectorAll('.slot-pill');
							var shown = 0;
							pills.forEach(function (pill) {
								var match = (gid === 'all') || (pill.dataset.gid === String(gid));
								pill.classList.toggle('hidden-pill', !match);
								if (match) shown++;
							});
							document.getElementById('lectureCount').textContent = shown;
						}
					</script>
				</body>

				</html>