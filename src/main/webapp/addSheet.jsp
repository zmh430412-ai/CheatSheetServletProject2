<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.cheatsheet.model.Category" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Cheat Sheet - CheatHub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');

        :root {
            --sidebar-bg: #ffffff;
            --main-bg: #f3f4f6;
            --accent: #2563eb;
            --text-dark: #111827;
            --text-gray: #6b7280;
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
            border-right: 1px solid #e5e7eb;
            position: fixed;
            height: 100vh;
            padding: 20px 0;
            z-index: 1000;
        }

        #content {
            flex: 1;
            margin-left: 260px; /* Sidebar အကျယ်အတိုင်း နေရာချန်ခြင်း */
            padding: 40px;
            display: flex;
            justify-content: center; /* Form ကို အလယ်ပို့ရန် */
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

        /* --- Form Styles --- */
        .form-container { max-width: 700px; width: 100%; }

        .form-card {
            background: #ffffff;
            border-radius: 20px;
            border: 1px solid #e5e7eb;
            overflow: hidden;
        }

        .card-header {
            background: #ffffff !important;
            padding: 25px 30px;
            border-bottom: 1px solid #f3f4f6;
        }

        .brand-text { color: #2563eb; font-weight: 700; }

        .form-label {
            font-weight: 600;
            font-size: 0.85rem;
            color: #4b5563;
            margin-bottom: 8px;
        }

        .form-control, .form-select {
            border-radius: 10px;
            padding: 10px 15px;
            border: 1px solid #e5e7eb;
            background-color: #f9fafb;
        }

        .code-area {
            font-family: 'JetBrains Mono', monospace;
            background-color: #0f172a !important;
            color: #e2e8f0 !important;
        }

        .btn-submit {
            background: #2563eb;
            color: #fff;
            border: none;
            padding: 12px;
            border-radius: 12px;
            font-weight: 600;
            transition: 0.3s;
        }

        .btn-submit:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.3);
            color: #fff;
        }

        .btn-back {
            background: #f3f4f6;
            color: #4b5563;
            border-radius: 8px;
            padding: 8px 15px;
            text-decoration: none;
        }

        @media (max-width: 992px) {
            #sidebar { display: none; }
            #content { margin-left: 0; padding: 20px; }
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
                <li class="active"><a href="addSheet"><i class="bi bi-file-earmark-plus"></i> Add New Sheet</a></li>
                <li><a href="manageSheets"><i class="bi bi-gear-wide-connected"></i> Manage All Sheets</a></li>
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
        <div class="form-container">
            <div class="form-card shadow-sm mt-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <div>
                        <span class="brand-text text-uppercase small d-block mb-1">Admin Panel</span>
                        <h4 class="fw-bold mb-0 text-dark">Add New Cheat Sheet</h4>
                    </div>
                    <a href="categories" class="btn-back fw-semibold">
                        <i class="bi bi-arrow-left me-1"></i> Back
                    </a>
                </div>
                
                <div class="card-body p-4 p-md-5">
                    <form action="addSheet" method="post">
                        <div class="mb-4">
                            <label class="form-label">Category</label>
                            <select name="categoryId" class="form-select shadow-none" required>
                                <option value="" selected disabled>Select the programming language</option>
                                <% 
                                    List<Category> catList = (List<Category>) request.getAttribute("catList");
                                    if (catList != null) {
                                        for (Category cat : catList) {
                                %>
                                    <option value="<%= cat.getId() %>"><%= cat.getName() %></option>
                                <% 
                                        }
                                    } 
                                %>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Sheet Title</label>
                            <input type="text" name="title" class="form-control shadow-none" placeholder="e.g. Array Methods, Loops, etc." required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Brief Description</label>
                            <textarea name="description" class="form-control shadow-none" rows="2" placeholder="Tell users what this sheet is about..."></textarea>
                        </div>

                        <div class="mb-4">
                            <label class="form-label">Code Snippets / Content</label>
                            <textarea name="codeContent" class="form-control code-area shadow-none" rows="8" placeholder="// Write your code or notes here..."></textarea>
                        </div>
                        
                        <div class="mt-4">
                            <button type="submit" class="btn btn-submit w-100 fw-bold shadow-sm">
                                <i class="bi bi-cloud-arrow-up-fill me-2"></i> Publish to CheatHub
                            </button>
                        </div>
                    </form>
                </div>
            </div>
            <p class="text-center mt-4 text-muted small">Make sure to review your code before saving.</p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>