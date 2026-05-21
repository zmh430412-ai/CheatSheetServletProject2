package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.cheatsheet.dao.CommentDAO;

@WebServlet("/editComment")
public class EditCommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // မြန်မာစာလုံးတွေ မပျက်အောင် Character Encoding ထည့်ထားပေးပါတယ်
        request.setCharacterEncoding("UTF-8");
        
        try {
            int commentId = Integer.parseInt(request.getParameter("commentId"));
            String commentText = request.getParameter("commentText");
            String catId = request.getParameter("catId");

            CommentDAO commentDao = new CommentDAO();
            commentDao.updateComment(commentId, commentText);

            // Project Path အမှန်ရအောင် ကပ်ပြီး viewSheetDetails ဆီ ပြန်မောင်းမယ်
            response.sendRedirect(request.getContextPath() + "/viewSheet?id=" + catId);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/categories");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
}