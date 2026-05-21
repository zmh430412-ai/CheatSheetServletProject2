package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.cheatsheet.dao.NoteDAO;

@WebServlet("/saveNote")
public class SaveNoteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		req.setCharacterEncoding("UTF-8");

		// ၁။ JSP ဘက်က Hidden Field ကနေ ပို့လိုက်တဲ့ ID ကို လက်ခံမယ်
		String id = req.getParameter("id"); 
		String title = req.getParameter("title");
		String content = req.getParameter("content");

		HttpSession session = req.getSession();
		Integer userId = (Integer) session.getAttribute("userId");

		if (userId != null) {
			NoteDAO dao = new NoteDAO();
			
			// ၂။ Flow မပျက်စေဘဲ ID ရှိမရှိပေါ်မူတည်ပြီး DAO ရဲ့ saveOrUpdateNote ကို သုံးမယ်
			try {
				dao.saveOrUpdateNote(id, title, content, String.valueOf(userId));
				resp.sendRedirect("myNotes");
			} catch (Exception e) {
				e.printStackTrace();
				resp.sendRedirect("myNotes.jsp?error=true");
			}
		} else {
			resp.sendRedirect("login.jsp");
		}
	}
}