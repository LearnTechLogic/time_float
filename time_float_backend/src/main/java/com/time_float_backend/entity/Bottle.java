package com.time_float_backend.entity;

import java.time.LocalDateTime;

public class Bottle {
    private Long id;
    private Long userId;
    private String content;
    private String imageUrl;
    private Boolean isPicked;
    private Long pickedUserId;
    private LocalDateTime pickedAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    private String username;
    private String pickedUsername;

    public Bottle() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Boolean getIsPicked() {
        return isPicked;
    }

    public void setIsPicked(Boolean isPicked) {
        this.isPicked = isPicked;
    }

    public Long getPickedUserId() {
        return pickedUserId;
    }

    public void setPickedUserId(Long pickedUserId) {
        this.pickedUserId = pickedUserId;
    }

    public LocalDateTime getPickedAt() {
        return pickedAt;
    }

    public void setPickedAt(LocalDateTime pickedAt) {
        this.pickedAt = pickedAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPickedUsername() {
        return pickedUsername;
    }

    public void setPickedUsername(String pickedUsername) {
        this.pickedUsername = pickedUsername;
    }
}
