package com.cheatsheet.model;

import java.sql.Timestamp;

public class Notification {
    private int id;
    private int userId;
    private int sheetId;
    private String message;
    private boolean isRead;
    private Timestamp createdAt;

    // Getters and Setters အားလုံးကို ထည့်ပေးပါ
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getSheetId() { return sheetId; }
    public void setSheetId(int sheetId) { this.sheetId = sheetId; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public boolean isRead() { return isRead; }
    public void setRead(boolean isRead) { this.isRead = isRead; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
