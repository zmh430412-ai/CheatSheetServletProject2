package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.dao.CategoryDAO;

@WebServlet("/addCategory")
public class AddCategoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Form ကနေပို့လိုက်တဲ့ name ကိုယူမယ် (JSP မှာ input name="catName" လို့ပေးထားလို့)
        String catName = request.getParameter("catName");
        
        if (catName != null && !catName.trim().isEmpty()) {
            CategoryDAO dao = new CategoryDAO();
            boolean success = dao.addCategory(catName);
            
            if (success) {
                // အောင်မြင်ရင် Dashboard ဆီ ပြန်ပို့မယ်
                response.sendRedirect("categories");
            } else {
                // မအောင်မြင်ရင် Error တစ်ခုခုပြမယ် (Optional)
                response.sendRedirect("categories?error=failed");
            }
            System.out.println();
        }
    }
}
