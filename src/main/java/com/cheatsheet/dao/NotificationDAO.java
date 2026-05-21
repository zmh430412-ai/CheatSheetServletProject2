package com.cheatsheet.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.cheatsheet.config.DBConnection;
import com.cheatsheet.model.Notification;

public class NotificationDAO {

    // ၁။ Admin က Reply ပြန်လိုက်ချိန်တွင် Noti အသစ်ထည့်ရန်
    public void addNotification(int userId, int sheetId, String message) {
        String sql = "INSERT INTO notifications (user_id, sheet_id, message) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, sheetId);
            ps.setString(3, message);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ၂။ သတ်မှတ်ထားသော User အတွက် Unread ဖြစ်နေသည့် Noti List ကို ဆွဲထုတ်ရန်
    public List<Notification> getUnreadNotificationsByUser(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE user_id = ? AND is_read = 0 ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setId(rs.getInt("id"));
                    n.setUserId(rs.getInt("user_id"));
                    n.setSheetId(rs.getInt("sheet_id"));
                    n.setMessage(rs.getString("message"));
                    n.setRead(rs.getBoolean("is_read"));
                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(n);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ၃။ Noti များကို ဖတ်ပြီးသားအဖြစ် ပြောင်းလဲရန်
    public void markAllAsRead(int userId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}