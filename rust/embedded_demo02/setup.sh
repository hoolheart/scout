#!/bin/bash
# STM32F407 RTIC 开发环境设置脚本

set -e

echo "=== STM32F407 RTIC 开发环境设置 ==="
echo ""

echo "1. 检查并安装Rust工具链..."
if command -v rustup &> /dev/null; then
    echo "   Rustup已安装"
    rustup default stable || true
    rustup target add thumbv7em-none-eabihf || true
else
    echo "   请先安装Rust: https://rustup.rs/"
    exit 1
fi

echo ""
echo "2. 检查ARM交叉编译工具链..."
if command -v arm-none-eabi-gcc &> /dev/null; then
    echo "   ARM工具链已安装"
else
    echo "   正在安装ARM工具链..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update
        sudo apt-get install -y gcc-arm-none-eabi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install arm-none-eabi-gcc
    else
        echo "   请手动安装ARM工具链"
    fi
fi

echo ""
echo "3. 安装probe-rs（用于硬件调试）..."
cargo install probe-rs --features cli || echo "   probe-rs已安装或安装失败"

echo ""
echo "4. 检查QEMU（用于模拟器运行）..."
if command -v qemu-system-arm &> /dev/null; then
    echo "   QEMU已安装"
else
    echo "   正在安装QEMU..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get install -y qemu-system-arm
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install qemu
    else
        echo "   请手动安装QEMU"
    fi
fi

echo ""
echo "=== 环境设置完成 ==="
echo ""
echo "QEMU模拟器运行："
echo "  cd qemu_demo && cargo run --release"
echo ""
echo "硬件调试："
echo "  cargo run --release"
