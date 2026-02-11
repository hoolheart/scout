# 电网基础知识培训 - 完整使用指南

## 📦 目录结构

```
02.train_grid/
├── 电网基础知识培训.md              # 原始培训材料（markdown + mermaid）
├── 电网基础知识培训.drawio         # Draw.io 图表源文件
├── 电网基础知识培训-slide.md       # Marp 格式 slide
├── convert-to-pdf.sh                # PDF/HTML 转换脚本
├── export-drawio-images.sh          # Draw.io 图片导出脚本
├── package.json                     # NPM 配置
├── README.md                        # 本说明文件
└── images/                          # 图片存放目录（导出后）
    └── slide_*.png                  # 从 draw.io 导出的图片
```

## 🚀 快速开始

### 最简单的方式（使用 mermaid 图表）

```bash
# 转换为 PDF（推荐使用 Chrome 引擎）
./convert-to-pdf.sh chrome
```

这会直接使用 mermaid 图表生成 PDF，无需导出 draw.io 图片。

---

## 📊 使用 Draw.io 导出图片（可选）

如果你希望使用更专业的 draw.io 导出图片，有以下两种方式：

### 方式一：使用自动化脚本（推荐）

```bash
# 运行导出脚本
./export-drawio-images.sh
```

该脚本会：
1. 检测是否安装了 drawio-cli
2. 如果未安装，询问是否自动安装
3. 导出所有页面为 PNG（透明背景、200%缩放）

### 方式二：手动导出

详细步骤请见 README-slide.md 文件。

---

## 🎬 转换 Slide 为 PDF/HTML

### 脚本命令

```bash
# 转换为 PDF（默认）
./convert-to-pdf.sh

# 转换为 HTML
./convert-to-pdf.sh html

# 同时转换为 PDF 和 HTML
./convert-to-pdf.sh all

# 使用 Chrome 引擎转换为 PDF（推荐，效果更好）
./convert-to-pdf.sh chrome
```

### NPM 命令

```bash
# 首先安装依赖
npm install

# 转换为 PDF
npm run convert:pdf

# 转换为 HTML
npm run convert:html

# 同时转换
npm run convert:all

# Chrome 引擎
npm run convert:chrome
```

---

## 📋 各脚本说明

### convert-to-pdf.sh
- **功能**：将 Marp slide 转换为 PDF 或 HTML
- **依赖**：@marp-team/marp-cli
- **输出**：电网基础知识培训.pdf 或 .html

### export-drawio-images.sh
- **功能**：从 draw.io 文件批量导出图片
- **依赖**：drawio-cli（可选）
- **输出**：images/page-*.png

---

## 🎨 自定义配置

### 修改主题

编辑 `电网基础知识培训-slide.md` 文件头部的配置：

```markdown
---
marp: true
theme: default          # 修改主题
paginate: true
class: lead
backgroundColor: #1a1a1a  # 修改背景色
color: #ffffff          # 修改文字颜色
---
```

可用主题：
- default
- uncover
- gaia
- inverted

### 自定义样式

在 slide 文件中添加 style 标签：

```markdown
<style>
section {
    font-family: 'Microsoft YaHei', sans-serif;
}
</style>
```

---

## 🔧 常见问题

### Q1: 转换失败，提示找不到 marp 命令

**解决方案：**
```bash
npm install -g @marp-team/marp-cli
```

### Q2: PDF 中中文显示为方框

**解决方案：**
- 使用 Chrome 引擎转换：`./convert-to-pdf.sh chrome`
- 或安装中文字体

### Q3: drawio-cli 导出失败

**解决方案：**
- 改用手动导出方式
- 确保 drawio-cli 版本 >= 14.6.0

### Q4: 想要修改 slide 内容

**解决方案：**
- 直接编辑 `电网基础知识培训-slide.md` 文件
- 重新运行转换脚本

---

## 📖 更多资源

- [Marp 官方文档](https://marp.app/)
- [Marp CLI GitHub](https://github.com/marp-team/marp-cli)
- [Draw.io 官网](https://www.diagrams.net/)

---

## 📝 许可

MIT License
