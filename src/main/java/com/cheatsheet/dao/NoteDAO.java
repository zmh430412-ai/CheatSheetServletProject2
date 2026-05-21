package com.cheatsheet.dao;

import java.sql.*;
import java.util.*;
import com.cheatsheet.config.DBConnection;

public class NoteDAO {
    
    public void saveNote(int userId, String title, String content) {
        String sql = "INSERT INTO my_notes (user_id, title, content) VALUES (?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setString(3, content);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    public List<Map<String, String>> getNotesByUserId(int userId) {
        List<Map<String, String>> list = new ArrayList<>();
        // ပြင်ဆင်ရန်- id ကိုပါ SELECT ထဲ ထည့်ပေးရပါမယ် (ဒါမှ Delete/Edit လုပ်ရင် id မပျောက်မှာပါ)
        String sql = "SELECT id, title, content FROM my_notes WHERE user_id = ? ORDER BY id DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> map = new HashMap<>();
                // ပြင်ဆင်ရန်- id ကို map ထဲ ထည့်ပေးမှ JSP ဘက်မှာ ယူသုံးလို့ရမှာပါ
                map.put("id", String.valueOf(rs.getInt("id"))); 
                map.put("title", rs.getString("title"));
                map.put("content", rs.getString("content"));
                list.add(map);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    
    // Note ဖျက်ခြင်း
    public void deleteNote(String id, String userId) throws Exception {
        try (Connection con = DBConnection.getConnection()) {
            // သတိပြုရန်- Table name ကို my_notes လို့ ညှိထားပါတယ်
            String sql = "DELETE FROM my_notes WHERE id = ? AND user_id = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            
            ps.setInt(1, Integer.parseInt(id));
            ps.setString(2, userId);
            
            ps.executeUpdate();
        }
    }
    
    public void saveOrUpdateNote(String id, String title, String content, String userId) throws Exception {
        try (Connection con = DBConnection.getConnection()) {
            if (id == null || id.isEmpty()) {
                // INSERT: Table name ကို my_notes လို့ ညှိထားပါတယ်
                String sql = "INSERT INTO my_notes (title, content, user_id) VALUES (?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, title);
                ps.setString(2, content);
                ps.setString(3, userId);
                ps.executeUpdate();
            } else {
                // UPDATE: Table name ကို my_notes လို့ ညှိထားပါတယ်
                String sql = "UPDATE my_notes SET title = ?, content = ? WHERE id = ? AND user_id = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, title);
                ps.setString(2, content);
                ps.setInt(3, Integer.parseInt(id));
                ps.setString(4, userId);
                ps.executeUpdate();
            }
        }
    }
}