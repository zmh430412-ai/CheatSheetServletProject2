package com.cheatsheet.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.cheatsheet.dao.SheetDAO;
import com.cheatsheet.model.Sheet;

@WebServlet("/manageSheets")
public class ManageSheetServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int page = 1; // လက်ရှိစာမျက်နှာ (Default 1)
        int recordsPerPage = 10; // တစ်မျက်နှာမှာ ပြချင်တဲ့ အရေအတွက်
        
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        SheetDAO dao = new SheetDAO();
        
        // Pagination အတွက် Data ဆွဲယူခြင်း
        int offset = (page - 1) * recordsPerPage;
        List<Sheet> list = dao.getSheetsWithPagination(offset, recordsPerPage);
        
        // စုစုပေါင်း စာမျက်နှာအရေအတွက်ကို တွက်ချက်ခြင်း
        int totalRecords = dao.getTotalRecords();
        int noOfPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

        // JSP သို့ Data များ ပို့ပေးခြင်း
        request.setAttribute("allSheets", list);
        request.setAttribute("noOfPages", noOfPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("recordsPerPage", recordsPerPage);

        request.getRequestDispatcher("manage_sheets.jsp").forward(request, response);
    }
}