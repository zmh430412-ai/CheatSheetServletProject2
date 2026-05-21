<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.cheatsheet.model.Sheet" %>

<%
    String userRole = (String) session.getAttribute("userRole");
    if (session.getAttribute("user") == null || !"admin".equals(userRole)) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    List<Sheet> allSheets = (List<Sheet>) request.getAttribute("allSheets");
    int noOfPages = (int) request.getAttribute("noOfPages");
    int currentPage = (int) request.getAttribute("currentPage");
    int recordsPerPage = (int) request.getAttribute("recordsPerPage");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage All Sheets - CheatHub Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&display=swap');
        
        :root {
            --sidebar-bg: #ffffff;
            --main-bg: #f8fafc;
            --accent: #2563eb;
            --text-dark: #1e293b;
            --text-gray: #64748b;
            --border-color: #e2e8f0;
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
        .manage-header { background: #ffffff; padding: 30px 40px; border-bottom: 1px solid var(--border-color); margin-bottom: 30px; }
        .table-container { background: #ffffff; border-radius: 15px; border: 1px solid var(--border-color); overflow: hidden; margin: 0 40px; }
        .category-pill { background: #e0f2fe; color: #0369a1; padding: 4px 10px; border-radius: 6px; font-size: 0.8rem; font-weight: 600; }
        
        .action-btn { width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; border-radius: 8px; transition: 0.2s; text-decoration: none; }
        .btn-edit { background: #eff6ff; color: #2563eb; }
        .btn-delete { background: #fef2f2; color: #ef4444; }
        
        .pagination .page-link { color: var(--accent); border-radius: 8px; margin: 0 3px; border: 1px solid var(--border-color); }
        .pagination .active .page-link { background-color: var(--accent); border-color: var(--accent); color: white; }

        @media (max-width: 992px) {
            #sidebar { display: none; }
            #content { margin-left: 0; }
            .manage-header, .table-container { margin-left: 15px; margin-right: 15px; padding: 20px; }
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
            
            <% if ("admin".equals(userRole)) { %>
                <li class="small text-uppercase text-muted fw-bold px-3 mt-4 mb-2" style="font-size: 0.7rem;">Admin Management</li>
                <li><a href="addSheet"><i class="bi bi-file-earmark-plus"></i> Add New Sheet</a></li>
                <li class="active"><a href="manageSheets"><i class="bi bi-gear-wide-connected"></i> Manage All Sheets</a></li>
                <li><a href="manageUsers"><i class="bi bi-people"></i> Manage Users</a></li>
            <% } else { %>
                <li class="small text-uppercase text-muted fw-bold px-3 mt-4 mb-2" style="font-size: 0.7rem;">My Workspace</li>
                <li><a href="myNotes"><i class="bi bi-journal-text"></i> My Saved Notes</a></li>
                <li><a href="displayFavorites"><i class="bi bi-star"></i> Favorite Sheets</a></li>
            <% } %>

            <li class="small text-uppercase text-muted fw-bold px-3 mt-4 mb-2" style="font-size: 0.7rem;">Account</li>
            <li><a href="${pageContext.request.contextPath}/profile.jsp"><i class="bi bi-person"></i> My Profile</a></li>
            <li><a href="logout" class="text-danger"><i class="bi bi-power"></i> Logout</a></li>
        </ul>
    </nav>

    <!-- Main Content အပိုင်း -->
    <div id="content">
        <div class="manage-header shadow-sm">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <a href="categories" class="text-decoration-none small text-muted"><i class="bi bi-arrow-left"></i> Back to Dashboard</a>
                    <h3 class="fw-bold mb-0 mt-2">Manage Cheat Sheets</h3>
                </div>
                <a href="addSheet" class="btn btn-primary rounded-3 px-4 fw-bold">
                    <i class="bi bi-plus-lg me-1"></i> Add New Sheet
                </a>
            </div>
        </div>

        <div class="table-container shadow-sm">
            <table class="table table-hover mb-0">
                <thead class="table-light">
                    <tr>
                        <th class="ps-4">No.</th>
                        <th>Title & Description</th>
                        <th>Category</th>
                        <th class="text-end pe-4">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if (allSheets != null && !allSheets.isEmpty()) {
                            int serialNo = (currentPage - 1) * recordsPerPage + 1;
                            for (Sheet sheet : allSheets) {
                    %>
                    <tr>
                        <td class="ps-4 text-muted">#<%= serialNo++ %></td>
                        <td>
                            <div class="fw-bold text-dark"><%= sheet.getTitle() %></div>
                            <div class="small text-muted text-truncate" style="max-width: 400px;"><%= sheet.getDescription() %></div>
                        </td>
                        <td><span class="category-pill"><%= sheet.getCategoryName() != null ? sheet.getCategoryName() : "General" %></span></td>
                        <td class="text-end pe-4">
                            <div class="d-flex justify-content-end gap-2">
                                <a href="editSheet?id=<%= sheet.getId() %>" class="action-btn btn-edit" title="Edit"><i class="bi bi-pencil-square"></i></a>
                                <a href="deleteSheet?id=<%= sheet.getId() %>" class="action-btn btn-delete" title="Delete" onclick="return confirm('Are you sure you want to delete this sheet?')"><i class="bi bi-trash"></i></a>
                            </div>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="4" class="text-center py-5 text-muted">No cheat sheets found.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- Pagination UI -->
        <% if (noOfPages > 1) { %>
        <nav aria-label="Page navigation" class="mt-4 pb-5">
            <ul class="pagination justify-content-center">
                <li class="page-item <%= currentPage == 1 ? "disabled" : "" %>">
                    <a class="page-link" href="manageSheets?page=<%= currentPage - 1 %>">Previous</a>
                </li>
                <% for (int i = 1; i <= noOfPages; i++) { %>
                    <li class="page-item <%= i == currentPage ? "active" : "" %>">
                        <a class="page-link" href="manageSheets?page=<%= i %>"><%= i %></a>
                    </li>
                <% } %>
                <li class="page-item <%= currentPage == noOfPages ? "disabled" : "" %>">
                    <a class="page-link" href="manageSheets?page=<%= currentPage + 1 %>">Next</a>
                </li>
            </ul>
        </nav>
        <% } %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>