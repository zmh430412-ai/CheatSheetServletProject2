<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Workspace - CheatHub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');
        
        :root {
            --sidebar-bg: #ffffff;
            --main-bg: #f8fafc;
            --accent: #2563eb;
            --text-dark: #0f172a;
            --text-gray: #64748b;
            --border: #e2e8f0;
        }

        body { 
            background-color: var(--main-bg); 
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: var(--text-dark);
            margin: 0;
        }

        .wrapper { display: flex; min-height: 100vh; }
        
        /* --- Sidebar --- */
        #sidebar {
            min-width: 260px;
            background: var(--sidebar-bg);
            border-right: 1px solid var(--border);
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

        .brand { padding: 10px 30px 30px; font-weight: 800; font-size: 1.4rem; color: var(--accent); }
        .sidebar-menu { list-style: none; padding: 0 15px; }
        .sidebar-menu a {
            display: flex; align-items: center; padding: 12px 15px;
            color: var(--text-gray); text-decoration: none; border-radius: 10px;
            font-weight: 500; transition: 0.2s;
        }
        .sidebar-menu a:hover, .sidebar-menu li.active a { background: #eff6ff; color: var(--accent); }
        .sidebar-menu a i { font-size: 1.2rem; margin-right: 12px; }

        /* --- Professional Quick Input --- */
        .quick-note-box {
            background: #fff;
            border-radius: 16px;
            border: 1px solid var(--border);
            padding: 20px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.03);
            margin-bottom: 40px;
            transition: 0.3s;
        }
        .quick-note-box:focus-within {
            box-shadow: 0 10px 25px rgba(37, 99, 235, 0.08);
            border-color: var(--accent);
        }
        .note-input-title {
            border: none;
            font-size: 1.1rem;
            font-weight: 700;
            width: 100%;
            margin-bottom: 10px;
            outline: none;
            color: var(--text-dark);
        }
        .note-input-content {
            border: none;
            width: 100%;
            resize: none;
            outline: none;
            color: var(--text-gray);
            font-size: 0.95rem;
            min-height: 40px;
        }
        .quick-note-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #f1f5f9;
        }

        /* --- Note Card --- */
        .note-card {
            background: #fff;
            border-radius: 14px;
            border: 1px solid var(--border);
            padding: 20px;
            height: 100%;
            transition: 0.3s;
            position: relative;
        }
        .note-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 20px rgba(0,0,0,0.05);
            border-color: var(--accent);
        }
        .note-card-title {
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 10px;
            padding-right: 25px;
        }
        .note-card-text {
            font-size: 0.9rem;
            color: var(--text-gray);
            line-height: 1.6;
            white-space: pre-wrap;
        }

        /* Action Menu Styling */
        .note-options {
            position: absolute;
            top: 15px;
            right: 10px;
        }
        .btn-option {
            background: none;
            border: none;
            color: var(--text-gray);
            padding: 0 5px;
            border-radius: 5px;
        }
        .btn-option:hover { background: #f1f5f9; }

        @media (max-width: 992px) {
            #sidebar { display: none; }
            #content { margin-left: 0; padding: 20px; }
        }
    </style>
</head>
<body>

<div class="wrapper">
    <nav id="sidebar">
        <div class="brand"><i class="bi bi-rocket-takeoff-fill"></i> CheatHub</div>
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
                <li class="active"><a href="myNotes"><i class="bi bi-journal-text"></i> My Saved Notes</a></li>
                <li><a href="displayFavorites"><i class="bi bi-star"></i> Favorite Sheets</a></li>
            <% } %>

            <li class="small text-uppercase text-muted fw-bold px-3 mt-4 mb-2" style="font-size: 0.7rem;">Account</li>
            <li><a href="${pageContext.request.contextPath}/profile.jsp"><i class="bi bi-person"></i> My Profile</a></li>
            <li><a href="logout" class="text-danger"><i class="bi bi-power"></i> Logout</a></li>
        </ul>
    </nav>

    <div id="content">
        <div class="row justify-content-center">
            <div class="col-xl-8">
                
                <header class="mb-5">
                    <h2 class="fw-bold mb-1">Personal Notes</h2>
                    <p class="text-muted">Capture ideas and important snippets.</p>
                </header>

                <!-- Professional Quick Input Form -->
                <form action="saveNote" method="post" class="quick-note-box" id="noteForm">
                    <!-- ID field for Edit -->
                    <input type="hidden" name="id" id="noteId">
                    
                    <input type="text" name="title" id="noteTitle" class="note-input-title" placeholder="Title of your note..." >
                    <textarea name="content" id="noteContent" class="note-input-content" rows="2" placeholder="Take a note..." required></textarea>
                    
                    <div class="quick-note-actions">
                        <button type="button" id="cancelBtn" class="btn btn-light btn-sm px-3 rounded-pill d-none" onclick="resetForm()">Cancel</button>
                        <button type="submit" id="submitBtn" class="btn btn-primary btn-sm px-4 rounded-pill fw-bold shadow-sm">
                            <i class="bi bi-plus-lg me-1"></i> Save Note
                        </button>
                    </div>
                </form>

                <div class="d-flex align-items-center mb-4">
                    <h6 class="fw-bold mb-0 me-3 text-uppercase small text-muted" style="letter-spacing: 1px;">Recent Notes</h6>
                    <div class="flex-grow-1 border-bottom"></div>
                </div>

                <div class="row g-4">
                    <% 
                        List<Map<String, String>> notes = (List<Map<String, String>>) request.getAttribute("noteList");
                        if (notes != null && !notes.isEmpty()) {
                            for (Map<String, String> n : notes) {
                    %>
                        <div class="col-md-6">
                            <div class="note-card">
                                <!-- Action Menu -->
                                <div class="note-options dropdown">
                                    <button class="btn-option" data-bs-toggle="dropdown"><i class="bi bi-three-dots-vertical"></i></button>
                                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0">
                                        <li>
                                            <button class="dropdown-item py-2" onclick="editNote('<%= n.get("id") %>', '<%= n.get("title").replace("'", "\\'") %>', '<%= n.get("content").replace("'", "\\'") %>')">
                                                <i class="bi bi-pencil me-2 text-primary"></i> Edit
                                            </button>
                                        </li>
                                        <li><hr class="dropdown-divider opacity-50"></li>
                                        <li>
                                            <a href="deleteNote?id=<%= n.get("id") %>" class="dropdown-item py-2 text-danger" onclick="return confirm('Delete?')">
                                                <i class="bi bi-trash me-2"></i> Delete
                                            </a>
                                        </li>
                                    </ul>
                                </div>

                                <div class="note-card-title">
                                    <i class="bi bi-pin-angle-fill text-warning me-1"></i>
                                    <%= n.get("title") %>
                                </div>
                                <div class="note-card-text"><%= n.get("content") %></div>
                            </div>
                        </div>
                    <% 
                            }
                        } else { 
                    %>
                        <div class="col-12 text-center py-5">
                            <div class="text-muted">
                                <i class="bi bi-journal-x display-4 d-block mb-3 opacity-25"></i>
                                <p>No notes yet.</p>
                            </div>
                        </div>
                    <% } %>
                </div>

                <footer class="mt-5 pt-5 text-center text-muted small">
                    &copy; 2026 CheatHub &bull; Personal Note Manager
                </footer>
            </div>
        </div>
    </div>
</div>

<script>
    // Edit Function
    function editNote(id, title, content) {
        document.getElementById('noteId').value = id;
        document.getElementById('noteTitle').value = title;
        document.getElementById('noteContent').value = content;
        
        // Change Button Style
        const submitBtn = document.getElementById('submitBtn');
        submitBtn.innerHTML = '<i class="bi bi-check2"></i> Update Note';
        submitBtn.classList.replace('btn-primary', 'btn-success');
        
        // Show Cancel Button
        document.getElementById('cancelBtn').classList.remove('d-none');
        
        // Scroll to form
        window.scrollTo({ top: 0, behavior: 'smooth' });
        document.getElementById('noteContent').focus();
    }

    // Reset Form
    function resetForm() {
        document.getElementById('noteId').value = '';
        document.getElementById('noteForm').reset();
        
        const submitBtn = document.getElementById('submitBtn');
        submitBtn.innerHTML = '<i class="bi bi-plus-lg me-1"></i> Save Note';
        submitBtn.classList.replace('btn-success', 'btn-primary');
        
        document.getElementById('cancelBtn').classList.add('d-none');
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>