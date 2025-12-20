# Rope - C++ 依赖管理框架

Rope 是一个现代化的 C++ 依赖管理框架，提供了完整的组件生命周期管理、依赖注入和条件匹配功能。

## 特性

- **组件管理**: 存储任意类型的服务指针
- **依赖管理**: 支持必要和非必要依赖
- **条件匹配**: 基于属性的条件依赖
- **生命周期管理**: 自动化的组件启动和停止
- **声明式API**: 操作队列和延迟执行
- **循环依赖检测**: 防止无效的依赖关系
- **类型安全**: 模板化的组件系统

## 快速开始

### 基本用法

```cpp
#include "rope/component.h"
#include "rope/dependency_manager.h"

// 创建服务类
class MyService {
public:
    void start() { std::cout << "Service started" << std::endl; }
    void stop() { std::cout << "Service stopped" << std::endl; }
};

int main() {
    // 创建依赖管理器
    rope::DependencyManager manager;

    // 创建服务和组件
    auto service = std::make_shared<MyService>();
    auto component = std::make_shared<rope::Component>("my_service", service);

    // 设置生命周期函数
    component->setStartFunction([](std::shared_ptr<MyService> s) { s->start(); });
    component->setStopFunction([](std::shared_ptr<MyService> s) { s->stop(); });

    // 注册组件
    manager.registerComponent(component);
    manager.run();

    // 启动组件
    manager.startComponent("my_service");

    return 0;
}
```

### 依赖管理

```cpp
// 创建有依赖的组件
auto db_service = std::make_shared<DatabaseService>();
auto app_service = std::make_shared<ApplicationService>();

auto db_component = std::make_shared<rope::Component>("database", db_service);
auto app_component = std::make_shared<rope::Component>("application", app_service);

// 设置应用依赖数据库
rope::Dependency dep("database", rope::Dependency::Type::REQUIRED);
manager.addDependency("application", dep);

// 注册和管理
manager.registerComponent(db_component);
manager.registerComponent(app_component);
manager.run();

// 自动按依赖顺序启动
manager.startAllComponents();
```

### 条件匹配

```cpp
// 设置组件属性
auto db_component = std::make_shared<rope::Component>("database", db_service);
db_component->setAttributes({
    {"type", "postgresql"},
    {"version", "13.0"},
    {"host", "localhost"}
});

// 创建带条件的依赖
rope::Dependency dep("database", rope::Dependency::Type::REQUIRED);
dep.addCondition("type", "postgresql");
dep.addCondition("version", "12", rope::Dependency::MatchOperator::GREATER);
dep.addCondition("host", "localhost", rope::Dependency::MatchOperator::EQUALS);

manager.addDependency("application", dep);
```

## 核心概念

### Component（组件）

组件是服务的包装器，包含：
- 服务指针
- 属性键值对
- 依赖关系列表
- 生命周期函数

### Dependency（依赖）

依赖描述组件间的关系：
- **类型**: REQUIRED（必要）或 OPTIONAL（可选）
- **基数**: SINGLE（单个）或 MULTIPLE（多个）
- **条件**: 基于属性的条件匹配
- **优先级**: 依赖启动的优先级

### DependencyManager（依赖管理器）

管理所有组件和依赖关系：
- 声明式操作队列
- 依赖解析和拓扑排序
- 生命周期自动管理
- 循环依赖检测

## 生命周期函数

组件支持四种生命周期函数：

```cpp
component->setStartFunction([](std::shared_ptr<MyService> service) {
    // 启动逻辑
});

component->setStopFunction([](std::shared_ptr<MyService> service) {
    // 停止逻辑
});

component->setAddDependencyFunction([](std::shared_ptr<MyService> service, const std::string& dep_name) {
    // 依赖添加时的处理
});

component->setRemoveDependencyFunction([](std::shared_ptr<MyService> service, const std::string& dep_name) {
    // 依赖移除时的处理
});
```

## 条件匹配操作符

- `EQUALS`: 等于
- `NOT_EQUALS`: 不等于
- `CONTAINS`: 包含
- `STARTS_WITH`: 开头是
- `ENDS_WITH`: 结尾是
- `GREATER`: 大于（数字比较）
- `GREATER_OR_EQUAL`: 大于等于
- `LESS`: 小于
- `LESS_OR_EQUAL`: 小于等于
- `REGEX`: 正则表达式匹配

## 构建和测试

```bash
# 配置构建
mkdir build && cd build
cmake ..

# 构建库和示例
cmake --build .

# 运行示例
./bin/examples/dependency_example

# 运行测试（如果启用）
ctest
```

## API 参考

### Component 类

```cpp
template<typename ServiceType>
Component(const std::string& name, std::shared_ptr<ServiceType> service);

// 属性管理
void setAttribute(const std::string& key, const std::string& value);
std::string getAttribute(const std::string& key) const;
void setAttributes(const std::map<std::string, std::string>& attrs);

// 依赖管理
void addDependency(const Dependency& dependency);
void removeDependency(const std::string& dependency_name);

// 生命周期函数
template<typename ServiceType>
void setStartFunction(std::function<void(std::shared_ptr<ServiceType>)> func);
```

### DependencyManager 类

```cpp
// 声明式API
void registerComponent(std::shared_ptr<Component> component);
void unregisterComponent(const std::string& component_name);
void addDependency(const std::string& component_name, const Dependency& dependency);
void removeDependency(const std::string& component_name, const std::string& dependency_name);

// 执行操作
void run();

// 生命周期控制
void startComponent(const std::string& component_name);
void stopComponent(const std::string& component_name);
void startAllComponents();
void stopAllComponents();

// 查询接口
bool hasComponent(const std::string& component_name) const;
std::vector<std::string> getStartupOrder() const;
std::vector<std::string> getShutdownOrder() const;
bool detectCircularDependency() const;
```

## 许可证

本项目采用 MIT 许可证。详见 LICENSE 文件。

## 贡献

欢迎提交 Issue 和 Pull Request！
