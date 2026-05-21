package com.cheatsheet.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.dao.FavoriteDAO;

@WebServlet("/toggleFavorite")
public class FavoriteServlet extends HttpServlet {
	 private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Session ကနေ UserId ကို ယူမယ်
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int sheetId = Integer.parseInt(request.getParameter("sheetId"));
        FavoriteDAO dao = new FavoriteDAO();

        // Database မှာ ရှိပြီးသားလား အရင်စစ်မယ်
        if (dao.isFavorite(userId, sheetId)) {
            dao.removeFavorite(userId, sheetId); // ရှိရင် ပြန်ဖြုတ် (Unlike)
        } else {
            dao.addFavorite(userId, sheetId);    // မရှိရင် အသစ်ထည့် (Like)
        }
        
        // နဂို Page (viewSheets.jsp) ဆီကိုပဲ ပြန်ပို့ပေးမယ်
        response.sendRedirect(request.getHeader("referer"));
    }
}