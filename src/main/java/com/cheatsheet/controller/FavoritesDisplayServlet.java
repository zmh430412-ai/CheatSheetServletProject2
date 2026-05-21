package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.dao.FavoriteDAO;

@WebServlet("/displayFavorites") // Sidebar က link နဲ့ တူရပါမယ်
public class FavoritesDisplayServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        FavoriteDAO dao = new FavoriteDAO();
        // DAO ထဲက getFavoritesByUser ကို ခေါ်ပြီး list ထုတ်မယ်
        List<Map<String, String>> favList = dao.getFavoritesByUser(userId);
        
        request.setAttribute("favList", favList);
        // favorites.jsp (အရှေ့မှာ ပေးခဲ့တဲ့ design file) ဆီကို ပို့မယ်
        request.getRequestDispatcher("favorites.jsp").forward(request, response);
    }
}
