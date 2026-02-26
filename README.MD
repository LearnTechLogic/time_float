# 时光漂流瓶 (Time Float)

一个使用 Flutter + Spring Boot + MySQL 开发的全栈时光漂流瓶应用，让用户可以发送、捞取和回复漂流瓶，分享生活中的美好瞬间。

## 功能特性

### 📱 用户功能
- 用户注册和登录
- JWT 身份认证
- 发送时光漂流瓶（支持文字内容）
- 随机捞取漂流瓶
- 查看自己发送的漂流瓶
- 查看捞取到的漂流瓶
- 回复漂流瓶
- 删除漂流瓶

### 🛠️ 技术栈
- **前端**: Flutter 3.x + Provider 状态管理
- **后端**: Spring Boot 3.2.10 + MyBatis 3.0.4
- **数据库**: MySQL 8.0+
- **认证**: JWT (JSON Web Token)
- **其他**: Lombok, HikariCP 连接池

## 项目结构

```
Timefloat/
├── time_float_backend/          # Spring Boot 后端
│   ├── src/main/java/com/time_float_backend/
│   │   ├── entity/              # 实体类 (User, Bottle, Reply)
│   │   ├── mapper/              # MyBatis Mapper 接口
│   │   ├── dto/                 # 数据传输对象
│   │   ├── service/             # 业务逻辑层
│   │   ├── controller/          # REST API 控制器
│   │   ├── common/              # 通用类 (Result)
│   │   ├── config/              # 配置类 (CORS, Web)
│   │   ├── exception/           # 异常处理
│   │   ├── interceptor/         # 登录拦截器
│   │   └── util/                # 工具类 (JWT)
│   └── src/main/resources/
│       ├── schema.sql           # 数据库初始化脚本
│       ├── mapper/              # MyBatis XML 映射文件
│       └── application.yml      # 应用配置文件
│
└── time_float_frontend/         # Flutter 前端
    └── lib/
        ├── models/              # 数据模型
        ├── services/            # API 服务封装
        ├── providers/           # 状态管理 (AuthProvider)
        ├── screens/             # UI 页面
        │   ├── login_screen.dart
        │   ├── register_screen.dart
        │   ├── main_screen.dart
        │   ├── pick_bottle_screen.dart
        │   ├── send_bottle_screen.dart
        │   ├── my_bottles_screen.dart
        │   └── bottle_detail_screen.dart
        ├── utils/               # 工具类和常量
        └── main.dart            # 应用入口
```

## 快速开始

### 前置要求
- JDK 17+
- Flutter 3.11.0+
- MySQL 8.0+
- Maven 3.6+

### 1. 数据库配置

创建数据库并执行初始化脚本：

```sql
-- 创建数据库
CREATE DATABASE IF NOT EXISTS time_float DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE time_float;

-- 执行 time_float_backend/src/main/resources/schema.sql 中的表创建脚本
```

修改 `time_float_backend/src/main/resources/application.yml` 中的数据库连接信息：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/time_float?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai&useSSL=false
    username: your_username
    password: your_password
```

### 2. 启动后端服务

```bash
cd time_float_backend
mvn clean spring-boot:run
```

后端服务将在 `http://localhost:8080` 启动。

### 3. 启动前端应用

```bash
cd time_float_frontend
flutter pub get
flutter run
```

## API 接口文档

### 认证接口

| 方法 | 路径 | 描述 | 需要认证 |
|------|------|------|---------|
| POST | `/api/auth/register` | 用户注册 | 否 |
| POST | `/api/auth/login` | 用户登录 | 否 |
| GET | `/api/user/me` | 获取当前用户信息 | 是 |

### 漂流瓶接口

| 方法 | 路径 | 描述 | 需要认证 |
|------|------|------|---------|
| POST | `/api/bottles/send` | 发送漂流瓶 | 是 |
| GET | `/api/bottles/pick` | 随机捞取漂流瓶 | 是 |
| GET | `/api/bottles/my` | 获取我发送的漂流瓶 | 是 |
| GET | `/api/bottles/picked` | 获取我捞取的漂流瓶 | 是 |
| GET | `/api/bottles/{id}` | 获取漂流瓶详情 | 是 |
| DELETE | `/api/bottles/{id}` | 删除漂流瓶 | 是 |

### 回复接口

| 方法 | 路径 | 描述 | 需要认证 |
|------|------|------|---------|
| POST | `/api/replies/send` | 发送回复 | 是 |
| GET | `/api/replies/bottle/{bottleId}` | 获取漂流瓶的回复列表 | 是 |

## 数据库设计

### users (用户表)
| 字段 | 类型 | 描述 |
|------|------|------|
| id | BIGINT | 用户ID (主键) |
| username | VARCHAR(50) | 用户名 (唯一) |
| password | VARCHAR(255) | 密码 (加密) |
| created_at | DATETIME | 创建时间 |
| updated_at | DATETIME | 更新时间 |

### bottles (漂流瓶表)
| 字段 | 类型 | 描述 |
|------|------|------|
| id | BIGINT | 漂流瓶ID (主键) |
| user_id | BIGINT | 发送者用户ID (外键) |
| content | TEXT | 漂流瓶内容 |
| image_url | VARCHAR(500) | 图片URL |
| is_picked | TINYINT(1) | 是否已被捞取 |
| picked_user_id | BIGINT | 捞取者用户ID (外键) |
| picked_at | DATETIME | 捞取时间 |
| created_at | DATETIME | 创建时间 |
| updated_at | DATETIME | 更新时间 |

### replies (回复表)
| 字段 | 类型 | 描述 |
|------|------|------|
| id | BIGINT | 回复ID (主键) |
| bottle_id | BIGINT | 漂流瓶ID (外键) |
| from_user_id | BIGINT | 发送者用户ID (外键) |
| to_user_id | BIGINT | 接收者用户ID (外键) |
| content | TEXT | 回复内容 |
| created_at | DATETIME | 创建时间 |
| updated_at | DATETIME | 更新时间 |

## 开发指南

### 后端开发
- 后端使用 Spring Boot 3.2.10 + MyBatis
- 遵循 RESTful API 设计规范
- 使用 JWT 进行身份认证
- 统一响应格式：`Result<T>`

### 前端开发
- 使用 Provider 进行状态管理
- API 请求通过 `ApiService` 统一封装
- Token 自动管理和刷新
- 响应式设计，支持多平台

## 常见问题

### Q: 后端启动失败，提示 "Property 'sqlSessionFactory' or 'sqlSessionTemplate' are required"
A: 确保使用 Spring Boot 3.2.x 版本，并在 Mapper 接口上添加 `@Mapper` 注解，同时在主类上添加 `@MapperScan` 注解。

### Q: 前端无法连接后端 API
A: 检查后端是否正常启动，确认 CORS 配置正确，以及 API 地址配置是否正确。

### Q: 数据库连接失败
A: 确认 MySQL 服务已启动，数据库已创建，用户名密码配置正确。

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request！
