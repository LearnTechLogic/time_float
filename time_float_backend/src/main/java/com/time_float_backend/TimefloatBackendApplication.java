package com.time_float_backend;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.time_float_backend.mapper")
public class TimefloatBackendApplication {

    public static void main(String[] args) {
        SpringApplication.run(TimefloatBackendApplication.class, args);
    }

}
