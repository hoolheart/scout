# F13 + F14 任务完成报告

## 任务 F13: 预览切换功能 ✅

### 实现内容

1. **预览面板显示/隐藏切换**
   - 文件: `lib/state/preview_state.dart`
   - 添加了 `initializeFromSettings()` 方法，从 AppSettings 初始化预览状态
   - 支持 toggle(), show(), hide(), setVisible() 方法

2. **工具栏切换按钮**
   - 文件: `lib/ui/layout/editor_area.dart`
   - Tab bar 右侧添加了预览切换按钮
   - 主 toolbar 中也添加了预览切换按钮
   - 使用 visibility/visibility_off 图标区分状态
   - 活跃状态显示不同颜色

3. **快捷键 Ctrl+\\**
   - 在 Shortcuts 中注册 `_TogglePreviewIntent`
   - 快捷键: `LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.backslash)`
   - 提示文本显示在按钮 tooltip 中

4. **状态持久化到 AppSettings**
   - 文件: `lib/state/app_state.dart` (已存在)
   - `setShowPreview(bool show)` - 保存预览状态
   - `togglePreview()` - 切换预览状态
   - AppSettings 模型中已有 `showPreview` 字段 (默认 true)

5. **预览关闭时编辑器占满宽度**
   - 文件: `lib/ui/layout/editor_area.dart`
   - 创建了 `_SplitView` 和 `_EditorOnlyView` 两个 widget
   - 使用 `AnimatedSwitcher` 实现平滑过渡动画 (250ms)
   - 预览关闭时编辑器独占整个可用空间

### 关键代码变更

```dart
// 预览切换处理
void _togglePreview(WidgetRef ref) {
  final newState = !ref.read(previewStateProvider);
  ref.read(previewStateProvider.notifier).setVisible(newState);
  // 保存到 settings
  ref.read(appStateProvider.notifier).setShowPreview(newState);
}

// 编辑器/预览视图切换
Widget _buildEditorPreview(String filePath, bool showPreview) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 250),
    child: showPreview
        ? _SplitView(key: const ValueKey('split'), filePath: filePath)
        : _EditorOnlyView(key: const ValueKey('editor_only'), filePath: filePath),
  );
}
```

---

## 任务 F14: 状态栏组件 ✅

### 实现内容

1. **当前文件路径**
   - 文件: `lib/ui/layout/status_bar.dart`
   - 显示完整文件路径，带 tooltip
   - 文件图标根据扩展名变化 (.md, .txt, .json, .yaml)

2. **保存状态指示**
   - 显示四种状态：
     - ✅ Saved (绿色) - 文件已保存
     - 🟠 Unsaved (橙色圆点) - 有未保存更改
     - ⏳ Saving... (蓝色进度条) - 正在保存
     - ❌ Save failed (红色) - 保存失败，带重试按钮

3. **光标位置 (行:列)**
   - 文件: `lib/ui/widgets/markdown_editor.dart` (更新)
   - 在编辑器中实时追踪光标位置
   - 显示格式: `Ln X, Col Y` (1-indexed)
   - 通过 CodeController 的 selection 计算位置

4. **字符数统计**
   - 显示总字符数
   - Tooltip 显示额外信息: 行数、词数
   - 实时更新

5. **编码信息**
   - 显示 UTF-8 编码
   - 显示换行符类型 (LF)

### 状态栏布局

```
┌─────────────────────────────────────────────────────────────────────────────┐
│ [icon] /path/to/file.md          │  [Save Status]   UTF-8   LF   Ln 1:1   123 chars  │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 关键组件

- **`StatusBar`** - 主容器，高度 28px，底部边框分隔
- **`_FileInfoSection`** - 左侧文件信息，带图标和路径
- **`_SaveStatusIndicator`** - 保存状态动态指示器
- **`_CursorPositionIndicator`** - 光标位置显示
- **`_CharacterCountIndicator`** - 字符/词/行统计
- **`_StatusItem`** - 通用状态项组件

### 光标位置追踪实现

```dart
void _updateCursorPosition() {
  if (_controller == null) return;

  final selection = _controller!.selection;
  if (selection.isValid) {
    final text = _controller!.text;
    final cursorOffset = selection.extentOffset;

    // 计算行和列
    final lines = text.substring(0, cursorOffset).split('\n');
    final line = lines.length - 1;
    final column = lines.last.length;

    ref.read(editorStateProvider.notifier).setCursorPosition(
      widget.filePath,
      CursorPosition(line: line, column: column),
    );
  }
}
```

---

## 文件变更列表

### 修改的文件

1. **lib/state/preview_state.dart**
   - 添加 `initializeFromSettings()` 方法

2. **lib/ui/layout/editor_area.dart**
   - 重构为 StatefulWidget
   - 添加预览切换按钮 (tab bar 和 toolbar)
   - 添加 Ctrl+\\ 快捷键
   - 添加 `_SplitView` 和 `_EditorOnlyView`
   - 添加平滑切换动画
   - 添加 `_ToolbarButton` 组件
   - 添加 Ctrl+S 保存快捷键

3. **lib/ui/widgets/markdown_editor.dart**
   - 添加光标位置追踪
   - 添加 `_updateCursorPosition()` 方法

### 已存在的文件 (无需修改)

- **lib/ui/layout/status_bar.dart** - 状态栏组件 (已实现)
- **lib/state/app_state.dart** - AppSettings 管理 (已实现)
- **lib/models/app_settings.dart** - showPreview 字段 (已存在)

---

## 功能测试清单

### F13 - 预览切换功能

- [x] 点击 tab bar 预览按钮切换预览
- [x] 点击 toolbar 预览按钮切换预览
- [x] 使用 Ctrl+\\ 快捷键切换预览
- [x] 预览关闭时编辑器占满宽度
- [x] 预览状态持久化到设置
- [x] 切换动画平滑流畅

### F14 - 状态栏组件

- [x] 显示当前文件路径
- [x] 未保存状态显示橙色指示
- [x] 已保存状态显示绿色勾选
- [x] 保存中显示进度条
- [x] 保存失败显示错误和重试按钮
- [x] 光标位置实时更新
- [x] 字符数统计正确
- [x] 显示 UTF-8 编码

---

## 技术细节

### 使用的包和依赖

- `flutter_riverpod` - 状态管理
- `flutter_code_editor` - Markdown 编辑器
- `flutter_markdown` - Markdown 预览
- `path` - 路径处理

### 设计模式

- **Riverpod Notifier Pattern** - 用于预览状态和编辑器状态
- **Intent/Action Pattern** - 用于键盘快捷键处理
- **ConsumerStatefulWidget** - 用于需要局部状态的 widget

### 性能优化

- 使用 `AnimatedSwitcher` 避免重建整个 widget 树
- 使用 `const ValueKey` 帮助 Flutter 识别 widget 变化
- 光标位置更新使用 `WidgetsBinding.instance.addPostFrameCallback` 避免阻塞 UI
