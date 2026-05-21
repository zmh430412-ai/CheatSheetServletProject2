package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // လက်ရှိရှိနေတဲ့ Session ကို ယူမယ်
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            session.invalidate(); // Session ကို ဖျက်ဆီးလိုက်တာ (Logout လုပ်လိုက်တာ)
        }
        
        // Login စာမျက်နှာကို ပြန်မောင်းထုတ်မယ်
        response.sendRedirect("login.jsp");
    }
}
