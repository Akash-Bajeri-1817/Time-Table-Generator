<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>Scheduling Constraints & Rules</title>
                <link
                    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;600;700&display=swap"
                    rel="stylesheet" />
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
                    rel="stylesheet" />
                <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                <script>tailwind.config = { theme: { extend: { colors: { primary: "#2D5A27", "primary-light": "#E8F5E9", "background-light": "#F4F1EA", "text-header": "#111827", "text-body": "#4B5563", "border-color": "#E5E7EB" }, fontFamily: { sans: ['Inter', 'sans-serif'], serif: ['Playfair Display', 'serif'] } } } }</script>
                <style>
                    .material-symbols-outlined {
                        font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24
                    }

                    .toggle-checkbox:checked {
                        right: 0;
                        border-color: #2D5A27;
                    }

                    .toggle-checkbox:checked+.toggle-label {
                        background-color: #2D5A27;
                    }

                    #breakSection {
                        transition: all .3s ease;
                    }
                </style>
            </head>

            <body class="bg-background-light font-sans text-text-header flex overflow-hidden h-screen">
                <c:set var="currentPage" value="constraints" />
                <jsp:include page="_sidebar.jsp" />

                <main class="flex-1 flex flex-col overflow-hidden">
                    <!-- Header -->
                    <header
                        class="bg-white border-b border-border-color px-8 py-4 flex items-center justify-between shrink-0">
                        <div>
                            <nav class="flex items-center gap-2 text-sm text-text-body mb-1">
                                <a href="${pageContext.request.contextPath}/admin" class="hover:text-primary">Admin</a>
                                <span class="material-symbols-outlined text-sm text-gray-400">chevron_right</span>
                                <span class="font-semibold text-primary">Constraints & Schedule Config</span>
                            </nav>
                            <h1 class="font-serif text-2xl font-bold text-primary">Constraints &amp; Schedule Config
                            </h1>
                        </div>
                    </header>

                    <!-- Scrollable Body -->
                    <div class="flex-1 overflow-y-auto p-8">
                        <div class="max-w-5xl mx-auto space-y-8">

                            <!-- Flash Message -->
                            <c:if test="${not empty message}">
                                <div class="bg-green-50 border border-green-200 rounded-xl p-4 flex items-center gap-3">
                                    <span class="material-symbols-outlined text-green-600">check_circle</span>
                                    <p class="text-sm font-medium text-green-800">${message}</p>
                                </div>
                            </c:if>

                            <!-- ═══════════════════════════════════════════════════
                     SECTION 1 — TIME SLOT CONFIGURATION (Real Backend)
                     Posts to AdminServlet action=save_timeslot_config
                ════════════════════════════════════════════════════ -->
                            <div class="bg-white rounded-xl border border-border-color shadow-sm overflow-hidden">
                                <div
                                    class="flex items-center gap-3 px-6 py-5 border-b border-border-color bg-primary-light/40">
                                    <div
                                        class="size-10 rounded-lg bg-primary/10 flex items-center justify-center text-primary">
                                        <span class="material-symbols-outlined">schedule</span>
                                    </div>
                                    <div>
                                        <h2 class="font-serif font-bold text-lg text-primary">Time Slot Configuration
                                        </h2>
                                        <p class="text-xs text-text-body">Configure working days, lecture times, and
                                            break.
                                            <strong class="text-primary">This directly generates time slots for the AI
                                                scheduler.</strong>
                                        </p>
                                    </div>
                                    <c:if test="${not empty activeConfig}">
                                        <span
                                            class="ml-auto px-3 py-1 bg-green-100 text-green-700 rounded-full text-xs font-semibold">Active
                                            Config Loaded</span>
                                    </c:if>
                                </div>
                                <form method="post" action="${pageContext.request.contextPath}/admin"
                                    class="p-6 space-y-6">
                                    <input type="hidden" name="action" value="save_timeslot_config" />

                                    <!-- Working Days -->
                                    <div>
                                        <label class="block text-sm font-semibold text-text-header mb-3">Working Days
                                            *</label>
                                        <div class="flex flex-wrap gap-3">
                                            <c:forEach var="day"
                                                items="${['monday','tuesday','wednesday','thursday','friday','saturday','sunday']}">
                                                <label
                                                    class="flex items-center gap-2 px-4 py-2 rounded-lg border border-border-color cursor-pointer hover:border-primary hover:bg-primary-light/30 transition-all has-[:checked]:border-primary has-[:checked]:bg-primary-light">
                                                    <input type="checkbox" name="${day}" value="${day}" ${day=='sunday'
                                                        ? '' : 'checked' }
                                                        class="size-4 rounded border-gray-300 text-primary focus:ring-primary/20" />
                                                    <span
                                                        class="text-sm font-medium capitalize">${fn:substring(day,0,3)}</span>
                                                </label>
                                            </c:forEach>
                                        </div>
                                    </div>

                                    <!-- Time + Duration + Count -->
                                    <div class="grid grid-cols-3 gap-5">
                                        <div>
                                            <label class="block text-sm font-semibold text-text-header mb-1.5"
                                                for="startTime">First Lecture Start</label>
                                            <input type="time" id="startTime" name="startTime"
                                                value="${not empty activeConfig ? activeConfig.firstLectureStartTime : '09:00'}"
                                                required
                                                class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20" />
                                        </div>
                                        <div>
                                            <label class="block text-sm font-semibold text-text-header mb-1.5"
                                                for="duration">Lecture Duration (min)</label>
                                            <input type="number" id="duration" name="duration" min="30" max="180"
                                                step="5"
                                                value="${not empty activeConfig ? activeConfig.lectureDurationMinutes : 60}"
                                                required
                                                class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20" />
                                        </div>
                                        <div>
                                            <label class="block text-sm font-semibold text-text-header mb-1.5"
                                                for="lecturesPerDay">Lectures Per Day</label>
                                            <input type="number" id="lecturesPerDay" name="lecturesPerDay" min="2"
                                                max="10"
                                                value="${not empty activeConfig ? activeConfig.lecturesPerDay : 6}"
                                                required
                                                class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20" />
                                        </div>
                                    </div>

                                    <!-- Break Configuration -->
                                    <div class="bg-orange-50 border border-orange-200 rounded-xl p-4">
                                        <div class="flex items-center justify-between mb-3">
                                            <div class="flex items-center gap-2">
                                                <span
                                                    class="material-symbols-outlined text-orange-600 text-base">free_breakfast</span>
                                                <label class="text-sm font-semibold text-text-header cursor-pointer"
                                                    for="hasBreakCheck">Include Break Period</label>
                                            </div>
                                            <input type="checkbox" id="hasBreakCheck" name="hasBreak" value="true" ${not
                                                empty activeConfig && activeConfig.hasBreak ? 'checked' : '' }
                                                onchange="document.getElementById('breakSection').classList.toggle('hidden', !this.checked)"
                                                class="size-4 rounded border-gray-300 text-primary focus:ring-primary/20" />
                                        </div>
                                        <div id="breakSection"
                                            class="${empty activeConfig || !activeConfig.hasBreak ? 'hidden' : ''} grid grid-cols-2 gap-4 mt-2">
                                            <div>
                                                <label class="block text-xs font-medium text-text-body mb-1">Break After
                                                    Lecture #</label>
                                                <input type="number" name="breakAfter" min="1" max="8"
                                                    value="${not empty activeConfig ? activeConfig.breakAfterLectureNumber : 3}"
                                                    class="w-full px-3 py-2 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20" />
                                            </div>
                                            <div>
                                                <label class="block text-xs font-medium text-text-body mb-1">Break
                                                    Duration
                                                    (min)</label>
                                                <input type="number" name="breakDuration" min="5" max="120" step="5"
                                                    value="${not empty activeConfig ? activeConfig.breakDurationMinutes : 30}"
                                                    class="w-full px-3 py-2 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20" />
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Action Buttons -->
                                    <div class="flex items-center gap-3 pt-2">
                                        <button type="submit"
                                            class="flex items-center gap-2 px-6 py-2.5 bg-primary text-white rounded-lg font-medium text-sm hover:bg-primary/90 shadow-sm transition-colors">
                                            <span class="material-symbols-outlined text-lg">save</span>Save &amp;
                                            Generate
                                            Time Slots
                                        </button>
                                        <a href="${pageContext.request.contextPath}/admin?action=generate_ai"
                                            class="flex items-center gap-2 px-6 py-2.5 bg-gradient-to-r from-primary to-green-600 text-white rounded-lg font-medium text-sm hover:opacity-90 shadow-sm transition-opacity">
                                            <span class="material-symbols-outlined text-lg">auto_awesome</span>Apply
                                            &amp;
                                            Generate Timetable
                                        </a>
                                        <a href="${pageContext.request.contextPath}/admin?action=generate_ai"
                                            class="flex items-center gap-2 px-5 py-2.5 border border-border-color bg-white rounded-lg text-sm font-medium text-text-body hover:bg-gray-50 transition-colors">
                                            <span class="material-symbols-outlined text-base">play_circle</span>Re-Run
                                            AI
                                            Solver
                                        </a>
                                    </div>
                                </form>
                            </div>

                            <!-- ═══════════════════════════════════════════════════
                     SECTION 2 — HARD CONSTRAINTS (Read-only display)
                     These are enforced in TimetableConstraintProvider.java
                     and cannot be toggled via UI — shown for transparency.
                ════════════════════════════════════════════════════ -->
                            <div class="bg-white rounded-xl border border-border-color shadow-sm overflow-hidden">
                                <div class="flex items-center gap-3 px-6 py-5 border-b border-border-color">
                                    <div
                                        class="size-10 rounded-lg bg-red-50 flex items-center justify-center text-red-600">
                                        <span class="material-symbols-outlined">lock</span>
                                    </div>
                                    <div>
                                        <h2 class="font-serif font-bold text-lg">Hard Constraints</h2>
                                        <p class="text-xs text-text-body">These rules are enforced by the AI solver and
                                            <strong class="text-red-600">cannot be violated</strong>. They ensure a
                                            conflict-free timetable.
                                        </p>
                                    </div>
                                </div>
                                <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-3">
                                    <c:forEach var="hc" items="${[
                            'Room Conflict: A classroom can host only one lecture at a time',
                            'Teacher Conflict: A faculty member can teach only one class at a time',
                            'Student Group Conflict: A group can attend only one lecture at a time',
                            'Division Conflict: A division cannot have two simultaneous lectures',
                            'Room Type: Theory lectures must be in CLASSROOM rooms (not Labs)'
                        ]}">
                                        <div
                                            class="flex items-start gap-3 p-4 bg-red-50 border border-red-100 rounded-xl">
                                            <span
                                                class="material-symbols-outlined text-red-500 text-base mt-0.5 shrink-0">block</span>
                                            <p class="text-sm text-red-900">${hc}</p>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <!-- ═══════════════════════════════════════════════════
                     SECTION 3 — SOFT CONSTRAINTS (Read-only display)
                ════════════════════════════════════════════════════ -->
                            <div class="bg-white rounded-xl border border-border-color shadow-sm overflow-hidden">
                                <div class="flex items-center gap-3 px-6 py-5 border-b border-border-color">
                                    <div
                                        class="size-10 rounded-lg bg-blue-50 flex items-center justify-center text-blue-600">
                                        <span class="material-symbols-outlined">tune</span>
                                    </div>
                                    <div>
                                        <h2 class="font-serif font-bold text-lg">Soft Constraints</h2>
                                        <p class="text-xs text-text-body">These are <strong>preferences</strong> the AI
                                            tries to satisfy. Breaking them doesn't prevent generation but lowers the
                                            schedule quality score.</p>
                                    </div>
                                </div>
                                <div class="p-6 grid grid-cols-1 md:grid-cols-2 gap-3">
                                    <div
                                        class="flex items-start gap-3 p-4 bg-blue-50 border border-blue-100 rounded-xl">
                                        <span
                                            class="material-symbols-outlined text-blue-500 text-base mt-0.5 shrink-0">star</span>
                                        <div>
                                            <p class="text-sm font-medium text-blue-900">Subject Variety Per Day</p>
                                            <p class="text-xs text-blue-700 mt-0.5">Avoids repeating the same subject
                                                twice
                                                in the same day for a division. Encourages variety.</p>
                                        </div>
                                    </div>
                                    <div
                                        class="flex items-start gap-3 p-4 bg-gray-50 border border-border-color rounded-xl opacity-60">
                                        <span
                                            class="material-symbols-outlined text-gray-400 text-base mt-0.5 shrink-0">add_circle</span>
                                        <div>
                                            <p class="text-sm font-medium">More soft constraints can be added</p>
                                            <p class="text-xs text-text-body mt-0.5">E.g., teacher preferred time
                                                windows,
                                                preferred rooms — add in TimetableConstraintProvider.java</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- Sticky Footer -->
                    <footer
                        class="bg-white border-t border-border-color px-8 py-4 flex items-center justify-between shrink-0">
                        <a href="${pageContext.request.contextPath}/admin"
                            class="px-5 py-2 text-text-body font-medium hover:text-text-header text-sm transition-colors">
                            ← Back to Dashboard
                        </a>
                        <div class="flex gap-3">
                            <a href="${pageContext.request.contextPath}/admin?action=generate_ai"
                                class="flex items-center gap-2 px-6 py-2.5 bg-primary text-white rounded-lg font-medium text-sm hover:bg-primary/90 shadow-sm transition-colors">
                                <span class="material-symbols-outlined text-lg">auto_awesome</span>
                                Apply &amp; Regenerate Timetable
                            </a>
                        </div>
                    </footer>
                </main>
            </body>

            </html>