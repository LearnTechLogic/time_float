package com.time_float_backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class SendBottleRequest {
    @NotBlank(message = "内容不能为空")
    @Size(max = 500, message = "内容不能超过500字")
    private String content;

    private String imageUrl;

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
}
