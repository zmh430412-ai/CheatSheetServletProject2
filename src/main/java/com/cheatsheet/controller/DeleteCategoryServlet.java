package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.dao.CategoryDAO;

@WebServlet("/deleteCategory")
public class DeleteCategoryServlet extends HttpServlet {
	 private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // URL ကပါလာတဲ့ ID ကို ယူမယ် (ဥပမာ- deleteCategory?id=1)
        int id = Integer.parseInt(request.getParameter("id"));
        
        CategoryDAO dao = new CategoryDAO();
        if (dao.deleteCategory(id)) {
            // ဖျက်ပြီးရင် Dashboard ဆီ ပြန်ပို့မယ်
            response.sendRedirect("categories");
        } else {
            response.getWriter().println("Error: Could not delete category.");
        }
    }
}
