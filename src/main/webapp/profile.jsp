<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - CheatHub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;600;700&display=swap');
        
        body {
            background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
            font-family: 'Plus Jakarta Sans', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
        }

        .profile-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: 24px;
        }

        .avatar-circle {
            width: 100px;
            height: 100px;
            background: linear-gradient(45deg, #2563eb, #3b82f6);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            font-weight: bold;
            border-radius: 50%;
            margin-bottom: 20px;
            box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.2);
            background-size: cover;
            background-position: center;
            position: relative;
        }

        .upload-badge {
            position: absolute;
            bottom: 0;
            right: 0;
            background: white;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            border: 1px solid #e2e8f0;
        }

        .info-label { letter-spacing: 0.05em; color: #64748b; font-size: 0.75rem; text-transform: uppercase; font-weight: 700; }
        
       
        .editable-input {
            background: transparent;
            border: none;
            font-weight: 700;
            font-size: 1.1rem;
            color: #1e293b;
            padding: 0;
            width: 100%;
        }
        .editable-input:focus {
            outline: none;
            color: #2563eb;
        }

        .role-badge { background: #eff6ff; color: #2563eb; border: 1px solid #dbeafe; padding: 6px 16px; font-weight: 600; }
        .btn-back { background: #ffffff; border: 1px solid #e2e8f0; color: #64748b; transition: all 0.2s; }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5 col-lg-4">
                <div class="card profile-card shadow-lg border-0 p-4 p-md-5">
                    
                    <form action="updateProfile" method="post" enctype="multipart/form-data">
                        
                        <div class="text-center mb-4">
                            <div class="position-relative d-inline-block">
                                <div class="avatar-circle mx-auto" id="avatarDisplay" 
     style="<%= (session.getAttribute("userImage") != null) ? 
     "background-image: url('uploads/" + session.getAttribute("userImage") + "'); background-size: cover; border: none;" : "" %>">
    
    
    <% if (session.getAttribute("userImage") == null) { %>
        <% 
            String user = (String) session.getAttribute("user");
            out.print(user != null ? user.substring(0, 1).toUpperCase() : "U"); 
        %>
    <% } %>
</div>
                                <label for="fileInput" class="upload-badge">
                                    <i class="bi bi-camera-fill text-primary"></i>
                                </label>
                                <input type="file" name="profilePic" id="fileInput" class="d-none" accept="image/*" onchange="previewImage(this)">
                            </div>
                            <h4 class="fw-bold m-0">My Profile</h4>
                            <p class="text-muted small mt-1">Manage your account details</p>
                        </div>

                        <div class="mb-4 bg-light p-3 rounded-3">
                            <label class="info-label d-block mb-1">Username</label>
                            <div class="d-flex align-items-center">
                                <i class="bi bi-person-fill text-primary me-2"></i>
                                <input type="text" name="username" class="editable-input" 
                                       value="<%= session.getAttribute("user") %>" 
                                       placeholder="Enter new username" required>
                                <i class="bi bi-pencil-square text-muted ms-auto" style="font-size: 0.8rem;"></i>
                            </div>
                        </div>

                        <div class="mb-4 bg-light p-3 rounded-3">
                            <label class="info-label d-block mb-1">Account Role</label>
                            <div class="mt-1">
                                <span class="badge role-badge rounded-pill">
                                    <i class="bi bi-shield-check me-1"></i>
                                    <%= session.getAttribute("userRole") %>
                                </span>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 rounded-3 py-2 fw-semibold mb-3 shadow-sm">
                            <i class="bi bi-check-circle me-2"></i>Save Changes
                        </button>
                    </form>

                    <div class="pt-2 border-top">
                        <a href="categories" class="btn btn-back w-100 rounded-3 py-2 fw-semibold">
                            <i class="bi bi-arrow-left me-2"></i>Back to Dashboard
                        </a>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <script>
        function previewImage(input) {
            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const avatar = document.getElementById('avatarDisplay');
                    avatar.style.backgroundImage = 'url(' + e.target.result + ')';
                    avatar.innerText = ''; 
                }
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</body>
</html>