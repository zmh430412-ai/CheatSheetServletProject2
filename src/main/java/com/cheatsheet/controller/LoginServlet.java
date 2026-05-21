package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.cheatsheet.dao.UserDAO;
import com.cheatsheet.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String u = req.getParameter("username");
        String p = req.getParameter("password");
        
        try {
            UserDAO dao = new UserDAO();
            User user = dao.checkLogin(u, p);

            if (user != null) {
                HttpSession session = req.getSession();
                
                // Session ထဲမှာ လိုအပ်တဲ့ အချက်အလက်တွေ သိမ်းဆည်းခြင်း
                session.setAttribute("userId", user.getId());
                session.setAttribute("user", u);
                session.setAttribute("userRole", user.getUserRole()); // "admin" သို့မဟုတ် "user"
                session.setAttribute("userImage", user.getProfilePic());
                // Admin ရော User ရော categories ဆီကိုပဲ လွှတ်လိုက်ပါမယ်
                // အဲ့ဒီမှာမှ Admin ဆိုရင် Add/Edit/Delete ခလုတ်တွေ ပေါ်လာမှာပါ
                resp.sendRedirect("categories");

            } else {
                // Login မှားရင် login page ပြန်သွားမယ်
                resp.sendRedirect("login.jsp?error=1");
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
            resp.sendRedirect("login.jsp?error=server");
        }
    }
}