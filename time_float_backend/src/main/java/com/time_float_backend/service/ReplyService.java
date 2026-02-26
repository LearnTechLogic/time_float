package com.time_float_backend.service;

import com.time_float_backend.dto.SendReplyRequest;
import com.time_float_backend.entity.Bottle;
import com.time_float_backend.entity.Reply;
import com.time_float_backend.exception.BusinessException;
import com.time_float_backend.mapper.BottleMapper;
import com.time_float_backend.mapper.ReplyMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReplyService {

    @Autowired
    private ReplyMapper replyMapper;

    @Autowired
    private BottleMapper bottleMapper;

    public void sendReply(Long fromUserId, SendReplyRequest request) {
        Bottle bottle = bottleMapper.findById(request.getBottleId());
        if (bottle == null) {
            throw new BusinessException(404, "漂流瓶不存在");
        }

        if (!bottle.getUserId().equals(fromUserId) && 
            (bottle.getPickedUserId() == null || !bottle.getPickedUserId().equals(fromUserId))) {
            throw new BusinessException(403, "无权回复此漂流瓶");
        }

        if (!bottle.getUserId().equals(request.getToUserId()) && 
            (bottle.getPickedUserId() == null || !bottle.getPickedUserId().equals(request.getToUserId()))) {
            throw new BusinessException(400, "接收者不正确");
        }

        Reply reply = new Reply();
        reply.setBottleId(request.getBottleId());
        reply.setFromUserId(fromUserId);
        reply.setToUserId(request.getToUserId());
        reply.setContent(request.getContent());
        replyMapper.insert(reply);
    }

    public List<Reply> getReplies(Long bottleId, Long userId) {
        Bottle bottle = bottleMapper.findById(bottleId);
        if (bottle == null) {
            throw new BusinessException(404, "漂流瓶不存在");
        }

        if (!bottle.getUserId().equals(userId) && 
            (bottle.getPickedUserId() == null || !bottle.getPickedUserId().equals(userId))) {
            throw new BusinessException(403, "无权查看此漂流瓶的回复");
        }

        return replyMapper.findByBottleId(bottleId);
    }
}
