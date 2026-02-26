package com.time_float_backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class SendReplyRequest {
    @NotNull(message = "漂流瓶ID不能为空")
    private Long bottleId;

    @NotNull(message = "接收者ID不能为空")
    private Long toUserId;

    @NotBlank(message = "内容不能为空")
    @Size(max = 500, message = "内容不能超过500字")
    private String content;

    public Long getBottleId() {
        return bottleId;
    }

    public void setBottleId(Long bottleId) {
        this.bottleId = bottleId;
    }

    public Long getToUserId() {
        return toUserId;
    }

    public void setToUserId(Long toUserId) {
        this.toUserId = toUserId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
