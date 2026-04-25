<%@ page contentType="text/html;charset=UTF-8" language="java" %>
	<%@ taglib prefix="c" uri="jakarta.tags.core" %>
		<!DOCTYPE html>
		<html class="light" lang="en">

		<head>
			<meta charset="utf-8" />
			<meta content="width=device-width, initial-scale=1.0" name="viewport" />
			<title>Timetable Admin Dashboard Overview</title>
			<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
			<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
				rel="stylesheet" />
			<link href="https://fonts.googleapis.com/css2?family=Georgia&display=swap" rel="stylesheet" />
			<link
				href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
				rel="stylesheet" />
			<style>
				.material-symbols-outlined {
					font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
				}
			</style>
			<script id="tailwind-config">
				tailwind.config = {
					darkMode: "class",
					theme: {
						extend: {
							colors: {
								"primary": "#2D5A27",
								"background-light": "#F4F1EA",
								"background-dark": "#171b17",
								"accent-cream": "#E8F5E9",
							},
							fontFamily: {
								"display": ["Inter", "sans-serif"],
								"serif": ["Georgia", "serif"]
							},
							borderRadius: {
								"DEFAULT": "0.5rem",
								"lg": "0.75rem",
								"xl": "1.5rem",
								"full": "9999px"
							},
						},
					},
				}
			</script>
			<style>
				.sidebar-active {
					background-color: #E8F5E9;
					border-left: 4px solid #2D5A27;
				}

				.glass-card {
					background: rgba(255, 255, 255, 0.9);
					backdrop-filter: blur(8px);
				}
			</style>
		</head>

		<body class="bg-background-light font-display text-slate-900 overflow-x-hidden">
			<div class="flex h-screen overflow-hidden">
				<!-- Sidebar -->
				<c:set var="currentPage" value="dashboard" />
				<jsp:include page="_sidebar.jsp" />

				<!-- Main Content Area -->
				<main class="flex-1 flex flex-col overflow-y-auto">
					<!-- Top Bar -->
					<header
						class="h-20 bg-white border-b border-primary/10 flex items-center justify-between px-4 lg:px-8 shrink-0">
						<div class="flex items-center gap-2 text-sm text-slate-500">
<button onclick="toggleSidebar()" class="lg:hidden p-2 -ml-2 mr-2 text-slate-500 hover:text-primary rounded-lg hover:bg-slate-100 flex items-center justify-center">
    <span class="material-symbols-outlined text-xl">menu</span>
</button>
							<a class="hover:text-primary" href="#">Admin</a>
							<span class="material-symbols-outlined text-xs">chevron_right</span>
							<span class="text-primary font-medium">Dashboard</span>
						</div>
						<div class="flex-1 max-w-2xl px-4 lg:px-12 hidden md:block">
						<!-- 	<div class="relative group">
								<span
									class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-slate-400 group-focus-within:text-primary">search</span>
								<input
									class="w-full h-11 bg-background-light border-none rounded-xl pl-12 pr-4 focus:ring-2 focus:ring-primary/20 text-sm placeholder:text-slate-400"
									placeholder="Search for faculty, rooms, or schedules..." type="text" />
							</div> -->
						</div>
						<div class="flex items-center gap-6">
							<!--  <button class="relative p-2 text-slate-500 hover:bg-primary/5 rounded-lg transition-colors">
								<span class="material-symbols-outlined">notifications</span>
								<span
									class="absolute top-1 right-1 size-4 bg-red-500 text-[10px] text-white flex items-center justify-center rounded-full border-2 border-white">3</span>
							</button>-->
							<div class="h-8 w-px bg-slate-200"></div>
							<div class="flex items-center gap-3 cursor-pointer">
								<div class="text-right hidden xl:block">
									<p class="text-xs font-bold text-slate-900">Admin User</p>
									<p class="text-[10px] text-slate-500 uppercase tracking-tight">Active Session</p>
								</div>
								<div class="size-10 rounded-lg bg-primary/20 bg-cover bg-center"
									data-alt="Profile picture of an admin user"
									style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuCh5jObjTnrsd0rQlWAhK9MZZLFc7EmIUk2llwkdXWBVtNclEyvL4gh36xtip4Vh_6u8Vtcozqgja19yYqLGkuElNg0Ul7uYbLQ68wVYhFTVwV-41u2YuSfU6qAN9ChaRhQoT9nIxrCWCVzDMCSOY0lyA3rSEF_sbZBOVHt2DYCMqKuWdwpMLdRs9WvYt57EE9q0ldtbkFzYOQEWc-3Mu48dDHGkpwnq34HxeQjh7MUFsw0yfgkxprmlPsp2I7Sbi747jnI2cvS-vUW')">
								</div>
							</div>
						</div>
					</header>

					<!-- Dashboard Content -->
					<div class="p-8 space-y-8">

						<c:if test="${not empty message}">
							<div
								class="bg-primary/10 border border-primary/20 text-primary px-5 py-3 rounded-lg text-sm font-medium mb-4">
								${message}
							</div>
						</c:if>

						<!-- KPI Hero Section -->
						<div class="grid grid-cols-1 md:grid-cols-1 md:grid-cols-2 lg:grid-cols-1 md:grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
							<div class="bg-white p-6 rounded-lg shadow-sm border border-primary/5 flex flex-col">
								<span class="text-slate-500 text-sm font-medium mb-1">Active Groups</span>
								<div class="flex items-baseline gap-2">
									<span class="text-3xl font-bold text-primary font-serif">${groupCount != null ? groupCount : '0'}</span>
									<span class="text-xs text-green-600 font-medium">Live</span>
								</div>
							</div>
							<div class="bg-white p-6 rounded-lg shadow-sm border border-primary/5 flex flex-col">
								<span class="text-slate-500 text-sm font-medium mb-1">Total Faculty</span>
								<div class="flex items-baseline gap-2">
									<span class="text-3xl font-bold text-primary font-serif">${facultyCount != null ? facultyCount : '0'}</span>
									<span class="text-xs text-slate-400 font-medium">Profiles</span>
								</div>
							</div>
							<div class="bg-white p-6 rounded-lg shadow-sm border border-primary/5 flex flex-col">
								<span class="text-slate-500 text-sm font-medium mb-1">Courses</span>
								<div class="flex items-baseline gap-2">
									<span class="text-3xl font-bold text-primary font-serif">${subjectCount != null ? subjectCount : '0'}</span>
									<span class="text-xs text-green-600 font-medium">Active</span>
								</div>
							</div>
							<div
								class="bg-white p-6 rounded-lg shadow-sm border border-primary/5 flex flex-col relative overflow-hidden group">
								<div class="absolute inset-0 bg-red-500/5 group-hover:bg-red-500/10 transition-colors">
								</div>
								<span class="text-slate-500 text-sm font-medium mb-1 z-10">Workloads</span>
								<div class="flex items-baseline gap-2 z-10">
									<span class="text-3xl font-bold text-primary font-serif">${workloadCount != null ? workloadCount : '0'}</span>
									<span class="text-xs text-primary font-medium">Assigned</span>
								</div>
							</div>
						</div>

						<!-- Action Shortcuts -->
						<div class="flex flex-wrap items-center gap-4">
							<a href="${pageContext.request.contextPath}/admin?action=generate_ai"
								class="bg-gradient-to-r from-primary to-[#4A7D41] text-white px-6 py-3 rounded-lg font-bold text-sm shadow-md hover:shadow-lg transition-all flex items-center gap-2"
								onclick="showLoader()">
								<span class="material-symbols-outlined text-lg">auto_awesome</span>
								Generate AI Timetable
							</a>
							<a href="${pageContext.request.contextPath}/admin?action=load_sample_data"
					class="bg-white text-primary border border-primary/20 px-6 py-3 rounded-lg font-bold text-sm hover:bg-primary/5 transition-all flex items-center gap-2">
					<span class="material-symbols-outlined text-lg">database</span>
					Load TY Sample Data
				</a>
				<a href="${pageContext.request.contextPath}/admin?action=load_fy_sample_data"
					class="bg-white text-blue-700 border border-blue-200 px-6 py-3 rounded-lg font-bold text-sm hover:bg-blue-50 transition-all flex items-center gap-2">
					<span class="material-symbols-outlined text-lg">database</span>
					Load FY Sample Data (2 PM)
				</a>
							<a href="${pageContext.request.contextPath}/admin?page=timetable"
								class="bg-white text-slate-600 border border-slate-200 px-6 py-3 rounded-lg font-bold text-sm hover:bg-slate-50 transition-all flex items-center gap-2">
								<span class="material-symbols-outlined text-lg">calendar_view_week</span>
								View Timetable
							</a>
							<a href="javascript:void(0)"
								onclick="openConfirmModal('Clear All Data', 'Are you sure you want to clear ALL data? This will permanently delete all faculty, subjects, rooms, workloads, timeslots, and schedules from the database. This action cannot be undone.', '${pageContext.request.contextPath}/admin?action=clear_all_data')"
								class="bg-red-50 text-red-700 border border-red-200 px-6 py-3 rounded-lg font-bold text-sm hover:bg-red-100 hover:border-red-300 transition-all flex items-center gap-2">
								<span class="material-symbols-outlined text-lg">delete_sweep</span>
								Clear All Data
							</a>
						</div>

						<!-- Main Visuals Grid -->
						<div class="grid grid-cols-1 lg:grid-cols-10 gap-8">
							<!-- Schedule Efficiency Area Chart -->
							<div class="lg:col-span-7 bg-white p-8 rounded-lg shadow-sm border border-primary/5">
								<div class="flex items-center justify-between mb-8">
									<div>
										<h3 class="font-serif text-xl font-bold text-slate-800">Recent Schedules</h3>
										<p class="text-sm text-slate-500">Overview of generated schedules</p>
									</div>
								</div>

								<div class="grid grid-cols-1 md:grid-cols-1 md:grid-cols-2 lg:grid-cols-1 md:grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
									<c:forEach var="g" items="${groups}">
										<div
											class="bg-background-light p-4 rounded-lg border border-primary/10 hover:border-primary/30 transition-all">
											<div class="flex justify-between items-start mb-2">
												<h4 class="font-bold text-primary">${g.name}</h4>
												<span
													class="px-2 py-0.5 bg-primary/10 text-primary text-[10px] font-bold rounded-full uppercase">Active</span>
											</div>
											<div class="text-xs text-slate-500 mb-4 flex items-center gap-1">
												<span class="material-symbols-outlined text-sm">schedule</span>
												Auto-generated
											</div>
											<div class="flex gap-2">
												<a href="${pageContext.request.contextPath}/admin?page=timetable"
													class="text-xs font-bold text-primary hover:underline">View
													Details</a>
											</div>
										</div>
									</c:forEach>

									<c:if test="${empty groups}">
										<div
											class="col-span-full border-2 border-dashed border-slate-200 p-8 text-center rounded-lg">
											<div
												class="size-12 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-3 text-slate-400">
												<span class="material-symbols-outlined text-2xl">event_busy</span>
											</div>
											<p class="text-slate-600 font-medium mb-1">No schedules generated yet.</p>
											<p class="text-xs text-slate-400">Load demo data or use the generate button
												to start.</p>
										</div>
									</c:if>
								</div>

							</div>

							<!-- Recent Activity -->
							<div
								class="lg:col-span-3 bg-white p-6 rounded-lg shadow-sm border border-primary/5 flex flex-col">
								<h3 class="font-serif text-xl font-bold text-slate-800 mb-6">Recent Activity</h3>
								<div class="flex-1 space-y-6 overflow-y-auto pr-2">
									<div class="flex gap-4 relative">
										<div class="absolute left-3.5 top-8 bottom-[-16px] w-px bg-slate-100"></div>
										<div
											class="size-7 rounded-full bg-primary/10 flex items-center justify-center shrink-0 z-10">
											<span
												class="material-symbols-outlined text-primary text-sm">auto_awesome</span>
										</div>
										<div>
											<p class="text-sm font-medium text-slate-800 leading-snug">Timetable
												generated for CS</p>
											<p class="text-xs text-slate-400 mt-1">10 minutes ago</p>
										</div>
									</div>
									<div class="flex gap-4 relative">
										<div class="absolute left-3.5 top-8 bottom-[-16px] w-px bg-slate-100"></div>
										<div
											class="size-7 rounded-full bg-amber-500/10 flex items-center justify-center shrink-0 z-10">
											<span
												class="material-symbols-outlined text-amber-600 text-sm">person_off</span>
										</div>
										<div>
											<p class="text-sm font-medium text-slate-800 leading-snug">Dr. Kumar marked
												as On Leave</p>
											<p class="text-xs text-slate-400 mt-1">2 hours ago</p>
										</div>
									</div>
									<div class="flex gap-4">
										<div
											class="size-7 rounded-full bg-green-500/10 flex items-center justify-center shrink-0 z-10">
											<span
												class="material-symbols-outlined text-green-600 text-sm">check_circle</span>
										</div>
										<div>
											<p class="text-sm font-medium text-slate-800 leading-snug">Room 102 conflict
												resolved</p>
											<p class="text-xs text-slate-400 mt-1">Yesterday</p>
										</div>
									</div>
								</div>
								<button class="mt-6 text-xs font-bold text-primary hover:underline self-center">View
									Full Audit Log</button>
							</div>
						</div>

						<!-- Lower Grid -->
						<div class="grid grid-cols-1 lg:grid-cols-1 md:grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 pb-12">
							<!-- Upcoming Lectures Table -->
							<div
								class="lg:col-span-2 bg-white rounded-lg shadow-sm border border-primary/5 overflow-hidden">
								<div class="px-6 py-4 border-b border-primary/5 flex items-center justify-between">
									<h3 class="font-serif text-xl font-bold text-slate-800">Sample Assigned Workloads
									</h3>
									<button class="text-xs font-bold text-slate-500 hover:text-primary">See All</button>
								</div>
								<div class="overflow-x-auto">
									<table class="w-full text-left">
										<thead
											class="bg-background-light/50 text-[10px] uppercase text-slate-500 font-bold">
											<tr>
												<th class="px-6 py-3">Group</th>
												<th class="px-6 py-3">Subject</th>
												<th class="px-6 py-3">Faculty</th>
											</tr>
										</thead>
										<tbody class="divide-y divide-slate-50">
											<c:forEach var="w" items="${workloads}" begin="0" end="4">
												<tr class="hover:bg-primary/5 transition-colors">
													<td class="px-6 py-4">
														<p class="text-sm font-semibold">${w.studentGroup.name}</p>
													</td>
													<td class="px-6 py-4">
														<p class="text-sm text-slate-600">${w.subject.name}</p>
														<p class="text-[10px] text-slate-400">${w.subject.code}</p>
													</td>
													<td class="px-6 py-4">
														<span
															class="px-2 py-1 bg-primary/10 text-primary text-xs font-bold rounded">${w.faculty.name}</span>
													</td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
							</div>

							<!-- System Health -->
							<div class="bg-white p-6 rounded-lg shadow-sm border border-primary/5">
								<h3 class="font-serif text-xl font-bold text-slate-800 mb-6">System Health</h3>
								<div class="space-y-6">
									<div>
										<div class="flex justify-between text-xs font-bold mb-2">
											<span class="text-slate-500">Server Status</span>
											<span class="text-green-600">Operational</span>
										</div>
										<div class="w-full bg-slate-100 h-2 rounded-full overflow-hidden">
											<div class="bg-green-500 h-full w-[98%]"></div>
										</div>
									</div>
									<div>
										<div class="flex justify-between text-xs font-bold mb-2">
											<span class="text-slate-500">Algorithm Status</span>
											<span class="text-primary">Ready</span>
										</div>
										<div class="w-full bg-slate-100 h-2 rounded-full overflow-hidden">
											<div class="bg-primary h-full w-[100%]"></div>
										</div>
									</div>
								</div>
								<div class="mt-8 p-4 bg-primary/5 rounded-lg border border-primary/10">
									<div class="flex items-center gap-3">
										<span class="material-symbols-outlined text-primary">cloud_done</span>
										<div>
											<p class="text-xs font-bold text-primary">Data Source</p>
											<p class="text-[10px] text-slate-500">Connected to Timefold AI</p>
										</div>
									</div>
								</div>
							</div>
						</div>

					</div>
				</main>
			</div>

	<!-- Confirm Modal -->
    <div id="confirmModal" class="hidden fixed inset-0 bg-gray-900/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
        <div class="bg-white rounded-2xl shadow-xl w-full max-w-md transform transition-all p-6">
            <div class="mb-6 flex items-start gap-4">
                <div class="w-10 h-10 rounded-full bg-red-100 flex items-center justify-center flex-shrink-0">
                    <span class="material-symbols-outlined text-red-600">warning</span>
                </div>
                <div>
                    <h3 class="text-lg font-bold text-gray-900" id="confirmModalTitle">Confirm Action</h3>
                    <p class="text-sm text-gray-600 mt-1" id="confirmModalText">Are you sure you want to proceed?</p>
                </div>
            </div>
            <div class="flex gap-3 justify-end mt-4">
                <button type="button" onclick="closeConfirmModal()" class="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-lg hover:bg-gray-50">Cancel</button>
                <a id="confirmModalLink" href="#" class="px-4 py-2 text-sm font-medium text-white bg-red-600 rounded-lg hover:bg-red-700">Confirm</a>
            </div>
        </div>
    </div>
    <script>
        function openConfirmModal(title, text, url) {
            document.getElementById('confirmModalTitle').textContent = title;
            document.getElementById('confirmModalText').textContent = text;
            document.getElementById('confirmModalLink').href = url;
            document.getElementById('confirmModal').classList.remove('hidden');
        }
        function closeConfirmModal() {
            document.getElementById('confirmModal').classList.add('hidden');
        }

        function showLoader() {
            var loader = document.getElementById('aiLoaderOverlay');
            if (loader) {
                loader.classList.remove('hidden');
                loader.classList.add('flex');
            }
        }
    </script>

	<!-- Full Screen Loader Overlay -->
	<div id="aiLoaderOverlay" class="hidden fixed inset-0 bg-white/80 backdrop-blur-sm z-[100] flex-col items-center justify-center transition-all duration-300">
		<div class="relative w-24 h-24 mb-6">
			<!-- Outer spinning ring -->
			<div class="absolute inset-0 rounded-full border-4 border-primary/20 border-t-primary animate-spin"></div>
			<!-- Inner pulse -->
			<div class="absolute inset-2 rounded-full bg-primary/10 animate-pulse flex items-center justify-center">
				<span class="material-symbols-outlined text-primary text-3xl animate-bounce">auto_awesome</span>
			</div>
		</div>
		<h2 class="text-2xl font-serif font-bold text-gray-900 mb-2">Generating Timetable...</h2>
		<p class="text-gray-500 text-sm max-w-md text-center">The AI is currently analyzing constraints and calculating the optimal schedule. This may take a few moments.</p>
	</div>
		</body>

		</html>