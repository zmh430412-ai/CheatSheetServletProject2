<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.cheatsheet.model.Sheet, com.cheatsheet.dao.FavoriteDAO, com.cheatsheet.dao.RatingDAO, com.cheatsheet.model.Comment, com.cheatsheet.dao.CommentDAO" %>
<%
    Integer userId = (Integer) session.getAttribute("userId");
    String userRole = (String) session.getAttribute("userRole");
    
    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    FavoriteDAO favDao = new FavoriteDAO();
    RatingDAO ratingDao = new RatingDAO();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("catName") %> - Cheat Sheet Details</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=JetBrains+Mono:wght@400;500&display=swap');
        body { background-color: #f3f4f6; font-family: 'Inter', sans-serif; color: #1f2937; line-height: 1.6; }
        
        .header-section { 
            background: #ffffff; 
            padding: 15px 0; 
            border-bottom: 1px solid #e5e7eb; 
            margin-bottom: 40px; 
            position: sticky;      
            top: 0;                
            z-index: 1020;         
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03) !important; 
        }

        .category-badge { background: #dbeafe; color: #1e40af; padding: 5px 15px; border-radius: 20px; font-size: 0.85rem; font-weight: 600; text-transform: uppercase; }
        h2 { font-weight: 800; color: #111827; margin: 0; }
        .sheet-card { background: #ffffff; border-radius: 12px; border: 1px solid #e5e7eb; transition: all 0.2s; }
        .sheet-title { color: #111827; font-weight: 700; display: flex; align-items: center; }
        .sheet-title::before { content: "#"; color: #3b82f6; margin-right: 10px; }
        
        .fav-btn { background: #f8fafc; border: 1px solid #e2e8f0; width: 38px; height: 38px; border-radius: 50%; display: flex; align-items: center; justify-content: center; transition: all 0.2s; text-decoration: none !important; }
        .fav-btn:hover { transform: scale(1.1); background: #fff1f2; border-color: #fda4af; }
        .fav-btn .bi-heart-fill { color: #ef4444; }
        .fav-btn .bi-heart { color: #94a3b8; }
        
        /* Rating Display */
        .rating-display { color: #f59e0b; font-weight: 700; font-size: 0.95rem; }

        /* Star Rating Interactive System */
        .star-rating { display: flex; flex-direction: row-reverse; justify-content: flex-end; }
        .star-rating input { display: none; }
        .star-rating label { font-size: 1.4rem; color: #cbd5e1; cursor: pointer; transition: color 0.2s; margin-right: 2px; }
        .star-rating label:hover, .star-rating label:hover ~ label, .star-rating input:checked ~ label { color: #f59e0b; }

        /* Code Styles */
        .code-container { background-color: #0f172a; border-radius: 10px; overflow: hidden; border: 1px solid #1e293b; margin-top: 20px; }
        .code-header { background: #1e293b; padding: 8px 16px; display: flex; justify-content: space-between; align-items: center; }
        .dot { width: 10px; height: 10px; border-radius: 50%; display: inline-block; }
        .dot-red { background: #ff5f56; } .dot-yellow { background: #ffbd2e; } .dot-green { background: #27c93f; }
        .code-box { padding: 20px; font-family: 'JetBrains Mono', monospace; font-size: 14px; color: #e2e8f0; overflow-x: auto; margin-bottom: 0; }
        
        .copy-btn { 
            background: rgba(255, 255, 255, 0.05); color: #94a3b8; border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 4px 12px; border-radius: 6px; font-size: 0.75rem; transition: all 0.3s; display: flex; align-items: center; gap: 6px;
        }
        .copy-btn:hover { background: rgba(255, 255, 255, 0.15); color: #ffffff; }
        .copy-btn.copied { background: #22c55e !important; color: white !important; border-color: #22c55e !important; }

        .back-btn { color: #6b7280; text-decoration: none; font-weight: 500; display: inline-flex; align-items: center; gap: 5px; }
        .back-btn:hover { color: #3b82f6; }
        #hidden_frame { display: none; }

        .comment-toggle-btn {
            background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; padding: 8px 16px;
            border-radius: 8px; font-weight: 600; font-size: 0.9rem; transition: all 0.2s;
        }
        .comment-toggle-btn:hover { background: #e2e8f0; color: #1e293b; }
        .comment-toggle-btn:not(.collapsed) { background: #e0f2fe; color: #0369a1; border-color: #bae6fd; }
        
        /* Comment Action Link Styles */
        .comment-action-link { font-size: 0.75rem; color: #94a3b8; text-decoration: none; margin-left: 10px; transition: color 0.2s; }
        .comment-action-link:hover { color: #3b82f6; }
        .comment-action-link.delete:hover { color: #ef4444; }
    </style>
</head>
<body>

<iframe name="hidden_frame" id="hidden_frame"></iframe>

<div class="header-section shadow-sm">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-2">
            <div class="d-flex align-items-center gap-3">
                <span class="category-badge">Category</span>
                <h2><%= request.getAttribute("catName") %> Cheat Sheet</h2>
            </div>
            <a href="categories" class="back-btn"><i class="bi bi-arrow-left"></i> Back to Home</a>
        </div>
    </div>
</div>

<div class="container mb-5">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <%
                List<Sheet> sheets = (List<Sheet>) request.getAttribute("sheetList");
                if(sheets != null && !sheets.isEmpty()) {
                    for(Sheet s : sheets) {
                        boolean isFavorite = (userId != null) && favDao.isFavorite(userId, s.getId());
                        double avgRating = ratingDao.getAverageRating(s.getId()); 
                        int userRating = (userId != null) ? ratingDao.getUserRating(s.getId(), userId) : 0;
            %>
                <div class="card sheet-card mb-5 p-4 shadow-sm">
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div class="flex-grow-1">
                            <div class="d-flex align-items-center gap-3">
                                <h4 class="sheet-title m-0"><%= s.getTitle() %></h4>
                                <% if (!"admin".equals(userRole)) { %>
                                <a href="toggleFavorite?sheetId=<%= s.getId() %>&catId=<%= request.getParameter("id") %>" 
                                   target="hidden_frame" onclick="toggleHeart(this)" class="fav-btn shadow-sm">
                                    <i class="bi <%= isFavorite ? "bi-heart-fill" : "bi-heart" %>"></i>
                                </a>
                                <% } %>
                            </div>
                            
                            <p class="text-muted mt-2 ms-4 mb-1"><%= s.getDescription() %></p>
                            
                            <div class="ms-4 d-flex align-items-center gap-4 mt-2">
                                <div class="rating-display d-flex align-items-center border-end pe-3">
                                    <i class="bi bi-star-fill me-1 text-warning"></i>
                                    <span><%= String.format("%.1f", avgRating) %></span>
                                </div>

                                <% if (!"admin".equals(userRole)) { %>
                                    <form action="submitRating" method="POST" class="star-rating" target="hidden_frame">
                                        <input type="hidden" name="sheetId" value="<%= s.getId() %>">
                                        <input type="hidden" name="catId" value="<%= request.getParameter("id") %>">
                                        <% for(int i=5; i>=1; i--) { %>
                                            <input type="radio" id="star<%= i %>-<%= s.getId() %>" name="rating" value="<%= i %>" 
                                                   <%= (userRating == i) ? "checked" : "" %> onchange="this.form.submit()">
                                            <label for="star<%= i %>-<%= s.getId() %>"><i class="bi bi-star-fill"></i></label>
                                        <% } %>
                                    </form>
                                <% } %>
                            </div>
                        </div>
                        
                        <% if ("admin".equals(userRole)) { %>
                            <div class="admin-actions btn-group ms-3">
                                <a href="editSheet?id=<%= s.getId() %>" class="btn btn-sm btn-outline-primary"><i class="bi bi-pencil-square"></i></a>
                                <a href="deleteSheet?id=<%= s.getId() %>" class="btn btn-sm btn-outline-danger" onclick="return confirm('Are you sure?')"><i class="bi bi-trash3"></i></a>
                            </div>
                        <% } %>
                    </div>
                    
                    <div class="code-container shadow-sm">
                        <div class="code-header">
                            <div class="code-dots"><div class="dot dot-red"></div><div class="dot dot-yellow"></div><div class="dot dot-green"></div></div>
                            <button class="btn btn-sm copy-btn" onclick="copyToClipboard(this)"><i class="bi bi-clipboard"></i> <span>Copy</span></button>
                        </div>
                        <pre class="code-box"><code><% 
                            String code = s.getCodeContent(); 
                            if(code != null) { out.print(code.replace("<", "&lt;").replace(">", "&gt;")); } 
                        %></code></pre>
                    </div>

                    <%-- Comment Section --%>
                    <%
                        CommentDAO commentDao = new CommentDAO();
                        // ★ [MODIFIED] ကွန်မန့်အားလုံး ဆွဲထုတ်မည့်အစား Main Comment များကိုသာ ဆွဲထုတ်စေရန် ပြောင်းလဲခေါ်ယူခြင်း
                        List<Comment> mainComments = commentDao.getMainCommentsBySheetId(s.getId());
                    %>
                    <div class="comment-section mt-4 border-top pt-3">
                        <button class="btn comment-toggle-btn d-flex align-items-center gap-2 collapsed" 
                                type="button" data-bs-toggle="collapse" 
                                data-bs-target="#collapseComments-<%= s.getId() %>" aria-expanded="false">
                            <i class="bi bi-chat-left-text"></i>
                            <span>Discussion (<%= (mainComments != null) ? mainComments.size() : 0 %>)</span>
                            <i class="bi bi-chevron-down small ms-auto"></i>
                        </button>

                        <div class="collapse mt-3" id="collapseComments-<%= s.getId() %>">
                            
                            <% if (!"admin".equals(userRole)) { %>
                                <form action="addComment" method="POST" class="mb-4" target="hidden_frame" onsubmit="handleCommentSubmit(this, '<%= s.getId() %>')">
                                    <input type="hidden" name="sheetId" value="<%= s.getId() %>">
                                    <input type="hidden" name="catId" value="<%= request.getParameter("id") %>">
                                    <div class="input-group shadow-sm rounded-3 overflow-hidden">
                                        <textarea name="commentText" class="form-control border-1 p-2" rows="2" placeholder="Write a comment..." style="resize: none;" required></textarea>
                                        <button type="submit" class="btn btn-primary px-4"><i class="bi bi-send-fill"></i></button>
                                    </div>
                                </form>
                            <% } %>

                            <div class="comment-list" style="max-height: 400px; overflow-y: auto;">
                                <% if(mainComments != null && !mainComments.isEmpty()) { 
                                    for(Comment c : mainComments) { %>
                                    
                                    <div class="p-3 rounded-3 mb-2 position-relative" style="background-color: #f8fafc; border: 1px solid #f1f5f9;">
                                        <div class="d-flex justify-content-between align-items-center mb-1">
                                            <div>
                                                <span class="fw-bold small text-primary"><i class="bi bi-person-circle me-1"></i><%= c.getUsername() %></span>
                                                
                                                <% if(userId != null && userId.equals(c.getUserId())) { %>
                                                    <a href="#" class="comment-action-link" data-bs-toggle="modal" data-bs-target="#editCommentModal" data-comment-id="<%= c.getId() %>" data-sheet-id="<%= s.getId() %>" data-comment-text="<%= c.getCommentText() %>"><i class="bi bi-pencil shadow-sm"></i> Edit</a>
                                                    <a href="deleteComment?id=<%= c.getId() %>&catId=<%= request.getParameter("id") %>" target="hidden_frame" class="comment-action-link delete" onclick="return handleDeleteComment(this, '<%= s.getId() %>')"><i class="bi bi-trash"></i> Delete</a>
                                                <% } %>

                                                <% if("admin".equals(userRole)) { %>
                                                    <a href="deleteCommentByAdmin?id=<%= c.getId() %>&catId=<%= request.getParameter("id") %>&sheetId=<%= s.getId() %>" target="hidden_frame" class="comment-action-link delete text-danger fw-bold ms-2" onclick="return handleDeleteComment(this, '<%= s.getId() %>')"><i class="bi bi-trash3-fill text-danger"></i> Admin Delete</a>
                                                <% } %>
                                            </div>
                                            <span class="text-muted" style="font-size: 0.7rem;"><%= c.getCreatedAt() %></span>
                                        </div>
                                        <p class="text-secondary m-0 small"><%= c.getCommentText() %></p>

                                        <% if("admin".equals(userRole)) { %>
                                            <div class="mt-2 text-end">
                                                <button class="btn btn-sm btn-link text-secondary text-decoration-none py-0 px-2 small" style="font-size: 0.75rem;" type="button" data-bs-toggle="collapse" data-bs-target="#replyForm-<%= c.getId() %>">
                                                    <i class="bi bi-reply-fill"></i> Reply
                                                </button>
                                            </div>
                                            <div class="collapse mt-2" id="replyForm-<%= c.getId() %>">
                                                <form action="addReply" method="POST" target="hidden_frame" onsubmit="handleCommentSubmit(this, '<%= s.getId() %>')">
                                                    <input type="hidden" name="sheetId" value="<%= s.getId() %>">
                                                    <input type="hidden" name="catId" value="<%= request.getParameter("id") %>">
                                                    <input type="hidden" name="parentId" value="<%= c.getId() %>">
                                                    <div class="input-group input-group-sm">
                                                        <input type="text" name="replyText" class="form-control" placeholder="Write admin reply..." required>
                                                        <button class="btn btn-secondary" type="submit">Send</button>
                                                    </div>
                                                </form>
                                            </div>
                                        <% } %>
                                    </div>

                                    <%
                                        List<Comment> replies = commentDao.getRepliesByCommentId(c.getId());
                                        if (replies != null) {
                                            for(Comment r : replies) {
                                    %>
                                        <div class="p-2 rounded-3 mb-2 ms-5 shadow-sm" style="background-color: #f0fdf4; border: 1px solid #dcfce7;">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <div>
                                                    <span class="fw-bold small text-success"><i class="bi bi-shield-check me-1"></i><%= r.getUsername() %> <span class="badge bg-success" style="font-size: 0.6rem; padding: 2px 5px;">Admin</span></span>
                                                    
                                                    <% if("admin".equals(userRole)) { %>
                                                        <a href="deleteCommentByAdmin?id=<%= r.getId() %>&catId=<%= request.getParameter("id") %>&sheetId=<%= s.getId() %>" target="hidden_frame" class="comment-action-link delete text-danger ms-2" onclick="return handleDeleteComment(this, '<%= s.getId() %>')"><i class="bi bi-trash"></i> Delete</a>
                                                    <% } %>
                                                </div>
                                                <span class="text-muted" style="font-size: 0.65rem;"><%= r.getCreatedAt() %></span>
                                            </div>
                                            <p class="text-dark m-0 small" style="font-size: 0.8rem;"><%= r.getCommentText() %></p>
                                        </div>
                                    <% 
                                            }
                                        } 
                                    %>

                                <% } } else { %>
                                    <p class="text-muted small fst-italic ps-2">No comments yet. Be the first to comment!</p>
                                <% } %>
                            </div>
                        </div>
                    </div>

                </div>
            <% } } %>
        </div>
    </div>
</div>

<div class="modal fade" id="editCommentModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <form action="editComment" method="POST" target="hidden_frame" onsubmit="handleEditSubmit(this)">
        <div class="modal-header">
          <h5 class="modal-title fw-bold" id="editModalLabel"><i class="bi bi-pencil-square text-primary me-2"></i>Edit Comment</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
            <input type="hidden" name="commentId" id="modalCommentId">
            <input type="hidden" name="catId" value="<%= request.getParameter("id") %>">
            <input type="hidden" id="modalSheetId">
            <div class="mb-3">
                <textarea class="form-control" name="commentText" id="modalCommentText" rows="3" style="resize: none;" required></textarea>
            </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-sm btn-primary px-3">Save Changes</button>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
function toggleHeart(el) {
    const icon = el.querySelector('i');
    icon.classList.toggle('bi-heart');
    icon.classList.toggle('bi-heart-fill');
}

function copyToClipboard(btn) {
    const codeContainer = btn.closest('.code-container');
    const code = codeContainer.querySelector('code').innerText;
    const btnIcon = btn.querySelector('i');
    const btnText = btn.querySelector('span');
    navigator.clipboard.writeText(code).then(() => {
        btn.classList.add('copied'); btnIcon.className = 'bi bi-check-lg'; btnText.innerText = 'Copied';
        setTimeout(() => { btn.classList.remove('copied'); btnIcon.className = 'bi bi-clipboard'; btnText.innerText = 'Copy'; }, 2000);
    });
}

function handleCommentSubmit(form, sheetId) {
    const textarea = form.querySelector('textarea[name="commentText"]');
    if (textarea) {
        setTimeout(() => { textarea.value = ''; }, 50);
    }
    const textInput = form.querySelector('input[name="replyText"]');
    if (textInput) {
        setTimeout(() => { textInput.value = ''; }, 50);
    }

    sessionStorage.setItem("openCommentSection", "collapseComments-" + sheetId);
    sessionStorage.setItem("scrollPos", window.scrollY);

    setTimeout(() => { window.location.reload(); }, 400);
}

function handleEditSubmit(form) {
    const sheetId = document.getElementById('modalSheetId').value;
    sessionStorage.setItem("openCommentSection", "collapseComments-" + sheetId);
    sessionStorage.setItem("scrollPos", window.scrollY);

    const modalEl = document.getElementById('editCommentModal');
    const modal = bootstrap.Modal.getInstance(modalEl);
    if(modal) modal.hide();

    setTimeout(() => { window.location.reload(); }, 400);
}

function handleDeleteComment(link, sheetId) {
    if (!confirm('Are you sure you want to delete this comment?')) {
        return false;
    }
    sessionStorage.setItem("openCommentSection", "collapseComments-" + sheetId);
    sessionStorage.setItem("scrollPos", window.scrollY);

    setTimeout(() => { window.location.reload(); }, 400);
    return true;
}

window.addEventListener('DOMContentLoaded', () => {
    const openSectionId = sessionStorage.getItem("openCommentSection");
    const scrollPos = sessionStorage.getItem("scrollPos");

    if (openSectionId) {
        const targetCollapse = document.getElementById(openSectionId);
        if (targetCollapse) {
            const bsCollapse = new bootstrap.Collapse(targetCollapse, { toggle: false });
            bsCollapse.show();
            
            const toggleBtn = document.querySelector(`[data-bs-target="#${openSectionId}"]`);
            if(toggleBtn) toggleBtn.classList.remove('collapsed');
        }
        sessionStorage.removeItem("openCommentSection");
    }

    if (scrollPos) {
        window.scrollTo(0, parseInt(scrollPos));
        sessionStorage.removeItem("scrollPos");
    }
});

const editCommentModal = document.getElementById('editCommentModal');
if (editCommentModal) {
    editCommentModal.addEventListener('show.bs.modal', event => {
        const button = event.relatedTarget;
        const commentId = button.getAttribute('data-comment-id');
        const sheetId = button.getAttribute('data-sheet-id');
        const commentText = button.getAttribute('data-comment-text');
        
        const modalIdInput = editCommentModal.querySelector('#modalCommentId');
        const modalSheetInput = editCommentModal.querySelector('#modalSheetId');
        const modalTextInput = editCommentModal.querySelector('#modalCommentText');
        
        modalIdInput.value = commentId;
        modalSheetInput.value = sheetId;
        modalTextInput.value = commentText;
    });
}
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>