#!/bin/bash

################################################################################
# Draw.io 图片批量导出脚本
# 自动将 draw.io 文件的所有页面导出为透明背景的 PNG 图片（200%缩放）
################################################################################

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 配置
DIO_FILE="电网基础知识培训.drawio"
OUTPUT_DIR="images"
SCALE=2  # 200%

# 页面名称映射（用于重命名导出的文件）
declare -A PAGE_NAMES=(
    ["电力的产生与消费特性"]="01_电力的产生与消费特性"
    ["电网发展里程碑"]="02_电网发展里程碑"
    ["三相交流电原理"]="03_三相交流电原理"
    ["相电压与线电压"]="04_相电压与线电压"
    ["功率因数影响"]="05_功率因数影响"
    ["电压等级体系"]="06_电压等级体系"
    ["中国电网特点"]="07_中国电网特点"
    ["美国电网"]="08_美国电网"
    ["有功无功视在功率"]="09_有功无功视在功率"
)

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查文件
check_file() {
    if [ ! -f "$1" ]; then
        print_error "文件不存在: $1"
        exit 1
    fi
}

# 检查命令
check_command() {
    command -v $1 &> /dev/null
}

# 使用 drawio-cli 导出
export_with_drawio_cli() {
    print_info "使用 drawio-cli 导出图片..."

    # 创建输出目录
    mkdir -p "$OUTPUT_DIR"

    # 导出所有页面
    drawio -x -f png -s "$SCALE" -t -o "$OUTPUT_DIR/page-%p.png" "$DIO_FILE"

    print_success "图片导出完成到 $OUTPUT_DIR 目录"
    print_info "导出的文件："
    ls -lh "$OUTPUT_DIR"/*.png
}

# 检查并安装 drawio-cli
check_install_drawio_cli() {
    if check_command drawio; then
        return 0
    fi

    print_warning "drawio-cli 未安装"

    read -p "是否现在安装 drawio-cli? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "正在安装 drawio-cli..."

        if check_command npm; then
            npm install -g drawio-cli
            print_success "drawio-cli 安装完成"
            return 0
        else
            print_error "未找到 npm，请先安装 Node.js"
            print_info "手动安装方法："
            echo "  1. 安装 Node.js: https://nodejs.org/"
            echo "  2. 运行: npm install -g drawio-cli"
            echo "  3. 或访问: https://github.com/jgraph/drawio-desktop/releases"
            return 1
        fi
    fi

    return 1
}

# 使用手动导出指南
show_manual_guide() {
    cat << 'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Draw.io 手动导出指南
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

由于 drawio-cli 未安装，请按照以下步骤手动导出图片：

步骤 1: 打开 Draw.io
  • 在线版：https://app.diagrams.net
  • 或本地安装 Draw.io Desktop

步骤 2: 打开文件
  • 打开 "电网基础知识培训.drawio" 文件

步骤 3: 逐页导出
  对每个页面执行：
  
  1. 选择页面（底部标签栏）
  2. 菜单：File → Export as → PNG...
  3. 设置选项：
     ✓ Transparent background（背景透明）
     ✓ Selection only（只导出选中区域）
     Scale: 200%
  4. 保存到 images/ 目录
  
步骤 4: 命名规范
  建议使用以下命名（放在 images/ 目录）：
  
  • slide_01_电力的产生与消费特性.png
  • slide_02_电网发展里程碑.png
  • slide_03_三相交流电原理.png
  • slide_04_相电压与线电压.png
  • slide_05_功率因数影响.png
  • slide_06_电压等级体系.png
  • slide_07_中国电网特点.png
  • slide_08_美国电网.png
  • slide_09_有功无功视在功率.png
  • slide_10_全球电网对比.png
  • slide_11_软件工程师启示.png

步骤 5: 更新 Slide 文件
  在 "电网基础知识培训-slide.md" 中，
  将 mermaid 代码块替换为图片引用：
  
  ![图片标题](images/slide_XX_图片标题.png)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
}

# 主函数
main() {
    echo "=========================================="
    echo "  Draw.io 图片批量导出工具"
    echo "=========================================="
    echo ""

    check_file "$DIO_FILE"

    if check_install_drawio_cli; then
        export_with_drawio_cli
        echo ""
        print_success "导出完成！"
        print_info "下一步：手动检查图片并更新 slide 文件中的引用"
    else
        show_manual_guide
    fi
}

main "$@"
