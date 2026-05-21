package com.cheatsheet.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// ★ URL Mapping မှန်ကန်စွာ ပါရှိရပါမည် (Case Sensitive ဖြစ်လို့ စာလုံးအကြီးအသေး သတိပြုပါ)
@WebServlet("/manageComments")
public class ManageCommentsServlet extends HttpServlet {
	 private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // ဒီနေရာမှာ လောလောဆယ် Admin Comment Manage Page သို့ တိုက်ရိုက် သွားခိုင်းထားပါမယ်
        // (နောင်တွင် Database မှ Unread Comments များကို ဆွဲထုတ်ပြီး Request ၌ ထည့်ပေးမည့် Logic ရေးရန်)
        
        request.getRequestDispatcher("manageComments.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}