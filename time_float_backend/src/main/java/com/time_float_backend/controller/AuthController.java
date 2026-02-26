package com.time_float_backend.controller;

import com.time_float_backend.common.Result;
import com.time_float_backend.dto.LoginRequest;
import com.time_float_backend.dto.LoginResponse;
import com.time_float_backend.dto.RegisterRequest;
import com.time_float_backend.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @PostMapping("/register")
    public Result<Void> register(@Valid @RequestBody RegisterRequest request) {
        userService.register(request);
        return Result.success("注册成功", null);
    }

    @PostMapping("/login")
    public Result<LoginResponse> login(@Valid @RequestBody LoginRequest request) {
        LoginResponse response = userService.login(request);
        return Result.success(response);
    }
}
