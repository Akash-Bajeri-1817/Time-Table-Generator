<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="utf-8" />
            <meta content="width=device-width, initial-scale=1.0" name="viewport" />
            <title>Subjects Management</title>
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
            </style>
        </head>

        <body class="bg-background-light font-sans text-text-header flex overflow-hidden h-screen">
            <c:set var="currentPage" value="subjects" />
            <jsp:include page="_sidebar.jsp" />
            <main class="flex-1 flex flex-col overflow-hidden">
                <header
                    class="bg-white border-b border-border-color px-8 py-4 flex items-center justify-between shrink-0">
                    <div>
                        <nav class="flex items-center gap-2 text-sm text-text-body mb-1">
                            <a href="${pageContext.request.contextPath}/admin" class="hover:text-primary">Admin</a>
                            <span class="material-symbols-outlined text-sm text-gray-400">chevron_right</span>
                            <span class="font-semibold text-primary">Subjects</span>
                        </nav>
                        <h1 class="font-serif text-2xl font-bold text-primary">Subject Management</h1>
                    </div>
                    <button onclick="document.getElementById('addModal').classList.remove('hidden')"
                        class="flex items-center gap-2 px-5 py-2.5 bg-primary text-white rounded-lg shadow-sm hover:bg-primary/90 font-medium text-sm">
                        <span class="material-symbols-outlined text-lg">add</span>Add Subject
                    </button>
                </header>
                <div class="flex-1 overflow-y-auto p-8 space-y-6">
                    <c:if test="${not empty message}">
                        <div class="bg-green-50 border border-green-200 rounded-xl p-4 flex items-center gap-3">
                            <span class="material-symbols-outlined text-green-600">check_circle</span>
                            <p class="text-sm text-green-800 font-medium">${message}</p>
                        </div>
                    </c:if>
                    <!-- Stats -->
                    <div class="grid grid-cols-4 gap-4">
                        <div
                            class="bg-white rounded-xl p-5 border border-border-color shadow-sm flex items-center gap-4">
                            <div class="size-12 rounded-full bg-blue-50 flex items-center justify-center text-blue-600">
                                <span class="material-symbols-outlined">menu_book</span></div>
                            <div>
                                <p class="text-sm text-text-body">Total Subjects</p>
                                <h3 class="text-2xl font-bold">${subjects.size()}</h3>
                            </div>
                        </div>
                        <div
                            class="bg-white rounded-xl p-5 border border-border-color shadow-sm flex items-center gap-4">
                            <div
                                class="size-12 rounded-full bg-primary-light flex items-center justify-center text-primary">
                                <span class="material-symbols-outlined">class</span></div>
                            <div>
                                <p class="text-sm text-text-body">Theory</p>
                                <h3 class="text-2xl font-bold">
                                    <c:set var="tc" value="0" />
                                    <c:forEach var="s" items="${subjects}">
                                        <c:if test="${!s.practical}">
                                            <c:set var="tc" value="${tc+1}" />
                                        </c:if>
                                    </c:forEach>${tc}
                                </h3>
                            </div>
                        </div>
                        <div
                            class="bg-white rounded-xl p-5 border border-border-color shadow-sm flex items-center gap-4">
                            <div
                                class="size-12 rounded-full bg-purple-50 flex items-center justify-center text-purple-600">
                                <span class="material-symbols-outlined">science</span></div>
                            <div>
                                <p class="text-sm text-text-body">Practical / Lab</p>
                                <h3 class="text-2xl font-bold">
                                    <c:set var="pc" value="0" />
                                    <c:forEach var="s" items="${subjects}">
                                        <c:if test="${s.practical}">
                                            <c:set var="pc" value="${pc+1}" />
                                        </c:if>
                                    </c:forEach>${pc}
                                </h3>
                            </div>
                        </div>
                        <div
                            class="bg-white rounded-xl p-5 border border-border-color shadow-sm flex items-center gap-4">
                            <div
                                class="size-12 rounded-full bg-orange-50 flex items-center justify-center text-orange-600">
                                <span class="material-symbols-outlined">school</span></div>
                            <div>
                                <p class="text-sm text-text-body">Loaded from DB</p>
                                <h3 class="text-2xl font-bold">${subjects.size()}</h3>
                            </div>
                        </div>
                    </div>
                    <!-- Table -->
                    <div class="bg-white rounded-xl border border-border-color shadow-sm overflow-hidden">
                        <table class="w-full">
                            <thead class="bg-gray-50 border-b border-border-color">
                                <tr>
                                    <th class="text-left px-6 py-4 text-xs font-semibold text-text-body uppercase">Code
                                    </th>
                                    <th class="text-left px-6 py-4 text-xs font-semibold text-text-body uppercase">
                                        Subject Name</th>
                                    <th class="text-left px-6 py-4 text-xs font-semibold text-text-body uppercase">
                                        Department</th>
                                    <th class="text-center px-6 py-4 text-xs font-semibold text-text-body uppercase">
                                        Lectures/Week</th>
                                    <th class="text-center px-6 py-4 text-xs font-semibold text-text-body uppercase">
                                        Type</th>
                                    <th class="text-right px-6 py-4 text-xs font-semibold text-text-body uppercase">
                                        Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-border-color">
                                <c:choose>
                                    <c:when test="${empty subjects}">
                                        <tr>
                                            <td colspan="6" class="text-center py-16 text-text-body">
                                                <span
                                                    class="material-symbols-outlined text-4xl text-gray-300 block mb-2">menu_book</span>
                                                No subjects yet. <a
                                                    href="${pageContext.request.contextPath}/admin?action=load_enhanced_data"
                                                    class="text-primary font-medium underline">Load sample data</a> or
                                                add manually.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="s" items="${subjects}">
                                            <tr class="hover:bg-gray-50 transition-colors">
                                                <td
                                                    class="px-6 py-4 text-sm font-mono font-semibold ${s.practical ? 'text-purple-700 bg-purple-50/50' : 'text-blue-700 bg-blue-50/50'}">
                                                    ${s.code}</td>
                                                <td class="px-6 py-4">
                                                    <p class="font-semibold text-sm">${s.name}</p>
                                                </td>
                                                <td class="px-6 py-4 text-sm text-text-body">${s.department}</td>
                                                <td class="px-6 py-4 text-center text-sm font-semibold text-primary">
                                                    ${s.lecturesPerWeek} hrs</td>
                                                <td class="px-6 py-4 text-center">
                                                    <c:choose>
                                                        <c:when test="${s.practical}"><span
                                                                class="px-2.5 py-1 rounded-full text-xs font-medium bg-purple-100 text-purple-700">Practical</span>
                                                        </c:when>
                                                        <c:otherwise><span
                                                                class="px-2.5 py-1 rounded-full text-xs font-medium bg-primary-light text-primary">Theory</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="px-6 py-4 text-right">
                                                    <a href="${pageContext.request.contextPath}/admin?action=delete_subject&id=${s.id}"
                                                        onclick="return confirm('Delete subject ${s.name}?')"
                                                        class="p-1.5 text-text-body hover:text-red-600 hover:bg-red-50 rounded-lg transition-colors inline-flex">
                                                        <span class="material-symbols-outlined text-base">delete</span>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                        <div class="px-6 py-4 border-t border-border-color">
                            <p class="text-sm text-text-body">${subjects.size()} subjects in database</p>
                        </div>
                    </div>
                </div>
            </main>
            <!-- Add Subject Modal -->
            <div id="addModal"
                class="hidden fixed inset-0 bg-black/40 backdrop-blur-sm z-50 flex items-center justify-center p-4">
                <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg">
                    <div class="flex items-center justify-between p-6 border-b border-border-color">
                        <div class="flex items-center gap-3">
                            <div
                                class="size-10 rounded-lg bg-primary-light flex items-center justify-center text-primary">
                                <span class="material-symbols-outlined">menu_book</span></div>
                            <h2 class="text-lg font-bold font-serif">Add New Subject</h2>
                        </div>
                        <button onclick="document.getElementById('addModal').classList.add('hidden')"
                            class="p-2 rounded-lg hover:bg-gray-100"><span
                                class="material-symbols-outlined">close</span></button>
                    </div>
                    <form method="post" action="${pageContext.request.contextPath}/admin" class="p-6 space-y-4">
                        <input type="hidden" name="action" value="add_subject" />
                        <div class="grid grid-cols-2 gap-4">
                            <div><label class="block text-sm font-medium mb-1.5">Subject Code *</label><input
                                    type="text" name="code" placeholder="e.g. CS101" required
                                    class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20" />
                            </div>
                            <div><label class="block text-sm font-medium mb-1.5">Subject Name *</label><input
                                    type="text" name="name" placeholder="e.g. Data Structures" required
                                    class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20" />
                            </div>
                        </div>
                        <div><label class="block text-sm font-medium mb-1.5">Department *</label><input type="text"
                                name="department" placeholder="e.g. Computer Science" required
                                class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20" />
                        </div>
                        <div><label class="block text-sm font-medium mb-1.5">Lectures Per Week *</label><input
                                type="number" name="lectures" min="1" max="10" value="3" required
                                class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20" />
                        </div>
                        <div class="flex items-center gap-3 p-4 bg-purple-50 border border-purple-200 rounded-xl">
                            <input type="checkbox" id="isPractical" name="isPractical"
                                class="size-4 rounded border-gray-300" />
                            <label for="isPractical" class="text-sm font-medium cursor-pointer">This is a Practical /
                                Lab subject</label>
                        </div>
                        <div class="flex justify-end gap-3 pt-2">
                            <button type="button" onclick="document.getElementById('addModal').classList.add('hidden')"
                                class="px-5 py-2.5 border border-border-color rounded-lg text-sm font-medium text-text-body hover:bg-gray-50">Cancel</button>
                            <button type="submit"
                                class="px-5 py-2.5 bg-primary text-white rounded-lg text-sm font-medium hover:bg-primary/90">Add
                                Subject</button>
                        </div>
                    </form>
                </div>
            </div>
        </body>

        </html>