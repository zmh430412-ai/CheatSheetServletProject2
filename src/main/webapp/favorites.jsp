<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>

<%
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Map<String, String>> favList = (List<Map<String, String>>) request.getAttribute("favList");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Favorite Sheets - CheatHub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&family=JetBrains+Mono:wght@400;500&display=swap');
        
        :root {
            --sidebar-bg: #ffffff;
            --main-bg: #f3f4f6;
            --accent: #2563eb;
            --text-dark: #111827;
            --text-gray: #6b7280;
            --border-color: #e5e7eb;
        }

        body { 
            background-color: var(--main-bg); 
            font-family: 'Plus Jakarta Sans', sans-serif; 
            margin: 0;
        }

        /* --- Layout Structure --- */
        .wrapper { display: flex; min-height: 100vh; }
        
        #sidebar {
            min-width: 260px;
            background: var(--sidebar-bg);
            border-right: 1px solid var(--border-color);
            position: fixed;
            height: 100vh;
            padding: 20px 0;
            z-index: 1000;
        }

        #content {
            flex: 1;
            margin-left: 260px; /* Sidebar နေရာချန်ရန် */
            padding: 0;
            width: 100%;
        }

        /* --- Sidebar Styles --- */
        .brand { padding: 10px 30px 30px; font-weight: 800; font-size: 1.4rem; color: var(--accent); }
        .sidebar-menu { list-style: none; padding: 0 15px; }
        .sidebar-menu li { margin-bottom: 5px; }
        .sidebar-menu a {
            display: flex;
            align-items: center;
            padding: 12px 15px;
            color: var(--text-gray);
            text-decoration: none;
            border-radius: 10px;
            font-weight: 500;
            transition: 0.2s;
        }
        .sidebar-menu a:hover, .sidebar-menu li.active a {
            background: #eff6ff;
            color: var(--accent);
        }
        .sidebar-menu a i { font-size: 1.2rem; margin-right: 12px; }

        /* --- Content Styles --- */
        .header-section { background: #ffffff; padding: 30px 40px; border-bottom: 1px solid var(--border-color); margin-bottom: 30px; }
        .sheet-card { background: #ffffff; border-radius: 16px; border: 1px solid var(--border-color); position: relative; }
        .sheet-title { color: var(--text-dark); font-weight: 700; display: flex; align-items: center; }
        .sheet-title::before { content: "#"; color: var(--accent); margin-right: 10px; }
        
        .category-badge { background: #dbeafe; color: #1e40af; padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; text-transform: uppercase; margin-bottom: 10px; display: inline-block; }

        /* --- Code Box Styles --- */
        .code-container { background-color: #0f172a; border-radius: 12px; overflow: hidden; border: 1px solid #1e293b; }
        .code-header { background: #1e293b; padding: 10px 16px; display: flex; justify-content: space-between; align-items: center; }
        .dot { width: 10px; height: 10px; border-radius: 50%; display: inline-block; margin-right: 4px; }
        .dot-red { background: #ff5f56; } .dot-yellow { background: #ffbd2e; } .dot-green { background: #27c93f; }
        .code-box { padding: 20px; margin: 0; font-family: 'JetBrains Mono', monospace; font-size: 14px; color: #e2e8f0; overflow-x: auto; }
        .copy-btn { background: rgba(255, 255, 255, 0.1); border: 1px solid rgba(255, 255, 255, 0.2); color: #cbd5e1; font-size: 0.75rem; border-radius: 6px; }

        .fav-btn-active { color: #ef4444; font-size: 1.5rem; text-decoration: none; transition: transform 0.2s; }
        .fav-btn-active:hover { transform: scale(1.2); }

        @media (max-width: 992px) {
            #sidebar { display: none; }
            #content { margin-left: 0; }
        }
    </style>
</head>
<body>

<div class="wrapper">
    <!-- Sidebar အပိုင်း -->
    <nav id="sidebar">
        <div class="brand">
            <i class="bi bi-rocket-takeoff-fill"></i> CheatHub
        </div>
        <ul class="sidebar-menu">
            <li><a href="categories"><i class="bi bi-columns-gap"></i> Dashboard</a></li>
            
            <% 
                String userRole = (String) session.getAttribute("userRole");
                if ("admin".equals(userRole)) { 
            %>
                <li class="small text-uppercase text-muted fw-bold px-3 mt-4 mb-2" style="font-size: 0.7rem;">Admin Management</li>
                <li><a href="addSheet"><i class="bi bi-file-earmark-plus"></i> Add New Sheet</a></li>
                <li><a href="manageSheets"><i class="bi bi-gear-wide-connected"></i> Manage All Sheets</a></li>
                <li><a href="manageUsers"><i class="bi bi-people"></i> Manage Users</a></li>
            <% } else { %>
                <li class="small text-uppercase text-muted fw-bold px-3 mt-4 mb-2" style="font-size: 0.7rem;">My Workspace</li>
                <li><a href="myNotes"><i class="bi bi-journal-text"></i> My Saved Notes</a></li>
                <li class="active"><a href="displayFavorites"><i class="bi bi-star"></i> Favorite Sheets</a></li>
            <% } %>

            <li class="small text-uppercase text-muted fw-bold px-3 mt-4 mb-2" style="font-size: 0.7rem;">Account</li>
            <li><a href="${pageContext.request.contextPath}/profile.jsp"><i class="bi bi-person"></i> My Profile</a></li>
            <li><a href="logout" class="text-danger"><i class="bi bi-power"></i> Logout</a></li>
        </ul>
    </nav>

    <!-- Main Content အပိုင်း -->
    <div id="content">
        <div class="header-section shadow-sm">
            <div class="container-fluid">
                <div class="d-flex align-items-center gap-3">
                    <h2 class="fw-bold mb-0"><i class="bi bi-heart-fill text-danger me-2"></i> My Favorites</h2>
                </div>
            </div>
        </div>

        <div class="container-fluid px-4 mb-5">
            <div class="row">
                <div class="col-xl-10 col-lg-12">
                    <%
                        if (favList != null && !favList.isEmpty()) {
                            for (Map<String, String> fav : favList) {
                    %>
                        <div class="card sheet-card mb-5 p-4 shadow-sm border-0">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div class="flex-grow-1">
                                    <span class="category-badge"><%= fav.get("category") %></span>
                                    <h4 class="sheet-title m-0"><%= fav.get("title") %></h4>
                                    <p class="text-muted mt-2 ms-4"><%= fav.get("description") != null ? fav.get("description") : "" %></p>
                                </div>
                                
                                <a href="toggleFavorite?sheetId=<%= fav.get("sheet_id") %>" class="fav-btn-active" title="Remove from Favorites">
                                    <i class="bi bi-heart-fill"></i>
                                </a>
                            </div>
                            
                            <div class="code-container shadow-sm">
                                <div class="code-header">
                                    <div class="code-dots">
                                        <div class="dot dot-red"></div>
                                        <div class="dot dot-yellow"></div>
                                        <div class="dot dot-green"></div>
                                    </div>
                                    <button class="btn btn-sm copy-btn" onclick="copyToClipboard(this)">
                                        <i class="bi bi-clipboard me-1"></i> Copy
                                    </button>
                                </div>
                                
                                <pre class="code-box"><code><% 
                                    String code = fav.get("code_content");
                                    if (code != null) {
                                        out.print(code.replace("<", "&lt;").replace(">", "&gt;"));
                                    } else {
                                        out.print("// No code content available");
                                    }
                                %></code></pre>
                            </div>
                        </div>
                    <%
                            }
                        } else {
                    %>
                        <div class="text-center p-5 bg-white rounded-4 border">
                            <i class="bi bi-star display-1 text-muted d-block mb-3"></i>
                            <h4 class="fw-bold">No favorites found.</h4>
                            <p class="text-muted">You haven't saved any cheat sheets yet.</p>
                            <a href="categories" class="btn btn-primary mt-3 px-4 rounded-pill fw-bold">Browse Cheat Sheets</a>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function copyToClipboard(btn) {
    const code = btn.closest('.code-container').querySelector('code').innerText;
    navigator.clipboard.writeText(code).then(() => {
        const originalHTML = btn.innerHTML;
        btn.innerHTML = '<i class="bi bi-check2"></i> Copied!';
        setTimeout(() => { btn.innerHTML = originalHTML; }, 2000);
    });
}
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>