package com.cheatsheet.controller;

import java.io.IOException;
import java.util.Map; // ထပ်တိုး
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.dao.CategoryDAO;

@WebServlet("/categories")
public class CategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (req.getSession().getAttribute("user") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        
        try {
            CategoryDAO dao = new CategoryDAO();
            
            // ၁။ မူရင်း Category List ကို ယူတယ်
            req.setAttribute("catList", dao.getAllCategories());
            
            // ၂။ Admin ဖြစ်ခဲ့ရင် Stats (Count) တွေကိုပါ ယူပြီး ထည့်ပေးလိုက်တယ်
            String userRole = (String) req.getSession().getAttribute("userRole");
            if ("admin".equals(userRole)) {
                Map<String, Integer> stats = dao.getSystemStats(); // DAO ထဲမှာ ဒီ method ရှိရမယ်
                req.setAttribute("stats", stats);
            }
            
            req.getRequestDispatcher("home.jsp").forward(req, resp);
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }
}