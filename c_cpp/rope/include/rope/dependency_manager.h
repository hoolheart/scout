#ifndef DEPENDENCY_MANAGER_H
#define DEPENDENCY_MANAGER_H

#include <string>
#include <map>
#include <vector>
#include <memory>
#include <queue>
#include <functional>
#include <unordered_set>
#include "component.h"
#include "rope_export.h"

namespace rope {

/**
 * @brief 依赖管理器类 - 管理所有组件和它们的依赖关系
 */
class ROPE_API DependencyManager {
public:
    /**
     * @brief 操作类型
     */
    enum class OperationType {
        REGISTER_COMPONENT,
        UNREGISTER_COMPONENT,
        ADD_DEPENDENCY,
        REMOVE_DEPENDENCY,
        UPDATE_COMPONENT_ATTRIBUTES
    };

    /**
     * @brief 操作基类
     */
    class Operation {
    public:
        virtual ~Operation() = default;
        virtual void execute(DependencyManager& manager) = 0;
        virtual OperationType getType() const = 0;

        // 禁用拷贝，支持移动
        Operation() = default;
        Operation(const Operation&) = delete;
        Operation& operator=(const Operation&) = delete;
        Operation(Operation&&) = default;
        Operation& operator=(Operation&&) = default;

        // 克隆函数用于支持多态拷贝
        virtual std::unique_ptr<Operation> clone() const = 0;
    };

private:
    std::map<std::string, std::shared_ptr<Component>> components_;
    std::deque<std::unique_ptr<Operation>> pending_operations_;
    bool auto_lifecycle_enabled_ = true;
    bool verbose_logging_ = false;

public:
    /**
     * @brief 构造函数
     */
    DependencyManager();

    /**
     * @brief 析构函数
     */
    ~DependencyManager() = default;

    // 禁用拷贝，支持移动
    DependencyManager(const DependencyManager&) = delete;
    DependencyManager& operator=(const DependencyManager&) = delete;
    DependencyManager(DependencyManager&&) = default;
    DependencyManager& operator=(DependencyManager&&) = default;

    // 配置选项
    void setAutoLifecycleManagement(bool enabled) { auto_lifecycle_enabled_ = enabled; }
    void enableAutoLifecycle(bool enabled) { auto_lifecycle_enabled_ = enabled; }
    bool isAutoLifecycleManagementEnabled() const { return auto_lifecycle_enabled_; }
    void setVerboseLogging(bool enabled) { verbose_logging_ = enabled; }
    bool isVerboseLoggingEnabled() const { return verbose_logging_; }

    // 声明式API
    void registerComponent(std::shared_ptr<Component> component);
    void unregisterComponent(const std::string& component_name);
    void addDependency(const std::string& component_name, const Dependency& dependency);
    void removeDependency(const std::string& component_name, const std::string& dependency_name);
    void updateComponentAttributes(const std::string& component_name,
                                  const std::map<std::string, std::string>& attributes);

    // 执行所有待处理的操作
    void run();

    // 直接操作（非声明式，立即执行）
    void registerComponentImmediate(std::shared_ptr<Component> component);
    void unregisterComponentImmediate(const std::string& component_name);
    void addDependencyImmediate(const std::string& component_name, const Dependency& dependency);
    void removeDependencyImmediate(const std::string& component_name, const std::string& dependency_name);

    // 查询接口
    bool hasComponent(const std::string& component_name) const;
    std::shared_ptr<Component> getComponent(const std::string& component_name) const;
    std::vector<std::string> getComponentNames() const;
    std::vector<std::string> getDependents(const std::string& component_name) const;
    std::vector<std::string> getDependencies(const std::string& component_name) const;

    // 依赖解析和生命周期管理
    bool areRequiredDependenciesSatisfied(const std::string& component_name) const;
    std::vector<std::string> getStartupOrder() const;
    std::vector<std::string> getShutdownOrder() const;
    bool detectCircularDependency() const;

    // 手动生命周期控制
    void startComponent(const std::string& component_name);
    void stopComponent(const std::string& component_name);
    void startAllComponents();
    void stopAllComponents();

    // 调试和诊断
    void printDependencyGraph() const;
    void printComponentStates() const;
    std::string getDependencyGraphAsDot() const;

private:
    // 内部操作类
    class RegisterComponentOp;
    class UnregisterComponentOp;
    class AddDependencyOp;
    class RemoveDependencyOp;
    class UpdateComponentAttributesOp;

    // 依赖关系图管理
    void buildDependencyGraph(std::map<std::string, std::vector<std::string>>& graph) const;
    void buildReverseDependencyGraph(std::map<std::string, std::vector<std::string>>& graph) const;

    // 拓扑排序
    std::vector<std::string> topologicalSort() const;

    // 生命周期管理
    void checkAndStartComponent(const std::string& component_name);
    void checkAndStopComponent(const std::string& component_name);
    void initializeComponent(const std::string& component_name);

    // 依赖关系变化处理
    void handleDependencyAdded(const std::string& component_name, const Dependency& dependency);
    void handleDependencyRemoved(const std::string& component_name, const std::string& dependency_name);
    void handleComponentRegistered(const std::string& component_name);
    void handleComponentUnregistered(const std::string& component_name);

    // 条件匹配
    std::vector<std::string> findMatchingComponents(const Dependency& dependency) const;

    // 日志和调试
    void logVerbose(const std::string& message) const;
    void logError(const std::string& message) const;

    // 工具函数
    bool isValidComponentName(const std::string& name) const;
    void validateDependency(const std::string& component_name, const Dependency& dependency) const;
};

/**
 * @brief 注册组件操作
 */
class DependencyManager::RegisterComponentOp : public DependencyManager::Operation {
private:
    std::shared_ptr<Component> component_;

public:
    explicit RegisterComponentOp(std::shared_ptr<Component> component)
        : component_(component) {}

    // 显式定义拷贝构造函数
    RegisterComponentOp(const RegisterComponentOp& other)
        : Operation(), component_(other.component_) {}

    void execute(DependencyManager& manager) override {
        manager.registerComponentImmediate(component_);
    }

    OperationType getType() const override {
        return OperationType::REGISTER_COMPONENT;
    }

    std::unique_ptr<Operation> clone() const override {
        return std::make_unique<RegisterComponentOp>(*this);
    }

    std::shared_ptr<Component> getComponent() const { return component_; }
};

/**
 * @brief 注销组件操作
 */
class DependencyManager::UnregisterComponentOp : public DependencyManager::Operation {
private:
    std::string component_name_;

public:
    explicit UnregisterComponentOp(const std::string& component_name)
        : component_name_(component_name) {}

    // 显式定义拷贝构造函数
    UnregisterComponentOp(const UnregisterComponentOp& other)
        : Operation(), component_name_(other.component_name_) {}

    void execute(DependencyManager& manager) override {
        manager.unregisterComponentImmediate(component_name_);
    }

    OperationType getType() const override {
        return OperationType::UNREGISTER_COMPONENT;
    }

    std::unique_ptr<Operation> clone() const override {
        return std::make_unique<UnregisterComponentOp>(*this);
    }

    const std::string& getComponentName() const { return component_name_; }
};

/**
 * @brief 添加依赖操作
 */
class DependencyManager::AddDependencyOp : public DependencyManager::Operation {
private:
    std::string component_name_;
    Dependency dependency_;

public:
    AddDependencyOp(const std::string& component_name, const Dependency& dependency)
        : component_name_(component_name), dependency_(dependency) {}

    // 显式定义拷贝构造函数
    AddDependencyOp(const AddDependencyOp& other)
        : Operation(), component_name_(other.component_name_), dependency_(other.dependency_) {}

    void execute(DependencyManager& manager) override {
        manager.addDependencyImmediate(component_name_, dependency_);
    }

    OperationType getType() const override {
        return OperationType::ADD_DEPENDENCY;
    }

    std::unique_ptr<Operation> clone() const override {
        return std::make_unique<AddDependencyOp>(*this);
    }

    const std::string& getComponentName() const { return component_name_; }
    const Dependency& getDependency() const { return dependency_; }
};

/**
 * @brief 删除依赖操作
 */
class DependencyManager::RemoveDependencyOp : public DependencyManager::Operation {
private:
    std::string component_name_;
    std::string dependency_name_;

public:
    RemoveDependencyOp(const std::string& component_name, const std::string& dependency_name)
        : component_name_(component_name), dependency_name_(dependency_name) {}

    // 显式定义拷贝构造函数
    RemoveDependencyOp(const RemoveDependencyOp& other)
        : Operation(), component_name_(other.component_name_), dependency_name_(other.dependency_name_) {}

    void execute(DependencyManager& manager) override {
        manager.removeDependencyImmediate(component_name_, dependency_name_);
    }

    OperationType getType() const override {
        return OperationType::REMOVE_DEPENDENCY;
    }

    std::unique_ptr<Operation> clone() const override {
        return std::make_unique<RemoveDependencyOp>(*this);
    }

    const std::string& getComponentName() const { return component_name_; }
    const std::string& getDependencyName() const { return dependency_name_; }
};

/**
 * @brief 更新组件属性操作
 */
class DependencyManager::UpdateComponentAttributesOp : public DependencyManager::Operation {
private:
    std::string component_name_;
    std::map<std::string, std::string> attributes_;

public:
    UpdateComponentAttributesOp(const std::string& component_name,
                                const std::map<std::string, std::string>& attributes)
        : component_name_(component_name), attributes_(attributes) {}

    // 显式定义拷贝构造函数
    UpdateComponentAttributesOp(const UpdateComponentAttributesOp& other)
        : Operation(), component_name_(other.component_name_), attributes_(other.attributes_) {}

    void execute(DependencyManager& manager) override {
        auto component = manager.getComponent(component_name_);
        if (component) {
            component->setAttributes(attributes_);
            manager.handleDependencyAdded(component_name_, Dependency("")); // 触发重新检查
        }
    }

    OperationType getType() const override {
        return OperationType::UPDATE_COMPONENT_ATTRIBUTES;
    }

    std::unique_ptr<Operation> clone() const override {
        return std::make_unique<UpdateComponentAttributesOp>(*this);
    }

    const std::string& getComponentName() const { return component_name_; }
    const std::map<std::string, std::string>& getAttributes() const { return attributes_; }
};

} // namespace rope

#endif // DEPENDENCY_MANAGER_H
