package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.dao.UserDAO;
import com.cheatsheet.model.User;

// RegisterServlet.java
	@WebServlet("/register")
	public class RegisterServlet extends HttpServlet {
		private static final long serialVersionUID = 1L;
	    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
	        User user = new User();
	        user.setUsername(req.getParameter("username"));
	        user.setPassword(req.getParameter("password"));
	        try {
	            new UserDAO().registerUser(user);
	            resp.sendRedirect("login.jsp");
	        } catch (Exception e) { e.printStackTrace(); }
	    }
	}

