package com.cheatsheet.dao;

import java.sql.*;
import java.util.*;
import com.cheatsheet.config.DBConnection;
import com.cheatsheet.model.Sheet;

public class SheetDAO {
    
   
    public List<Sheet> getSheetsByCategoryId(int categoryId) {
        List<Sheet> list = new ArrayList<>();
        String sql = "SELECT * FROM sheets WHERE category_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Sheet s = new Sheet();
                s.setId(rs.getInt("id"));
                s.setTitle(rs.getString("title"));
                s.setDescription(rs.getString("description"));
                s.setCodeContent(rs.getString("code_content"));
                list.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    
    public List<Sheet> searchSheets(String query) {
        List<Sheet> list = new ArrayList<>();
        String sql = "SELECT * FROM sheets WHERE title LIKE ? OR description LIKE ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + query + "%");
            ps.setString(2, "%" + query + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Sheet s = new Sheet();
                s.setId(rs.getInt("id"));
                s.setTitle(rs.getString("title"));
                s.setDescription(rs.getString("description"));
                s.setCodeContent(rs.getString("code_content"));
                list.add(s);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    
    public boolean addSheet(int categoryId, String title, String description, String codeContent) {
        String sql = "INSERT INTO sheets (category_id, title, description, code_content) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setString(2, title);
            ps.setString(3, description);
            ps.setString(4, codeContent);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    
    public boolean deleteSheet(int id) {
        String sql = "DELETE FROM sheets WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    
    public Sheet getSheetById(int id) {
        String sql = "SELECT * FROM sheets WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Sheet s = new Sheet();
                s.setId(rs.getInt("id"));
                s.setTitle(rs.getString("title"));
                s.setDescription(rs.getString("description"));
                s.setCodeContent(rs.getString("code_content"));
                return s;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    
    public boolean updateSheet(int id, String title, String description, String codeContent) {
        String sql = "UPDATE sheets SET title=?, description=?, code_content=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, description);
            ps.setString(3, codeContent);
            ps.setInt(4, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
    public List<Sheet> getAllSheets() {
        List<Sheet> list = new ArrayList<>();
        
        String sql = "SELECT s.*, c.name AS category_name FROM sheets s " +
                     "JOIN categories c ON s.category_id = c.id ORDER BY s.id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Sheet s = new Sheet();
                s.setId(rs.getInt("id"));
                s.setTitle(rs.getString("title"));
                s.setDescription(rs.getString("description"));
                s.setCodeContent(rs.getString("code_content"));
                s.setCategoryId(rs.getInt("category_id"));
                
                
                s.setCategoryName(rs.getString("category_name")); 
                
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Sheet> getSheetsWithPagination(int offset, int noOfRecords) {
        List<Sheet> list = new ArrayList<>();
        String sql = "SELECT s.*, c.name AS category_name FROM sheets s " +
                     "JOIN categories c ON s.category_id = c.id " +
                     "ORDER BY s.id DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, noOfRecords); 
            ps.setInt(2, offset);      
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Sheet s = new Sheet();
                    s.setId(rs.getInt("id"));
                    s.setTitle(rs.getString("title"));
                    s.setDescription(rs.getString("description"));
                    s.setCategoryName(rs.getString("category_name"));
                    list.add(s);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

   
    public int getTotalRecords() {
        int total = 0;
        String sql = "SELECT COUNT(*) FROM sheets";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) total = rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return total;
    }
    
}