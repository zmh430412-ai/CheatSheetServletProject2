package com.cheatsheet.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cheatsheet.config.DBConnection;
import com.cheatsheet.model.Category;

public class CategoryDAO {
    
    // ၁။ Categories အားလုံး ဆွဲထုတ်ခြင်း
    public List<Category> getAllCategories() throws SQLException {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM categories";
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(new Category(rs.getInt("id"), rs.getString("name")));
            }
        }
        return list;
    }

    // ၂။ ID ဖြင့် Category Object တစ်ခုလုံး ဆွဲထုတ်ခြင်း (Edit Form တွင် သုံးရန်)
    public Category getCategoryById(int id) {
        String sql = "SELECT * FROM categories WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Category(rs.getInt("id"), rs.getString("name"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ၃။ ★ [FIXED - TEXT ONLY] ID ဖြင့် Category နာမည် (String) သီးသန့်ဆွဲထုတ်ခြင်း (View Sheet တွင် သုံးရန်)
    public String getCategoryNameById(int catId) {
        String name = "Cheat Sheet";
        String sql = "SELECT name FROM categories WHERE id = ?"; 
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, catId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    name = rs.getString("name"); // String value ကို ကွက်တိရယူခြင်း
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return name;
    }

    // ၄။ Category အသစ်ထည့်ခြင်း
    public boolean addCategory(String name) {
        String sql = "INSERT INTO categories (name) VALUES (?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ၅။ Category အမည် ပြင်ဆင်ခြင်း
    public boolean updateCategory(int id, String newName) {
        String sql = "UPDATE categories SET name = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newName);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ၆။ Category ဖျက်ခြင်း
    public boolean deleteCategory(int id) {
        String sql = "DELETE FROM categories WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ၇။ Admin Dashboard အတွက် Stats များ ရယူခြင်း
    public Map<String, Integer> getSystemStats() {
        Map<String, Integer> stats = new HashMap<>();
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM sheets");
            try (ResultSet rs1 = ps1.executeQuery()) {
                if (rs1.next()) stats.put("sheetCount", rs1.getInt(1));
            }

            PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) FROM users");
            try (ResultSet rs2 = ps2.executeQuery()) {
                if (rs2.next()) stats.put("userCount", rs2.getInt(1));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }
}