package com.time_float_backend.controller;

import com.time_float_backend.common.Result;
import com.time_float_backend.dto.SendBottleRequest;
import com.time_float_backend.entity.Bottle;
import com.time_float_backend.service.BottleService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bottle")
public class BottleController {

    @Autowired
    private BottleService bottleService;

    @PostMapping("/send")
    public Result<Void> sendBottle(@Valid @RequestBody SendBottleRequest request, HttpServletRequest httpRequest) {
        Long userId = (Long) httpRequest.getAttribute("userId");
        bottleService.sendBottle(userId, request);
        return Result.success("发送成功", null);
    }

    @PostMapping("/pick")
    public Result<Bottle> pickBottle(HttpServletRequest httpRequest) {
        Long userId = (Long) httpRequest.getAttribute("userId");
        Bottle bottle = bottleService.pickBottle(userId);
        return Result.success(bottle);
    }

    @GetMapping("/my")
    public Result<List<Bottle>> getMyBottles(HttpServletRequest httpRequest) {
        Long userId = (Long) httpRequest.getAttribute("userId");
        List<Bottle> bottles = bottleService.getMyBottles(userId);
        return Result.success(bottles);
    }

    @GetMapping("/picked")
    public Result<List<Bottle>> getPickedBottles(HttpServletRequest httpRequest) {
        Long userId = (Long) httpRequest.getAttribute("userId");
        List<Bottle> bottles = bottleService.getPickedBottles(userId);
        return Result.success(bottles);
    }

    @GetMapping("/{id}")
    public Result<Bottle> getBottleDetail(@PathVariable Long id, HttpServletRequest httpRequest) {
        Long userId = (Long) httpRequest.getAttribute("userId");
        Bottle bottle = bottleService.getBottleDetail(id, userId);
        return Result.success(bottle);
    }

    @DeleteMapping("/{id}")
    public Result<Void> deleteBottle(@PathVariable Long id, HttpServletRequest httpRequest) {
        Long userId = (Long) httpRequest.getAttribute("userId");
        bottleService.deleteBottle(id, userId);
        return Result.success("删除成功", null);
    }
}
