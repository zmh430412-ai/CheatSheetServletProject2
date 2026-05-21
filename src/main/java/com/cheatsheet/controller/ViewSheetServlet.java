package com.cheatsheet.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession; 

import com.cheatsheet.dao.CategoryDAO;
import com.cheatsheet.dao.NotificationDAO; 
import com.cheatsheet.dao.SheetDAO;
import com.cheatsheet.model.Sheet;

@WebServlet("/viewSheet")
public class ViewSheetServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        String catName = req.getParameter("name");
        String sheetIdStr = req.getParameter("sheetId"); 

        // ==========================================
        // ၁။ [NOTIFICATION LOGIC] Noti အားလုံးကို ဖတ်ပြီးသားအဖြစ် ပြောင်းလဲခြင်း
        // ==========================================
        HttpSession session = req.getSession();
        if (session.getAttribute("userId") != null) {
            int currentUserId = (Integer) session.getAttribute("userId");
            try {
                NotificationDAO notiDao = new NotificationDAO();
                notiDao.markAllAsRead(currentUserId); 
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        // ==========================================

        SheetDAO dao = new SheetDAO();
        List<Sheet> sheets = new ArrayList<>();
        int catId = 0;

        // ==========================================
        // ၂။ [CORE LOGIC] Cheat Sheet နှင့် Category ID ရှာဖွေခြင်း
        // ==========================================
        if (sheetIdStr != null && !sheetIdStr.isEmpty()) {
            // Noti ကနေ sheetId သီးသန့် ပါလာခဲ့လျှင်
            int sheetId = Integer.parseInt(sheetIdStr);
            
            // Database မှ အဆိုပါ Sheet ကို တိုက်ရိုက်ဆွဲထုတ်ယူခြင်း
            Sheet specificSheet = dao.getSheetById(sheetId); 
            
            if (specificSheet != null) {
                sheets.add(specificSheet);
                catId = specificSheet.getCategoryId(); // မူလ Category ID အမှန်ကို ရယူခြင်း (id=1 ကို Overwrite လုပ်သည်)
            }
        } else if (idParam != null && !idParam.isEmpty()) {
            // ပုံမှန် Dashboard ကနေ Category အလိုက် ဝင်လာပါက
            catId = Integer.parseInt(idParam);
            sheets = dao.getSheetsByCategoryId(catId);
        }

        // ==========================================
        // ၃။ [CATEGORY NAME] Category နာမည်ကို DB တွင် တိကျစွာ ရှာဖွေခြင်း
        // ==========================================
        if (catName == null || catName.isEmpty()) {
            try {
                CategoryDAO catDao = new CategoryDAO();
                catName = catDao.getCategoryNameById(catId); // အပေါ်ကရလာတဲ့ catId အမှန်ဖြင့် ရှာမည်
            } catch (Exception e) {
                catName = "Cheat Sheet"; 
            }
        }

        req.setAttribute("sheetList", sheets);
        req.setAttribute("catName", catName);
        req.getRequestDispatcher("viewSheet.jsp").forward(req, resp);
    }
}