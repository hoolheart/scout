#!/bin/bash

################################################################################
# 电网基础知识培训 - Marp Slide 转 PDF 自动化脚本
################################################################################

set -e  # 遇到错误立即退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 配置
MD_FILE="电网基础知识培训-slide.md"
PDF_OUTPUT="电网基础知识培训.pdf"
HTML_OUTPUT="电网基础知识培训.html"

# 打印带颜色的消息
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

# 检查文件是否存在
check_file() {
    if [ ! -f "$1" ]; then
        print_error "文件不存在: $1"
        exit 1
    fi
}

# 检查命令是否存在
check_command() {
    if ! command -v $1 &> /dev/null; then
        return 1
    fi
    return 0
}

# 安装 Marp CLI
install_marp() {
    print_info "Marp CLI 未安装，正在安装..."

    if check_command npm; then
        npm install -g @marp-team/marp-cli
        print_success "Marp CLI 安装完成"
    elif check_command npx; then
        print_info "npm 未全局安装，将使用 npx 运行"
        return 0
    else
        print_error "未找到 npm 或 npx，请先安装 Node.js"
        print_info "访问 https://nodejs.org 下载安装"
        exit 1
    fi
}

# 转换为 PDF
convert_to_pdf() {
    print_info "正在转换 $MD_FILE 为 PDF..."

    if check_command marp; then
        marp "$MD_FILE" --pdf -o "$PDF_OUTPUT"
    else
        npx @marp-team/marp-cli "$MD_FILE" --pdf -o "$PDF_OUTPUT"
    fi

    print_success "PDF 生成完成: $PDF_OUTPUT"
}

# 转换为 HTML
convert_to_html() {
    print_info "正在转换 $MD_FILE 为 HTML..."

    if check_command marp; then
        marp "$MD_FILE" --html -o "$HTML_OUTPUT"
    else
        npx @marp-team/marp-cli "$MD_FILE" --html -o "$HTML_OUTPUT"
    fi

    print_success "HTML 生成完成: $HTML_OUTPUT"
}

# 转换为 PDF（带 Chrome 指定）
convert_to_pdf_chrome() {
    print_info "正在使用 Chrome 引擎转换 $MD_FILE 为 PDF..."

    if check_command marp; then
        marp "$MD_FILE" --pdf --allow-local-files -o "$PDF_OUTPUT"
    else
        npx @marp-team/marp-cli "$MD_FILE" --pdf --allow-local-files -o "$PDF_OUTPUT"
    fi

    print_success "PDF 生成完成: $PDF_OUTPUT"
}

# 显示使用帮助
show_help() {
    echo "用法: $0 [选项]"
    echo ""
    echo "选项:"
    echo "  pdf        转换为 PDF（默认）"
    echo "  html       转换为 HTML"
    echo "  all        转换为 PDF 和 HTML"
    echo "  chrome     使用 Chrome 引擎转换为 PDF（推荐）"
    echo "  help       显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0              # 转换为 PDF"
    echo "  $0 html         # 转换为 HTML"
    echo "  $0 all          # 转换为 PDF 和 HTML"
    echo "  $0 chrome       # 使用 Chrome 引擎转换为 PDF"
}

# 主函数
main() {
    echo "=========================================="
    echo "  电网基础知识培训 - Marp 转换工具"
    echo "=========================================="
    echo ""

    # 检查 markdown 文件
    check_file "$MD_FILE"

    # 检查/安装 Marp CLI
    if ! check_command marp && ! check_command npx; then
        install_marp
    fi

    # 解析命令行参数
    case "${1:-pdf}" in
        pdf)
            convert_to_pdf
            ;;
        html)
            convert_to_html
            ;;
        all)
            convert_to_pdf
            convert_to_html
            ;;
        chrome)
            convert_to_pdf_chrome
            ;;
        help|--help|-h)
            show_help
            exit 0
            ;;
        *)
            print_error "未知选项: $1"
            show_help
            exit 1
            ;;
    esac

    echo ""
    print_success "转换完成！"
    echo ""
    echo "生成的文件:"
    if [ -f "$PDF_OUTPUT" ]; then
        echo "  📄 $PDF_OUTPUT"
    fi
    if [ -f "$HTML_OUTPUT" ]; then
        echo "  🌐 $HTML_OUTPUT"
    fi
    echo ""
}

# 运行主函数
main "$@"
