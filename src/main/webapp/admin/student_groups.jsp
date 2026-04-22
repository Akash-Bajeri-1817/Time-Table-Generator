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
                                                <a href="javascript:void(0)"
                                                    onclick="openConfirmModal('Delete Group', 'Are you sure you want to delete ${g.name}? This action cannot be undone.', '${pageContext.request.contextPath}/admin?action=delete_group&id=${g.id}')"
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
                                <div class="px-6 py-4 border-b border-border-color flex items-center justify-between">
                                    <h2 class="font-semibold text-sm">Divisions from DB</h2>
                                    <div class="flex gap-2">
                                        <button onclick="document.getElementById('addBranchModal').classList.remove('hidden')"
                                            class="flex items-center gap-1 px-3 py-1.5 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 font-medium text-xs">
                                            <span class="material-symbols-outlined text-sm">add</span>Add Branch
                                        </button>
                                        <button onclick="document.getElementById('addDivisionModal').classList.remove('hidden')"
                                            class="flex items-center gap-1 px-3 py-1.5 bg-blue-50 text-blue-700 rounded-lg hover:bg-blue-100 font-medium text-xs">
                                            <span class="material-symbols-outlined text-sm">add</span>Add Division
                                        </button>
                                    </div>
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
                                            <th
                                                class="text-right px-6 py-3 text-xs font-semibold text-text-body uppercase">
                                                Action</th>
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
                                                <td class="px-6 py-3 text-right">
                                                    <a href="javascript:void(0)"
                                                        onclick="openConfirmModal('Delete Division', 'Are you sure you want to delete Division \`${d.name}\`? This action cannot be undone.', '${pageContext.request.contextPath}/admin?action=delete_division&id=${d.id}')"
                                                        class="text-red-400 hover:text-red-600 transition-colors inline-block p-1">
                                                        <span class="material-symbols-outlined text-lg">delete</span>
                                                    </a>
                                                </td>
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
                            <button onclick="closeGroupModal()"
                                class="p-2 rounded-lg hover:bg-gray-100"><span
                                    class="material-symbols-outlined">close</span></button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin"
                              class="p-6 space-y-4" id="groupForm" onsubmit="return validateGroupForm()">
                            <input type="hidden" name="action" value="add_group" />
                            <div>
                                <label class="block text-sm font-medium mb-1.5">Group Name * <span class="text-gray-400 font-normal text-xs">(must be unique)</span></label>
                                <input type="text" name="name" id="gName" placeholder="e.g. TY BSc CS - Div A"
                                    class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all" />
                                <p id="gNameErr" class="text-red-500 text-xs mt-1 hidden"></p>
                            </div>
                            <p class="text-xs text-text-body">This group can then be assigned to workloads and scheduled by the AI.</p>
                            <div class="flex justify-end gap-3 pt-2">
                                <button type="button" onclick="closeGroupModal()"
                                    class="px-5 py-2.5 border border-border-color rounded-lg text-sm font-medium text-text-body hover:bg-gray-50">Cancel</button>
                                <button type="submit"
                                    class="px-5 py-2.5 bg-primary text-white rounded-lg text-sm font-medium hover:bg-primary/90">Create Group</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Add Branch Modal -->
                <div id="addBranchModal"
                    class="hidden fixed inset-0 bg-black/40 backdrop-blur-sm z-50 flex items-center justify-center p-4">
                    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md">
                        <div class="flex items-center justify-between p-6 border-b border-border-color">
                            <div class="flex items-center gap-3">
                                <div class="size-10 rounded-lg bg-gray-100 flex items-center justify-center text-gray-700">
                                    <span class="material-symbols-outlined">account_balance</span>
                                </div>
                                <h2 class="text-lg font-bold font-serif">Add Branch</h2>
                            </div>
                            <button onclick="closeBranchModal()"
                                class="p-2 rounded-lg hover:bg-gray-100"><span class="material-symbols-outlined">close</span></button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin"
                              class="p-6 space-y-4" id="branchForm" onsubmit="return validateBranchForm()">
                            <input type="hidden" name="action" value="add_branch" />
                            <div>
                                <label class="block text-sm font-medium mb-1.5">Branch Code * <span class="text-gray-400 font-normal text-xs">(e.g. BSC, BBA)</span></label>
                                <input type="text" name="code" id="bCode" placeholder="e.g. BSC"
                                    class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all" />
                                <p id="bCodeErr" class="text-red-500 text-xs mt-1 hidden"></p>
                            </div>
                            <div>
                                <label class="block text-sm font-medium mb-1.5">Branch Name *</label>
                                <input type="text" name="name" id="bName" placeholder="e.g. Bachelor of Science"
                                    class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all" />
                                <p id="bNameErr" class="text-red-500 text-xs mt-1 hidden"></p>
                            </div>
                            <div>
                                <label class="block text-sm font-medium mb-1.5">Department Name *</label>
                                <input type="text" name="department_name" id="bDept" placeholder="e.g. Commerce"
                                    class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all" />
                                <p id="bDeptErr" class="text-red-500 text-xs mt-1 hidden"></p>
                            </div>
                            <div class="flex justify-end gap-3 pt-4 border-t border-border-color mt-4">
                                <button type="button" onclick="closeBranchModal()"
                                    class="px-5 py-2.5 border border-border-color rounded-lg text-sm font-medium text-text-body hover:bg-gray-50">Cancel</button>
                                <button type="submit" class="px-5 py-2.5 bg-gray-800 text-white rounded-lg text-sm font-medium hover:bg-gray-900">Create Branch</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Add Division Modal -->
                <div id="addDivisionModal"
                    class="hidden fixed inset-0 bg-black/40 backdrop-blur-sm z-50 flex items-center justify-center p-4">
                    <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md">
                        <div class="flex items-center justify-between p-6 border-b border-border-color">
                            <div class="flex items-center gap-3">
                                <div class="size-10 rounded-lg bg-blue-50 flex items-center justify-center text-blue-600">
                                    <span class="material-symbols-outlined">account_tree</span>
                                </div>
                                <h2 class="text-lg font-bold font-serif">Add Division</h2>
                            </div>
                            <button onclick="closeDivModal()"
                                class="p-2 rounded-lg hover:bg-gray-100"><span class="material-symbols-outlined">close</span></button>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/admin"
                              class="p-6 space-y-4" id="divForm" onsubmit="return validateDivForm()">
                            <input type="hidden" name="action" value="add_division" />
                            <div>
                                <label class="block text-sm font-medium mb-1.5">Division Name * <span class="text-gray-400 font-normal text-xs">(e.g. A, B, C)</span></label>
                                <input type="text" name="name" id="dName" placeholder="e.g. A"
                                    class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all" />
                                <p id="dNameErr" class="text-red-500 text-xs mt-1 hidden"></p>
                            </div>
                            <div>
                                <label class="block text-sm font-medium mb-1.5">Year Level *</label>
                                <select name="year" id="dYear" class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 bg-white focus:border-primary transition-all">
                                    <option value="FY">First Year (FY)</option>
                                    <option value="SY">Second Year (SY)</option>
                                    <option value="TY">Third Year (TY)</option>
                                </select>
                            </div>
                            <div>
                                <label class="block text-sm font-medium mb-1.5">Branch *</label>
                                <select name="branch_id" id="dBranch" class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 bg-white focus:border-primary transition-all">
                                    <option value="">Select Branch</option>
                                    <c:forEach var="b" items="${branches}">
                                        <option value="${b.id}">${b.name} (${b.code})</option>
                                    </c:forEach>
                                </select>
                                <p id="dBranchErr" class="text-red-500 text-xs mt-1 hidden"></p>
                            </div>
                            <div class="grid grid-cols-2 gap-4">
                                <div>
                                    <label class="block text-sm font-medium mb-1.5">Capacity <span class="text-gray-400 font-normal text-xs">(optional, 1–1000)</span></label>
                                    <input type="number" name="capacity" id="dCap" placeholder="e.g. 60"
                                        class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all" />
                                    <p id="dCapErr" class="text-red-500 text-xs mt-1 hidden"></p>
                                </div>
                                <div>
                                    <label class="block text-sm font-medium mb-1.5">Default Room</label>
                                    <input type="text" name="classroom" placeholder="e.g. Room 101"
                                        class="w-full px-3 py-2.5 border border-border-color rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-primary/20 focus:border-primary transition-all" />
                                </div>
                            </div>
                            <div class="flex justify-end gap-3 pt-4 border-t border-border-color mt-4">
                                <button type="button" onclick="closeDivModal()"
                                    class="px-5 py-2.5 border border-border-color rounded-lg text-sm font-medium text-text-body hover:bg-gray-50">Cancel</button>
                                <button type="submit" class="px-5 py-2.5 bg-blue-600 text-white rounded-lg text-sm font-medium hover:bg-blue-700">Create Division</button>
                            </div>
                        </form>
                    </div>
                </div>
            </body>

            <script>
                function showE(id,msg){ const e=document.getElementById(id); e.textContent=msg; e.classList.remove('hidden'); }
                function clearE(id){ const e=document.getElementById(id); e.textContent=''; e.classList.add('hidden'); }
                // Group
                function closeGroupModal(){ document.getElementById('addModal').classList.add('hidden'); clearE('gNameErr'); document.getElementById('groupForm').reset(); }
                function validateGroupForm(){
                    const name=document.getElementById('gName').value.trim();
                    clearE('gNameErr');
                    if(!name){ showE('gNameErr','Group name is required.'); return false; }
                    if(!/^[A-Za-z0-9 \-]{2,50}$/.test(name)){ showE('gNameErr','Group name must contain only letters, numbers, spaces, dashes (min 2 chars).'); return false; }
                    return true;
                }
                document.getElementById('gName').addEventListener('input',function(){ if(/^[A-Za-z0-9 \-]{2,50}$/.test(this.value.trim())) clearE('gNameErr'); });

                // Branch
                function closeBranchModal(){ document.getElementById('addBranchModal').classList.add('hidden'); ['bCodeErr','bNameErr','bDeptErr'].forEach(clearE); document.getElementById('branchForm').reset(); }
                function validateBranchForm(){
                    let v=true;
                    const code=document.getElementById('bCode').value.trim();
                    const name=document.getElementById('bName').value.trim();
                    const dept=document.getElementById('bDept').value.trim();
                    ['bCodeErr','bNameErr','bDeptErr'].forEach(clearE);
                    if(!code){ showE('bCodeErr','Branch code is required.'); v=false; }
                    else if(!/^[A-Za-z0-9]{2,10}$/.test(code)){ showE('bCodeErr','Code must be 2–10 alphanumeric chars.'); v=false; }
                    
                    if(!name){ showE('bNameErr','Branch name is required.'); v=false; }
                    else if(!/^[A-Za-z0-9. \-]{3,100}$/.test(name)){ showE('bNameErr','Name must contain only letters, numbers, spaces, dots, dashes (min 3 chars).'); v=false; }
                    
                    if(!dept){ showE('bDeptErr','Department name is required.'); v=false; }
                    else if(!/^[A-Za-z \-]{2,50}$/.test(dept)){ showE('bDeptErr','Department must contain only letters, spaces, dashes (min 2 chars).'); v=false; }
                    return v;
                }

                // Division
                function closeDivModal(){ document.getElementById('addDivisionModal').classList.add('hidden'); ['dNameErr','dBranchErr','dCapErr'].forEach(clearE); document.getElementById('divForm').reset(); }
                function validateDivForm(){
                    let v=true;
                    const name=document.getElementById('dName').value.trim();
                    const branch=document.getElementById('dBranch').value;
                    const capVal=document.getElementById('dCap').value;
                    ['dNameErr','dBranchErr','dCapErr'].forEach(clearE);
                    
                    if(!name){ showE('dNameErr','Division name is required.'); v=false; }
                    else if(!/^[A-Za-z0-9]{1,10}$/.test(name)){ showE('dNameErr','Division name must be alphanumeric (max 10 chars).'); v=false; }
                    
                    if(!branch){ showE('dBranchErr','Please select a branch.'); v=false; }
                    
                    if(capVal!==''){ const cap=parseInt(capVal,10); if(isNaN(cap)||cap<1||cap>1000){ showE('dCapErr','Capacity must be 1–1000.'); v=false; } }
                    return v;
                }
                document.getElementById('dBranch').addEventListener('change',function(){ if(this.value) clearE('dBranchErr'); });

                document.addEventListener('keydown',function(e){
                    if(e.key==='Escape'){ closeGroupModal(); closeBranchModal(); closeDivModal(); }
                });
                // Confirm Modal Logic
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