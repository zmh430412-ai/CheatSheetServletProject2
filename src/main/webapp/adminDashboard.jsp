<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Add Cheat Sheet</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

        body { 
            background-color: #f0f2f5; 
            font-family: 'Inter', sans-serif;
            color: #334155;
        }

        .admin-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .card-header {
            background: #0f172a !important; /* Deep Navy Admin Style */
            padding: 20px 25px;
            border-bottom: none;
        }

        .card-header h4 {
            font-weight: 700;
            margin: 0;
            font-size: 1.25rem;
            letter-spacing: -0.5px;
        }

        .card-body {
            padding: 40px;
            background: #ffffff;
        }

        .card-title {
            color: #1e293b;
            font-weight: 600;
            margin-bottom: 25px;
        }

        .form-label {
            font-weight: 600;
            color: #475569;
            font-size: 0.9rem;
            margin-bottom: 8px;
        }

        .form-control {
            border: 1px solid #e2e8f0;
            padding: 12px 15px;
            border-radius: 8px;
            transition: all 0.2s;
            font-size: 0.95rem;
        }

        .form-control:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
        }

        /* Code Textarea Styling */
        textarea[name="codeContent"] {
            background-color: #f8fafc;
            font-family: 'JetBrains Mono', 'Consolas', monospace;
            font-size: 14px;
            color: #1e293b;
            border: 1px dashed #cbd5e1;
        }

        .btn-save {
            background-color: #2563eb;
            border: none;
            padding: 14px;
            font-weight: 600;
            border-radius: 8px;
            transition: background 0.2s;
        }

        .btn-save:hover {
            background-color: #1d4ed8;
        }

        .helper-text {
            font-size: 0.8rem;
            color: #94a3b8;
            margin-top: 4px;
        }

        .logout-link {
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }
        .logout-link:hover {
            color: #be123c !important;
        }
    </style>
</head>
<body>

    <div class="container mt-5 mb-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card admin-card">
                    <div class="card-header text-white d-flex justify-content-between align-items-center">
                        <h4><i class="bi bi-shield-lock me-2"></i>Admin Management</h4>
                        <a href="categories" class="btn btn-outline-light btn-sm px-3 rounded-pill">
                            <i class="bi bi-eye me-1"></i> View as User
                        </a>
                    </div>
                    <div class="card-body">
                        <h5 class="card-title d-flex align-items-center">
                            <i class="bi bi-plus-square-dotted me-2 text-primary"></i>
                            Add New Cheat Sheet Content
                        </h5>
                        
                        <form action="addSheet" method="post">
                            <div class="mb-4">
                                <label class="form-label">Category Assignment</label>
                                <input type="number" name="categoryId" class="form-control" placeholder="Enter ID (1: Java, 2: PHP, 3: SQL)" required>
                                <div class="helper-text">Select the category mapping for this content.</div>
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label">Sheet Title</label>
                                <input type="text" name="title" class="form-control" placeholder="e.g. Lambda Expressions" required>
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label">Short Description</label>
                                <textarea name="description" class="form-control" rows="2" placeholder="Briefly explain what this code snippet does..."></textarea>
                            </div>
                            
                            <div class="mb-4">
                                <label class="form-label">Source Code / Content</label>
                                <textarea name="codeContent" class="form-control" rows="8" 
                                          placeholder="// Paste your code or reference material here..." required></textarea>
                            </div>
                            
                            <div class="d-grid mt-5">
                                <button type="submit" class="btn btn-success btn-save shadow-sm">
                                    <i class="bi bi-cloud-arrow-up me-2"></i>Save to Database
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <div class="text-center mt-4">
                    <a href="logout" class="text-danger logout-link small">
                        <i class="bi bi-box-arrow-right me-1"></i> Sign out from admin session
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>