package com.time_float_backend.controller;

import com.time_float_backend.common.Result;
import com.time_float_backend.dto.SendReplyRequest;
import com.time_float_backend.entity.Reply;
import com.time_float_backend.service.ReplyService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reply")
public class ReplyController {

    @Autowired
    private ReplyService replyService;

    @PostMapping("/send")
    public Result<Void> sendReply(@Valid @RequestBody SendReplyRequest request, HttpServletRequest httpRequest) {
        Long userId = (Long) httpRequest.getAttribute("userId");
        replyService.sendReply(userId, request);
        return Result.success("回复成功", null);
    }

    @GetMapping("/list/{bottleId}")
    public Result<List<Reply>> getReplies(@PathVariable Long bottleId, HttpServletRequest httpRequest) {
        Long userId = (Long) httpRequest.getAttribute("userId");
        List<Reply> replies = replyService.getReplies(bottleId, userId);
        return Result.success(replies);
    }
}
