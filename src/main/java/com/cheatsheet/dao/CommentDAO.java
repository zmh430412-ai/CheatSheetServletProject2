package com.cheatsheet.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.cheatsheet.config.DBConnection;
import com.cheatsheet.model.Comment;

public class CommentDAO {
    
    // ၁။ User က Comment အသစ်သိမ်းရန် (is_read ကို 0 ဟု သတ်မှတ်ပြီး Admin ဆီ Noti တက်စေမည်)
    public boolean addComment(Comment comment) {
        String sql = "INSERT INTO comments (sheet_id, user_id, comment_text, is_read) VALUES (?, ?, ?, 0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, comment.getSheetId());
            ps.setInt(2, comment.getUserId());
            ps.setString(3, comment.getCommentText());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return false;
    }

    // ၂။ Sheet တစ်ခုချင်းစီရဲ့ Main Comment များကိုသာ ယူရန် (parent_id IS NULL ဖြစ်သော ကွန်မန့်များ)
    public List<Comment> getMainCommentsBySheetId(int sheetId) {
        List<Comment> list = new ArrayList<>();
        String sql = "SELECT c.*, u.username FROM comments c JOIN users u ON c.user_id = u.id WHERE c.sheet_id = ? AND c.parent_id IS NULL ORDER BY c.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sheetId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Comment c = new Comment();
                c.setId(rs.getInt("id"));
                c.setSheetId(rs.getInt("sheet_id"));
                c.setUserId(rs.getInt("user_id"));
                c.setCommentText(rs.getString("comment_text"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                c.setUsername(rs.getString("username"));
                // Model တွင် parentId နှင့် isRead ဖန်တီးထားပါက Setter များ ဖွင့်ပေးနိုင်သည်
                c.setParentId((Integer) rs.getObject("parent_id")); 
                c.setRead(rs.getBoolean("is_read"));
                list.add(c);
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // ၃။ Main Comment တစ်ခုချင်းစီ၏အောက်က Admin Reply များကို ဆွဲထုတ်ရန်
    public List<Comment> getRepliesByCommentId(int commentId) {
        List<Comment> list = new ArrayList<>();
        String sql = "SELECT c.*, u.username FROM comments c JOIN users u ON c.user_id = u.id WHERE c.parent_id = ? ORDER BY c.created_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Comment c = new Comment();
                c.setId(rs.getInt("id"));
                c.setSheetId(rs.getInt("sheet_id"));
                c.setUserId(rs.getInt("user_id"));
                c.setCommentText(rs.getString("comment_text"));
                c.setCreatedAt(rs.getTimestamp("created_at"));
                c.setUsername(rs.getString("username"));
                c.setParentId(rs.getInt("parent_id"));
                c.setRead(rs.getBoolean("is_read"));
                list.add(c);
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    // ၄။ Admin ဘက်ကနေ Reply ပြန်လည်သိမ်းဆည်းရန်
    public boolean insertReply(int sheetId, int userId, String text, int parentId) {
        String sql = "INSERT INTO comments (sheet_id, user_id, comment_text, parent_id, is_read) VALUES (?, ?, ?, ?, 1)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sheetId);
            ps.setInt(2, userId);
            ps.setString(3, text);
            ps.setInt(4, parentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return false;
    }

    // ၅။ Admin ဘက်တွင် ပြသရန်အတွက် ဖတ်မရသေးသော (is_read = 0) Noti အရေအတွက်ကို ရယူရန်
    public int getUnreadNotificationCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM comments WHERE parent_id IS NULL AND is_read = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return count;
    }

    // ၆။ Admin က Noti Panel ထဲ ဝင်ကြည့်လိုက်လျှင် Unread ဖြစ်နေသမျှကို အားလုံးဖတ်ပြီးသား (Read) ပြောင်းရန်
    public void markAllAsRead() {
        String sql = "UPDATE comments SET is_read = 1 WHERE parent_id IS NULL AND is_read = 0";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.executeUpdate();
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
    }

    // ၇။ User က မိမိကိုယ်ပိုင် Comment ကို ပြန်ပြင်ရန်
    public boolean updateComment(int commentId, String newText) {
        String sql = "UPDATE comments SET comment_text = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newText);
            ps.setInt(2, commentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ၈။ User က မိမိကိုယ်ပိုင် Comment ကို ပြန်ဖျက်ရန်
    public boolean deleteComment(int commentId) {
        String sql = "DELETE FROM comments WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ၉။ Admin အခွင့်အာဏာဖြင့် မည်သည့် Comment / Reply ကိုမဆို ဖျက်ရန် 
    // (Database တွင် ON DELETE CASCADE ချိတ်ခဲ့၍ Main Comment ဖျက်လျှင် Reply များပါ အလိုအလျောက် ပျက်မည်ဖြစ်သည်)
    public boolean deleteCommentByAdmin(int commentId) {
        String sql = "DELETE FROM comments WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public Comment getCommentById(int commentId) {
        Comment c = null;
        String sql = "SELECT * FROM comments WHERE id = ?";
        try (Connection conn = com.cheatsheet.config.DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, commentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    c = new Comment();
                    c.setId(rs.getInt("id"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setSheetId(rs.getInt("sheet_id"));
                    c.setCommentText(rs.getString("comment_text"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return c;
    }
    // ဟောင်းနွမ်းနေသော getCommentsBySheetId Method နေရာတွင် getMainCommentsBySheetId ကို အစားထိုးသုံးစွဲသွားမည်ဖြစ်ပါသည်
}