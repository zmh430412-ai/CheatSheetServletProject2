package com.cheatsheet.controller;


import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.cheatsheet.dao.NoteDAO;

@WebServlet("/deleteNote")
public class DeleteNoteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NoteDAO dao = new NoteDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Integer userId = (Integer) req.getSession().getAttribute("userId");
        if (userId == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String id = req.getParameter("id"); // URL query string ကနေ id ကို ယူမယ်

        try {
            dao.deleteNote(id, String.valueOf(userId));
            resp.sendRedirect("myNotes"); // ဖျက်ပြီးရင် list page ကို ပြန်သွားမယ်
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().print("Error deleting note: " + e.getMessage());
        }
    }
}
