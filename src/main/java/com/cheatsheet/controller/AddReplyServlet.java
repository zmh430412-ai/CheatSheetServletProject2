package com.cheatsheet.controller;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cheatsheet.dao.CommentDAO;
import com.cheatsheet.dao.NotificationDAO; // ★ NotificationDAO ကို Import လုပ်ပါ
import com.cheatsheet.model.Comment;       // ★ Comment Model ကို Import လုပ်ပါ

@WebServlet("/addReply")
public class AddReplyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("userRole");
        
        // Admin ဟုတ်မဟုတ် စစ်ဆေးခြင်း
        if (!"admin".equals(userRole)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int sheetId = Integer.parseInt(request.getParameter("sheetId"));
        int catId = Integer.parseInt(request.getParameter("catId"));
        int parentId = Integer.parseInt(request.getParameter("parentId"));
        int userId = (Integer) session.getAttribute("userId");
        String replyText = request.getParameter("replyText");

        // ၁။ Reply ကို comments table ထဲသို့ အရင်ဆုံး Insert လုပ်ခြင်း
        CommentDAO dao = new CommentDAO();
        dao.insertReply(sheetId, userId, replyText, parentId);

        // ၂။ ★ [ADDED FOR NOTIFICATION] မူလ Comment ပိုင်ရှင်ဆီသို့ Notification ပို့ရန် Logic
        try {
            // မူလ Comment Object ကို ဆွဲထုတ်ပြီး မည်သည့် User ရေးခဲ့သည်ကို ရှာဖွေခြင်း
            // (မှတ်ချက် - သင့် CommentDAO ထဲတွင် getCommentById မက်သတ် မရှိသေးပါက အောက်ပါအတိုင်း အမြန်ဆောက်ပေးရန် လိုအပ်ပါသည်)
            Comment originalComment = dao.getCommentById(parentId); 
            
            if (originalComment != null) {
                int originalUserId = originalComment.getUserId(); // မူလ ကွန်မန့်ပေးသူ၏ ID
                
                // Admin ကိုယ်တိုင်ပေးတဲ့ ကွန်မန့်ကို Admin က ပြန် Reply လုပ်တာမျိုး မဟုတ်မှသာ Noti တက်စေရန်
                if (originalUserId != userId) { 
                    NotificationDAO notiDao = new NotificationDAO();
                    String notiMessage = "Admin replied to your comment: \"" + originalComment.getCommentText() + "\"";
                    
                    notiDao.addNotification(originalUserId, sheetId, notiMessage);
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // Notification ထည့်ရာတွင် Error တက်သော်လည်း Reply Process မရပ်တန့်စေရန် ကာကွယ်ခြင်း
        }

        // မူလ စာမျက်နှာဆီ Script နဲ့ ပြန်လှည့်မယ် (အောက်က View ပိုင်းမှာ သုံးမယ့် session တွေအတွက်)
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<script>");
        out.println("sessionStorage.setItem('openCommentSection', 'collapseComments-" + sheetId + "');");
        out.println("window.parent.location.reload();");
        out.println("<script>");
    }
}