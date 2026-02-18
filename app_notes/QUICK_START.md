# 开发快速参考指南

## 项目结构

```
app_notes/
├── PRD.md           # 产品需求文档
├── ARCHITECTURE.md  # 架构设计文档
├── TASKS.md         # 任务分解文档
├── README.md        # 项目说明
├── rust/            # Rust 后端
│   ├── src/
│   │   ├── lib.rs           # FFI 入口
│   │   ├── api/             # API 模块
│   │   ├── services/        # 业务服务
│   │   └── models/          # 数据模型
│   └── Cargo.toml
├── flutter/         # Flutter 前端
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app.dart
│   │   ├── core/            # 核心模型
│   │   ├── providers/       # Riverpod 状态
│   │   ├── services/        # 服务层
│   │   ├── widgets/         # UI 组件
│   │   └── utils/           # 工具函数
│   └── pubspec.yaml
└── docs/            # 其他文档
```

---

## 第一阶段：基础骨架（必须首先完成）

### Rust 开发者

```bash
# 1. 创建项目
cargo new --lib rust_backend
cd rust_backend

# 2. 添加依赖到 Cargo.toml
[dependencies]
flutter_rust_bridge = "2.0"
tokio = { version = "1", features = ["full"] }
anyhow = "1.0"

# 3. 创建基础 FFI 结构
# src/lib.rs - 参考 ARCHITECTURE.md 的 FFI Bridge 部分
```

**关键交付物**:
- [ ] `init_app()` 函数
- [ ] `read_file()` 基础实现
- [ ] `write_file()` 基础实现
- [ ] 代码生成工作正常

### Flutter 开发者

```bash
# 1. 创建项目
flutter create --platforms=windows,macos,linux flutter_frontend

# 2. 添加依赖到 pubspec.yaml
dependencies:
  flutter_rust_bridge: ^2.0
  riverpod: ^2.4
  flutter_riverpod: ^2.4
  file_picker: ^6.0
  flutter_code_editor: ^0.3
  flutter_markdown: ^0.6

# 3. 配置 build.gradle / CMakeLists.txt 以支持 Rust
```

**关键交付物**:
- [ ] 项目可以在三平台运行
- [ ] 基础 MaterialApp 结构
- [ ] Riverpod ProviderScope 包装
- [ ] 可以调用 Rust 函数

---

## 核心开发顺序

### 🔴 阻塞依赖（必须按序执行）

```
R1 (Rust项目) ──────┬──→ F4 (FFI集成) ────→ F3 (状态管理)
                    │                         ↓
F1 (Flutter项目) ───┘                    F6 (编辑器)
                                              ↓
                                         F7 (预览)
```

**说明**: 
- R1 和 F1 可以并行
- F4 依赖 R1 和 F1
- F3 依赖 F4
- F6 依赖 F3
- F7 依赖 F6

### 🟡 并行开发（可以同时进行）

**Rust 后端并行任务**:
- R3 (文件系统) 和 R4 (Markdown解析) 可以并行
- R6 (文件监控) 可以稍后独立开发

**Flutter 前端并行任务**:
- F5 (侧边栏) 和 F6 (编辑器) 可以并行
- F9 (标签栏) 和 F7 (预览) 可以并行

---

## 关键接口定义

### Rust → Flutter 核心 API

```rust
// 必须首先实现这三个基础函数

pub fn read_file(path: String) -> Result<String, String> {
    // 异步读取文件
}

pub fn write_file(path: String, content: String) -> Result<(), String> {
    // 异步写入文件
}

pub fn parse_markdown(content: String) -> String {
    // 解析为 HTML
}
```

### Flutter 核心 Provider

```dart
// 必须首先实现这三个基础 Provider

// 1. 编辑器状态
@riverpod
class EditorState extends _$EditorState {
  String content = '';
  bool isDirty = false;
  
  void updateContent(String newContent) {
    content = newContent;
    isDirty = true;
    ref.notifyListeners();
  }
  
  Future<void> save(String path) async {
    await api.writeFile(path: path, content: content);
    isDirty = false;
    ref.notifyListeners();
  }
}

// 2. 预览状态
@riverpod
String previewContent(Ref ref) {
  final content = ref.watch(editorStateProvider).content;
  // 调用 Rust 解析
  return content; // HTML
}

// 3. 工作区状态
@riverpod
class WorkspaceState extends _$WorkspaceState {
  FileNode? root;
  
  Future<void> openDirectory(String path) async {
    // 加载文件树
  }
}
```

---

## 快速测试清单

### 基础功能测试

```bash
# 1. 编译测试
cd rust && cargo build --release
cd flutter && flutter build <platform>

# 2. 基础 FFI 测试
# - 打开应用
# - 选择一个 Markdown 文件
# - 确认内容加载到编辑器

# 3. 编辑和保存测试
# - 修改内容
# - 按 Ctrl+S 保存
# - 用外部编辑器打开文件，确认修改已保存

# 4. 预览测试
# - 输入 Markdown 语法
# - 确认预览实时更新
# - 确认代码块有语法高亮
```

### 性能基准

```
测试文件: 1MB Markdown 文件

预期性能:
- 文件打开: < 1秒
- 预览更新: < 100ms (输入后2秒)
- 内存占用: < 200MB
```

---

## 常见问题与解决

### 1. flutter_rust_bridge 代码生成失败

**解决**:
```bash
# 安装 codegen
cargo install flutter_rust_bridge_codegen

# 运行生成
flutter_rust_bridge_codegen generate

# 检查 rust 和 flutter 版本兼容性
```

### 2. 文件路径问题（Windows vs macOS/Linux）

**解决**:
- Rust 端使用 `std::path::PathBuf` 处理所有路径
- 不要硬编码路径分隔符
- 使用 `Path::join()` 而不是字符串拼接

### 3. 异步函数 FFI 问题

**解决**:
```rust
// 正确的方式 - 使用 flutter_rust_bridge 的异步支持
pub async fn read_file(path: String) -> Result<String, String> {
    tokio::fs::read_to_string(&path).await
        .map_err(|e| e.to_string())
}
```

### 4. 状态管理 Provider 刷新问题

**解决**:
```dart
// 确保调用 notifyListeners()
void updateContent(String newContent) {
  content = newContent;
  isDirty = true;
  notifyListeners(); // 不要忘记！
}

// 或者使用 state = newState (Riverpod)
state = state.copyWith(content: newContent, isDirty: true);
```

---

## 代码审查检查表

### Rust 代码审查

- [ ] 使用 `?` 运算符进行错误传播
- [ ] 异步函数使用 `async/await`
- [ ] 错误信息对用户友好
- [ ] 有适当的日志记录
- [ ] 单元测试覆盖主要路径

### Flutter 代码审查

- [ ] Widget 使用 `const` 构造函数
- [ ] 状态管理使用 Riverpod
- [ ] 异步操作使用 `FutureProvider` 或 `AsyncNotifier`
- [ ] UI 字符串支持国际化
- [ ] 有适当的错误处理 UI

---

## 依赖库参考

### Rust Dependencies

```toml
[dependencies]
# 核心
flutter_rust_bridge = "2.0"
tokio = { version = "1", features = ["full"] }
anyhow = "1.0"
thiserror = "1.0"

# 文件系统
notify = "6.0"

# Markdown
pulldown-cmark = "0.9"
syntect = "5.0"  # 代码高亮

# 工具
serde = { version = "1.0", features = ["derive"] }
serde_json = "1.0"
tracing = "0.1"
```

### Flutter Dependencies

```yaml
dependencies:
  # 核心
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  
  # 文件
  file_picker: ^6.1.0
  path_provider: ^2.1.0
  path: ^1.8.0
  
  # 编辑和预览
  flutter_code_editor: ^0.3.0
  flutter_markdown: ^0.6.18
  
  # UI
  window_manager: ^0.3.0
  flex_color_scheme: ^7.3.0
  
  # 工具
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  riverpod_generator: ^2.3.0
  custom_lint: ^0.5.0
  riverpod_lint: ^2.3.0
```

---

## 下一步行动

### 立即开始

1. **Rust 开发者**: 创建项目，实现 R1 (项目初始化)
2. **Flutter 开发者**: 创建项目，实现 F1 (项目初始化)
3. **UI 开发者**: 准备阶段，研究 flutter_code_editor 和 flutter_markdown 用法

### 本周目标

- [ ] Rust 和 Flutter 项目都可以编译运行
- [ ] 基础 FFI 调用成功
- [ ] 可以读取和显示 Markdown 文件内容
- [ ] 可以编辑和保存文件

### 成功标准

Sprint 1 结束时应可以：
1. 打开一个 Markdown 文件
2. 编辑内容
3. 看到实时预览
4. 保存修改

---

**如有问题，请参考 ARCHITECTURE.md 和 TASKS.md 获取详细说明**
