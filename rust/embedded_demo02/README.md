# STM32F407 RTIC 最小系统

基于RTIC框架的STM32F407最小系统工程，支持硬件调试和QEMU模拟器运行。

## 项目结构

```
.
├── Cargo.toml              # 主项目配置（硬件调试）
├── memory.x               # 内存布局定义
├── .cargo/
│   └── config.toml        # Cargo配置（probe-rs调试器）
├── src/
│   └── main.rs            # 主程序（带串口输出）
└── qemu_demo/             # QEMU模拟器版本
    ├── Cargo.toml
    ├── memory.x
    ├── .cargo/
    │   └── config.toml    # QEMU运行配置
    └── src/
        └── main.rs        # QEMU优化版主程序
```

## 环境准备

### 1. 安装Rust工具链和嵌入式目标

```bash
rustup default stable
rustup target add thumbv7em-none-eabihf
```

### 2. 安装ARM交叉编译工具链

**Ubuntu/Debian:**
```bash
sudo apt-get install gcc-arm-none-eabi
```

**macOS:**
```bash
brew install arm-none-eabi-gcc
```

### 3. 安装调试工具（硬件调试）

```bash
cargo install probe-rs --features cli
```

### 4. 安装QEMU（模拟器运行）

**Ubuntu/Debian:**
```bash
sudo apt-get install qemu-system-arm
```

**macOS:**
```bash
brew install qemu
```

## 使用方法

### QEMU模拟器运行（推荐）

```bash
cd qemu_demo
cargo build --release
cargo run --release
```

QEMU将以84MHz运行STM32F407，LED（PA5）每秒翻转一次。

### 硬件调试

连接ST-Link调试器后：

```bash
cargo build --release
cargo run --release
```

使用probe-rs自动检测并烧录程序到STM32F407开发板。

## 代码说明

### RTIC任务结构

- **init**: 初始化时钟、GPIO、定时器
- **idle**: 低功耗模式，等待中断
- **timer_interrupt**: 定时器中断处理，每秒触发

### 功能特性

- LED闪烁（PA5引脚）
- 定时器中断（TIM2，1秒间隔）
- RTIC任务调度
- 低功耗wfi指令

## 调试

### 使用GDB调试QEMU

```bash
cd qemu_demo
cargo build
qemu-system-arm -cpu cortex-m4 -machine netduinoplus2 -nographic -monitor none -semihosting-config enable=on,target=native -kernel target/thumbv7em-none-eabihf/debug/qemu-stm32f407 -s -S
```

在另一个终端：
```bash
arm-none-eabi-gdb target/thumbv7em-none-eabihf/debug/qemu-stm32f407
(gdb) target remote :1234
(gdb) break main
(gdb) continue
```

## 参考

- [RTIC文档](https://rtic.rs/)
- [stm32f4xx-hal](https://docs.rs/stm32f4xx-hal/)
- [QEMU STM32支持](https://wiki.qemu.org/Documentation/Platforms/ARM)
