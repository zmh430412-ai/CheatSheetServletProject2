package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.dao.CategoryDAO;


@WebServlet("/editCategory")
public class EditCategoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Modal Form ကနေပို့လိုက်တဲ့ Data တွေကို ယူမယ်
            int id = Integer.parseInt(request.getParameter("id"));
            String newName = request.getParameter("catName");
            
            CategoryDAO dao = new CategoryDAO();
            boolean success = dao.updateCategory(id, newName);
            
            if (success) {
                // အောင်မြင်ရင် Dashboard (home) ဆီ ပြန်ပို့မယ်
                response.sendRedirect("categories");
            } else {
                response.sendRedirect("categories?error=update_failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("categories");
        }
    }
    
    // doGet ကိုတော့ Error မတက်အောင် categories ဆီပဲ ပြန်လွှတ်ထားလိုက်ပါ
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("categories");
    }
}
