<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="utf-8" />
                <meta content="width=device-width, initial-scale=1.0" name="viewport" />
                <title>Student Groups</title>
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
                <c:set var="currentPage" value="groups" />
                <jsp:include page="_sidebar.jsp" />
                <main class="flex-1 flex flex-col overflow-hidden">
                    <header
                        class="bg-white border-b border-border-color px-8 py-4 flex items-center justify-between shrink-0">
                        <div>
                            <nav class="flex items-center gap-2 text-sm text-text-body mb-1">
                                <a href="${pageContext.request.contextPath}/admin" class="hover:text-primary">Admin</a>
                                <span class="material-symbols-outlined text-sm text-gray-400">chevron_right</span>
                                <span class="font-semibold text-primary">Student Groups</span>
                            </nav>
                            <h1 class="font-serif text-2xl font-bold text-primary">Student Groups</h1>
                        </div>
                        <button onclick="document.getElementById('addModal').classList.remove('hidden')"
                            class="flex items-center gap-2 px-5 py-2.5 bg-primary text-white rounded-lg shadow-sm hover:bg-primary/90 font-medium text-sm">
                            <span class="material-symbols-outlined text-lg">add</span>Add Group
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
                        <div class="grid grid-cols-3 gap-4">
                            <div
                                class="bg-white rounded-xl p-5 border border-border-color shadow-sm flex items-center gap-4">
                                <div
                                    class="size-12 rounded-full bg-primary-light flex items-center justify-center text-primary">
                                    <span class="material-symbols-outlined">groups</span>
                                </div>
                                <div>
                                    <p class="text-sm text-text-body">Student Groups</p>
                                    <h3 class="text-2xl font-bold">${groups.size()}</h3>
                                </div>
                            </div>
                            <div
                                class="bg-white rounded-xl p-5 border border-border-color shadow-sm flex items-center gap-4">
                                <div
                                    class="size-12 rounded-full bg-blue-50 flex items-center justify-center text-blue-600">
                                    <span class="material-symbols-outlined">account_tree</span>
                                </div>
                                <div>
                                    <p class="text-sm text-text-body">Divisions (DB)</p>
                                    <h3 class="text-2xl font-bold">${divisions.size()}</h3>
                                </div>
                            </div>
                            <div
                                class="bg-white rounded-xl p-5 border border-border-color shadow-sm flex items-center gap-4">
                                <div
                                    class="size-12 rounded-full bg-orange-50 flex items-center justify-center text-orange-600">
                                    <span class="material-symbols-outlined">info</span>
                                </div>
                                <div>
                                    <p class="text-sm text-text-body">Groups power the AI scheduler</p>
                                    <p class="text-xs text-text-body mt-0.5">Assign each to a workload</p>
                                </div>
                            </div>
                        </div>

                        <!-- Groups Table -->
                        <div class="bg-white rounded-xl border border-border-color shadow-sm overflow-hidden">
                            <div class="px-6 py-4 border-b border-border-color flex items-center justify-between">
                                <h2 class="font-semibold text-sm">All Student Groups</h2>
                                <span class="text-xs text-text-body">${groups.size()} groups</span>
                            </div>
                            <c:choose>
                                <c:when test="${empty groups}">
                                    <div class="text-center py-16 text-text-body">
                                        <span
                                            class="material-symbols-outlined text-4xl text-gray-300 block mb-2">groups</span>
                                        No groups yet. <a
                                            href="${pageContext.request.contextPath}/admin?action=load_enhanced_data"
                                            class="text-primary underline">Load sample data</a> or add manually.
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 p-6">
                                        <c:forEach var="g" items="${groups}">
                                            <div
                                                class="bg-gray-50 border border-border-color rounded-xl p-5 flex items-start justify-between">
                                                <div>
                                                    <div
                                                        class="size-10 rounded-full bg-primary-light flex items-center justify-center text-primary font-bold mb-3">
                                                        ${fn:substring(g.name,0,2)}</div>
                                                    <p class="font-semibold text-sm">${g.name}</p>
                                                    <p class="text-xs text-text-body mt-0.5">ID: ${g.id}</p>
                                                </div>
                                                <a href="${pageContext.request.contextPath}/admin?action=delete_group&id=${g.id}"
                                                    onclick="return confirm('Delete group ${g.name}?')"
                                                    class="p-1.5 text-text-body hover:text-red-600 hover:bg-red-50 rounded-lg inline-flex transition-colors">
                                                    <span class="material-symbols-outlined text-base">delete</span>
                                                </a>
                                            </div>
                                        </c:forEach>
                                        <!-- Add card -->
                                        <button onclick="document.getElementById('addModal').classList.remove('hidden')"
                                            class="bg-white rounded-xl border-2 border-dashed border-border-color p-5 flex flex-col items-center justify-center gap-2 hover:border-primary hover:bg-primary-light/30 transition-all group min-h-[120px]">
                                            <div
                                                class="size-10 rounded-full bg-gray-100 group-hover:bg-primary-light flex items-center justify-center text-gray-400 group-hover:text-primary transition-colors">
                                                <span class="material-symbols-outlined">add</span>
                                            </div>
                                            <p class="text-sm text-text-body group-hover:text-primary">Add New Group</p>
                                        </button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Divisions Table -->
                        <c:if test="${not empty divisions}">
                            <div class="bg-white rounded-xl border border-border-color shadow-sm overflow-hidden">
                                <div class="px-6 py-4 border-b border-border-color">
                                    <h2 class="font-semibold text-sm">Divisions from DB</h2>
                                </div>
                                <table class="w-full">
                                    <thead class="bg-gray-50 border-b border-border-color">
                                        <tr>
                                            <th
                                                class="text-left px-6 py-3 text-xs font-semibold text-text-body uppercase">
                                                Division</th>
                                            <th
                                                class="text-left px-6 py-3 text-xs font-semibold text-text-body uppercase">
                                                Branch</th>
                                            <th
                                                class="text-center px-6 py-3 text-xs font-semibold text-text-body uppercase">
                                                Year</th>
                                            <th
                                                class="text-center px-6 py-3 text-xs font-semibold text-text-body uppercase">
                                                Capacity</th>
                                            <th
                                                class="text-left px-6 py-3 text-xs font-semibold text-text-body uppercase">
                                                Default Room</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-border-color">
                                        <c:forEach var="d" items="${divisions}">
                                            <tr class="hover:bg-gray-50">
                                                <td class="px-6 py-3 text-sm font-bold">Div ${d.name}</td>
                                                <td class="px-6 py-3 text-sm">${d.branch.name}</td>
                                                <td class="px-6 py-3 text-center text-sm">${d.year}</td>
                                                <td class="px-6 py-3 text-center text-sm">${d.capacity}</td>
                                                <td class="px-6 py-3 text-sm font-mono">${d.classroom}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </div>
                </main>
                <!-- Add Group Modal -->
                <div id="addModal"
                    class="hidden fixed inset-0 bg-black/40 backdrop-blur-sm z-50 flex items-center justify-center p-4">
                    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md">
                        <div class="flex items-center justify-between p-6 border-b border-border-color">
                            <div class="flex items-center gap-3">
                                <div
                                    class="size-10 rounded-lg bg-primary-light flex items-center justify-center text-primary">
                                    <span class="material-symbols-outlined">groups</span>
                                </div>
                                <h2 class="text-lg font-bold font-serif">Add Student Group</h2>
                            </div>
                            <button onclick="document.getElementById('addModal').classList.add('hidden')"
                                class="p-2 rounded-lg hover:bg-gray-100"><span
                                    class="material-symbols-outlined">close</span></button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin" class="p-6 space-y-4">
                            <input type="hidden" name="action" value="add_group" />
                            <div><label class="block text-sm font-medium mb-1.5">Group Name *</label><input type="text"
                                    name="name" placeholder="e.g. TY BSc CS - Div A" required
                                    class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20" />
                            </div>
                            <p class="text-xs text-text-body">This group can then be assigned to workloads and scheduled
                                by
                                the AI.</p>
                            <div class="flex justify-end gap-3 pt-2">
                                <button type="button"
                                    onclick="document.getElementById('addModal').classList.add('hidden')"
                                    class="px-5 py-2.5 border border-border-color rounded-lg text-sm font-medium text-text-body hover:bg-gray-50">Cancel</button>
                                <button type="submit"
                                    class="px-5 py-2.5 bg-primary text-white rounded-lg text-sm font-medium hover:bg-primary/90">Create
                                    Group</button>
                            </div>
                        </form>
                    </div>
                </div>
            </body>

            </html>