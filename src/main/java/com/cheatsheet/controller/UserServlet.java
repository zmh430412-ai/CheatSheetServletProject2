package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.dao.UserDAO;

@WebServlet("/manageUsers")
public class UserServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Admin မဟုတ်ရင် ပေးမဝင်ဘူး
        String role = (String) req.getSession().getAttribute("userRole");
        if (!"admin".equals(role)) {
            resp.sendRedirect("categories");
            return;
        }

        UserDAO dao = new UserDAO();
        req.setAttribute("userList", dao.getAllUsers());
        req.getRequestDispatcher("manage-users.jsp").forward(req, resp);
    }
}
