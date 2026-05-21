<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - CheatHub</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap');

        body { 
            /* ====== နောက်ခံ Background ပြောင်းလဲထားသည့်နေရာ ====== */
            background-color: #f8fafc; /* Fallback အရောင် */
            background-image: 
                radial-gradient(circle at top right, rgba(239, 246, 255, 0.8) 0%, rgba(248, 250, 252, 0.9) 100%),
                url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyMDAiIGhlaWdodD0iMjAwIiB2aWV3Qm94PSIwIDAgMjAwIDIwMCI+CiAgPHRleHQgeD0iMTAiIHk9IjMwIiBmaWxsPSIjZTJlOGYwIiBmb250LWZhbWlseT0iTW9ub3NwYWNlIiBmb250LXNpemU9IjEyIiBvcGFjaXR5PSIwLjMiPntjb2RlfSA8L3RleHQ+CiAgPHRleHQgeD0iNTAiIHk9IjYwIiBmaWxsPSIjZTJlOGYwIiBmb250LWZhbWlseT0iTW9ub3NwYWNlIiBmb250LXNpemU9IjEyIiBvcGFjaXR5PSIwLjMiPi8qIHJlZiAqLzwvTU9OT1NQQUNFPjwvdGV4dD4KICA8dGV4dCB4PSIxMjAiIHk9IjkwIiBmaWxsPSIjZTJlOGYwIiBmb250LWZhbWlseT0iTW9ub3NwYWNlIiBmb250LXNpemU9IjEyIiBvcGFjaXR5PSIwLjMiPmdldCgpOzwvdGV4dD4KICA8dGV4dCB4PSIxMCIgeT0iMTIwIiBmaWxsPSIjZTJlOGYwIiBmb250LWZhbWlseT0iTW9ub3NwYWNlIiBmb250LXNpemU9IjEyIiBvcGFjaXR5PSIwLjMiPi8vIGNoZWF0PC90ZXh0PgogIDx0ZXh0IHg9IjgwIiB5PSIxNTAiIGmaWxsPSIjZTJlOGYwIiBmb250LWZhbWlseT0iTW9ub3NwYWNlIiBmb250LXNpemU9IjEyIiBvcGFjaXR5PSIwLjMiPjxzcGFuPjwvc3Bhbj48L3RleHQ+CiAgPHRleHQgeD0iNDAiIHk9IjE4MCIgmaWxsPSIjZTJlOGYwIiBmb250LWZhbWlseT0iTW9ub3NwYWNlIiBmb250LXNpemU9IjEyIiBvcGFjaXR5PSIwLjMiPltbZGF0YV1dPC90ZXh0Pgo8L3N2Zz4=');
            background-repeat: repeat;
            background-size: auto, 250px 250px; /* SVG ပုံရဲ့ အရွယ်အစားကို ထိန်းချုပ် */
            /* =================================================== */
            
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: #1e293b;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            position: relative; /* Before element အတွက် လိုအပ် */
        }

        /* ပုံရိပ်က Login Card ကို မဖုံးသွားအောင် Layer တစ်ခုခံခြင်း */
        body::before {
            content: "";
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: radial-gradient(circle at top right, rgba(239, 246, 255, 0.5) 0%, rgba(248, 250, 252, 0.7) 100%);
            z-index: -1;
        }

        .login-container {
            width: 100%;
            max-width: 420px;
            padding: 20px;
            z-index: 1; /* Background အပေါ်မှာ ပေါ်စေရန် */
        }

        .login-card {
            background: rgba(255, 255, 255, 0.95); /* အနည်းငယ် ကြည်လင်အောင် ပြုလုပ် */
            border: 1px solid rgba(226, 232, 240, 0.8);
            border-radius: 24px;
            padding: 45px 35px;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.02);
            backdrop-filter: blur(5px); /* နောက်ခံကို ဝေဝေလေး ဖြစ်စေရန် */
        }

        .brand-logo {
            width: 60px;
            height: 60px;
            background: #2563eb;
            color: white;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin: 0 auto 20px;
            box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.3);
        }

        .login-title {
            font-weight: 800;
            font-size: 1.75rem;
            color: #0f172a;
            letter-spacing: -0.025em;
            margin-bottom: 8px;
        }

        .login-subtitle {
            color: #64748b;
            font-size: 0.95rem;
            margin-bottom: 32px;
        }

        .form-label {
            font-weight: 600;
            font-size: 0.85rem;
            color: #475569;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        /* --- Password Toggle Style --- */
        .password-wrapper {
            position: relative;
        }

        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #64748b;
            font-size: 1.2rem;
            z-index: 10;
            transition: color 0.2s;
        }

        .password-toggle:hover {
            color: #2563eb;
        }

        .form-control {
            border-radius: 12px;
            padding: 12px 16px;
            border: 1px solid #e2e8f0;
            font-size: 1rem;
            background-color: #f8fafc;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .form-control:focus {
            background-color: #fff;
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
            outline: none;
        }

        .btn-login {
            background: #2563eb;
            color: #ffffff;
            border: none;
            border-radius: 12px;
            padding: 14px;
            font-weight: 700;
            width: 100%;
            margin-top: 10px;
            transition: all 0.3s;
            box-shadow: 0 4px 6px -1px rgba(37, 99, 235, 0.2);
        }

        .btn-login:hover {
            background: #1d4ed8;
            transform: translateY(-1px);
            box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.3);
        }

        .alert-error {
            background-color: #fef2f2;
            border: 1px solid #fee2e2;
            color: #dc2626;
            font-size: 0.875rem;
            border-radius: 12px;
            padding: 12px 16px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            font-weight: 500;
        }

        .register-text {
            text-align: center;
            margin-top: 28px;
            font-size: 0.9rem;
            color: #64748b;
        }

        .register-link {
            color: #2563eb;
            text-decoration: none;
            font-weight: 700;
        }

        .register-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="login-container">
        <div class="login-card">
            
            <div class="text-center">
                <div class="brand-logo">
                    <i class="bi bi-terminal-fill"></i>
                </div>
                <h2 class="login-title">CheatHub</h2>
                <p class="login-subtitle">Sign in to access your cheat sheets</p>
            </div>

            <%-- Error Message --%>
            <% if(request.getParameter("error") != null) { %>
                <div class="alert-error">
                    <i class="bi bi-exclamation-circle-fill me-2"></i>
                    Invalid username or password
                </div>
            <% } %>

            <form action="login" method="post">
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <input type="text" name="username" class="form-control shadow-none" placeholder="Enter your username" required>
                </div>
                
                <div class="mb-4">
                    <label class="form-label">Password</label>
                    <div class="password-wrapper">
                        <input type="password" name="password" id="passwordInput" class="form-control shadow-none" style="padding-right: 45px;" placeholder="••••••••" required>
                        <i class="bi bi-eye password-toggle" id="toggleIcon" onclick="togglePassword()"></i>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-login">Sign In</button>
            </form>
            
            <div class="register-text">
                Don't have an account? <a href="register.jsp" class="register-link">Sign up</a>
            </div>
        </div>
        
        <p class="text-center mt-4 small text-muted fw-medium">
            &copy; 2026 CheatHub &bull; All Rights Reserved
        </p>
    </div>

    <script>
        function togglePassword() {
            const passwordInput = document.getElementById('passwordInput');
            const toggleIcon = document.getElementById('toggleIcon');
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleIcon.classList.remove('bi-eye');
                toggleIcon.classList.add('bi-eye-slash');
            } else {
                passwordInput.type = 'password';
                toggleIcon.classList.remove('bi-eye-slash');
                toggleIcon.classList.add('bi-eye');
            }
        }
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>