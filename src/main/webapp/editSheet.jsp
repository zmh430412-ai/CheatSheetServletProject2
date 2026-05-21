<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cheatsheet.model.Sheet" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Cheat Sheet</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light p-5">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow border-0">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Edit Cheat Sheet Content</h4>
                </div>
                <div class="card-body p-4">
                    <% Sheet s = (Sheet) request.getAttribute("sheet"); %>
                    <form action="editSheet" method="post">
                        <input type="hidden" name="id" value="<%= s.getId() %>">
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Title</label>
                            <input type="text" name="title" class="form-control" value="<%= s.getTitle() %>" required>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Description</label>
                            <textarea name="description" class="form-control" rows="3"><%= s.getDescription() %></textarea>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Code Content</label>
                            <textarea name="codeContent" class="form-control" rows="8" style="font-family: monospace; background: #f8f9fa;"><%= s.getCodeContent() %></textarea>
                        </div>
                        
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary px-4">Update Changes</button>
                            <a href="categories" class="btn btn-light px-4 border">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>