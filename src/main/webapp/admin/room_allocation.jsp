<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <title>Room Allocation Management</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
            rel="stylesheet" />
        <link
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
            rel="stylesheet" />
        <script>
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        colors: {
                            primary: "#2c5926",
                            "primary-light": "#E8F5E9",
                            "background-light": "#F4F1EA",
                            "background-dark": "#161d15",
                        },
                        fontFamily: {
                            sans: ["Inter", "sans-serif"],
                            serif: ["Georgia", "serif"],
                        },
                        borderRadius: {
                            DEFAULT: "0.5rem",
                            lg: "1rem",
                            xl: "1.5rem",
                            full: "9999px"
                        },
                    },
                },
            }
        </script>
        <style>
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }
        </style>
    </head>

    <body class="bg-background-light font-sans text-slate-900 antialiased overflow-x-hidden">
        <div class="flex h-screen w-full overflow-hidden">

            <!-- Sidebar -->
            <%@ taglib prefix="c" uri="jakarta.tags.core" %>
                <c:set var="currentPage" value="rooms" />
                <jsp:include page="_sidebar.jsp" />

                <!-- Main Content -->
                <main class="flex-1 flex flex-col min-w-0 bg-background-light overflow-y-auto">

                    <!-- Top Bar -->
                    <header
                        class="sticky top-0 z-20 flex items-center justify-between bg-white border-b border-slate-200 px-8 py-4">
                        <div class="flex items-center gap-2 text-sm">
                            <a class="text-slate-500 hover:text-primary cursor-pointer transition-colors"
                                href="${pageContext.request.contextPath}/admin/dashboard.jsp">Admin</a>
                            <span class="material-symbols-outlined text-base text-slate-400">chevron_right</span>
                            <span class="font-semibold text-primary">Room Allocation</span>
                        </div>
                        <div class="flex items-center gap-6">
                            <div class="relative w-64 hidden sm:block">
                                <span
                                    class="absolute left-3 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-lg">search</span>
                                <input
                                    class="w-full h-10 pl-10 pr-4 bg-slate-50 border border-slate-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-slate-900 placeholder-slate-400"
                                    placeholder="Search rooms..." type="text" />
                            </div>
                           <!--   <button
                                class="relative p-2 text-slate-500 hover:bg-slate-100 rounded-full transition-colors">
                                <span class="material-symbols-outlined">notifications</span>
                                <span
                                    class="absolute top-2 right-2 size-2 bg-red-500 rounded-full border-2 border-white"></span>
                            </button>-->
                        </div>
                    </header>

                    <!-- Dashboard Content -->
                    <div class="p-8 space-y-8 max-w-7xl mx-auto w-full">
                        <c:if test="${not empty message}">
                            <c:choose>
                                <c:when test="${fn:contains(message, 'Duplicate') or fn:contains(message, 'required') or fn:contains(message, 'Error')}">
                                    <div class="bg-red-50 border border-red-200 rounded-xl p-4 flex items-center gap-3">
                                        <span class="material-symbols-outlined text-red-600">error</span>
                                        <p class="text-sm text-red-800 font-medium">${message}</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="bg-green-50 border border-green-200 rounded-xl p-4 flex items-center gap-3">
                                        <span class="material-symbols-outlined text-green-600">check_circle</span>
                                        <p class="text-sm text-green-800 font-medium">${message}</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:if>

                        <!-- KPI Cards -->
                        <div class="flex">
                            <div
                                class="bg-white p-6 rounded-xl shadow-sm border border-slate-100 flex flex-col justify-between h-36 min-w-[250px]">
                                <div class="flex items-start justify-between mb-4">
                                    <div>
                                        <p class="text-slate-500 text-sm font-medium mb-1">Total Rooms</p>
                                        <h3 class="text-3xl font-bold font-serif text-slate-900">${rooms.size()}</h3>
                                    </div>
                                    <div class="p-2 bg-primary-light rounded-lg text-primary">
                                        <span class="material-symbols-outlined">meeting_room</span>
                                    </div>
                                </div>
                                <div class="text-xs text-slate-400">Manage all rooms here</div>
                            </div>
                        </div>

                        <!-- Action Row -->
                        <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
                            <div class="flex p-1 bg-white rounded-lg border border-slate-200">
                                <button
                                    class="px-4 py-2 text-sm font-medium rounded-md bg-primary text-white shadow-sm transition-all">All
                                    Rooms</button>
                                <button
                                    class="px-4 py-2 text-sm font-medium rounded-md text-slate-600 hover:bg-slate-50 transition-all">Classrooms</button>
                                <button
                                    class="px-4 py-2 text-sm font-medium rounded-md text-slate-600 hover:bg-slate-50 transition-all">Labs</button>
                                <button
                                    class="px-4 py-2 text-sm font-medium rounded-md text-slate-600 hover:bg-slate-50 transition-all">Seminar
                                    Halls</button>
                            </div>
                            <button onclick="document.getElementById('addRoomModal').classList.remove('hidden')"
                                class="flex items-center gap-2 px-5 py-2.5 bg-primary hover:bg-primary/90 text-white rounded-lg shadow-sm shadow-primary/30 transition-all font-medium text-sm">
                                <span class="material-symbols-outlined text-lg">add</span>
                                Add Room
                            </button>
                        </div>

                        <!-- Room Grid -->
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                            <c:choose>
                                <c:when test="${empty rooms}">
                                    <div
                                        class="col-span-full bg-white rounded-xl p-8 text-center border border-slate-100 shadow-sm">
                                        <div
                                            class="size-16 bg-slate-50 rounded-full flex items-center justify-center mx-auto mb-4">
                                            <span
                                                class="material-symbols-outlined text-3xl text-slate-300">meeting_room</span>
                                        </div>
                                        <h3 class="font-serif text-lg font-bold text-slate-900 mb-2">No Rooms Found</h3>
                                        <p class="text-slate-500 text-sm mb-6 max-w-sm mx-auto">It looks like there are
                                            no rooms in the system yet. Add some rooms to start scheduling.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="room" items="${rooms}">
                                        <div
                                            class="bg-white rounded-xl p-5 shadow-sm border border-slate-100 hover:shadow-md transition-shadow">
                                            <div class="flex justify-between items-start mb-4">
                                                <div>
                                                    <h3 class="text-xl font-bold font-serif text-slate-900 mb-1">
                                                        ${room.name}</h3>
                                                    <p
                                                        class="text-xs text-slate-500 font-medium uppercase tracking-wide">
                                                        <c:choose>
                                                            <c:when test="${room.type == 'CLASSROOM'}">Classroom
                                                            </c:when>
                                                            <c:when test="${room.type == 'LAB'}">Laboratory</c:when>
                                                            <c:otherwise>${room.type}</c:otherwise>
                                                        </c:choose>
                                                    </p>
                                                </div>
                                                <span
                                                    class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">Available</span>
                                            </div>
                                            <div class="flex items-center gap-4 text-sm text-slate-600 mb-4">
                                                <div class="flex items-center gap-1.5 bg-slate-50 px-2 py-1 rounded">
                                                    <span
                                                        class="material-symbols-outlined text-lg text-slate-400">group</span>
                                                    <span>Cap: ${room.capacity}</span>
                                                </div>
                                                <div class="flex items-center gap-1.5 bg-slate-50 px-2 py-1 rounded">
                                                    <span class="material-symbols-outlined text-lg text-slate-400">
                                                        <c:choose>
                                                            <c:when test="${room.type == 'CLASSROOM'}">class</c:when>
                                                            <c:when test="${room.type == 'LAB'}">science</c:when>
                                                            <c:otherwise>meeting_room</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                    <span>
                                                        <c:choose>
                                                            <c:when test="${room.type == 'CLASSROOM'}">Class</c:when>
                                                            <c:when test="${room.type == 'LAB'}">Lab</c:when>
                                                            <c:otherwise>Room</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="flex flex-col gap-2">
                                                <button
                                                    class="w-full py-2 border border-slate-200 rounded-lg text-sm font-medium text-slate-600 hover:bg-slate-50 transition-colors">Quick
                                                    Assign</button>
                                                <a href="javascript:void(0)"
                                                    class="w-full py-2 border border-red-100 rounded-lg text-sm font-medium text-red-500 hover:bg-red-50 text-center transition-colors block"
                                                    onclick="openConfirmModal('Delete Room', 'Are you sure you want to delete ${room.name}? This action cannot be undone.', '${pageContext.request.contextPath}/admin?action=delete_room&id=${room.id}')">Delete Room</a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>

                    </div>
                </main>

                <!-- Add Room Modal -->
                <div id="addRoomModal"
                    class="hidden fixed inset-0 bg-black/40 backdrop-blur-sm z-50 flex items-center justify-center p-4">
                    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md">
                        <div
                            class="flex items-center justify-between p-6 border-b border-border-color border-slate-200">
                            <div class="flex items-center gap-3">
                                <div
                                    class="size-10 rounded-lg bg-primary-light flex items-center justify-center text-primary">
                                    <span class="material-symbols-outlined">meeting_room</span>
                                </div>
                                <h2 class="text-lg font-bold font-serif text-slate-900">Add New Room</h2>
                            </div>
                            <button onclick="closeRoomModal()"
                                class="p-2 rounded-lg hover:bg-gray-100 text-slate-400"><span
                                    class="material-symbols-outlined">close</span></button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin"
                              class="p-6 space-y-4" id="roomForm" onsubmit="return validateRoomForm()">
                            <input type="hidden" name="action" value="add_room" />
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-1.5">Room Name * <span class="text-gray-400 font-normal text-xs">(must be unique)</span></label>
                                <input type="text" name="name" id="rName" placeholder="e.g. Room 101, Lab 201"
                                    class="w-full px-3 py-2.5 border border-slate-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-slate-900 placeholder:text-slate-400 bg-slate-50" />
                                <p id="rNameErr" class="text-red-500 text-xs mt-1 hidden"></p>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-1.5">Capacity * <span class="text-gray-400 font-normal text-xs">(1–1000)</span></label>
                                <input type="number" name="capacity" id="rCap" placeholder="e.g. 60" min="1" max="1000"
                                    class="w-full px-3 py-2.5 border border-slate-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-slate-900 placeholder:text-slate-400 bg-slate-50" />
                                <p id="rCapErr" class="text-red-500 text-xs mt-1 hidden"></p>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-slate-700 mb-1.5">Room Type *</label>
                                <select name="type" id="rType"
                                    class="w-full px-3 py-2.5 border border-slate-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all text-slate-900 bg-slate-50">
                                    <option value="">Select room type</option>
                                    <option value="CLASSROOM">Classroom</option>
                                    <option value="LAB">Laboratory</option>
                                </select>
                                <p id="rTypeErr" class="text-red-500 text-xs mt-1 hidden"></p>
                            </div>
                            <div class="flex justify-end gap-3 pt-4">
                                <button type="button" onclick="closeRoomModal()"
                                    class="px-5 py-2.5 border border-slate-200 rounded-lg text-sm font-medium text-slate-600 hover:bg-slate-50 transition-colors">Cancel</button>
                                <button type="submit"
                                    class="px-5 py-2.5 bg-primary text-white rounded-lg text-sm font-medium hover:bg-primary/90 transition-colors">Create Room</button>
                            </div>
                        </form>
                    </div>
                </div>

        </div>
    </body>

    <script>
        function showRErr(id, msg){ const e=document.getElementById(id); e.textContent=msg; e.classList.remove('hidden'); }
        function clearRErr(id){ const e=document.getElementById(id); e.textContent=''; e.classList.add('hidden'); }
        function closeRoomModal(){
            document.getElementById('addRoomModal').classList.add('hidden');
            ['rNameErr','rCapErr','rTypeErr'].forEach(clearRErr);
            document.getElementById('roomForm').reset();
        }
        function validateRoomForm(){
            let valid = true;
            const name = document.getElementById('rName').value.trim();
            const cap  = parseInt(document.getElementById('rCap').value, 10);
            const type = document.getElementById('rType').value;
            ['rNameErr','rCapErr','rTypeErr'].forEach(clearRErr);

            if(!name){ showRErr('rNameErr','Room name is required.'); valid=false; }
            else if(!/^[A-Za-z0-9 \-]{2,50}$/.test(name)){ showRErr('rNameErr','Room name must contain only letters, numbers, spaces, dashes (min 2 chars).'); valid=false; }

            if(isNaN(cap)||cap<1||cap>1000){ showRErr('rCapErr','Capacity must be a number between 1 and 1000.'); valid=false; }

            if(!type){ showRErr('rTypeErr','Please select a room type.'); valid=false; }

            return valid;
        }
        document.getElementById('rName').addEventListener('input', function(){ if(/^[A-Za-z0-9 \-]{2,50}$/.test(this.value.trim())) clearRErr('rNameErr'); });
        document.getElementById('rCap').addEventListener('input', function(){ const v=parseInt(this.value,10); if(v>=1&&v<=1000) clearRErr('rCapErr'); });
        document.getElementById('rType').addEventListener('change', function(){ if(this.value) clearRErr('rTypeErr'); });
        document.addEventListener('keydown', function(e){ if(e.key==='Escape') closeRoomModal(); });

        function openConfirmModal(title, text, url) {
            document.getElementById('confirmModalTitle').textContent = title;
            document.getElementById('confirmModalText').textContent = text;
            document.getElementById('confirmModalLink').href = url;
            document.getElementById('confirmModal').classList.remove('hidden');
        }
        function closeConfirmModal() {
            document.getElementById('confirmModal').classList.add('hidden');
        }
    </script>
    
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
    </html>