# Architecture Design: Markdown Note Application

## Overview

### Context
一款本地优先的跨平台 Markdown 笔记桌面应用，提供直观的文件管理、流畅的编辑体验和实时预览功能。数据完全存储在本地，保护用户隐私。

### Scope
**包含:**
- 本地 Markdown 文件读写和管理
- 工作区文件夹树形展示
- 实时编辑与预览
- 多标签页支持
- 主题切换
- 跨平台支持（Windows/macOS/Linux）

**不包含:**
- 云同步功能
- 实时协作编辑
- 插件系统
- 版本控制

---

## System Architecture

### 整体架构图

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          Presentation Layer (Flutter)                   │
├──────────────┬───────────────────────────────────────┬──────────────────┤
│  UI Layer    │           State Management            │   Data Access    │
│              │            (Riverpod)                 │    Layer         │
│ ┌─────────┐  │  ┌─────────────┐  ┌─────────────┐    │  ┌──────────────┐│
│ │  Menu   │  │  │  App State  │  │  Editor     │    │  │ File Picker  ││
│ │  Bar    │  │  │  Providers  │  │  Providers  │    │  │   Service    ││
│ └─────────┘  │  └─────────────┘  └─────────────┘    │  └──────────────┘│
│ ┌─────────┐  │  ┌─────────────┐  ┌─────────────┐    │  ┌──────────────┐│
│ │ Sidebar │  │  │  File Tree  │  │   Preview   │    │  │     FFI      ││
│ │ (Tree)  │  │  │   State     │  │   State     │    │  │   Bridge     ││
│ └─────────┘  │  └─────────────┘  └─────────────┘    │  └──────────────┘│
│ ┌─────────┐  │  ┌─────────────┐  ┌─────────────┐    │                  │
│ │  Tab    │  │  │  Settings   │  │  Workspace  │    │                  │
│ │  Bar    │  │  │   State     │  │   State     │    │                  │
│ └─────────┘  │  └─────────────┘  └─────────────┘    │                  │
│ ┌─────────┐  │                                      │                  │
│ │ Editor  │  │                                      │                  │
│ │ (Code)  │  │                                      │                  │
│ └─────────┘  │                                      │                  │
│ ┌─────────┐  │                                      │                  │
│ │ Preview │  │                                      │                  │
│ │(Render) │  │                                      │                  │
│ └─────────┘  │                                      │                  │
│ ┌─────────┐  │                                      │                  │
│ │ Status  │  │                                      │                  │
│ │  Bar    │  │                                      │                  │
│ └─────────┘  │                                      │                  │
└──────────────┴───────────────────────────────────────┴──────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                    FFI Layer (flutter_rust_bridge)                      │
├─────────────────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                     Rust Backend                                 │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐   │  │
│  │  │ File System  │  │  Markdown    │  │   File Watcher       │   │  │
│  │  │   Service    │  │   Parser     │  │   (notify)           │   │  │
│  │  │              │  │ (pulldown-   │  │                      │   │  │
│  │  │  - Read/Write│  │   cmark)     │  │  - Watch changes     │   │  │
│  │  │  - File ops  │  │              │  │  - Emit events       │   │  │
│  │  │  - Path mgmt │  │  - Parse MD  │  │  - Debounce          │   │  │
│  │  └──────────────┘  │  - To HTML   │  └──────────────────────┘   │  │
│  │                    └──────────────┘                             │  │
│  │  ┌──────────────────────────────────────────────────────────┐  │  │
│  │  │                   Async Runtime (Tokio)                  │  │  │
│  │  │  - I/O operations                                        │  │  │
│  │  │  - File watching                                         │  │  │
│  │  │  - Thread pool                                           │  │  │
│  │  └──────────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         Operating System                                │
├─────────────────────────────────────────────────────────────────────────┤
│                    File System (Local Storage)                          │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Component Design

### 1. Rust 后端组件

#### 1.1 File System Service
- **Responsibility**: 本地文件系统操作，包括文件读写、目录遍历、文件创建/删除/重命名
- **Interface**:
  ```rust
  // File operations
  pub async fn read_file(path: String) -> Result<String, AppError>;
  pub async fn write_file(path: String, content: String) -> Result<(), AppError>;
  pub async fn create_file(path: String) -> Result<(), AppError>;
  pub async fn delete_file(path: String) -> Result<(), AppError>;
  pub async fn rename_file(old_path: String, new_path: String) -> Result<(), AppError>;
  
  // Directory operations
  pub async fn read_dir(path: String) -> Result<Vec<FileEntry>, AppError>;
  pub async fn create_dir(path: String) -> Result<(), AppError>;
  pub async fn delete_dir(path: String) -> Result<(), AppError>;
  
  // Path utilities
  pub fn get_file_name(path: String) -> String;
  pub fn get_parent_dir(path: String) -> Option<String>;
  pub fn join_paths(base: String, relative: String) -> String;
  ```
- **Dependencies**: tokio::fs, std::path::PathBuf
- **Acceptance Criteria**:
  - 所有文件操作都是异步的
  - 正确处理跨平台路径（Windows/Unix）
  - 提供详细的错误信息
  - 支持大文件（>10MB）流式读取

#### 1.2 Markdown Parser Service
- **Responsibility**: Markdown 解析和 HTML 生成
- **Interface**:
  ```rust
  pub fn parse_markdown(content: String) -> ParseResult;
  pub fn parse_to_html(content: String) -> String;
  
  pub struct ParseResult {
      pub html: String,
      pub toc: Vec<Heading>,
      pub word_count: u32,
      pub char_count: u32,
  }
  
  pub struct Heading {
      pub level: u8,
      pub text: String,
      pub anchor: String,
  }
  ```
- **Dependencies**: pulldown-cmark, syntect (for代码高亮)
- **Acceptance Criteria**:
  - 支持 CommonMark 规范
  - 支持 GitHub Flavored Markdown
  - 代码块语法高亮
  - 生成目录（TOC）
  - 字数统计准确

#### 1.3 File Watcher Service
- **Responsibility**: 监控文件系统变化，通知前端
- **Interface**:
  ```rust
  pub async fn watch_directory(path: String) -> Result<WatchHandle, AppError>;
  pub async fn unwatch_directory(handle: WatchHandle) -> Result<(), AppError>;
  
  // Events sent to Flutter
  pub enum FileSystemEvent {
      Created { path: String, is_dir: bool },
      Modified { path: String },
      Deleted { path: String },
      Renamed { old_path: String, new_path: String },
  }
  ```
- **Dependencies**: notify, tokio::sync::mpsc
- **Acceptance Criteria**:
  - 实时监控文件变化
  - 防抖处理（避免频繁触发）
  - 支持递归监控子目录
  - 优雅处理监控错误

#### 1.4 Error Handling Module
- **Responsibility**: 统一的错误类型和处理
- **Interface**:
  ```rust
  #[derive(Debug)]
  pub enum AppError {
      IoError(String),
      ParseError(String),
      WatchError(String),
      NotFound(String),
      PermissionDenied(String),
      InvalidPath(String),
  }
  ```

### 2. Flutter 前端组件

#### 2.1 State Management (Riverpod)

##### App State Provider
```dart
@riverpod
class AppState extends _$AppState {
  AppConfig build() => AppConfig(
    themeMode: ThemeMode.system,
    recentWorkspaces: [],
  );
  
  void setThemeMode(ThemeMode mode);
  void addRecentWorkspace(String path);
}
```

##### Workspace State Provider
```dart
@riverpod
class WorkspaceState extends _$WorkspaceState {
  Workspace? build() => null;
  
  Future<void> openWorkspace(String path);
  Future<void> closeWorkspace();
  Future<void> refreshFileTree();
  
  void handleFileSystemEvent(FileSystemEvent event);
}
```

##### Editor State Provider
```dart
@riverpod
class EditorState extends _$EditorState {
  List<OpenFile> build() => [];
  
  Future<void> openFile(String path);
  Future<void> closeFile(String path);
  Future<void> saveFile(String path, String content);
  void updateContent(String path, String content);
  
  void setActiveTab(String path);
  String? get activeTab;
  bool hasUnsavedChanges(String path);
}
```

##### Preview State Provider
```dart
@riverpod
class PreviewState extends _$PreviewState {
  bool build() => true; // isVisible
  
  void toggleVisibility();
  void setVisibility(bool visible);
}
```

#### 2.2 UI Components

##### Main Layout
```dart
class MainLayout extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: MenuBar(),
      body: Row(
        children: [
          Sidebar(),
          Expanded(
            child: Column(
              children: [
                TabBar(),
                Expanded(
                  child: EditorPane(),
                ),
                StatusBar(),
              ],
            ),
          ),
          if (showPreview) PreviewPane(),
        ],
      ),
    );
  }
}
```

##### Sidebar Component
- **Responsibility**: 文件树展示和导航
- **Features**:
  - 树形结构展示文件夹和文件
  - 展开/折叠文件夹
  - 右键菜单（新建、删除、重命名）
  - 文件图标和类型标识
  - 当前文件高亮

##### Editor Component
- **Responsibility**: Markdown 代码编辑
- **Features**:
  - 语法高亮（flutter_code_editor）
  - 行号显示
  - Tab 缩进（2空格）
  - 撤销/重做
  - 字体缩放

##### Preview Component
- **Responsibility**: Markdown 实时预览
- **Features**:
  - HTML 渲染（flutter_markdown）
  - 代码高亮
  - 滚动同步（可选）
  - 样式主题

#### 2.3 Services

##### File Picker Service
```dart
class FilePickerService {
  Future<String?> pickFile();
  Future<String?> pickDirectory();
  Future<String?> saveFileAs();
}
```

##### Settings Service
```dart
class SettingsService {
  Future<AppSettings> loadSettings();
  Future<void> saveSettings(AppSettings settings);
}
```

### 3. FFI Bridge (flutter_rust_bridge)

#### API 定义
```rust
#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Initialize tokio runtime
}

// File operations
pub fn read_file(path: String) -> Result<String, String>;
pub fn write_file(path: String, content: String) -> Result<(), String>;
pub fn create_file(path: String) -> Result<(), String>;
pub fn delete_file(path: String) -> Result<(), String>;
pub fn rename_file(old_path: String, new_path: String) -> Result<(), String>;

// Directory operations
pub fn read_directory(path: String) -> Result<Vec<FileEntry>, String>;

// Markdown operations
pub fn parse_markdown(content: String) -> ParseResult;

// File watching (stream)
pub fn start_watching(path: String) -> Result<u32, String>;
pub fn stop_watching(watch_id: u32) -> Result<(), String>;
pub fn get_file_events() -> Stream<FileSystemEvent>;
```

---

## Data Flow

### 1. 打开文件流程

```
User clicks file in Sidebar
        │
        ▼
┌───────────────┐
│ Sidebar State │ emits OpenFile event
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Editor State  │ calls openFile(path)
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ FFI Bridge    │ calls Rust read_file()
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ File System   │ reads file from disk
│   Service     │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Editor State  │ updates state, creates tab
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Preview State │ triggers re-render
└───────────────┘
```

### 2. 编辑自动保存流程

```
User types in Editor
        │
        ▼
┌───────────────┐
│ Editor Widget │ onChanged event
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Editor State  │ updateContent(), marks dirty
└───────┬───────┘
        │
        ▼
┌───────────────┐
│  Debounce     │ 2 second delay
│   Timer       │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Editor State  │ calls saveFile()
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ FFI Bridge    │ calls Rust write_file()
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ File System   │ writes to disk
│   Service     │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Editor State  │ marks clean, clears dirty flag
└───────────────┘
```

### 3. 文件监控流程

```
External file changes
        │
        ▼
┌───────────────┐
│ File Watcher  │ detects change
│   Service     │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ FFI Bridge    │ streams event to Flutter
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Workspace     │ handles event
│   State       │ - Updates file tree
└───────┬───────┘  - Reloads open file if modified
        │
        ▼
┌───────────────┐
│   UI Updates  │ re-renders affected components
└───────────────┘
```

---

## Non-Functional Requirements

### Performance
- **应用启动**: < 3秒（冷启动）
- **文件打开**: < 1秒（<1MB文件）
- **预览更新**: < 100ms（防抖后）
- **内存占用**: 空闲<200MB，编辑大文件<500MB
- **实现策略**:
  - 使用虚拟列表展示大文件树
  - Markdown 解析使用 Rust 原生实现
  - 文件监控使用系统 API（kqueue/FSEvents/inotify）
  - 图片懒加载

### Security
- **文件访问**: 遵循操作系统权限
- **无网络通信**: 除可选更新检查外不联网
- **数据隐私**: 所有数据本地存储
- **沙箱**: 遵守各平台沙箱规则

### Scalability
- **文件数量**: 支持工作区内 10,000+ 文件
- **文件大小**: 支持 10MB+ 单文件（性能可能受限）
- **打开文件**: 支持 20+ 同时打开的标签页

### Maintainability
- **代码组织**: 清晰的模块边界
- **错误处理**: 统一的错误类型
- **日志**: 结构化日志记录
- **测试**: 单元测试覆盖率 >80%

---

## Data Models

### Core Types

```rust
// File system types
pub struct FileEntry {
    pub name: String,
    pub path: String,
    pub is_dir: bool,
    pub size: u64,
    pub modified: Option<u64>,
}

pub struct Workspace {
    pub path: String,
    pub name: String,
    pub root: FileNode,
}

pub struct FileNode {
    pub entry: FileEntry,
    pub children: Vec<FileNode>,
    pub is_expanded: bool,
}

// Editor types
pub struct OpenFile {
    pub path: String,
    pub name: String,
    pub content: String,
    pub original_content: String,
    pub is_dirty: bool,
    pub cursor_position: CursorPosition,
}

pub struct CursorPosition {
    pub line: u32,
    pub column: u32,
}

// Settings
pub struct AppSettings {
    pub theme: ThemeMode,
    pub editor_font_size: f32,
    pub editor_font_family: String,
    pub recent_workspaces: Vec<String>,
    pub auto_save: bool,
    pub auto_save_delay_ms: u32,
    pub show_preview: bool,
    pub sidebar_width: f32,
}
```

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| flutter_rust_bridge 集成问题 | 高 | 预留1周调研时间，参考官方示例，准备纯Dart降级方案 |
| 大文件性能问题 | 中 | 虚拟滚动，分页加载，流式处理 |
| 跨平台路径差异 | 中 | 使用 Rust PathBuf 处理所有路径，充分测试 |
| macOS 沙盒权限问题 | 中 | 配置正确的 entitlements，实现权限申请流程 |
| 文件监控资源消耗 | 中 | 限制监控深度，提供手动刷新选项 |
| 内存泄漏（长运行） | 中 | 定期profile，使用弱引用，及时释放资源 |

---

## Decision Log

| Decision | Rationale | Trade-offs |
|----------|-----------|------------|
| Rust 处理文件系统 | 性能更好，跨平台路径处理统一 | 增加架构复杂度，需要FFI |
| Riverpod 状态管理 | 编译时安全，性能优秀，适合Flutter | 学习曲线较陡 |
| 本地优先架构 | 隐私保护，无网络依赖 | 无法实现云同步 |
| 分屏布局（编辑+预览） | 用户习惯，类似Typora/Obsidian | 小屏幕体验受限 |
| 自动保存（2秒延迟） | 平衡性能和数据安全 | 可能丢失2秒内数据 |
| Markdown解析在Rust | 性能更好，可复用逻辑 | 增加通信开销 |
