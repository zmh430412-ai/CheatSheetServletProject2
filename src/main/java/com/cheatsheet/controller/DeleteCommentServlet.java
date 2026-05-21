package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.cheatsheet.dao.CommentDAO;

@WebServlet("/deleteComment")
public class DeleteCommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int commentId = Integer.parseInt(request.getParameter("id"));
            String catId = request.getParameter("catId");

            CommentDAO commentDao = new CommentDAO();
            commentDao.deleteComment(commentId);

            // Project Path အမှန်ရအောင် ကပ်ပြီး viewSheetDetails ဆီ ပြ can မောင်းမယ်
            response.sendRedirect(request.getContextPath() + "/viewSheet?id=" + catId);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/categories");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}