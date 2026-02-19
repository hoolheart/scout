# AppNotes - Markdown Editor

一个现代化的桌面 Markdown 编辑器，支持 Windows、macOS 和 Linux。

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

---

## 项目概述

AppNotes 是一个本地优先的跨平台 Markdown 笔记桌面应用，使用 Rust + Flutter 技术栈构建。

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

## 功能特性

- 📝 **实时预览**: 编辑 Markdown 时即时预览渲染效果
- 📁 **文件夹工作区**: 打开整个文件夹作为工作区，方便管理文档
- 🎨 **主题切换**: 支持亮色和暗色主题
- 💾 **自动保存**: 自动保存您的更改，无需担心丢失内容
- 🔍 **文件树浏览**: 直观的文件树界面，支持展开/折叠
- ⌨️ **快捷键支持**: 丰富的键盘快捷键提高编辑效率
- 🖥️ **跨平台**: 支持 Windows、macOS 和 Linux

---

## 系统要求

### Windows
- Windows 10 或更高版本
- 64 位处理器

### macOS
- macOS 10.14 或更高版本
- Intel 或 Apple Silicon 处理器

### Linux
- Ubuntu 20.04 或兼容发行版
- 64 位处理器
- GTK 3.0 或更高版本

---

## 安装说明

### Windows

#### 方法一：使用安装程序（推荐）
1. 下载 `appnotes-1.0.0-setup.exe`
2. 运行安装程序并按照提示完成安装
3. 从开始菜单或桌面快捷方式启动 AppNotes

#### 方法二：便携版
1. 下载 `appnotes-1.0.0-windows.zip`
2. 解压到任意目录
3. 运行 `app_notes.exe`

#### 方法三：Microsoft Store
通过 Microsoft Store 安装（即将推出）

### macOS

#### 方法一：DMG 安装（推荐）
1. 下载 `appnotes-1.0.0.dmg`
2. 双击打开 DMG 文件
3. 将 AppNotes 拖到 Applications 文件夹
4. 从 Applications 启动 AppNotes

#### 方法二：Homebrew
```bash
brew install --cask appnotes
```

### Linux

#### 方法一：DEB 包（Ubuntu/Debian）
```bash
sudo dpkg -i appnotes-1.0.0.deb
sudo apt-get install -f  # 安装依赖
```

#### 方法二：Tarball
```bash
tar -xzf appnotes-1.0.0-linux-x64.tar.gz
cd appnotes
./app_notes
```

#### 方法三：AppImage（即将推出）
```bash
chmod +x appnotes-1.0.0.AppImage
./appnotes-1.0.0.AppImage
```

---

## 使用指南

### 快速开始

1. **打开文件夹**: 点击侧边栏的 "Open Folder" 按钮或按 `Ctrl+O` 选择一个文件夹作为工作区
2. **创建文件**: 点击 "New File" 按钮或右键点击文件夹选择 "New File"
3. **编辑文档**: 点击文件在编辑器中打开，开始编写 Markdown
4. **预览效果**: 右侧实时预览区域会显示渲染后的效果
5. **保存文件**: 按 `Ctrl+S` 保存当前文件

### 界面说明

```
┌─────────────────────────────────────────────────────────┐
│  AppNotes - Markdown Editor                    ─ □ ✕   │
├────────┬────────────────────────────────────────────────┤
│        │  file1.md  file2.md  ●file3.md          ×      │
│  📁    ├────────────────────────────────────────────────┤
│  docs  │                                                │
│   ├─a.md│  # Hello World                               │
│   └─b.md│                                              │
│  note.md│  This is a **markdown** document.            │
│        │                                                │
│        │  - Item 1                                    │
│        │  - Item 2                                    │
│        │                                                │
├────────┤────────────────────────────────────────────────┤
│ 🔍     │  # Hello World                                 │
├────────┤                                                │
│        │  This is a **markdown** document.              │
│        │                                                │
│        │  • Item 1                                      │
│        │  • Item 2                                      │
│        │                                                │
└────────┴────────────────────────────────────────────────┘
/workspace/docs/note.md                    UTF-8   LF   Saved
Ln 5, Col 12                    156 chars | 25 words
```

### Markdown 支持

AppNotes 支持标准的 Markdown 语法：

- 标题 (`# H1`, `## H2`, 等)
- 粗体和斜体 (`**bold**`, `*italic*`)
- 列表 (有序和无序)
- 链接和图片 (`[text](url)`, `![alt](image)`)
- 代码块 (行内和块级)
- 表格
- 引用块
- 任务列表

---

## 快捷键列表

### 文件操作

| 快捷键 | 功能 |
|--------|------|
| `Ctrl + O` | 打开文件夹 |
| `Ctrl + N` | 新建文件 |
| `Ctrl + S` | 保存当前文件 |
| `Ctrl + Shift + S` | 另存为 |
| `Ctrl + W` | 关闭当前文件 |
| `Ctrl + Shift + W` | 关闭所有文件 |
| `Ctrl + Q` | 退出应用 |

### 编辑操作

| 快捷键 | 功能 |
|--------|------|
| `Ctrl + Z` | 撤销 |
| `Ctrl + Shift + Z` | 重做 |
| `Ctrl + X` | 剪切 |
| `Ctrl + C` | 复制 |
| `Ctrl + V` | 粘贴 |
| `Ctrl + A` | 全选 |
| `Ctrl + F` | 查找 |
| `Ctrl + H` | 替换 |

### 视图操作

| 快捷键 | 功能 |
|--------|------|
| `Ctrl + =` / `Ctrl + +` | 放大字体 |
| `Ctrl + -` | 缩小字体 |
| `Ctrl + 0` | 重置字体大小 |
| `Ctrl + B` | 切换侧边栏 |
| `Ctrl + P` | 切换预览 |
| `F11` | 全屏模式 |

### 窗口导航

| 快捷键 | 功能 |
|--------|------|
| `Ctrl + Tab` | 切换到下一个文件 |
| `Ctrl + Shift + Tab` | 切换到上一个文件 |
| `Ctrl + 1-9` | 切换到第 N 个文件 |

---

## 开发构建

### 环境要求

- Flutter SDK 3.11.0 或更高版本
- Dart SDK 3.0 或更高版本
- Rust toolchain (用于 FFI 功能)

### 构建步骤

1. **克隆仓库**
```bash
git clone https://github.com/yourusername/appnotes.git
cd appnotes
```

2. **获取依赖**
```bash
flutter pub get
```

3. **生成代码**
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **运行应用**
```bash
flutter run
```

5. **构建发布版本**

**Windows:**
```bash
flutter build windows --release
```

**macOS:**
```bash
flutter build macos --release
```

**Linux:**
```bash
flutter build linux --release
```

### 运行测试

```bash
# 运行所有测试
./scripts/test.sh

# 或直接使用 flutter
flutter test

# 生成覆盖率报告
./scripts/test.sh --coverage
```

### 使用构建脚本

```bash
# 构建当前平台
./scripts/build.sh

# 构建特定平台
./scripts/build.sh --platform windows
./scripts/build.sh --platform macos
./scripts/build.sh --platform linux

# 创建安装包
./scripts/package.sh --platform all --version 1.0.0
```

---

## 项目结构

```
app_notes/
├── lib/                    # Dart 源代码
│   ├── main.dart          # 应用入口
│   ├── app.dart           # 应用配置
│   ├── models/            # 数据模型
│   ├── state/             # 状态管理 (Riverpod)
│   ├── services/          # 服务层
│   └── ui/                # UI 组件
│       ├── layout/        # 布局组件
│       └── widgets/       # 可复用组件
├── test/                  # 测试文件
│   ├── models_test.dart
│   ├── state_test.dart
│   ├── services/
│   │   ├── file_service_test.dart
│   │   └── rust_service_test.dart
│   └── ui/
│       ├── file_tree_view_test.dart
│       ├── sidebar_test.dart
│       └── status_bar_test.dart
├── windows/               # Windows 平台配置
├── macos/                 # macOS 平台配置
├── linux/                 # Linux 平台配置
├── scripts/               # 构建脚本
│   ├── build.sh
│   ├── package.sh
│   └── test.sh
└── assets/                # 静态资源
```

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

## 许可证

本项目基于 MIT 许可证开源 - 查看 [LICENSE](LICENSE) 文件了解详情。

---

## 支持

如有问题，请参考:
1. 对应模块的设计文档
2. 任务分解中的验收标准
3. 快速开始中的常见问题

---

**项目状态**: 开发中  
**文档版本**: 1.1  
**最后更新**: 2024-02-19

**享受写作！** ✨
