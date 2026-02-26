# 时光漂流瓶项目 - 实施计划

## 项目概述
使用 Flutter（前端）+ Spring Boot（后端）+ MySQL（数据库）开发一个时光漂流瓶应用，用户可以：
- 发送时光漂流瓶（包含文字、图片）
- 随机捞取漂流瓶
- 查看自己发送的漂流瓶
- 回复捞取到的漂流瓶

---

## [x] 任务 1：数据库设计与初始化
- **Priority**: P0
- **Depends On**: None
- **Description**: 
  - 设计数据库表结构（用户表、漂流瓶表、回复表）
  - 创建数据库初始化脚本
  - 配置 MyBatis 实体类和 Mapper
- **Success Criteria**:
  - 数据库表结构完整，包含所有必要字段和索引
  - MyBatis 实体类和 Mapper 正确配置
- **Test Requirements**:
  - `programmatic` TR-1.1: 数据库脚本可以成功执行并创建所有表
  - `programmatic` TR-1.2: MyBatis 配置正确，可以进行基本的 CRUD 操作
- **Notes**: 
  - 用户表：id, username, password, created_at
  - 漂流瓶表：id, user_id, content, image_url, created_at, is_picked, picked_user_id
  - 回复表：id, bottle_id, from_user_id, to_user_id, content, created_at
- **Status**: 已完成

## [x] 任务 2：后端 Spring Boot 基础架构完善
- **Priority**: P0
- **Depends On**: 任务 1
- **Description**:
  - 添加 Spring Web 依赖
  - 配置跨域处理
  - 统一响应结果封装
  - 全局异常处理
  - 添加 JWT 认证支持
- **Success Criteria**:
  - 后端可以正常启动
  - 跨域请求可以正常处理
  - API 响应格式统一
- **Test Requirements**:
  - `programmatic` TR-2.1: 后端服务启动成功，端口正常监听
  - `programmatic` TR-2.2: 可以通过 Postman 测试基础接口返回统一格式
- **Status**: 已完成

## [x] 任务 3：后端用户认证模块开发
- **Priority**: P0
- **Depends On**: 任务 2
- **Description**:
  - 用户注册接口
  - 用户登录接口
  - JWT Token 生成和验证
  - 获取当前用户信息接口
- **Success Criteria**:
  - 用户可以注册和登录
  - JWT Token 验证正常工作
- **Test Requirements**:
  - `programmatic` TR-3.1: 注册接口可以创建新用户
  - `programmatic` TR-3.2: 登录接口可以返回 JWT Token
  - `programmatic` TR-3.3: 受保护的接口需要有效 Token 才能访问
- **Status**: 已完成

## [x] 任务 4：后端漂流瓶核心功能开发
- **Priority**: P0
- **Depends On**: 任务 3
- **Description**:
  - 发送漂流瓶接口
  - 随机捞取漂流瓶接口
  - 获取我的漂流瓶列表接口
  - 获取捞取到的漂流瓶列表接口
  - 删除漂流瓶接口
- **Success Criteria**:
  - 漂流瓶的发送、捞取、查询功能完整
- **Test Requirements**:
  - `programmatic` TR-4.1: 可以成功发送漂流瓶
  - `programmatic` TR-4.2: 可以随机捞取未被捞取的漂流瓶
  - `programmatic` TR-4.3: 可以查询自己发送和捞取的漂流瓶列表
- **Status**: 已完成

## [x] 任务 5：后端漂流瓶回复功能开发
- **Priority**: P1
- **Depends On**: 任务 4
- **Description**:
  - 发送回复接口
  - 获取漂流瓶的回复列表接口
- **Success Criteria**:
  - 用户可以回复漂流瓶并查看回复历史
- **Test Requirements**:
  - `programmatic` TR-5.1: 可以成功发送回复
  - `programmatic` TR-5.2: 可以获取漂流瓶的所有回复
- **Status**: 已完成

## [x] 任务 6：Flutter 前端基础架构搭建
- **Priority**: P0
- **Depends On**: None
- **Description**:
  - 添加必要的依赖（http, provider/shared_preferences, flutter_secure_storage 等）
  - 配置路由管理
  - 创建主题配置
  - 实现 API 请求封装
  - 实现 Token 管理
- **Success Criteria**:
  - 前端项目架构清晰，依赖配置完整
- **Test Requirements**:
  - `human-judgment` TR-6.1: 项目可以正常编译运行
  - `human-judgment` TR-6.2: 基础页面导航正常
- **Status**: 已完成

## [x] 任务 7：Flutter 用户认证页面开发
- **Priority**: P0
- **Depends On**: 任务 3, 任务 6
- **Description**:
  - 登录页面 UI
  - 注册页面 UI
  - 集成登录/注册 API
  - 实现 Token 持久化
- **Success Criteria**:
  - 用户可以在前端完成注册和登录
- **Test Requirements**:
  - `human-judgment` TR-7.1: 登录和注册页面 UI 美观
  - `programmatic` TR-7.2: 可以成功登录并跳转到主页
  - `programmatic` TR-7.3: 登录状态可以持久化保存
- **Status**: 已完成

## [x] 任务 8：Flutter 漂流瓶主页开发
- **Priority**: P0
- **Depends On**: 任务 4, 任务 7
- **Description**:
  - 主页底部导航栏
  - 捞取漂流瓶页面（带有动画效果）
  - 发送漂流瓶页面
  - 我的漂流瓶列表页面
- **Success Criteria**:
  - 主页功能完整，可以进行捞取和发送漂流瓶操作
- **Test Requirements**:
  - `human-judgment` TR-8.1: 页面 UI 美观，交互流畅
  - `programmatic` TR-8.2: 可以成功捞取漂流瓶
  - `programmatic` TR-8.3: 可以成功发送漂流瓶
  - `programmatic` TR-8.4: 可以查看我的漂流瓶列表
- **Status**: 已完成

## [x] 任务 9：Flutter 漂流瓶详情和回复功能开发
- **Priority**: P1
- **Depends On**: 任务 5, 任务 8
- **Description**:
  - 漂流瓶详情页面
  - 回复列表展示
  - 发送回复功能
- **Success Criteria**:
  - 可以查看漂流瓶详情并进行回复
- **Test Requirements**:
  - `human-judgment` TR-9.1: 详情页面 UI 美观
  - `programmatic` TR-9.2: 可以查看回复列表
  - `programmatic` TR-9.3: 可以成功发送回复
- **Status**: 已完成

## [x] 任务 10：整体功能测试与优化
- **Priority**: P1
- **Depends On**: 任务 9
- **Description**:
  - 端到端功能测试
  - 修复发现的 Bug
  - UI/UX 优化
  - 性能优化
- **Success Criteria**:
  - 所有功能正常工作，用户体验良好
- **Test Requirements**:
  - `human-judgment` TR-10.1: 完整流程测试通过（注册→登录→发送→捞取→回复）
  - `human-judgment` TR-10.2: UI 响应流畅，无明显卡顿
- **Status**: 已完成

---

## 项目完成总结

时光漂流瓶项目已全部完成！项目包含完整的前后端功能：

### 后端（Spring Boot）
- ✅ 数据库设计与初始化
- ✅ 用户认证（注册、登录、JWT）
- ✅ 漂流瓶核心功能（发送、捞取、查询、删除）
- ✅ 漂流瓶回复功能

### 前端（Flutter）
- ✅ 基础架构搭建
- ✅ 用户认证页面（登录、注册）
- ✅ 主页底部导航
- ✅ 捞取漂流瓶页面（带动画效果）
- ✅ 发送漂流瓶页面
- ✅ 我的漂流瓶列表
- ✅ 漂流瓶详情和回复页面

### 项目结构
```
Timefloat/
├── time_float_backend/          # Spring Boot 后端
│   ├── src/main/java/
│   │   ├── entity/              # 实体类
│   │   ├── mapper/              # MyBatis Mapper
│   │   ├── dto/                 # 数据传输对象
│   │   ├── service/             # 业务逻辑
│   │   ├── controller/          # 控制器
│   │   ├── common/              # 通用类
│   │   ├── config/              # 配置类
│   │   ├── exception/           # 异常处理
│   │   └── util/                # 工具类
│   └── src/main/resources/
│       ├── schema.sql           # 数据库脚本
│       ├── mapper/              # MyBatis XML映射
│       └── application.yml      # 配置文件
└── time_float_frontend/         # Flutter前端
    └── lib/
        ├── models/              # 数据模型
        ├── services/            # API服务
        ├── providers/           # 状态管理
        ├── screens/             # 页面
        └── utils/               # 工具类
```
