package com.cheatsheet.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cheatsheet.config.DBConnection;

public class FavoriteDAO {
    
    public boolean isFavorite(int userId, int sheetId) {
        String sql = "SELECT 1 FROM favorites WHERE user_id = ? AND sheet_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, sheetId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    public boolean addFavorite(int userId, int sheetId) {
        String sql = "INSERT INTO favorites (user_id, sheet_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, sheetId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean removeFavorite(int userId, int sheetId) {
        String sql = "DELETE FROM favorites WHERE user_id = ? AND sheet_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, sheetId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Map<String, String>> getFavoritesByUser(int userId) {
        List<Map<String, String>> list = new ArrayList<>();
        // s.description နဲ့ s.code_content ကိုပါ SQL မှာ ထပ်တိုးယူထားပါတယ်
        String sql = "SELECT s.id as sheet_id, s.title, s.description, s.code_content, s.category_id, c.name as cat_name FROM sheets s " +
                     "JOIN favorites f ON s.id = f.sheet_id " +
                     "JOIN categories c ON s.category_id = c.id " +
                     "WHERE f.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> map = new HashMap<>();
                    map.put("sheet_id", rs.getString("sheet_id"));
                    map.put("title", rs.getString("title"));
                    map.put("description", rs.getString("description")); // ထပ်တိုး
                    map.put("code_content", rs.getString("code_content")); // ထပ်တိုး
                    map.put("cat_id", rs.getString("category_id"));
                    map.put("category", rs.getString("cat_name"));
                    list.add(map);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}