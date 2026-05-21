<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.cheatsheet.model.Comment, com.cheatsheet.dao.CommentDAO" %>
<%
    String userRole = (String) session.getAttribute("userRole");
    if (session.getAttribute("user") == null || !"admin".equals(userRole)) {
        response.sendRedirect("categories");
        return;
    }

    CommentDAO commentDao = new CommentDAO();
    
    try {
        commentDao.markAllAsRead();
    } catch(Exception e) {
        e.printStackTrace();
    }

    java.sql.Connection conn = null;
    java.sql.PreparedStatement ps = null;
    java.sql.ResultSet rs = null;
    
    class AdminCommentView {
        int id, sheetId, catId;
        String username, commentText, createdAt;
        boolean isRead;
    }
    
    List<AdminCommentView> allComments = new java.util.ArrayList<>();
    try {
        conn = com.cheatsheet.config.DBConnection.getConnection();
        String sql = "SELECT c.*, u.username, s.category_id FROM comments c " +
                     "JOIN users u ON c.user_id = u.id " +
                     "JOIN sheets s ON c.sheet_id = s.id " +
                     "WHERE c.parent_id IS NULL ORDER BY c.created_at DESC";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();
        while(rs.next()) {
            AdminCommentView c = new AdminCommentView();
            c.id = rs.getInt("id");
            c.sheetId = rs.getInt("sheet_id");
            c.catId = rs.getInt("category_id");
            c.commentText = rs.getString("comment_text");
            c.createdAt = rs.getTimestamp("created_at").toString();
            c.username = rs.getString("username");
            c.isRead = rs.getBoolean("is_read");
            allComments.add(c);
        }
    } catch(Exception e) { 
        e.printStackTrace(); 
    } finally { 
        if(rs!=null) rs.close(); 
        if(ps!=null) ps.close(); 
        if(conn!=null) conn.close(); 
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Comments - Admin Dashboard</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

        body { 
            background-color: #f3f4f6; 
            font-family: 'Inter', sans-serif;
            color: #1f2937;
        }

        #content {
            flex: 1;
            padding: 40px 20px;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .comment-row {
            background: #ffffff;
            border-radius: 12px;
            padding: 20px;
            border: 1px solid #e5e7eb;
            transition: 0.2s;
        }
        .comment-row:hover {
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border-color: #d1d5db;
        }
        
        .badge-unread {
            background-color: #ef4444;
            color: white;
            font-size: 0.65rem;
            padding: 3px 8px;
            border-radius: 20px;
            font-weight: 600;
        }

        #hidden_frame { display: none; }
    </style>
</head>
<body>

<iframe name="hidden_frame" id="hidden_frame"></iframe>

<div class="container">
    <div id="content">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="fw-bold mb-1"><i class="bi bi-chat-left-text text-primary me-2"></i>User Discussions</h2>
                <p class="text-muted mb-0">Review and moderate all comments submitted by users.</p>
            </div>
            <a href="categories" class="btn btn-outline-primary rounded-pill px-4 btn-sm fw-bold">
                <i class="bi bi-house-door me-1"></i> Back to Dashboard
            </a>
        </div>

        <div class="bg-white d-flex align-items-center shadow-sm px-4 rounded-3 mb-4 border" style="max-width: 400px; height: 45px;">
            <i class="bi bi-search text-muted me-2"></i>
            <input type="text" id="commentSearch" class="form-control border-0 shadow-none bg-transparent" placeholder="Search comments or users...">
        </div>

        <div class="d-flex flex-column gap-3" id="commentContainer">
            <%
                if(!allComments.isEmpty()) {
                    for(AdminCommentView c : allComments) {
            %>
                <div class="comment-row shadow-sm">
                    <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
                        <div>
                            <div class="d-flex align-items-center gap-2 flex-wrap">
                                <h6 class="fw-bold mb-0 text-primary"><i class="bi bi-person-circle me-1"></i><%= c.username %></h6>
                                <span class="text-muted small" style="font-size: 0.75rem;"><%= c.createdAt %></span>
                                <% if(!c.isRead) { %>
                                    <span class="badge-unread"><i class="bi bi-lightning-fill"></i> New</span>
                                <% } %>
                            </div>
                            <p class="mt-2 text-secondary mb-0 px-1" style="font-size: 0.95rem;"><%= c.commentText %></p>
                        </div>
                        
                        <div class="d-flex gap-2">
                            <a href="viewSheet?id=<%= c.catId %>&sheetId=<%= c.sheetId %>" class="btn btn-sm btn-light border text-secondary px-3 rounded-pill">
                                <i class="bi bi-eye-fill"></i> View & Reply
                            </a>
                            <a href="deleteCommentByAdmin?id=<%= c.id %>" target="hidden_frame" class="btn btn-sm btn-outline-danger px-3 rounded-pill" onclick="return handleDeleteRow(this)">
                                <i class="bi bi-trash3"></i> Delete
                            </a>
                        </div>
                    </div>
                </div>
            <% 
                    } 
                } else { 
            %>
                <div class="text-center py-5 bg-white rounded-3 border shadow-sm">
                    <i class="bi bi-chat-square-dots text-muted display-4 mb-3 d-block"></i>
                    <p class="text-muted mb-0">No user conversations or comments found in the system.</p>
                </div>
            <% } %>
        </div>
    </div>
</div>

<script>
    document.getElementById('commentSearch').addEventListener('keyup', function() {
        let filter = this.value.toLowerCase();
        let rows = document.querySelectorAll('.comment-row');
        rows.forEach(row => {
            let text = row.innerText.toLowerCase();
            row.style.display = text.includes(filter) ? "" : "none";
        });
    });

    function handleDeleteRow(el) {
        if(!confirm('Are you sure you want to permanently delete this comment?')) {
            return false;
        }
        const row = el.closest('.comment-row');
        row.style.opacity = '0.4';
        row.style.pointerEvents = 'none';
        
        setTimeout(() => {
            row.style.display = 'none';
        }, 500);
        return true;
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>