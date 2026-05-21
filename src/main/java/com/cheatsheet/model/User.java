package com.cheatsheet.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class User {
	private int id;
    private String username;
    private String password;
    private String userRole;
    private String profilePic;
    // Getters and Setters
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
