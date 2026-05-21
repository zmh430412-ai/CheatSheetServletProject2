package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.dao.CommentDAO;
import com.cheatsheet.model.Comment;


@WebServlet("/addComment")
public class AddCommentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            
            int sheetId = Integer.parseInt(request.getParameter("sheetId"));
            int userId = (int) session.getAttribute("userId"); 
            String commentText = request.getParameter("commentText");
            String catId = request.getParameter("catId"); 

            
            Comment comment = new Comment();
            comment.setSheetId(sheetId);
            comment.setUserId(userId);
            comment.setCommentText(commentText);

            
            CommentDAO commentDao = new CommentDAO();
            commentDao.addComment(comment);

           
            response.sendRedirect("viewSheet?id=" + catId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("categories");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("categories"); 
    }
}