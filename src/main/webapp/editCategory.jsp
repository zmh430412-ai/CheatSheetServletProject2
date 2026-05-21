<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cheatsheet.model.Category" %>

<%
    // Admin မဟုတ်ရင် ပေးမဝင်ဘူး
    String userRole = (String) session.getAttribute("userRole");
    if (session.getAttribute("user") == null || !"admin".equals(userRole)) {
        response.sendRedirect("categories");
        return;
    }

    // Servlet ကနေ ပို့လိုက်တဲ့ Category Object ကို ယူမယ်
    Category cat = (Category) request.getAttribute("category");
    if (cat == null) {
        response.sendRedirect("categories");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Category - CheatHub</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');

        body { 
            background-color: #f3f4f6; 
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: #1f2937;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
        }

        .edit-card {
            background: #ffffff;
            border-radius: 24px;
            border: 1px solid #e5e7eb;
            width: 100%;
            max-width: 450px;
            padding: 40px;
        }

        .icon-box {
            width: 50px; height: 50px;
            background: #eff6ff;
            color: #2563eb;
            border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 20px;
        }

        .form-label {
            font-weight: 600;
            font-size: 0.85rem;
            color: #4b5563;
            margin-bottom: 8px;
        }

        .form-control {
            border-radius: 12px;
            padding: 12px 15px;
            border: 1px solid #e5e7eb;
            font-size: 1rem;
            background-color: #f9fafb;
            transition: 0.2s;
        }

        .form-control:focus {
            background-color: #fff;
            border-color: #2563eb;
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
            outline: none;
        }

        .btn-update {
            background: #2563eb;
            color: #fff;
            border: none;
            padding: 12px;
            border-radius: 12px;
            font-weight: 600;
            width: 100%;
            transition: 0.3s;
            margin-top: 10px;
        }

        .btn-update:hover {
            background: #1d4ed8;
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(37, 99, 235, 0.3);
        }

        .btn-cancel {
            display: block;
            text-align: center;
            color: #6b7280;
            text-decoration: none;
            font-size: 0.9rem;
            margin-top: 15px;
            font-weight: 500;
        }

        .btn-cancel:hover { color: #1f2937; }
    </style>
</head>
<body>

<div class="edit-card shadow-sm">
    <div class="icon-box">
        <i class="bi bi-pencil-square"></i>
    </div>
    
    <h3 class="fw-bold text-dark mb-1">Edit Category</h3>
    <p class="text-muted small mb-4">Rename your programming language category.</p>

    <form action="editCategory" method="POST">
        <input type="hidden" name="id" value="<%= cat.getId() %>">

        <div class="mb-4">
            <label class="form-label">Category Name</label>
            <input type="text" name="catName" class="form-control" 
                   value="<%= cat.getName() %>" 
                   placeholder="e.g. Kotlin, React Native" required autofocus>
        </div>

        <button type="submit" class="btn btn-update">
            Save Changes
        </button>
        
        <a href="categories" class="btn-cancel">
            <i class="bi bi-x-lg me-1 small"></i> Discard Changes
        </a>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>