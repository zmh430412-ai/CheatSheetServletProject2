package com.cheatsheet.model;
import java.sql.Timestamp;

public class Comment {
    private int id;
    private int sheetId;
    private int userId;
    private String commentText;
    private Timestamp createdAt;
    private String username; // JSP မှာ ဘယ်သူရေးလဲ ပြဖို့အတွက် Username ပါတစ်ခါတည်းသိမ်းမယ်
    private Integer parentId;
    private boolean isRead;
    
    
    // Getters and Setters များ...
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getSheetId() { return sheetId; }
    public void setSheetId(int sheetId) { this.sheetId = sheetId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getCommentText() { return commentText; }
    public void setCommentText(String commentText) { this.commentText = commentText; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public Integer getParentId() { return parentId; }
    public void setParentId(Integer parentId) { this.parentId = parentId; }
    public boolean isRead() { return isRead; }
    public void setRead(boolean isRead) { this.isRead = isRead; }
}