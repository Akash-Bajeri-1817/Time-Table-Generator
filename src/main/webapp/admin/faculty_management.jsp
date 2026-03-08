<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>Forest Green Timetable Admin Dashboard</title>
        <link
            href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@400;600;700&display=swap"
            rel="stylesheet" />
        <link
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
            rel="stylesheet" />
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <script>
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        colors: {
                            primary: "#2D5A27", // Forest Green
                            "primary-light": "#E8F5E9", // Light Green for active backgrounds/badges
                            "primary-dark": "#1e3d1a",
                            "background-cream": "#F4F1EA", // Warm off-white
                            "surface-white": "#FFFFFF",
                            "text-header": "#111827",
                            "text-body": "#6B7280",
                            "border-color": "#E5E7EB",
                            "badge-neutral": "#F3F4F6",
                            "badge-error-bg": "#FEE2E2",
                            "badge-error-text": "#DC2626",
                        },
                        fontFamily: {
                            serif: ["Playfair Display", "Georgia", "serif"],
                            sans: ["Inter", "sans-serif"],
                        },
                        borderRadius: {
                            "DEFAULT": "0.75rem", // 12px roughly
                            "lg": "0.75rem",
                            "xl": "0.75rem",
                            "2xl": "1rem",
                        },
                        boxShadow: {
                            'md': '0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03)',
                        }
                    },
                },
            }
        </script>
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #F4F1EA;
            }

            h1,
            h2,
            h3,
            h4,
            h5,
            h6,
            .card-title {
                font-family: 'Playfair Display', serif;
                color: #111827;
            }

            .scrollbar-hide::-webkit-scrollbar {
                display: none;
            }

            .scrollbar-hide {
                -ms-overflow-style: none;
                scrollbar-width: none;
            }

            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }
        </style>
    </head>

    <body
        class="bg-background-cream text-text-body min-h-screen flex overflow-hidden font-sans transition-colors duration-200">
        <%@ taglib prefix="c" uri="jakarta.tags.core" %>
            <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
                <c:set var="currentPage" value="faculty" />
                <jsp:include page="_sidebar.jsp" />
                <main class="flex-1 flex flex-col h-screen overflow-hidden relative">
                    <header
                        class="h-16 bg-surface-white border-b border-border-color flex items-center justify-between px-6 shrink-0 z-10 shadow-sm">
                        <div class="flex items-center gap-2 text-sm text-text-body">
                            <a class="hover:text-primary transition-colors font-sans" href="#">Admin</a>
                            <span class="material-symbols-outlined text-base">chevron_right</span>
                            <span class="font-medium text-text-header font-sans">Faculty Management</span>
                        </div>
                        <div class="flex items-center gap-4">
                            <div class="relative hidden md:block w-64">
                                <span
                                    class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-gray-400 text-lg">search</span>
                                <input
                                    class="w-full pl-9 pr-4 py-2 bg-background-cream border-none rounded-lg text-sm focus:ring-1 focus:ring-primary placeholder-gray-400 text-text-header transition-all"
                                    placeholder="Search faculty, rooms..." type="text" />
                            </div>
                            <button class="relative p-2 text-text-body hover:text-primary transition-colors">
                                <span class="material-symbols-outlined">notifications</span>
                                <span
                                    class="absolute top-1.5 right-1.5 w-4 h-4 bg-badge-error-text text-white text-[10px] font-bold flex items-center justify-center rounded-full border border-surface-white">3</span>
                            </button>
                        </div>
                    </header>
                    <div class="flex-1 overflow-auto flex bg-background-cream">
                        <div class="flex-1 p-8 min-w-0">
                            <div class="flex flex-col gap-6 max-w-7xl mx-auto">
                                <!-- Flash Message -->
                                <c:if test="${not empty sessionScope.flashMessage}">
                                    <div class="bg-primary-light border border-primary text-primary px-4 py-3 rounded relative"
                                        role="alert">
                                        <span class="block sm:inline">${sessionScope.flashMessage}</span>
                                    </div>
                                    <c:remove var="flashMessage" scope="session" />
                                </c:if>
                                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                                    <div>
                                        <h2 class="text-3xl font-bold text-text-header font-serif">Faculty Overview</h2>
                                        <p class="text-text-body text-sm mt-1 font-sans">Manage teaching staff,
                                            assignments
                                            and
                                            conflicts.</p>
                                    </div>
                                    <div class="flex gap-3">
                                        <button
                                            class="px-4 py-2 border border-slate-300 rounded-lg text-sm font-medium text-text-header hover:bg-white transition-colors flex items-center gap-2 shadow-sm bg-white">
                                            <span class="material-symbols-outlined text-lg">download</span>
                                            Bulk Export
                                        </button>
                                        <button
                                            class="px-4 py-2 bg-primary hover:bg-primary-dark text-white rounded-lg text-sm font-medium shadow-md hover:shadow-lg transition-all flex items-center gap-2">
                                            <span class="material-symbols-outlined text-lg">auto_awesome</span>
                                            Generate Timetable
                                        </button>
                                    </div>
                                </div>
                                <div class="flex">
                                    <div
                                        class="bg-surface-white p-5 rounded-xl shadow-md border border-gray-100 min-w-[250px]">
                                        <div class="flex justify-between items-start mb-4">
                                            <div class="p-2 bg-primary-light rounded-lg">
                                                <span class="material-symbols-outlined text-primary">group</span>
                                            </div>
                                            <span
                                                class="text-xs font-medium text-primary bg-primary-light px-2 py-0.5 rounded-full">Live</span>
                                        </div>
                                        <h3 class="text-text-body text-sm font-medium font-sans">Total Faculty</h3>
                                        <p class="text-3xl font-bold text-text-header mt-1 font-serif">
                                            ${faculties.size()}
                                        </p>
                                    </div>
                                </div>

                                <div
                                    class="bg-surface-white rounded-xl shadow-md overflow-hidden border border-gray-100">
                                    <div class="overflow-x-auto">
                                        <table class="w-full text-left border-collapse">
                                            <thead>
                                                <tr class="border-b border-gray-200 bg-gray-50/50">
                                                    <th
                                                        class="p-4 text-xs font-semibold text-text-body uppercase tracking-wider font-sans">
                                                        Name</th>
                                                    <th
                                                        class="p-4 text-xs font-semibold text-text-body uppercase tracking-wider font-sans">
                                                        Department</th>
                                                    <th
                                                        class="p-4 text-xs font-semibold text-text-body uppercase tracking-wider font-sans">
                                                        Specialization</th>
                                                    <th
                                                        class="p-4 text-xs font-semibold text-text-body uppercase tracking-wider font-sans">
                                                        Weekly Hours</th>
                                                    <th
                                                        class="p-4 text-xs font-semibold text-text-body uppercase tracking-wider font-sans">
                                                        Status</th>
                                                    <th
                                                        class="p-4 text-xs font-semibold text-text-body uppercase tracking-wider text-right font-sans">
                                                        Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody class="divide-y divide-gray-100">
                                                <c:choose>
                                                    <c:when test="${empty faculties}">
                                                        <tr>
                                                            <td colspan="7" class="p-8 text-center text-text-body">
                                                                <span
                                                                    class="material-symbols-outlined text-4xl mb-2 text-gray-300">group_off</span>
                                                                <p>No faculty members found. Click the + button to
                                                                    add
                                                                    one.
                                                                </p>
                                                            </td>
                                                        </tr>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:forEach var="f" items="${faculties}">
                                                            <tr
                                                                class="group hover:bg-background-cream transition-colors">
                                                                <td class="p-4">
                                                                    <div class="flex items-center gap-3">
                                                                        <div
                                                                            class="w-8 h-8 rounded-full bg-primary-light text-primary flex items-center justify-center text-xs font-bold">
                                                                            ${fn:substring(f.name, 0,
                                                                            2).toUpperCase()}
                                                                        </div>
                                                                        <div>
                                                                            <div
                                                                                class="font-medium text-text-header text-sm">
                                                                                ${f.name}</div>
                                                                            <div class="text-xs text-text-body">
                                                                                ${f.email}
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </td>
                                                                <td class="p-4 text-sm text-text-body">
                                                                    ${f.department}
                                                                </td>
                                                                <td class="p-4 text-sm text-text-body">-</td>
                                                                <td class="p-4 text-sm text-text-body">-</td>
                                                                <td class="p-4">
                                                                    <span
                                                                        class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-medium bg-primary-light text-primary border border-primary/20">
                                                                        <span
                                                                            class="w-1.5 h-1.5 rounded-full bg-primary"></span>
                                                                        Active
                                                                    </span>
                                                                </td>
                                                                <td class="p-4 text-right">
                                                                    <a href="${pageContext.request.contextPath}/admin?action=delete_faculty&id=${f.id}"
                                                                        class="text-red-400 hover:text-red-600 transition-colors"
                                                                        onclick="return confirm('Delete ${f.name}?');">
                                                                        <span
                                                                            class="material-symbols-outlined text-lg">delete</span>
                                                                    </a>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </c:otherwise>
                                                </c:choose>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div
                                        class="p-4 border-t border-gray-200 flex items-center justify-between bg-gray-50/30">
                                        <span class="text-sm text-text-body">Showing ${faculties.size()} of
                                            ${faculties.size()}</span>
                                        <div class="flex gap-1">
                                            <button
                                                class="p-1 rounded hover:bg-white text-gray-500 disabled:opacity-50 hover:shadow-sm"><span
                                                    class="material-symbols-outlined text-lg">chevron_left</span></button>
                                            <button
                                                class="p-1 rounded hover:bg-white text-gray-500 hover:shadow-sm"><span
                                                    class="material-symbols-outlined text-lg">chevron_right</span></button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                    <button onclick="document.getElementById('addFacultyModal').classList.remove('hidden')"
                        class="absolute bottom-8 right-8 w-14 h-14 bg-primary text-white rounded-full shadow-lg shadow-primary/30 hover:scale-110 hover:shadow-xl hover:shadow-primary/40 transition-all flex items-center justify-center z-50">
                        <span class="material-symbols-outlined text-2xl">add</span>
                    </button>

                    <!-- Add Faculty Modal -->
                    <div id="addFacultyModal"
                        class="fixed inset-0 bg-black/50 hidden z-50 flex items-center justify-center backdrop-blur-sm transition-opacity">
                        <div
                            class="bg-surface-white rounded-xl shadow-xl w-full max-w-md border border-border-color overflow-hidden">
                            <div
                                class="flex justify-between items-center p-6 border-b border-border-color bg-gray-50/50">
                                <h3 class="text-xl font-bold text-text-header font-serif">Add New Faculty</h3>
                                <button onclick="document.getElementById('addFacultyModal').classList.add('hidden')"
                                    class="text-gray-400 hover:text-gray-600 transition-colors">
                                    <span class="material-symbols-outlined">close</span>
                                </button>
                            </div>
                            <form action="${pageContext.request.contextPath}/admin" method="post" class="p-6">
                                <input type="hidden" name="action" value="add_faculty">
                                <div class="space-y-4">
                                    <div>
                                        <label class="block text-sm font-semibold text-text-header mb-1 font-sans">Full
                                            Name
                                            *</label>
                                        <input type="text" name="name" required
                                            class="w-full rounded-lg border-gray-300 shadow-sm focus:border-primary focus:ring-primary text-sm p-2.5 bg-background-cream placeholder-gray-400"
                                            placeholder="e.g. Dr. John Doe">
                                    </div>
                                    <div>
                                        <label class="block text-sm font-semibold text-text-header mb-1 font-sans">Email
                                            address *</label>
                                        <input type="email" name="email" required
                                            class="w-full rounded-lg border-gray-300 shadow-sm focus:border-primary focus:ring-primary text-sm p-2.5 bg-background-cream placeholder-gray-400"
                                            placeholder="john.doe@college.edu">
                                    </div>
                                    <div>
                                        <label
                                            class="block text-sm font-semibold text-text-header mb-1 font-sans">Department
                                            *</label>
                                        <input type="text" name="department" required
                                            class="w-full rounded-lg border-gray-300 shadow-sm focus:border-primary focus:ring-primary text-sm p-2.5 bg-background-cream placeholder-gray-400"
                                            placeholder="e.g. Computer Science">
                                    </div>
                                </div>
                                <div class="mt-8 flex justify-end gap-3">
                                    <button type="button"
                                        onclick="document.getElementById('addFacultyModal').classList.add('hidden')"
                                        class="px-5 py-2.5 border border-gray-300 rounded-lg text-sm font-semibold text-gray-700 hover:bg-gray-50 transition-colors">Cancel</button>
                                    <button type="submit"
                                        class="px-5 py-2.5 bg-primary hover:bg-primary-dark text-white rounded-lg text-sm font-semibold shadow-md hover:shadow-lg transition-all">Save
                                        Faculty</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </main>

    </body>

    </html>