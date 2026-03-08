<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>
<!DOCTYPE html>
<html class="light" lang="en">

<head>
<meta charset="utf-8" />
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<title>Timetable Detail Grid View</title>
<script
	src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
	rel="stylesheet" />
<link
	href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@700&display=swap"
	rel="stylesheet" />
<script id="tailwind-config">
                    tailwind.config = {
                        darkMode: "class",
                        theme: {
                            extend: {
                                colors: {
                                    "primary": "#2D5A27",
                                    "primary-light": "#E8F5E9",
                                    "forest-green": "#2D5A27",
                                    "cream": "#F4F1EA",
                                    "background-light": "#ffffff",
                                    "background-dark": "#132012",
                                    "card-bg": "#ffffff",
                                    "text-main": "#1a1a1a",
                                    "text-muted": "#64748b",
                                },
                                fontFamily: {
                                    "display": ["Inter", "sans-serif"],
                                    "serif": ["Playfair Display", "serif"]
                                },
                                borderRadius: {
                                    "DEFAULT": "0.5rem",
                                    "lg": "1rem",
                                    "xl": "1.5rem",
                                    "full": "9999px"
                                },
                            },
                        },
                    }
                </script>
<style>
body {
	font-family: 'Inter', sans-serif;
}

.timetable-grid {
	display: grid;
	grid-template-columns: 100px repeat(6, 1fr);
	gap: 1rem;
}

@media print {
	.no-print {
		display: none !important;
	}
	.division-page {
		page-break-after: always;
	}
}
</style>
</head>

<body class="bg-background-light text-text-main min-h-screen">
	<div class="layout-container flex flex-col min-h-screen">
		<header
			class="flex items-center justify-between border-b border-gray-200 px-8 py-4 bg-white sticky top-0 z-50 shadow-sm no-print">
			<div class="flex items-center gap-8">
				<div class="flex items-center gap-3">
					<div
						class="size-8 bg-forest-green rounded flex items-center justify-center text-white">
						<span class="material-symbols-outlined font-bold">calendar_today</span>
					</div>
					<h2 class="text-xl font-bold tracking-tight text-forest-green">TimetableGen</h2>
				</div>
				<nav class="hidden md:flex items-center gap-6">
					<a
						class="text-sm font-medium text-slate-600 hover:text-forest-green transition-colors"
						href="admin">Dashboard</a>
				</nav>
			</div>
			<div class="flex items-center gap-4">
				<button onclick="window.print()"
					class="bg-forest-green text-white px-4 py-2 rounded-lg text-sm font-bold flex items-center gap-2 hover:opacity-90 transition-opacity">
					<span class="material-symbols-outlined text-base">print</span>
					Print
				</button>
				<div
					class="size-10 rounded-full bg-slate-200 overflow-hidden border border-gray-200">
					<img alt="Admin" class="w-full h-full object-cover"
						src="https://lh3.googleusercontent.com/aida-public/AB6AXuCNvZZesh7dtcfakm65FO6qQ0INRL8bfF7Sj858Ab5UQQl6KnBWDw8DDeqC7giKn2G3w8xfixX54-X-oTOG2r34bLNPKWIkRECC-R3eApxNg8P_73tN2nPlfGz8SBDxCFR6FmGjEzGqr4qt8HTgK6sSpZH3WIRdQsXq6oFNhIn1Xct-8noiNonFY4LBKhAhi32YlXI7GF1ZTpBQ7GGiDHe_VQypLhoYfi60XDcAeDlt-QoZK81YAj8cEtkpUjs3d6yor9L-09JsQ-Q" />
				</div>
			</div>
		</header>

		<main class="flex-1 px-8 py-10 max-w-[1400px] mx-auto w-full">
			<!-- Error messaging -->
			<c:if test="${empty divisions}">
				<div
					class="bg-amber-100 border border-amber-300 text-amber-800 px-6 py-4 rounded-xl shadow-sm mb-8 no-print">
					<strong class="font-bold flex items-center gap-2 mb-2"><span
						class="material-symbols-outlined">warning</span> No Data Found!</strong>
					<p class="text-sm">Please go back to Admin Dashboard, click
						'Load Sample Data', and then click 'Generate Timetable'.</p>
					<a href="admin"
						class="mt-3 inline-block bg-white text-gray-800 font-semibold px-4 py-2 rounded shadow-sm hover:bg-gray-50">Back
						to Dashboard</a>
				</div>
			</c:if>

			<c:if test="${not empty divisions}">

				<c:forEach var="division" items="${divisions}">
					<div class="division-page mb-16">
						<div
							class="flex flex-col md:flex-row justify-between items-start md:items-end mb-10 gap-6">
							<div>
								<nav
									class="flex items-center gap-2 text-slate-500 text-xs mb-2 uppercase tracking-widest font-semibold">
									<span>Academic Year 2025-26</span> <span
										class="material-symbols-outlined text-[10px]">chevron_right</span>
									<span class="text-forest-green font-bold">Location:
										${division.classroom}</span>
								</nav>
								<h1 class="text-5xl font-serif text-slate-900 mb-2">Detailed
									Schedule - Group ${division.name}</h1>
								<p class="text-slate-500 font-display">Time Table generated
									systematically</p>
							</div>
							<div class="flex flex-col gap-2 no-print">
								<label
									class="text-xs font-bold uppercase tracking-wider text-slate-500 ml-1">Current
									Filter</label>
								<div class="relative min-w-[180px]">
									<div
										class="appearance-none w-full bg-forest-green border-none rounded-[12px] px-4 py-3 text-white font-medium shadow-md">
										Group ${division.name}</div>
								</div>
							</div>
						</div>

						<div
							class="bg-cream rounded-xl border border-stone-200 p-6 shadow-lg relative overflow-x-auto">
							<div class="min-w-[800px]">
								<div class="timetable-grid mb-6">
									<div
										class="flex items-center justify-center font-bold text-slate-500 uppercase text-xs tracking-widest">
										Time</div>
									<c:forEach var="day" items="${days}">
										<div
											class="bg-white/50 rounded-lg py-3 flex items-center justify-center font-bold text-forest-green uppercase text-xs tracking-widest border border-stone-200/50 shadow-sm">
											${day}</div>
									</c:forEach>
								</div>

								<div class="space-y-4">
									<c:set var="timeSlots" value="${['08:45', '09:30', '10:15']}" />

									<c:forEach var="timeStr" items="${timeSlots}">
										<div class="timetable-grid">
											<div
												class="flex items-center justify-center text-slate-500 font-medium text-sm">
												${timeStr} AM</div>

											<c:forEach var="day" items="${days}">
												<c:set var="foundSchedule" value="${false}" />
												<c:forEach var="entry" items="${scheduleMap}">
													<c:set var="schedule" value="${entry.value}" />
													<c:if
														test="${schedule.division.id == division.id && schedule.timeSlot.dayOfWeek == day && schedule.timeSlot.startTime.toString().startsWith(timeStr)}">
														<div
															class="bg-white p-4 rounded-[12px] border border-stone-200 shadow-sm hover:shadow-md hover:border-forest-green/30 transition-all cursor-pointer">
															<h4 class="font-bold text-forest-green text-sm">
																${schedule.workload.subject.code}</h4>
															<p class="text-slate-500 text-xs mt-1 truncate"
																title="${schedule.workload.faculty.name}">
																${schedule.workload.faculty.name}</p>
															<div
																class="flex items-center gap-1 mt-2 text-slate-400 text-[10px] font-bold uppercase tracking-wider">
																<span class="material-symbols-outlined text-xs">location_on</span>
																${schedule.room.name}
															</div>
														</div>
														<c:set var="foundSchedule" value="${true}" />
													</c:if>
												</c:forEach>

												<c:if test="${!foundSchedule}">
													<div
														class="bg-transparent p-4 rounded-[12px] border border-dashed border-stone-300 flex items-center justify-center">
														<span class="text-slate-300 text-xs font-medium">Free</span>
													</div>
												</c:if>
											</c:forEach>
										</div>
									</c:forEach>

									<!-- Practicals Section -->
									<c:if test="${not empty practicalScheduleMap}">
										<div class="timetable-grid">
											<div
												class="flex items-center justify-center text-slate-500 font-medium text-sm">
												12:30 PM</div>
											<div
												class="bg-primary-light/50 p-4 rounded-[12px] border border-forest-green/10 shadow-sm col-span-6 flex items-center justify-center"
												style="grid-column: span 6;">
												<span
													class="text-forest-green font-bold tracking-[0.3em] text-xs uppercase">Practical
													Sessions</span>
											</div>
										</div>

										<div class="timetable-grid">
											<div
												class="flex items-center justify-center text-slate-500 font-medium text-sm text-center">
												12:30 PM<br>to<br>3:00 PM
											</div>

											<c:forEach var="day" items="${practicalDays}">
												<c:set var="daySchedules"
													value="${practicalScheduleMap[day.toString()]}" />
												<c:set var="foundPractical" value="${false}" />
												<c:set var="practicalContent" value="" />

												<c:forEach var="schedule" items="${daySchedules}">
													<c:if test="${schedule.division.id == division.id}">
														<c:set var="practicalContent">
                                                                        ${practicalContent}
                                                                        <div
																class="bg-white p-3 rounded-lg border border-stone-200 mb-2 shadow-sm">
																<h4 class="font-bold text-forest-green text-xs">
																	${schedule.workload.subject.code}</h4>
																<p class="text-slate-500 text-[10px] mt-1 truncate">
																	${schedule.workload.faculty.name}</p>
																<c:if test="${schedule.batch != null}">
																	<div
																		class="flex items-center gap-1 mt-1 text-slate-400 text-[9px] font-bold uppercase">
																		<span class="material-symbols-outlined text-[10px]">group</span>
																		${schedule.batch.name}
																	</div>
																</c:if>
															</div>
														</c:set>
														<c:set var="foundPractical" value="${true}" />
													</c:if>
												</c:forEach>

												<c:if test="${foundPractical}">
													<div class="flex flex-col">${practicalContent}</div>
												</c:if>
												<c:if test="${!foundPractical}">
													<div
														class="bg-transparent p-4 rounded-[12px] border border-dashed border-stone-300 flex items-center justify-center">
														<span class="text-slate-300 text-xs font-medium">Free</span>
													</div>
												</c:if>
											</c:forEach>
										</div>
									</c:if>

								</div>
							</div>
						</div>
					</div>
				</c:forEach>
			</c:if>

		</main>
		<button onclick="window.print()"
			class="fixed bottom-8 right-8 bg-forest-green hover:bg-[#23471f] text-white w-14 h-14 md:w-auto md:px-6 md:h-14 rounded-full md:rounded-[12px] shadow-2xl flex items-center justify-center gap-3 transition-all z-[100] group ring-4 ring-white no-print">
			<span class="material-symbols-outlined text-white">picture_as_pdf</span>
			<span
				class="hidden md:inline font-bold uppercase tracking-widest text-sm">Export
				PDF / Print</span>
		</button>
		<footer
			class="mt-auto py-8 px-8 border-t border-gray-200 text-slate-500 flex justify-between items-center text-sm bg-gray-50 no-print">
			<p>© 2024 TimetableGen Academic Scheduling Portal</p>
			<div class="flex gap-6">
				<a class="hover:text-forest-green transition-colors" href="#">Privacy
					Policy</a> <a class="hover:text-forest-green transition-colors"
					href="#">Support</a>
			</div>
		</footer>
	</div>
</body>

</html>