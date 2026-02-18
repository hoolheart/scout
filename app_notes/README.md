# Markdown 笔记应用 - 项目文档

## 项目概述

一个本地优先的跨平台 Markdown 笔记桌面应用，使用 Rust + Flutter 技术栈构建。

**核心特性**:
- 📝 本地 Markdown 文件编辑
- 📁 文件夹工作区管理
- 👁️ 实时预览
- 🏷️ 多标签页支持
- 🎨 暗色/亮色主题
- ⌨️ 丰富的键盘快捷键

**技术栈**:
- 后端: Rust (flutter_rust_bridge, tokio, notify)
- 前端: Flutter Desktop (flutter_code_editor, riverpod)

---

## 文档导航

| 文档 | 说明 | 目标读者 |
|------|------|----------|
| [PRD.md](./PRD.md) | 产品需求文档 | 所有成员 |
| [ARCHITECTURE.md](./ARCHITECTURE.md) | 架构设计文档 | 架构师、开发者 |
| [TASKS.md](./TASKS.md) | 任务分解列表 | 项目经理、开发者 |
| [QUICK_START.md](./QUICK_START.md) | 快速开始指南 | 新加入开发者 |
| [ROADMAP.md](./ROADMAP.md) | 开发路线图 | 项目经理、所有成员 |

---

## 快速开始

### 1. 阅读 PRD
了解产品需求和用户故事

```bash
cat PRD.md
```

### 2. 理解架构
查看系统架构和模块设计

```bash
cat ARCHITECTURE.md
```

### 3. 查看任务
了解当前 Sprint 的任务分配

```bash
cat TASKS.md
```

### 4. 开始开发
根据角色查看对应的开发指南

```bash
# Rust 开发者
cat QUICK_START.md | grep -A 20 "Rust 开发者"

# Flutter 开发者  
cat QUICK_START.md | grep -A 20 "Flutter 开发者"
```

---

## 项目结构

```
app_notes/
├── PRD.md              # 产品需求文档
├── ARCHITECTURE.md     # 架构设计
├── TASKS.md           # 任务分解
├── QUICK_START.md     # 快速开始
├── ROADMAP.md         # 开发路线图
├── README.md          # 本文件
└── src/               # 源代码（开发中创建）
    ├── rust/          # Rust 后端
    └── flutter/       # Flutter 前端
```

---

## 开发阶段

### 📍 Phase 1: 基础架构 (Week 1-2)
- Rust 项目初始化
- Flutter 项目初始化
- FFI 集成
- 单文件编辑功能

**里程碑**: 可以打开、编辑、保存单个 Markdown 文件

### 📍 Phase 2: 工作区与预览 (Week 3-4)
- 文件夹工作区
- 文件树导航
- 实时预览
- 多标签页

**里程碑**: 完整的文件管理和预览功能

### 📍 Phase 3: 文件操作 (Week 5-6)
- 新建/删除/重命名文件
- 自动保存
- 右键菜单
- 状态栏

**里程碑**: 完善的文件操作和用户体验

### 📍 Phase 4: 完善与发布 (Week 7-8)
- 主题系统
- 键盘快捷键
- 跨平台测试
- 打包发布

**里程碑**: 三平台可用，可安装使用

---

## 角色分工

| 角色 | 职责 | 主要任务 |
|------|------|----------|
| **rust_dev** | Rust 后端开发 | 文件系统、Markdown解析、文件监控 |
| **flutter_dev** | Flutter 逻辑开发 | 状态管理、服务层、业务逻辑 |
| **ui_dev** | Flutter UI 开发 | 界面组件、交互设计、用户体验 |

---

## 关键技术决策

1. **Rust 处理文件系统**: 性能更好，跨平台路径处理统一
2. **Riverpod 状态管理**: 编译时安全，适合大型应用
3. **本地优先架构**: 隐私保护，无网络依赖
4. **分屏布局**: 类似 Typora/Obsidian 的用户体验

详细决策记录请查看 ARCHITECTURE.md 的 Decision Log 部分。

---

## 开发规范

### Git 工作流
- 主分支: `main`
- 功能分支: `feature/T{任务ID}-{描述}`
- 提交信息: `{类型}: {描述} (T{任务ID})`

示例:
```bash
git checkout -b feature/R3-file-system
git commit -m "feat: implement read_file and write_file (R3)"
```

### 代码规范
- Rust: 遵循 `cargo clippy` 建议
- Flutter: 遵循 `flutter_lints` 规则
- 所有代码必须通过 PR 审查

---

## 测试策略

### 单元测试
- Rust: `cargo test`
- Flutter: `flutter test`
- 目标覆盖率: >80%

### 集成测试
- 文件操作流程
- FFI 调用
- UI 交互

### 跨平台测试
- Windows 10/11
- macOS 10.14+
- Ubuntu 20.04+

---

## 发布流程

1. 代码冻结
2. 最终测试
3. 版本号更新
4. 生成 changelog
5. 打包各平台
6. 创建 release
7. 发布文档

---

## 支持

如有问题，请参考:
1. 对应模块的设计文档
2. 任务分解中的验收标准
3. 快速开始中的常见问题

---

**项目状态**: 准备开发  
**文档版本**: 1.0  
**最后更新**: 2024-01-15
