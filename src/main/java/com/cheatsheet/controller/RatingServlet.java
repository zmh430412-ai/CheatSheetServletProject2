package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/submitRating")
public class RatingServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String sheetIdStr = req.getParameter("sheetId");
        String catId = req.getParameter("catId");
        String ratingStr = req.getParameter("rating");
        Integer userId = (Integer) req.getSession().getAttribute("userId");

        if (userId != null && sheetIdStr != null && ratingStr != null) {
            try {
                int sheetId = Integer.parseInt(sheetIdStr);
                int rating = Integer.parseInt(ratingStr);
                
                new com.cheatsheet.dao.RatingDAO().addOrUpdateRating(sheetId, userId, rating);
                // ပေးပြီးရင် မူလ Sheet ဆီ ပြန်သွားမယ်
                resp.sendRedirect("viewSheet?id=" + catId);
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect("categories");
            }
        } else {
            resp.sendRedirect("login.jsp");
        }
    }
}
