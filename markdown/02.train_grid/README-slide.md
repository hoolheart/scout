# 电网基础知识培训 - Slide 制作说明

本目录包含电网基础知识培训的 slide 相关文件。

## 📁 文件说明

| 文件 | 说明 |
|------|------|
| `电网基础知识培训.md` | 原始培训材料（markdown格式，使用mermaid图表） |
| `电网基础知识培训.drawio` | Draw.io 格式的专业图表源文件 |
| `电网基础知识培训-slide.md` | Marp 格式的 slide（使用mermaid图表） |
| `convert-to-pdf.sh` | 自动化转换脚本（转换为PDF/HTML） |
| `package.json` | NPM 配置文件 |
| `README-slide.md` | 本说明文件 |

## 🚀 快速开始

### 方法一：直接运行脚本（推荐）

```bash
# 转换为 PDF（默认）
./convert-to-pdf.sh

# 转换为 HTML
./convert-to-pdf.sh html

# 转换为 PDF 和 HTML
./convert-to-pdf.sh all

# 使用 Chrome 引擎转换为 PDF（推荐，效果更好）
./convert-to-pdf.sh chrome
```

### 方法二：使用 npm

```bash
# 安装依赖
npm install

# 转换为 PDF
npm run convert:pdf

# 转换为 HTML
npm run convert:html

# 转换为 PDF 和 HTML
npm run convert:all

# 使用 Chrome 引擎转换为 PDF
npm run convert:chrome
```

### 方法三：手动使用 Marp CLI

```bash
# 全局安装 Marp CLI
npm install -g @marp-team/marp-cli

# 转换为 PDF
marp 电网基础知识培训-slide.md --pdf -o 电网基础知识培训.pdf

# 转换为 HTML
marp 电网基础知识培训-slide.md --html -o 电网基础知识培训.html
```

## 📊 使用 Draw.io 导出的图片

如果你希望使用 draw.io 导出的 PNG 图片（背景透明、200%缩放），请按以下步骤操作：

### 步骤 1：打开 Draw.io 文件

使用以下任一方式打开 `电网基础知识培训.drawio`：
- 在线版：https://app.diagrams.net
- 桌面版：下载 Draw.io Desktop

### 步骤 2：导出所有页面为 PNG

对每个页面执行以下操作：

1. 在页面导航栏选择要导出的页面
2. 菜单：File → Export as → PNG...
3. 设置导出选项：
   - ✅ Transparent background（背景透明）
   - Scale: 200%（缩放200%）
   - ✅ Selection only（只导出选中的图形区域）
4. 保存文件，建议命名为：`slide_01_电力的产生与消费特性.png`
   - 命名格式：`slide_序号_标题.png`

### 步骤 3：创建 images 目录

```bash
mkdir images
```

将所有导出的 PNG 文件放入 `images/` 目录。

### 步骤 4：替换 Slide 文件中的图表

在 `电网基础知识培训-slide.md` 中，将 mermaid 代码块替换为图片引用。

**替换前（mermaid图表）：**
````markdown
```mermaid
graph LR
    A[发电厂] --> B[用户]
```
````

**替换后（图片引用）：**
```markdown
![电力的产生与消费特性](images/slide_01_电力的产生与消费特性.png)
```

### 步骤 5：重新转换

运行转换脚本生成 PDF：
```bash
./convert-to-pdf.sh chrome
```

## 📋 各页面对应的图片命名建议

| 页面标题 | 建议图片文件名 |
|----------|---------------|
| 电力的产生与消费特性 | slide_01_电力的产生与消费特性.png |
| 电网发展里程碑 | slide_02_电网发展里程碑.png |
| 什么是三相交流电 | slide_03_什么是三相交流电.png |
| 为什么三相平衡时总功率恒定 | slide_04_三相平衡功率恒定.png |
| 三相电优势 | slide_05_三相电优势.png |
| 连接方式对比 | slide_06_连接方式对比.png |
| 推车工作模型 | slide_07_推车工作模型.png |
| 功率三角形 | slide_08_功率三角形.png |
| 为什么要关注功率因数 | slide_09_功率因数影响.png |
| 中国电网电压等级体系 | slide_10_电压等级体系.png |
| 变压器原理 | slide_11_变压器原理.png |
| 典型输电链路 | slide_12_输电链路.png |
| 中国电网 | slide_13_中国电网特点.png |
| 美国电网 | slide_14_美国电网.png |
| 欧洲电网 | slide_15_欧洲电网.png |
| 日本电网 | slide_16_日本电网.png |
| 频率标准对比 | slide_17_频率分布.png |
| 给软件工程师的启示 | slide_18_软件工程师启示.png |

## 🎨 Draw.io 批量导出技巧

如果你需要导出很多页面，可以考虑以下方法：

### 方法一：使用 Draw.io CLI（高级）

Draw.io 提供了命令行工具，可以批量导出：

```bash
# 安装 draw.io CLI
npm install -g drawio-cli

# 导出所有页面
drawio-cli -x -f png -s 2 -t -o images/%f.png 电网基础知识培训.drawio
```

参数说明：
- `-x`: 导出所有页面
- `-f png`: 导出为 PNG 格式
- `-s 2`: 缩放 200%
- `-t`: 透明背景
- `-o`: 输出路径和命名规则

### 方法二：使用脚本自动化导出

创建一个自动化脚本，调用 draw.io 命令行工具或自动化工具（如 Python + selenium）来批量导出。

## 🛠️ 依赖要求

- Node.js >= 14.0.0
- npm 或 npx
- Chrome/Chromium（用于 PDF 渲染，可选）

## 📤 输出文件

转换后会在当前目录生成以下文件：

- `电网基础知识培训.pdf` - PDF 格式的演示文稿
- `电网基础知识培训.html` - HTML 格式的演示文稿（可通过浏览器打开）

## 🔧 常见问题

### Q1: 提示 "command not found: marp"
**A:** 运行 `npm install -g @marp-team/marp-cli` 安装 Marp CLI

### Q2: 转换 PDF 时中文显示乱码
**A:** 确保系统中安装了中文字体。在 Marp 配置中指定字体，或使用 Chrome 引擎转换：`./convert-to-pdf.sh chrome`

### Q3: 导出的 PNG 图片背景不透明
**A:** 在 Draw.io 导出时确保勾选 "Transparent background" 选项

### Q4: 图片清晰度不够
**A:** 在 Draw.io 导出时设置 Scale 为 200% 或更高

### Q5: 想要自定义样式
**A:** 编辑 `电网基础知识培训-slide.md` 文件顶头的 Marp 配置部分，或者创建自定义主题文件

## 📖 Marp 参考资源

- 官方文档：https://marp.app/
- CLI 文档：https://github.com/marp-team/marp-cli
- 主题定制：https://marp.app/theming
