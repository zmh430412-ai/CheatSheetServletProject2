package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.cheatsheet.dao.SheetDAO;
import com.cheatsheet.model.Sheet;

@WebServlet("/editSheet")
public class EditSheetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // GET: Edit Form ပြပေးရန်
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        SheetDAO dao = new SheetDAO();
        Sheet sheet = dao.getSheetById(id); // DAO ထဲမှာ ဒီ method ရှိဖို့လိုပါတယ်

        if (sheet != null) {
            request.setAttribute("sheet", sheet);
            request.getRequestDispatcher("editSheet.jsp").forward(request, response);
        } else {
            response.sendRedirect("categories");
        }
    }

    // POST: ပြင်ဆင်ချက်များကို သိမ်းဆည်းရန်
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String codeContent = request.getParameter("codeContent");

        SheetDAO dao = new SheetDAO();
        boolean success = dao.updateSheet(id, title, description, codeContent);

        if (success) {
            // Update အောင်မြင်ရင် မူလ category ဆီ ပြန်သွားမယ်
            response.sendRedirect("categories");
        } else {
            response.sendRedirect("editSheet?id=" + id + "&error=1");
        }
    }
}
