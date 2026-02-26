-- 创建数据库
CREATE DATABASE IF NOT EXISTS time_float DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE time_float;

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码(加密)',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- 漂流瓶表
CREATE TABLE IF NOT EXISTS bottles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '漂流瓶ID',
    user_id BIGINT NOT NULL COMMENT '发送者用户ID',
    content TEXT NOT NULL COMMENT '漂流瓶内容',
    image_url VARCHAR(500) COMMENT '图片URL',
    is_picked TINYINT(1) NOT NULL DEFAULT 0 COMMENT '是否已被捞取: 0-否, 1-是',
    picked_user_id BIGINT COMMENT '捞取者用户ID',
    picked_at DATETIME COMMENT '捞取时间',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user_id (user_id),
    INDEX idx_is_picked (is_picked),
    INDEX idx_picked_user_id (picked_user_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (picked_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='漂流瓶表';

-- 回复表
CREATE TABLE IF NOT EXISTS replies (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '回复ID',
    bottle_id BIGINT NOT NULL COMMENT '漂流瓶ID',
    from_user_id BIGINT NOT NULL COMMENT '发送者用户ID',
    to_user_id BIGINT NOT NULL COMMENT '接收者用户ID',
    content TEXT NOT NULL COMMENT '回复内容',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_bottle_id (bottle_id),
    INDEX idx_from_user_id (from_user_id),
    INDEX idx_to_user_id (to_user_id),
    FOREIGN KEY (bottle_id) REFERENCES bottles(id) ON DELETE CASCADE,
    FOREIGN KEY (from_user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (to_user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='回复表';
