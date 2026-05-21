package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.cheatsheet.dao.UserDAO;

@WebServlet("/deleteUser")
public class DeleteUserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Security check: Admin ဟုတ်မဟုတ် အရင်စစ်မယ်
        String role = (String) request.getSession().getAttribute("userRole");
        if (!"admin".equals(role)) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            UserDAO dao = new UserDAO();
            
            if (dao.deleteUser(userId)) {
                // ဖျက်ပြီးရင် manageUsers servlet ဆီ ပြန်သွားမယ်
                response.sendRedirect("manageUsers");
            } else {
                response.sendRedirect("manageUsers?error=could_not_delete");
            }
        } catch (Exception e) {
            response.sendRedirect("manageUsers");
        }
    }
}