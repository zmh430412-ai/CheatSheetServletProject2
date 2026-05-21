package com.cheatsheet.controller;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import com.cheatsheet.dao.UserDAO;

@WebServlet("/updateProfile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Session မရှိရင် Login ကို မောင်းထုတ်မယ်
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String newName = request.getParameter("username");
        Part filePart = request.getPart("profilePic");
        int userId = (int) session.getAttribute("userId"); 
        
        String fileName = null;
        
        // User က ပုံအသစ် ရွေးပြီး တင်ခဲ့သလား စစ်ဆေးခြင်း
        if (filePart != null && filePart.getSize() > 0) {
            fileName = filePart.getSubmittedFileName();
            
            // ပုံသိမ်းမည့်နေရာ လမ်းကြောင်း (webapp/uploads)
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            
            // Server folder ထဲသို့ ပုံကို အပြီးအပိုင် ရေးထည့်ခြင်း
            filePart.write(uploadPath + File.separator + fileName);
        } else {
            // ပုံအသစ် မတင်ခဲ့ရင် Session ထဲက လက်ရှိ ပုံဟောင်းအတိုင်းပဲ ပြန်ထားမယ်
            fileName = (String) session.getAttribute("userImage");
        }

        UserDAO dao = new UserDAO();
        
        // Database ထဲမှာ သွားပြီး Update လုပ်မယ်
        if (dao.updateProfile(userId, newName, fileName)) {
            // Database မှာ အောင်မြင်ရင် လက်ရှိ Session မှာပါ ဒေတာအသစ် ချက်ချင်းလဲပစ်မယ်
            session.setAttribute("user", newName);
            session.setAttribute("userImage", fileName);
            
            // *** ဤနေရာတွင် .jsp မသုံးဘဲ /profile Servlet URL ဆီသို့ သွားခိုင်းလိုက်ပါပြီ ***
            response.sendRedirect("profile?success=1");
        } else {
            response.sendRedirect("profile?error=1");
        }
    }
}