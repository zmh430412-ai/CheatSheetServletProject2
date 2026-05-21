package com.cheatsheet.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.cheatsheet.config.DBConnection;

public class RatingDAO {
    // Rating အသစ်ထည့်မယ် (ရှိပြီးသားဆိုရင် Update လုပ်မယ်)
    public void addOrUpdateRating(int sheetId, int userId, int value) throws Exception {
        String sql = "INSERT INTO ratings (sheet_id, user_id, rating_value) VALUES (?, ?, ?) " +
                     "ON DUPLICATE KEY UPDATE rating_value = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sheetId);
            ps.setInt(2, userId);
            ps.setInt(3, value);
            ps.setInt(4, value);
            ps.executeUpdate();
        }
    }

    // ပျမ်းမျှ Rating ကို တွက်ချက်မယ်
    public double getAverageRating(int sheetId) {
        String sql = "SELECT AVG(rating_value) as avg_rating FROM ratings WHERE sheet_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sheetId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("avg_rating");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0.0;
    }
    
    public int getUserRating(int sheetId, int userId) {
        String sql = "SELECT rating_value FROM ratings WHERE sheet_id = ? AND user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, sheetId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("rating_value");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0; // မပေးရသေးရင် ၀ ပြန်မယ်
    }
}