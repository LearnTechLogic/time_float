package com.time_float_backend.service;

import com.time_float_backend.dto.LoginRequest;
import com.time_float_backend.dto.LoginResponse;
import com.time_float_backend.dto.RegisterRequest;
import com.time_float_backend.entity.User;
import com.time_float_backend.exception.BusinessException;
import com.time_float_backend.mapper.UserMapper;
import com.time_float_backend.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    @Autowired
    private JwtUtil jwtUtil;

    private String encryptPassword(String password) {
        return DigestUtils.md5DigestAsHex(password.getBytes());
    }

    public void register(RegisterRequest request) {
        User existUser = userMapper.findByUsername(request.getUsername());
        if (existUser != null) {
            throw new BusinessException(400, "用户名已存在");
        }

        User user = new User();
        user.setUsername(request.getUsername());
        user.setPassword(encryptPassword(request.getPassword()));
        userMapper.insert(user);
    }

    public LoginResponse login(LoginRequest request) {
        User user = userMapper.findByUsername(request.getUsername());
        if (user == null) {
            throw new BusinessException(400, "用户不存在");
        }

        if (!user.getPassword().equals(encryptPassword(request.getPassword()))) {
            throw new BusinessException(400, "密码错误");
        }

        String token = jwtUtil.generateToken(user.getId(), user.getUsername());
        return new LoginResponse(token, user.getId(), user.getUsername());
    }

    public User getUserById(Long userId) {
        return userMapper.findById(userId);
    }
}
