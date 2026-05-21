package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cheatsheet.dao.SheetDAO;
import com.cheatsheet.dao.CategoryDAO; // CategoryDAO ကို import လုပ်ပါ
import com.cheatsheet.model.Category;  // Category model ကို import လုပ်ပါ

@WebServlet("/addSheet")
public class AddSheetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // ၁။ Add Sheet Page ကို သွားတဲ့အခါ Category စာရင်းပါအောင် doGet ထည့်မယ်
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String role = (String) req.getSession().getAttribute("userRole");
        if (!"admin".equals(role)) {
            resp.sendRedirect("login.jsp");
            return;
        }

        try {
            CategoryDAO catDao = new CategoryDAO();
            List<Category> catList = catDao.getAllCategories();
            
            // Category စာရင်းကို request ထဲထည့်ပြီး JSP ဆီ ပို့မယ်
            req.setAttribute("catList", catList);
            req.getRequestDispatcher("addSheet.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("categories");
        }
    }

    // ၂။ လက်ရှိ ရှိပြီးသား doPost (Flow မပြောင်းဘဲ လိုအပ်တာ စစ်ပေးထားပါတယ်)
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String role = (String) req.getSession().getAttribute("userRole");
        if (!"admin".equals(role)) {
            resp.sendRedirect("login.jsp");
            return;
        }

        try {
            int catId = Integer.parseInt(req.getParameter("categoryId"));
            String title = req.getParameter("title");
            String desc = req.getParameter("description");
            String code = req.getParameter("codeContent");

            SheetDAO dao = new SheetDAO();
            if (dao.addSheet(catId, title, desc, code)) {
                resp.sendRedirect("viewSheet?id=" + catId + "&name=Updated");
            } else {
                resp.getWriter().println("Error saving data!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("addSheet"); // Error ဖြစ်ရင် မူလနေရာကို ပြန်ပို့မယ်
        }
    }
}