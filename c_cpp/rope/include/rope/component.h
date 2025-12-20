#ifndef COMPONENT_H
#define COMPONENT_H

#include <string>
#include <any>
#include <map>
#include <vector>
#include <functional>
#include <memory>
#include "rope_export.h"

namespace rope {

/**
 * @brief 依赖类 - 描述组件之间的依赖关系
 */
class ROPE_API Dependency {
public:
    /**
     * @brief 依赖类型
     */
    enum class Type {
        REQUIRED,     // 必要依赖
        OPTIONAL      // 非必要依赖
    };

    /**
     * @brief 依赖基数
     */
    enum class Cardinality {
        SINGLE,       // 只选一个
        MULTIPLE      // 可选多个
    };

    /**
     * @brief 条件匹配操作符
     */
    enum class MatchOperator {
        EQUALS,           // 等于
        NOT_EQUALS,       // 不等于
        CONTAINS,         // 包含
        STARTS_WITH,      // 开头是
        ENDS_WITH,        // 结尾是
        GREATER,          // 大于
        GREATER_OR_EQUAL,  // 大于等于
        LESS,             // 小于
        LESS_OR_EQUAL,     // 小于等于
        REGEX             // 正则表达式
    };

private:
    std::string name_;
    Type type_;
    Cardinality cardinality_;
    std::map<std::string, std::pair<MatchOperator, std::string>> conditions_;
    std::string description_;
    int priority_ = 0;
    bool delayed_start_ = false;

public:
    /**
     * @brief 构造函数
     * @param name 依赖的服务名
     * @param type 依赖类型
     * @param cardinality 依赖基数
     */
    Dependency(const std::string& name, Type type = Type::REQUIRED,
               Cardinality cardinality = Cardinality::SINGLE);

    // 获取基本信息
    const std::string& getName() const { return name_; }
    Type getType() const { return type_; }
    Cardinality getCardinality() const { return cardinality_; }
    const std::string& getDescription() const { return description_; }

    // 设置描述
    void setDescription(const std::string& desc) { description_ = desc; }

    // 优先级和延迟启动
    void setPriority(int priority) { priority_ = priority; }
    int getPriority() const { return priority_; }
    void setDelayedStart(bool delayed) { delayed_start_ = delayed; }
    bool isDelayedStart() const { return delayed_start_; }

    // 条件管理
    void addCondition(const std::string& attribute, const std::string& value,
                      MatchOperator op = MatchOperator::EQUALS);
    void removeCondition(const std::string& attribute);
    const std::map<std::string, std::pair<MatchOperator, std::string>>& getConditions() const;

    // 条件匹配
    bool matchesConditions(const std::map<std::string, std::string>& attributes) const;

    // 比较操作符（用于 std::find）
    bool operator==(const Dependency& other) const {
        return name_ == other.name_;
    }
};

/**
 * @brief 组件类 - 表示一个服务及其依赖关系
 */
class ROPE_API Component {
public:
    /**
     * @brief 组件状态
     */
    enum class State {
        UNINITIALIZED,  // 未初始化
        INITIALIZING,   // 初始化中
        INITIALIZED,    // 已初始化
        STARTING,       // 启动中
        STARTED,        // 已启动
        STOPPING,       // 停止中
        STOPPED,        // 已停止
        ERROR           // 错误状态
    };

    // 生命周期函数类型定义
    template<typename ServiceType>
    using StartFunction = std::function<void(std::shared_ptr<ServiceType>)>;

    template<typename ServiceType>
    using StopFunction = std::function<void(std::shared_ptr<ServiceType>)>;

    template<typename ServiceType>
    using AddDependencyFunction = std::function<void(std::shared_ptr<ServiceType>, const std::string&)>;

    template<typename ServiceType>
    using RemoveDependencyFunction = std::function<void(std::shared_ptr<ServiceType>, const std::string&)>;

private:
    std::string name_;
    std::any service_ptr_;
    std::map<std::string, std::string> attributes_;
    State state_;
    std::vector<Dependency> dependencies_;

    // 生命周期函数（使用 std::any 进行类型擦除）
    std::any start_func_;
    std::any stop_func_;
    std::any add_dep_func_;
    std::any remove_dep_func_;

    // 类型擦除的执行函数
    std::function<void()> execute_start_;
    std::function<void()> execute_stop_;
    std::function<void(const std::string&)> execute_add_dep_;
    std::function<void(const std::string&)> execute_remove_dep_;

public:
    /**
     * @brief 构造函数模板
     * @param name 组件名称
     * @param service 服务指针
     */
    template<typename ServiceType>
    Component(const std::string& name, std::shared_ptr<ServiceType> service);

    /**
     * @brief 析构函数
     */
    ~Component() = default;

    // 基本信息
    const std::string& getName() const { return name_; }
    State getState() const { return state_; }
    void setState(State state) { state_ = state; }

    // 属性管理
    void setAttribute(const std::string& key, const std::string& value);
    std::string getAttribute(const std::string& key) const;
    bool hasAttribute(const std::string& key) const;
    void removeAttribute(const std::string& key);
    void setAttributes(const std::map<std::string, std::string>& attrs);
    const std::map<std::string, std::string>& getAllAttributes() const { return attributes_; }

    // 服务指针管理
    template<typename ServiceType>
    void setService(std::shared_ptr<ServiceType> service);

    template<typename ServiceType>
    std::shared_ptr<ServiceType> getService() const;

    // 依赖管理
    void addDependency(const Dependency& dependency);
    void removeDependency(const std::string& dependency_name);
    const std::vector<Dependency>& getDependencies() const { return dependencies_; }
    bool hasDependency(const std::string& dependency_name) const;

    // 设置生命周期函数
    template<typename ServiceType>
    void setStartFunction(std::function<void(std::shared_ptr<ServiceType>)> func);

    template<typename ServiceType>
    void setStopFunction(std::function<void(std::shared_ptr<ServiceType>)> func);

    template<typename ServiceType>
    void setAddDependencyFunction(std::function<void(std::shared_ptr<ServiceType>, const std::string&)> func);

    template<typename ServiceType>
    void setRemoveDependencyFunction(std::function<void(std::shared_ptr<ServiceType>, const std::string&)> func);

    // 执行生命周期函数
    void executeStart();
    void executeStop();
    void executeAddDependency(const std::string& dependency_name);
    void executeRemoveDependency(const std::string& dependency_name);

    // 检查生命周期函数是否已设置
    bool hasStartFunction() const { return static_cast<bool>(execute_start_); }
    bool hasStopFunction() const { return static_cast<bool>(execute_stop_); }
    bool hasAddDependencyFunction() const { return static_cast<bool>(execute_add_dep_); }
    bool hasRemoveDependencyFunction() const { return static_cast<bool>(execute_remove_dep_); }

    // 状态转换
    std::string stateToString(State state) const;
};

// 模板实现必须在头文件中

template<typename ServiceType>
Component::Component(const std::string& name, std::shared_ptr<ServiceType> service)
    : name_(name), service_ptr_(service), state_(State::UNINITIALIZED) {
}

template<typename ServiceType>
void Component::setService(std::shared_ptr<ServiceType> service) {
    service_ptr_ = service;
}

template<typename ServiceType>
std::shared_ptr<ServiceType> Component::getService() const {
    try {
        return std::any_cast<std::shared_ptr<ServiceType>>(service_ptr_);
    } catch (const std::bad_any_cast& e) {
        return nullptr;
    }
}

template<typename ServiceType>
void Component::setStartFunction(std::function<void(std::shared_ptr<ServiceType>)> func) {
    auto service = std::any_cast<std::shared_ptr<ServiceType>>(service_ptr_);
    start_func_ = func;
    execute_start_ = [func, service]() {
        func(service);
    };
}

template<typename ServiceType>
void Component::setStopFunction(std::function<void(std::shared_ptr<ServiceType>)> func) {
    auto service = std::any_cast<std::shared_ptr<ServiceType>>(service_ptr_);
    stop_func_ = func;
    execute_stop_ = [func, service]() {
        func(service);
    };
}

template<typename ServiceType>
void Component::setAddDependencyFunction(std::function<void(std::shared_ptr<ServiceType>, const std::string&)> func) {
    auto service = std::any_cast<std::shared_ptr<ServiceType>>(service_ptr_);
    add_dep_func_ = func;
    execute_add_dep_ = [func, service](const std::string& dep_name) {
        func(service, dep_name);
    };
}

template<typename ServiceType>
void Component::setRemoveDependencyFunction(std::function<void(std::shared_ptr<ServiceType>, const std::string&)> func) {
    auto service = std::any_cast<std::shared_ptr<ServiceType>>(service_ptr_);
    remove_dep_func_ = func;
    execute_remove_dep_ = [func, service](const std::string& dep_name) {
        func(service, dep_name);
    };
}

} // namespace rope

#endif // COMPONENT_H
