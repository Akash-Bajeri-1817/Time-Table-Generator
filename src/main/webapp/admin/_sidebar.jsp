<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%-- Shared sidebar fragment. Set 'currentPage' before including: <c:set var="currentPage"
            value="dashboard|faculty|rooms|subjects|groups|workload|constraints|timetable" />
        --%>
        <aside class="w-72 bg-white border-r border-slate-200 flex flex-col justify-between shrink-0 overflow-y-auto">
            <div class="flex flex-col gap-6 p-6">
                <!-- Logo -->
                <div class="flex items-center gap-3">
                    <div class="size-10 rounded-lg bg-primary/10 flex items-center justify-center text-primary">
                        <span class="material-symbols-outlined text-2xl">school</span>
                    </div>
                    <div>
                        <h1 class="text-base font-bold text-slate-900">Timetable Admin</h1>
                        <p class="text-sm text-slate-500">Management System</p>
                    </div>
                </div>

                <!-- Nav Links -->
                <nav class="flex flex-col gap-1">

                    <a href="${pageContext.request.contextPath}/admin?page=dashboard" class="<c:choose><c:when test="
                        ${currentPage=='dashboard' }">relative flex items-center gap-3 px-4 py-3 rounded-lg
                        bg-primary/10 text-primary font-semibold</c:when>
                        <c:otherwise>flex items-center gap-3 px-4 py-3 rounded-lg text-slate-600 hover:bg-slate-50
                            hover:text-primary transition-colors font-medium</c:otherwise>
                        </c:choose>">
                        <c:if test="${currentPage == 'dashboard'}">
                            <div class="absolute left-0 top-1/2 -translate-y-1/2 h-8 w-1 bg-primary rounded-r-full">
                            </div>
                        </c:if>
                        <span class="material-symbols-outlined text-xl">dashboard</span>
                        <span class="text-sm">Dashboard</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin?page=faculty" class="<c:choose><c:when test="
                        ${currentPage=='faculty' }">relative flex items-center gap-3 px-4 py-3 rounded-lg bg-primary/10
                        text-primary font-semibold</c:when>
                        <c:otherwise>flex items-center gap-3 px-4 py-3 rounded-lg text-slate-600 hover:bg-slate-50
                            hover:text-primary transition-colors font-medium</c:otherwise>
                        </c:choose>">
                        <c:if test="${currentPage == 'faculty'}">
                            <div class="absolute left-0 top-1/2 -translate-y-1/2 h-8 w-1 bg-primary rounded-r-full">
                            </div>
                        </c:if>
                        <span class="material-symbols-outlined text-xl">group</span>
                        <span class="text-sm">Faculty Management</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin?page=rooms" class="<c:choose><c:when test="
                        ${currentPage=='rooms' }">relative flex items-center gap-3 px-4 py-3 rounded-lg bg-primary/10
                        text-primary font-semibold</c:when>
                        <c:otherwise>flex items-center gap-3 px-4 py-3 rounded-lg text-slate-600 hover:bg-slate-50
                            hover:text-primary transition-colors font-medium</c:otherwise>
                        </c:choose>">
                        <c:if test="${currentPage == 'rooms'}">
                            <div class="absolute left-0 top-1/2 -translate-y-1/2 h-8 w-1 bg-primary rounded-r-full">
                            </div>
                        </c:if>
                        <span class="material-symbols-outlined text-xl">meeting_room</span>
                        <span class="text-sm">Room Allocation</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin?page=subjects" class="<c:choose><c:when test="
                        ${currentPage=='subjects' }">relative flex items-center gap-3 px-4 py-3 rounded-lg bg-primary/10
                        text-primary font-semibold</c:when>
                        <c:otherwise>flex items-center gap-3 px-4 py-3 rounded-lg text-slate-600 hover:bg-slate-50
                            hover:text-primary transition-colors font-medium</c:otherwise>
                        </c:choose>">
                        <c:if test="${currentPage == 'subjects'}">
                            <div class="absolute left-0 top-1/2 -translate-y-1/2 h-8 w-1 bg-primary rounded-r-full">
                            </div>
                        </c:if>
                        <span class="material-symbols-outlined text-xl">menu_book</span>
                        <span class="text-sm">Subjects</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin?page=groups" class="<c:choose><c:when test="
                        ${currentPage=='groups' }">relative flex items-center gap-3 px-4 py-3 rounded-lg bg-primary/10
                        text-primary font-semibold</c:when>
                        <c:otherwise>flex items-center gap-3 px-4 py-3 rounded-lg text-slate-600 hover:bg-slate-50
                            hover:text-primary transition-colors font-medium</c:otherwise>
                        </c:choose>">
                        <c:if test="${currentPage == 'groups'}">
                            <div class="absolute left-0 top-1/2 -translate-y-1/2 h-8 w-1 bg-primary rounded-r-full">
                            </div>
                        </c:if>
                        <span class="material-symbols-outlined text-xl">groups</span>
                        <span class="text-sm">Student Groups</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin?page=workload" class="<c:choose><c:when test="
                        ${currentPage=='workload' }">relative flex items-center gap-3 px-4 py-3 rounded-lg bg-primary/10
                        text-primary font-semibold</c:when>
                        <c:otherwise>flex items-center gap-3 px-4 py-3 rounded-lg text-slate-600 hover:bg-slate-50
                            hover:text-primary transition-colors font-medium</c:otherwise>
                        </c:choose>">
                        <c:if test="${currentPage == 'workload'}">
                            <div class="absolute left-0 top-1/2 -translate-y-1/2 h-8 w-1 bg-primary rounded-r-full">
                            </div>
                        </c:if>
                        <span class="material-symbols-outlined text-xl">assignment</span>
                        <span class="text-sm">Workload</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin?page=constraints" class="<c:choose><c:when test="
                        ${currentPage=='constraints' }">relative flex items-center gap-3 px-4 py-3 rounded-lg
                        bg-primary/10 text-primary font-semibold</c:when>
                        <c:otherwise>flex items-center gap-3 px-4 py-3 rounded-lg text-slate-600 hover:bg-slate-50
                            hover:text-primary transition-colors font-medium</c:otherwise>
                        </c:choose>">
                        <c:if test="${currentPage == 'constraints'}">
                            <div class="absolute left-0 top-1/2 -translate-y-1/2 h-8 w-1 bg-primary rounded-r-full">
                            </div>
                        </c:if>
                        <span class="material-symbols-outlined text-xl">gavel</span>
                        <span class="text-sm">Constraints</span>
                    </a>

                    <a href="${pageContext.request.contextPath}/admin?page=timetable" class="<c:choose><c:when test="
                        ${currentPage=='timetable' }">relative flex items-center gap-3 px-4 py-3 rounded-lg
                        bg-primary/10 text-primary font-semibold</c:when>
                        <c:otherwise>flex items-center gap-3 px-4 py-3 rounded-lg text-slate-600 hover:bg-slate-50
                            hover:text-primary transition-colors font-medium</c:otherwise>
                        </c:choose>">
                        <c:if test="${currentPage == 'timetable'}">
                            <div class="absolute left-0 top-1/2 -translate-y-1/2 h-8 w-1 bg-primary rounded-r-full">
                            </div>
                        </c:if>
                        <span class="material-symbols-outlined text-xl">table_chart</span>
                        <span class="text-sm">View Timetable</span>
                    </a>

                </nav>
            </div>

            <!-- User Profile -->
            <div class="p-6 border-t border-slate-100">
                <div class="flex items-center gap-3 px-2">
                    <div
                        class="size-10 rounded-full bg-primary/10 flex items-center justify-center text-primary font-bold text-sm">
                        AD</div>
                    <div class="flex flex-col">
                        <span class="text-sm font-bold text-slate-900">Admin User</span>
                        <span class="text-xs text-slate-500">Super Administrator</span>
                    </div>
                </div>
            </div>
        </aside>