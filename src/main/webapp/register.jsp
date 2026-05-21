<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - Cheat Sheet Manager</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
        
        body {
            background: #f3f4f6;
            font-family: 'Inter', sans-serif;
            height: 100vh;
            display: flex;
            align-items: center;
        }
        
        .register-card {
            background: #ffffff;
            border-radius: 16px;
            border: none;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
            padding: 40px;
        }
        
        .form-label {
            font-weight: 500;
            color: #374151;
            font-size: 0.9rem;
        }
        
        .form-control {
            padding: 12px 16px;
            border-radius: 8px;
            border: 1px solid #d1d5db;
        }
        
        .form-control:focus {
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
            border-color: #3b82f6;
        }
        
        .btn-primary {
            background: #3b82f6;
            border: none;
            padding: 12px;
            font-weight: 600;
            border-radius: 8px;
            transition: all 0.3s;
        }
        
        .btn-primary:hover {
            background: #2563eb;
            transform: translateY(-1px);
        }
        
        .input-group-text {
            background: transparent;
            border-left: none;
            cursor: pointer;
            color: #6b7280;
        }
        
        .password-field {
            border-right: none;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card register-card">
                <div class="text-center mb-4">
                 <h2 class="register-title">CheatHub</h2>
                    <h2 class="fw-bold text-dark">Create Account</h2>
                    <p class="text-muted">Start managing your cheat sheets today</p>
                </div>

                <form action="register" method="POST" onsubmit="return validateForm()">
                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <input type="text" name="username" class="form-control" placeholder="Choose a username" required>
                    </div>

                    <!-- <div class="mb-3">
                        <label class="form-label">Email Address</label>
                        <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
                    </div>
 -->
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <div class="input-group">
                            <input type="password" name="password" id="password" class="form-control password-field" placeholder="Create a password" required>
                            <span class="input-group-text" onclick="togglePassword('password', this)">
                                <i class="bi bi-eye"></i>
                            </span>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Confirm Password</label>
                        <div class="input-group">
                            <input type="password" id="confirm_password" class="form-control password-field" placeholder="Repeat your password" required>
                            <span class="input-group-text" onclick="togglePassword('confirm_password', this)">
                                <i class="bi bi-eye"></i>
                            </span>
                        </div>
                        <div id="password-error" class="text-danger mt-1 small d-none">
                            Passwords do not match!
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 mb-3">Sign Up</button>
                    
                    <div class="text-center">
                        <span class="text-muted small">Already have an account? </span>
                        <a href="login.jsp" class="text-decoration-none small fw-bold">Sign In</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
    // Password ကြည့်လို့ရအောင် လုပ်ပေးတဲ့ Function
    function togglePassword(inputId, iconElement) {
        const input = document.getElementById(inputId);
        const icon = iconElement.querySelector('i');
        
        if (input.type === "password") {
            input.type = "text";
            icon.classList.replace("bi-eye", "bi-eye-slash");
        } else {
            input.type = "password";
            icon.classList.replace("bi-eye-slash", "bi-eye");
        }
    }

    // Password နှစ်ခု တူ/မတူ စစ်တဲ့ Function
    function validateForm() {
        const pass = document.getElementById("password").value;
        const confirmPass = document.getElementById("confirm_password").value;
        const errorDiv = document.getElementById("password-error");

        if (pass !== confirmPass) {
            errorDiv.classList.remove("d-none");
            return false; // Form ကို ပို့ခွင့်မပြုဘူး
        }
        
        errorDiv.classList.add("d-none");
        return true; // Password တူရင် ပို့ခွင့်ပြုတယ်
    }
</script>

</body>
</html>