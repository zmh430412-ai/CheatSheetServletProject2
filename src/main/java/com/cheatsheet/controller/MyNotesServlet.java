package com.cheatsheet.controller;

import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.cheatsheet.dao.NoteDAO;

@WebServlet("/myNotes")
public class MyNotesServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer userId = (Integer) req.getSession().getAttribute("userId");

        if (userId == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        NoteDAO dao = new NoteDAO();
        List<Map<String, String>> noteList = dao.getNotesByUserId(userId);

        req.setAttribute("noteList", noteList);
        req.getRequestDispatcher("myNotes.jsp").forward(req, resp);
    }
    
    
}