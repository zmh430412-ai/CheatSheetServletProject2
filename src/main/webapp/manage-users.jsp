<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.cheatsheet.model.User" %>

<%
    // Admin Check
    String currentRole = (String) session.getAttribute("userRole");
    if (session.getAttribute("user") == null || !"admin".equals(currentRole)) {
        response.sendRedirect("categories");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - CheatHub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&display=swap');
        
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
            color: var(--text-dark);
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
            margin-left: 260px;
            padding: 40px;
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

        /* --- Table & Card Styles --- */
        .user-card { background: #ffffff; border-radius: 20px; border: 1px solid var(--border-color); overflow: hidden; }
        .badge-admin { background-color: #dcfce7; color: #15803d; font-weight: 600; padding: 5px 12px; border-radius: 8px; font-size: 0.75rem; }
        .badge-user { background-color: #f1f5f9; color: #475569; font-weight: 600; padding: 5px 12px; border-radius: 8px; font-size: 0.75rem; }
        
        @media (max-width: 992px) {
            #sidebar { display: none; }
            #content { margin-left: 0; padding: 20px; }
        }
    </style>
</head>
<body>

<div class="wrapper">
    <nav id="sidebar">
        <div class="brand">
            <i class="bi bi-rocket-takeoff-fill"></i> CheatHub
        </div>
        <ul class="sidebar-menu">
            <li><a href="categories"><i class="bi bi-columns-gap"></i> Dashboard</a></li>
            
            <% if ("admin".equals(currentRole)) { %>
                <li class="small text-uppercase text-muted fw-bold px-3 mt-4 mb-2" style="font-size: 0.7rem;">Admin Management</li>
                <li><a href="addSheet"><i class="bi bi-file-earmark-plus"></i> Add New Sheet</a></li>
                <li><a href="manageSheets"><i class="bi bi-gear-wide-connected"></i> Manage All Sheets</a></li>
                <li class="active"><a href="manageUsers"><i class="bi bi-people"></i> Manage Users</a></li>
            <% } %>

            <li class="small text-uppercase text-muted fw-bold px-3 mt-4 mb-2" style="font-size: 0.7rem;">Account</li>
            <li><a href="${pageContext.request.contextPath}/profile.jsp"><i class="bi bi-person"></i> My Profile</a></li>
            <li><a href="logout" class="text-danger"><i class="bi bi-power"></i> Logout</a></li>
        </ul>
    </nav>

    <div id="content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-1">User Directory</h2>
                <p class="text-muted small mb-0">Manage all system users and their access levels.</p>
            </div>
            <a href="categories" class="btn btn-outline-dark rounded-3 px-3 fw-bold">
                <i class="bi bi-arrow-left me-1"></i> Dashboard
            </a>
        </div>

        <div class="user-card shadow-sm">
            <div class="table-responsive">
                <table class="table table-hover mb-0 align-middle">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4 py-3">Username</th>
                            <th class="py-3">Role</th>
                            <th class="text-end pe-4 py-3">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<User> userList = (List<User>) request.getAttribute("userList");
                            if (userList != null && !userList.isEmpty()) {
                                for (User u : userList) {
                        %>
                        <tr>
                            <td class="ps-4 fw-bold text-dark"><%= u.getUsername() %></td>
                            <td>
                                <% if ("admin".equals(u.getUserRole())) { %>
                                    <span class="badge-admin text-uppercase">Admin</span>
                                <% } else { %>
                                    <span class="badge-user text-uppercase">User</span>
                                <% } %>
                            </td>
                            <td class="text-end pe-4">
                                <% if (!"admin".equals(u.getUserRole())) { %>
                                    <a href="deleteUser?id=<%= u.getId() %>" 
                                       class="btn btn-sm btn-outline-danger border-0"
                                       title="Remove User"
                                       onclick="return confirm('Are you sure you want to delete this user?')">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                <% } else { %>
                                    <span class="text-muted small">Protected</span>
                                <% } %>
                            </td>
                        </tr>
                        <% 
                                }
                            } else {
                        %>
                        <%-- ★ Column အရေအတွက် လျော့သွားသဖြင့် colspan ကို 3 သို့ ပြောင်းလဲထားပါသည် --%>
                        <tr><td colspan="3" class="text-center py-5 text-muted">No users found in database.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>