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

@WebServlet("/searchSheet")
public class SearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String query = req.getParameter("query");
        SheetDAO dao = new SheetDAO();
        List<Sheet> results = dao.searchSheets(query);

        req.setAttribute("sheetList", results);
        req.setAttribute("catName", "Search Results for: " + query);
        req.getRequestDispatcher("viewSheet.jsp").forward(req, resp);
    }
}
