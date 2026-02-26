package com.time_float_backend.service;

import com.time_float_backend.dto.SendBottleRequest;
import com.time_float_backend.entity.Bottle;
import com.time_float_backend.exception.BusinessException;
import com.time_float_backend.mapper.BottleMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class BottleService {

    @Autowired
    private BottleMapper bottleMapper;

    public void sendBottle(Long userId, SendBottleRequest request) {
        Bottle bottle = new Bottle();
        bottle.setUserId(userId);
        bottle.setContent(request.getContent());
        bottle.setImageUrl(request.getImageUrl());
        bottle.setIsPicked(false);
        bottleMapper.insert(bottle);
    }

    @Transactional
    public Bottle pickBottle(Long userId) {
        Bottle bottle = bottleMapper.pickRandomBottle(userId);
        if (bottle == null) {
            throw new BusinessException(404, "暂时没有漂流瓶可捞取");
        }

        bottle.setIsPicked(true);
        bottle.setPickedUserId(userId);
        bottle.setPickedAt(LocalDateTime.now());
        bottleMapper.update(bottle);

        return bottleMapper.findById(bottle.getId());
    }

    public List<Bottle> getMyBottles(Long userId) {
        return bottleMapper.findByUserId(userId);
    }

    public List<Bottle> getPickedBottles(Long userId) {
        return bottleMapper.findByPickedUserId(userId);
    }

    public Bottle getBottleDetail(Long bottleId, Long userId) {
        Bottle bottle = bottleMapper.findById(bottleId);
        if (bottle == null) {
            throw new BusinessException(404, "漂流瓶不存在");
        }

        if (!bottle.getUserId().equals(userId) && 
            (bottle.getPickedUserId() == null || !bottle.getPickedUserId().equals(userId))) {
            throw new BusinessException(403, "无权查看此漂流瓶");
        }

        return bottle;
    }

    public void deleteBottle(Long bottleId, Long userId) {
        Bottle bottle = bottleMapper.findById(bottleId);
        if (bottle == null) {
            throw new BusinessException(404, "漂流瓶不存在");
        }

        if (!bottle.getUserId().equals(userId)) {
            throw new BusinessException(403, "无权删除此漂流瓶");
        }

        bottleMapper.deleteById(bottleId);
    }
}
