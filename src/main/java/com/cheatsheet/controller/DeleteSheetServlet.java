package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.dao.SheetDAO;

@WebServlet("/deleteSheet")
public class DeleteSheetServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        SheetDAO dao = new SheetDAO();
        if(dao.deleteSheet(id)) {
            // ဖျက်ပြီးရင် အရင်ကြည့်နေတဲ့ နေရာကိုပဲ ပြန်သွားမယ်
            response.sendRedirect(request.getHeader("Referer"));
        } else {
            response.getWriter().println("Delete Error!");
        }
    }
}
