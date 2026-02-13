# 基于Rust的STM32 RTOS Top 5调研报告

## 📊 Top 5 排名（按社区热度）

| 排名 | RTOS名称 | GitHub Stars | Forks | 状态 |
|------|----------|--------------|-------|------|
| 1 | Embassy | 8,767 | 1,366 | 活跃 |
| 2 | RTIC | 6,216 | 804 | 活跃 |
| 3 | Tock OS | 5,680 | 2,077 | 活跃 |
| 4 | FreeRTOS Rust bindings | 2,238 | 245 | 活跃 |
| 5 | Drone OS | 175 | 19 | 活跃 |

---

## 1️⃣ Embassy

**🏆 综合评分最高**

### 成熟度 ⭐⭐⭐⭐⭐
- 最新版本：0.9.1 (活跃开发)
- 专为嵌入式设计的现代async/await执行器
- 无需heap，静态任务分配
- 完整的STM32支持

### 功能丰富程度 ⭐⭐⭐⭐⭐
- **核心特性**：
  - 异步执行器（async/await）
  - 集成定时器队列
  - 零配置，自动内存分配
  - 多优先级支持
  - WFE/SEV低功耗支持

- **生态组件**：
  - embassy-stm32 (HAL层)
  - embassy-net (网络协议栈)
  - embassy-usb (USB支持)
  - embassy-time (时间管理)
  - embassy-sync (同步原语)

### 社区热度 ⭐⭐⭐⭐⭐
- GitHub: 8,767 stars (最高)
- 活跃的开发团队
- 丰富的文档和示例
- 大量的用户案例

### 适用场景
- 需要异步编程的现代嵌入式应用
- 低功耗IoT设备
- 网络连接应用

---

## 2️⃣ RTIC (Real-Time Interrupt-driven Concurrency)

**🏆 最稳定成熟**

### 成熟度 ⭐⭐⭐⭐⭐
- 版本：2.2.0 (稳定)
- 最早的Rust RTOS框架之一
- 经过大量生产验证
- 完整的测试覆盖

### 功能丰富程度 ⭐⭐⭐⭐
- **核心特性**：
  - 中断驱动并发模型
  - 编译时任务调度
  - 内存安全的资源共享
  - 零运行时开销
  - 支持任务优先级

- **架构特点**：
  - 静态内存分配
  - 不需要heap
  - 编译时资源检测

### 社区热度 ⭐⭐⭐⭐
- GitHub: 6,216 stars
- 长期稳定的用户群
- 丰富的教程和文档
- 与cortex-m生态深度集成

### 适用场景
- 硬实时系统
- 中断驱动应用
- 资源受限的STM32

---

## 3️⃣ Tock OS

**🏆 安全性最强**

### 成熟度 ⭐⭐⭐⭐
- 学术研究项目
- 多个生产部署案例
- 持续的开发更新
- 经过安全审计

### 功能丰富程度 ⭐⭐⭐⭐
- **核心特性**：
  - 类型安全的进程隔离
  - 多进程支持
  - Capsule驱动架构
  - 细粒度权限控制
  - 低功耗管理

- **安全特性**：
  - 进程间内存隔离
  - 类型安全的IPC
  - 权限最小化

### 社区热度 ⭐⭐⭐⭐
- GitHub: 5,680 stars
- 学术界和工业界支持
- 频繁的技术论文发布
- 丰富的硬件支持

### 适用场景
- 需要运行第三方应用的安全设备
- 多应用IoT平台
- 安全关键系统

---

## 4️⃣ FreeRTOS Rust bindings

**🏆 生态最兼容**

### 成熟度 ⭐⭐⭐⭐
- 基于成熟的FreeRTOS内核
- 活跃的Rust绑定开发
- 与现有C生态无缝集成

### 功能丰富程度 ⭐⭐⭐⭐
- **核心特性**：
  - FreeRTOS任务、队列、信号量
  - 完整的Rust安全封装
  - 与C代码互操作
  - 调度器兼容

- **优势**：
  - 可利用现有的FreeRTOS驱动
  - 与C库无缝集成
  - 成熟的工具链

### 社区热度 ⭐⭐⭐
- GitHub: 2,238 stars
- 来自FreeRTOS生态的用户
- 适合迁移项目

### 适用场景
- 从C迁移到Rust的项目
- 需要使用现有FreeRTOS驱动
- 混合C/Rust代码库

---

## 5️⃣ Drone OS

**🏆 最轻量级**

### 成熟度 ⭐⭐⭐
- 专注ARM Cortex-M
- 相对较小众
- 但持续活跃开发

### 功能丰富程度 ⭐⭐⭐
- **核心特性**：
  - 基于寄存器的API
  - 零开销抽象
  - 极小的二进制大小
  - 确定性性能

- **特点**：
  - 类似汇编的精细控制
  - 编译时优化
  - 极低内存占用

### 社区热度 ⭐⭐
- GitHub: 175 stars
- 小但活跃的社区
- 专业用户群体

### 适用场景
- 超低资源MCU
- 需要精确控制的系统
- 性能关键应用

---

## 🔍 深度对比分析

### 性能对比

| 指标 | Embassy | RTIC | Tock OS | FreeRTOS | Drone OS |
|------|---------|------|---------|----------|----------|
| 内存占用 | 低 | 极低 | 中 | 中 | 极低 |
| 中断延迟 | 低 | 极低 | 中 | 低 | 极低 |
| 上下文切换 | 快 | 极快 | 中 | 快 | 极快 |
| 功耗 | 优秀 | 优秀 | 良好 | 良好 | 优秀 |

### 开发体验对比

| 方面 | Embassy | RTIC | Tock OS | FreeRTOS | Drone OS |
|------|---------|------|---------|----------|----------|
| 学习曲线 | 中等 | 中等 | 陡峭 | 低 | 陡峭 |
| 文档质量 | 优秀 | 优秀 | 良好 | 中等 | 中等 |
| 调试工具 | 优秀 | 良好 | 中等 | 良好 | 中等 |
| IDE支持 | 优秀 | 良好 | 中等 | 良好 | 中等 |

### STM32芯片支持

| STM32系列 | Embassy | RTIC | Tock OS | FreeRTOS | Drone OS |
|-----------|---------|------|---------|----------|----------|
| STM32F0 | ✅ | ✅ | 部分 | ✅ | ✅ |
| STM32F1 | ✅ | ✅ | 部分 | ✅ | ✅ |
| STM32F3 | ✅ | ✅ | 部分 | ✅ | ✅ |
| STM32F4 | ✅ | ✅ | 部分 | ✅ | ✅ |
| STM32F7 | ✅ | ✅ | 部分 | ✅ | ✅ |
| STM32G0 | ✅ | ✅ | 部分 | ✅ | ✅ |
| STM32G4 | ✅ | ✅ | 部分 | ✅ | ✅ |
| STM32H7 | ✅ | ✅ | 部分 | ✅ | ✅ |
| STM32L0 | ✅ | ✅ | 部分 | ✅ | ✅ |
| STM32L4 | ✅ | ✅ | 部分 | ✅ | ✅ |
| STM32WB | ✅ | ✅ | 部分 | ✅ | ✅ |
| STM32WL | ✅ | ✅ | 部分 | ✅ | ✅ |

---

## 🎯 选择建议

### 选择 Embassy 如果：
- ✅ 需要现代async/await编程
- ✅ 需要网络/USB等高级功能
- ✅ 新项目，无需迁移现有代码
- ✅ 需要活跃的社区支持

### 选择 RTIC 如果：
- ✅ 需要硬实时保证
- ✅ 中断驱动应用
- ✅ 资源极其受限
- ✅ 需要稳定成熟的方案

### 选择 Tock OS 如果：
- ✅ 需要运行不可信的第三方应用
- ✅ 安全性是首要考虑
- ✅ 需要多进程隔离
- ✅ 学术研究或安全关键系统

### 选择 FreeRTOS Rust bindings 如果：
- ✅ 从C/C++迁移到Rust
- ✅ 已有FreeRTOS驱动和代码
- ✅ 团队熟悉FreeRTOS
- ✅ 需要与C库互操作

### 选择 Drone OS 如果：
- ✅ 超低资源MCU
- ✅ 需要像汇编一样的控制力
- ✅ 性能是关键因素
- ✅ 愿意学习陡峭的学习曲线

---

## 📈 总体趋势

1. **Embassy正在成为主流**：async/await编程模式在嵌入式领域越来越受欢迎
2. **RTIC仍然是硬实时的首选**：对于确定性要求极高的场景
3. **安全性需求推动Tock OS发展**：IoT安全需求增长
4. **Rust原生方案优于绑定**：相比FreeRTOS bindings，原生Rust RTOS发展更快
5. **生态工具链日益完善**：probe-rs、defmt等工具大大改善开发体验

---

## 📚 相关资源

### 官方链接
- Embassy: https://github.com/embassy-rs/embassy
- RTIC: https://github.com/rtic-rs/cortex-m-rtic
- Tock OS: https://github.com/tock/tock
- FreeRTOS Rust: https://github.com/ivajloip/rust-freertos
- Drone OS: https://github.com/drone-os/drone

### 文档
- Embassy Docs: https://docs.embassy.dev/
- RTIC Book: https://rtic.rs/
- Tock Documentation: https://www.tockos.org/documentation/
- Rust Embedded Book: https://rust-embedded.github.io/book/

---

**最终推荐**：对于大多数STM32项目，**Embassy**是最佳选择，它提供现代化的开发体验、丰富的功能和活跃的社区。对于硬实时系统，选择**RTIC**。对于安全关键系统，考虑**Tock OS**。
