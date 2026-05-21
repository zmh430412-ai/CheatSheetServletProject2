<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, com.cheatsheet.model.Category, com.cheatsheet.dao.CommentDAO" %>
<%-- ★ Notification အတွက် လိုအပ်သော Class များကို Import လုပ်ပါသည် --%>
<%@ page import="com.cheatsheet.dao.NotificationDAO, com.cheatsheet.model.Notification" %>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%
    // Servlet ကပို့လိုက်တဲ့ Map ကိုယူမယ်
    Map<String, Integer> statsMap = (Map<String, Integer>) request.getAttribute("stats");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - CheatHub</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap');

        :root {
            --sidebar-bg: #ffffff;
            --main-bg: #f8fafc;
            --accent: #2563eb;
            --text-dark: #0f172a;
            --text-gray: #64748b;
        }

        body { 
            background-color: var(--main-bg); 
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: var(--text-dark);
        }

        .wrapper { display: flex; min-height: 100vh; }
        
        #sidebar {
            min-width: 260px;
            background: var(--sidebar-bg);
            border-right: 1px solid #e2e8f0;
            position: fixed;
            height: 100vh;
            padding: 20px 0;
            z-index: 1000;
        }

        #content {
            flex: 1;
            margin-left: 260px;
            padding: 40px;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .brand { padding: 10px 30px 30px; font-weight: 800; font-size: 1.5rem; color: var(--accent); }
        .sidebar-menu { list-style: none; padding: 0 15px; }
        .sidebar-menu a {
            display: flex; align-items: center; padding: 12px 15px;
            color: var(--text-gray); text-decoration: none; border-radius: 12px;
            font-weight: 600; transition: 0.2s;
        }
        .sidebar-menu a:hover, .sidebar-menu li.active a { background: #eff6ff; color: var(--accent); }
        .sidebar-menu a i { font-size: 1.2rem; margin-right: 12px; }

        /* --- Updated Card & Admin Actions --- */
        .cat-card-wrapper { 
            position: relative; 
            height: 100%; 
        }

        .cat-card {
            background: #fff; border-radius: 20px; padding: 40px 20px; border: 1px solid #f1f5f9;
            text-align: center; text-decoration: none; color: inherit;
            transition: 0.3s ease; height: 100%; display: flex; flex-direction: column; 
            align-items: center; justify-content: center;
            position: relative;
            z-index: 1;
        }
        .cat-card:hover { transform: translateY(-5px); box-shadow: 0 15px 35px rgba(0,0,0,0.06); border-color: var(--accent); }

        .admin-actions { 
            position: absolute; 
            top: 15px; 
            right: 15px; 
            display: flex; 
            gap: 6px; 
            z-index: 10; 
            opacity: 0;
            transition: 0.3s ease;
        }

        .cat-card-wrapper:hover .admin-actions {
            opacity: 1;
        }

        .action-btn { 
            width: 34px; height: 34px; border-radius: 50%; display: flex; align-items: center; justify-content: center; 
            background: white; border: 1px solid #e2e8f0; box-shadow: 0 4px 6px rgba(0,0,0,0.05); cursor: pointer;
            transition: 0.2s;
        }
        .action-btn:hover { background: #f8fafc; transform: scale(1.1); border-color: var(--accent); }

        .cat-icon-circle {
            width: 65px; height: 65px; background: #f1f5f9; border-radius: 18px;
            display: flex; align-items: center; justify-content: center;
            margin-bottom: 15px; font-size: 2rem; color: var(--accent);
        }

        .hero-banner {
            background: linear-gradient(135deg, #1e293b 0%, #2563eb 100%);
            border-radius: 24px; padding: 50px; color: white; margin-bottom: 40px;
            position: relative; <%-- Noti Bell အနေအထား ချိန်ညှိရန် --%>
        }

        .search-bar { background: #fff; border: 1px solid #e2e8f0; border-radius: 15px; }

        /* --- Footer Styles --- */
        .main-footer {
            margin-top: auto;
            padding-top: 60px;
            padding-bottom: 30px;
            border-top: 1px solid #e2e8f0;
        }
        .footer-title { font-size: 0.85rem; font-weight: 800; color: var(--text-dark); letter-spacing: 1.2px; text-transform: uppercase; margin-bottom: 20px; }
        .footer-text { color: var(--text-gray); font-size: 0.9rem; line-height: 1.6; }
        .footer-links { list-style: none; padding: 0; }
        .footer-links a { color: var(--text-gray); text-decoration: none; font-size: 0.9rem; transition: 0.2s; display: block; margin-bottom: 10px; cursor: pointer; }
        .footer-links a:hover { color: var(--accent); transform: translateX(5px); }
        
        .social-btn {
            width: 35px; height: 35px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center;
            border: 1px solid #e2e8f0; color: var(--text-gray); margin-right: 8px; transition: 0.3s;
        }
        .social-btn:hover { background: var(--accent); color: white; transform: translateY(-3px); }

        .modal-backdrop { z-index: 1040 !important; }
        .modal { z-index: 1050 !important; }
        
        .stat-card {
            background: #fff;
            border-radius: 20px;
            padding: 25px;
            border: 1px solid #f1f5f9;
            transition: 0.3s ease;
            display: flex;
            align-items: center;
            height: 100%;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        }
        .stat-icon-box {
            width: 60px;
            height: 60px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin-right: 20px;
        }
        .bg-soft-primary { background: #eff6ff; color: #2563eb; }
        .bg-soft-success { background: #f0fdf4; color: #22c55e; }
        .bg-soft-warning { background: #fffbeb; color: #f59e0b; }

        .stat-label { color: #64748b; font-size: 0.85rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; }
        .stat-value { color: #0f172a; font-size: 1.6rem; font-weight: 800; line-height: 1; }
        
        @media (max-width: 992px) { #sidebar { display: none; } #content { margin-left: 0; padding: 20px; } }
    </style>
</head>
<body>

<div class="wrapper">
    <nav id="sidebar">
        <div class="brand"><i class="bi bi-rocket-takeoff-fill"></i> CheatHub</div>
        <ul class="sidebar-menu">
            <li class="active"><a href="categories"><i class="bi bi-columns-gap"></i> Dashboard</a></li>
            <% 
                String userRole = (String) session.getAttribute("userRole");
                @SuppressWarnings("unchecked")
                List<Category> list = (List<Category>) request.getAttribute("catList");

                if ("admin".equals(userRole)) { 
            %>
                <li class="small text-uppercase text-muted fw-bold px-3 mt-4 mb-2" style="font-size: 0.7rem;">Admin Management</li>
                <li><a href="addSheet"><i class="bi bi-file-earmark-plus"></i> Add New Sheet</a></li>
                <li><a href="manageSheets"><i class="bi bi-gear-wide-connected"></i> Manage All Sheets</a></li>
                <li><a href="manageUsers"><i class="bi bi-people"></i> Manage Users</a></li>
            <% } else { %>
                <li class="small text-uppercase text-muted fw-bold px-3 mt-4 mb-2" style="font-size: 0.7rem;">My Workspace</li>
                <li><a href="myNotes"><i class="bi bi-journal-text"></i> My Saved Notes</a></li>
                <li><a href="displayFavorites"><i class="bi bi-star-fill"></i> Favorite Sheets</a></li>
            <% } %>
            <li class="small text-uppercase text-muted fw-bold px-3 mt-4 mb-2" style="font-size: 0.7rem;">Account</li>
            <li><a href="profile"><i class="bi bi-person-circle"></i> My Profile</a></li>
            <li><a href="logout" class="text-danger"><i class="bi bi-power"></i> Logout</a></li>
        </ul>
    </nav>

    <div id="content">
        <%-- Header Logic --%>
        <% if ("admin".equals(userRole)) { 
            CommentDAO commentDao = new CommentDAO();
            int unreadNotiCount = commentDao.getUnreadNotificationCount();
        %>
            <div class="mb-5 mt-2 position-relative text-center">
                <div class="position-absolute top-0 end-0 mt-2">
                    <a href="manageComments" class="btn btn-light rounded-pill p-2 shadow-sm position-relative" style="width: 45px; height: 45px; display: inline-flex; align-items: center; justify-content: center;">
                        <i class="bi bi-bell-fill fs-5 text-secondary"></i>
                        <% if (unreadNotiCount > 0) { %>
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger border border-2 border-white" style="font-size: 0.7rem;">
                                <%= unreadNotiCount %>
                            </span>
                        <% } %>
                    </a>
                </div>

                <h1 class="fw-bold display-5 mb-2">Admin <span class="text-primary">Dashboard</span></h1>
                <div class="search-bar d-flex align-items-center mx-auto shadow-sm px-4 mt-4" style="max-width: 600px; height: 55px;">
                    <i class="bi bi-search text-muted me-2"></i>
                    <input type="text" id="searchInput" class="form-control border-0 shadow-none bg-transparent" placeholder="Search categories...">
                </div>
            </div>
            
            <div class="row g-4 mb-5">
                <div class="col-md-4">
                    <div class="stat-card shadow-sm">
                        <div class="stat-icon-box bg-soft-primary"><i class="bi bi-grid-fill"></i></div>
                        <div>
                            <p class="stat-label mb-1">Total Categories</p>
                            <h4 class="stat-value mb-0"><%= (list != null) ? list.size() : 0 %></h4>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card shadow-sm">
                        <div class="stat-icon-box bg-soft-success"><i class="bi bi-file-earmark-code-fill"></i></div>
                        <div>
                            <p class="stat-label mb-1">Total Sheets</p>
                            <h4 class="stat-value mb-0"><%= (statsMap != null && statsMap.get("sheetCount") != null) ? statsMap.get("sheetCount") : 0 %></h4>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card shadow-sm">
                        <div class="stat-icon-box bg-soft-warning"><i class="bi bi-people-fill"></i></div>
                        <div>
                            <p class="stat-label mb-1">Active Users</p>
                            <h4 class="stat-value mb-0"><%= (statsMap != null && statsMap.get("userCount") != null) ? statsMap.get("userCount") : 0 %></h4>
                        </div>
                    </div>
                </div>
            </div>
            
        <% } else { 
            // ★ [USER SIDE NOTIFICATION LOGIC]
            List<Notification> userNotiList = null;
            if (session.getAttribute("userId") != null) {
                int currentUserId = (Integer) session.getAttribute("userId");
                NotificationDAO notiDao = new NotificationDAO();
                userNotiList = notiDao.getUnreadNotificationsByUser(currentUserId);
            }
        %>
            <div class="hero-banner d-flex align-items-center justify-content-between">
                <div>
                    <h1 class="fw-bold display-6 mb-2">Master Your Craft!</h1>
                    <p class="opacity-75 fs-5">Welcome back, <%= session.getAttribute("user") %>.</p>
                    <div class="search-bar d-flex align-items-center mt-4 px-4 bg-white shadow-none" style="max-width: 500px; height: 55px;">
                        <i class="bi bi-search text-muted me-2"></i>
                        <input type="text" id="searchInput" class="form-control border-0 shadow-none bg-transparent" placeholder="Quick search...">
                    </div>
                </div>
                
                <%-- ★ [USER NOTIFICATION BELL DROPDOWN IN BANNER] --%>
                <div class="position-absolute top-0 end-0 mt-4 me-4 d-flex align-items-center">
                    <div class="dropdown">
                        <button class="btn btn-light rounded-circle shadow p-0 d-flex align-items-center justify-content-center position-relative" 
                                type="button" id="userBellDropdown" data-bs-toggle="dropdown" aria-expanded="false" 
                                style="width: 45px; height: 45px; border: none;">
                            <i class="bi bi-bell-fill fs-5 text-dark"></i>
                            <% if (userNotiList != null && !userNotiList.isEmpty()) { %>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger border border-2 border-white" style="font-size: 0.65rem; padding: 4px 6px;">
                                    <%= userNotiList.size() %>
                                </span>
                            <% } %>
                        </button>
                        
                        <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 mt-2 py-0 overflow-hidden" 
                            aria-labelledby="userBellDropdown" style="min-width: 320px; max-height: 380px; overflow-y: auto; border-radius: 16px; z-index: 2000;">
                            <div class="px-3 py-3 bg-light border-bottom fw-bold text-dark d-flex justify-content-between align-items-center">
                                <span><i class="bi bi-bell-pulse text-primary me-2"></i>Notifications</span>
                                <% if (userNotiList != null && !userNotiList.isEmpty()) { %>
                                    <span class="badge bg-danger rounded-pill fw-semibold" style="font-size: 0.7rem;"><%= userNotiList.size() %> New</span>
                                <% } %>
                            </div>
                            
                            <% 
                                if (userNotiList != null && !userNotiList.isEmpty()) { 
                                    for (Notification n : userNotiList) {
                            %>
                                <li>
                                    <a class="dropdown-item px-3 py-2.5 border-bottom text-wrap" href="viewSheet?sheetId=<%= n.getSheetId() %>&id=1" style="font-size: 0.85rem;">
                                        <div class="text-dark fw-semibold mb-1" style="line-height: 1.4;"><%= n.getMessage() %></div>
                                        <small class="text-muted d-flex align-items-center gap-1" style="font-size: 0.7rem;">
                                            <i class="bi bi-clock"></i> Reply Received
                                        </small>
                                    </a>
                                </li>
                            <% 
                                    }
                                } else { 
                            %>
                                <div class="text-center py-4 px-3 text-muted">
                                    <i class="bi bi-bell-slash text-black-50 d-block mb-2" style="font-size: 2rem;"></i>
                                    <p class="m-0 small">No updates on your comments.</p>
                                </div>
                            <% } %>
                        </ul>
                    </div>
                </div>
                
                <div class="d-none d-xl-block" style="margin-right: 40px;"><i class="bi bi-terminal-plus" style="font-size: 8rem; opacity: 0.2;"></i></div>
            </div>
        <% } %>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h5 class="fw-bold mb-0">Explore Categories</h5>
            <% if ("admin".equals(userRole)) { %>
                <button type="button" class="btn btn-primary rounded-pill px-4 fw-bold" data-bs-toggle="modal" data-bs-target="#addCatModal">
                    <i class="bi bi-plus-lg me-1"></i> Add Category
                </button>
            <% } %>
        </div>

        <div class="row g-4 mb-5" id="categoryGrid">
            <%
                if (list != null && !list.isEmpty()) {
                    for (Category cat : list) {
                        String icon = "bi-code-square"; 
                        String name = cat.getName().toLowerCase();
                        if(name.contains("python")) icon = "bi-filetype-py";
                        else if(name.contains("sql")) icon = "bi-database-fill";
                        else if(name.contains("java")) icon = "bi-cup-hot-fill";
                        else if(name.contains("php")) icon = "bi-filetype-php";
            %>
                <div class="col-6 col-md-4 col-xl-3 category-item">
                    <div class="cat-card-wrapper">
                        <% if ("admin".equals(userRole)) { %>
                            <div class="admin-actions">
                                <button type="button" class="action-btn border-0 shadow-sm" data-bs-toggle="modal" data-bs-target="#editCatModal" onclick="setEditData('<%= cat.getId() %>', '<%= cat.getName() %>')">
                                    <i class="bi bi-pencil-fill text-primary"></i>
                                </button>
                                <a href="deleteCategory?id=<%= cat.getId() %>" class="action-btn text-decoration-none border-0 shadow-sm" onclick="return confirm('Are you sure?')">
                                    <i class="bi bi-trash3-fill text-danger"></i>
                                </a>
                            </div>
                        <% } %>
                        <a href="viewSheet?id=<%= cat.getId() %>&name=<%= cat.getName() %>" class="cat-card shadow-sm">
                            <div class="cat-icon-circle"><i class="bi <%= icon %>"></i></div>
                            <h6 class="text-dark text-uppercase fw-bold mb-1"><%= cat.getName() %></h6>
                            <div class="small text-muted">View Sheets <i class="bi bi-arrow-right ms-1"></i></div>
                        </a>
                    </div>
                </div>
            <% } } %>
        </div>

        <%-- Footer: Only show if NOT admin --%>
        <% if (!"admin".equals(userRole)) { %>
        <footer class="main-footer">
            <div class="row g-4">
                <div class="col-md-5">
                    <h6 class="footer-title">About CheatHub</h6>
                    <p class="footer-text">
                        A dedicated space for developers to access high-quality technical cheat sheets. 
                        Simplify your workflow and master your programming skills.
                    </p>
                    <div class="mt-3">
                        <a href="#" class="social-btn"><i class="bi bi-github"></i></a>
                        <a href="#" class="social-btn"><i class="bi bi-linkedin"></i></a>
                        <a href="#" class="social-btn"><i class="bi bi-globe"></i></a>
                    </div>
                </div>
                <div class="col-md-3 ms-auto">
                    <h6 class="footer-title">Support</h6>
                    <ul class="footer-links">
                        <li><a data-bs-toggle="modal" data-bs-target="#privacyModal">Privacy Policy</a></li>
                        <li><a data-bs-toggle="modal" data-bs-target="#termsModal">Terms of Use</a></li>
                        <li><a data-bs-toggle="modal" data-bs-target="#helpModal">Help Center</a></li>
                    </ul>
                </div>
                <div class="col-md-3">
                    <h6 class="footer-title">Contact</h6>
                    <p class="footer-text mb-1">support@cheathub.com</p>
                    <p class="footer-text">Tech Hub, Digital City</p>
                </div>
            </div>
            <div class="text-center mt-5 pt-4 border-top">
                <p class="footer-text small mb-0">&copy; 2026 <strong>CheatHub</strong>. Handcrafted for Developers.</p>
            </div>
        </footer>
        <% } %>
    </div>
</div>

<%-- Existing Modals --%>
<div class="modal fade" id="addCatModal" tabindex="-1" aria-labelledby="addCatModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-4 shadow">
            <div class="modal-header border-0 pb-0">
                <h5 class="fw-bold" id="addCatModalLabel">New Category</h5>
                <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="addCategory" method="POST">
                <div class="modal-body py-4">
                    <input type="text" name="catName" class="form-control rounded-3 py-2 border-light bg-light shadow-none" placeholder="e.g. React" required>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="submit" class="btn btn-primary rounded-3 px-4">Add Category</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal fade" id="editCatModal" tabindex="-1" aria-labelledby="editCatModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-4 shadow">
            <div class="modal-header border-0 pb-0">
                <h5 class="fw-bold" id="editCatModalLabel">Edit Category</h5>
                <button type="button" class="btn-close shadow-none" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="editCategory" method="POST">
                <div class="modal-body py-4">
                    <input type="hidden" name="id" id="editCatId">
                    <input type="text" name="catName" id="editCatName" class="form-control rounded-3 py-2 border-light bg-light shadow-none" required>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="submit" class="btn btn-primary rounded-3 px-4">Update</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%-- Support Link Modals --%>
<div class="modal fade" id="privacyModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 rounded-4 shadow">
            <div class="modal-header border-0"><h5 class="fw-bold"><i class="bi bi-shield-lock-fill text-primary me-2"></i> Privacy Policy</h5><button type="button" class="btn-close shadow-none" data-bs-dismiss="modal"></button></div>
            <div class="modal-body py-4">
                <p class="text-muted">CheatHub ensures the security of your personal information.</p>
                <ul class="text-muted">
                    <li>We only collect and store your name and email address.</li>
                    <li>Your data will never be sold to any third-party organizations.</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="termsModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 rounded-4 shadow">
            <div class="modal-header border-0"><h5 class="fw-bold"><i class="bi bi-file-text-fill text-primary me-2"></i> Terms of Use</h5><button type="button" class="btn-close shadow-none" data-bs-dismiss="modal"></button></div>
            <div class="modal-body py-4">
                <p class="text-muted">By using CheatHub, you agree to the following terms:</p>
                <ul class="text-muted">
                    <li>The information provided must be used for educational purposes only.</li>
                    <li>Any use of this platform for illegal activities is strictly prohibited.</li>
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="helpModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content border-0 rounded-4 shadow">
            <div class="modal-header border-0"><h5 class="fw-bold"><i class="bi bi-question-circle-fill text-primary me-2"></i> Help Center</h5><button type="button" class="btn-close shadow-none" data-bs-dismiss="modal"></button></div>
            <div class="modal-body py-4">
                <h6 class="fw-bold">How to use?</h6>
                <p class="text-muted small">Simply click on a category to explore its related cheat sheets.</p>
                <h6 class="fw-bold">Contact Support</h6>
                <p class="text-muted small"><strong>support@cheathub.com</strong></p>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('searchInput').addEventListener('keyup', function() {
        let filter = this.value.toLowerCase();
        let items = document.querySelectorAll('.category-item');
        items.forEach(item => {
            let title = item.querySelector('h6').innerText.toLowerCase();
            item.style.display = title.includes(filter) ? "" : "none";
        });
    });

    function setEditData(id, name) {
        document.getElementById('editCatId').value = id;
        document.getElementById('editCatName').value = name;
    }
</script>
</body>
</html>