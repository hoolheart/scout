#include "rope/dependency_manager.h"
#include <algorithm>
#include <stack>
#include <unordered_set>
#include <stdexcept>
#include <iostream>
#include <sstream>
#include <queue>
#include <functional>

namespace rope {

// DependencyManager 类实现

DependencyManager::DependencyManager() {
}

// 声明式API实现

void DependencyManager::registerComponent(std::shared_ptr<Component> component) {
    if (!component) {
        logError("Cannot register null component");
        return;
    }

    if (!isValidComponentName(component->getName())) {
        logError("Invalid component name: " + component->getName());
        return;
    }

    pending_operations_.push_back(
        std::make_unique<RegisterComponentOp>(component)
    );
    logVerbose("Queued register component operation: " + component->getName());
}

void DependencyManager::unregisterComponent(const std::string& component_name) {
    pending_operations_.push_back(
        std::make_unique<UnregisterComponentOp>(component_name)
    );
    logVerbose("Queued unregister component operation: " + component_name);
}

void DependencyManager::addDependency(const std::string& component_name, const Dependency& dependency) {
    pending_operations_.push_back(
        std::make_unique<AddDependencyOp>(component_name, dependency)
    );
    logVerbose("Queued add dependency operation: " + component_name + " -> " + dependency.getName());
}

void DependencyManager::removeDependency(const std::string& component_name, const std::string& dependency_name) {
    pending_operations_.push_back(
        std::make_unique<RemoveDependencyOp>(component_name, dependency_name)
    );
    logVerbose("Queued remove dependency operation: " + component_name + " -> " + dependency_name);
}

void DependencyManager::updateComponentAttributes(const std::string& component_name,
                                                const std::map<std::string, std::string>& attributes) {
    pending_operations_.push_back(
        std::make_unique<UpdateComponentAttributesOp>(component_name, attributes)
    );
    logVerbose("Queued update attributes operation: " + component_name);
}

void DependencyManager::run() {
    logVerbose("Executing pending operations...");

    while (!pending_operations_.empty()) {
        auto operation = std::move(pending_operations_.front());
        pending_operations_.pop_front();

        try {
            operation->execute(*this);
        } catch (const std::exception& e) {
            logError("Error executing operation: " + std::string(e.what()));
        }
    }

    logVerbose("All pending operations executed");
}

// 直接操作实现

void DependencyManager::registerComponentImmediate(std::shared_ptr<Component> component) {
    if (!component) {
        throw std::invalid_argument("Cannot register null component");
    }

    if (!isValidComponentName(component->getName())) {
        throw std::invalid_argument("Invalid component name: " + component->getName());
    }

    const std::string& name = component->getName();

    // 检查是否已存在
    if (components_.find(name) != components_.end()) {
        logError("Component already registered: " + name);
        return;
    }

    components_[name] = component;
    component->setState(Component::State::INITIALIZED);

    logVerbose("Component registered: " + name);

    // 处理组件注册事件
    handleComponentRegistered(name);

    // 自动生命周期管理
    if (auto_lifecycle_enabled_) {
        checkAndStartComponent(name);
    }
}

void DependencyManager::unregisterComponentImmediate(const std::string& component_name) {
    auto it = components_.find(component_name);
    if (it == components_.end()) {
        logError("Component not found: " + component_name);
        return;
    }

    auto component = it->second;

    // 先停止组件
    if (component->getState() == Component::State::STARTED && auto_lifecycle_enabled_) {
        checkAndStopComponent(component_name);
    }

    // 从其他组件中移除对此组件的依赖
    for (auto& [name, comp] : components_) {
        if (name != component_name) {
            comp->removeDependency(component_name);
        }
    }

    components_.erase(it);
    logVerbose("Component unregistered: " + component_name);

    // 处理组件注销事件
    handleComponentUnregistered(component_name);
}

void DependencyManager::addDependencyImmediate(const std::string& component_name, const Dependency& dependency) {
    auto component_it = components_.find(component_name);
    if (component_it == components_.end()) {
        throw std::invalid_argument("Component not found: " + component_name);
    }

    validateDependency(component_name, dependency);

    auto component = component_it->second;
    component->addDependency(dependency);

    logVerbose("Dependency added: " + component_name + " -> " + dependency.getName());

    // 处理依赖添加事件
    handleDependencyAdded(component_name, dependency);

    // 自动生命周期管理
    if (auto_lifecycle_enabled_) {
        checkAndStartComponent(component_name);
    }
}

void DependencyManager::removeDependencyImmediate(const std::string& component_name, const std::string& dependency_name) {
    auto component_it = components_.find(component_name);
    if (component_it == components_.end()) {
        logError("Component not found: " + component_name);
        return;
    }

    auto component = component_it->second;
    if (!component->hasDependency(dependency_name)) {
        logError("Dependency not found: " + component_name + " -> " + dependency_name);
        return;
    }

    component->removeDependency(dependency_name);

    logVerbose("Dependency removed: " + component_name + " -> " + dependency_name);

    // 处理依赖删除事件
    handleDependencyRemoved(component_name, dependency_name);

    // 自动生命周期管理
    if (auto_lifecycle_enabled_) {
        checkAndStopComponent(component_name);
    }
}

// 查询接口实现

bool DependencyManager::hasComponent(const std::string& component_name) const {
    return components_.find(component_name) != components_.end();
}

std::shared_ptr<Component> DependencyManager::getComponent(const std::string& component_name) const {
    auto it = components_.find(component_name);
    return (it != components_.end()) ? it->second : nullptr;
}

std::vector<std::string> DependencyManager::getComponentNames() const {
    std::vector<std::string> names;
    for (const auto& [name, component] : components_) {
        names.push_back(name);
    }
    return names;
}

std::vector<std::string> DependencyManager::getDependents(const std::string& component_name) const {
    std::vector<std::string> dependents;
    for (const auto& [name, component] : components_) {
        if (component->hasDependency(component_name)) {
            dependents.push_back(name);
        }
    }
    return dependents;
}

std::vector<std::string> DependencyManager::getDependencies(const std::string& component_name) const {
    auto component = getComponent(component_name);
    if (!component) {
        return {};
    }

    std::vector<std::string> dependencies;
    for (const auto& dep : component->getDependencies()) {
        dependencies.push_back(dep.getName());
    }
    return dependencies;
}

// 依赖解析和生命周期管理

bool DependencyManager::areRequiredDependenciesSatisfied(const std::string& component_name) const {
    auto component = getComponent(component_name);
    if (!component) {
        return false;
    }

    for (const auto& dependency : component->getDependencies()) {
        if (dependency.getType() == Dependency::Type::REQUIRED) {
            auto matching_components = findMatchingComponents(dependency);
            if (matching_components.empty()) {
                return false;
            }

            // 检查匹配的组件是否已启动
            bool any_started = false;
            for (const auto& match_name : matching_components) {
                auto match_component = getComponent(match_name);
                if (match_component && match_component->getState() == Component::State::STARTED) {
                    any_started = true;
                    break;
                }
            }

            if (!any_started) {
                return false;
            }
        }
    }

    return true;
}

std::vector<std::string> DependencyManager::getStartupOrder() const {
    return topologicalSort();
}

std::vector<std::string> DependencyManager::getShutdownOrder() const {
    auto startup_order = getStartupOrder();
    std::reverse(startup_order.begin(), startup_order.end());
    return startup_order;
}

bool DependencyManager::detectCircularDependency() const {
    std::map<std::string, std::vector<std::string>> graph;
    buildDependencyGraph(graph);

    std::unordered_set<std::string> visited;
    std::unordered_set<std::string> rec_stack;

    std::function<bool(const std::string&)> has_cycle =
        [&](const std::string& node) -> bool {
        visited.insert(node);
        rec_stack.insert(node);

        for (const auto& neighbor : graph[node]) {
            if (rec_stack.find(neighbor) != rec_stack.end()) {
                return true; // 找到环
            }
            if (visited.find(neighbor) == visited.end() && has_cycle(neighbor)) {
                return true;
            }
        }

        rec_stack.erase(node);
        return false;
    };

    for (const auto& [node, neighbors] : graph) {
        if (visited.find(node) == visited.end()) {
            if (has_cycle(node)) {
                return true;
            }
        }
    }

    return false;
}

// 手动生命周期控制

void DependencyManager::startComponent(const std::string& component_name) {
    auto component = getComponent(component_name);
    if (!component) {
        throw std::invalid_argument("Component not found: " + component_name);
    }

    if (component->getState() != Component::State::INITIALIZED) {
        logError("Component not in initialized state: " + component_name);
        return;
    }

    if (!areRequiredDependenciesSatisfied(component_name)) {
        logError("Required dependencies not satisfied for component: " + component_name);
        return;
    }

    try {
        component->executeStart();
        logVerbose("Component started: " + component_name);

        // 通知依赖此组件的其他组件
        auto dependents = getDependents(component_name);
        for (const auto& dependent : dependents) {
            checkAndStartComponent(dependent);
        }
    } catch (const std::exception& e) {
        logError("Failed to start component " + component_name + ": " + e.what());
    }
}

void DependencyManager::stopComponent(const std::string& component_name) {
    auto component = getComponent(component_name);
    if (!component) {
        throw std::invalid_argument("Component not found: " + component_name);
    }

    if (component->getState() != Component::State::STARTED) {
        logError("Component not in started state: " + component_name);
        return;
    }

    // 检查是否有其他组件依赖此组件
    auto dependents = getDependents(component_name);
    for (const auto& dependent : dependents) {
        auto dep_component = getComponent(dependent);
        if (dep_component && dep_component->getState() == Component::State::STARTED) {
            logError("Cannot stop component " + component_name + " because " + dependent + " depends on it");
            return;
        }
    }

    try {
        component->executeStop();
        logVerbose("Component stopped: " + component_name);
    } catch (const std::exception& e) {
        logError("Failed to stop component " + component_name + ": " + e.what());
    }
}

void DependencyManager::startAllComponents() {
    auto order = getStartupOrder();
    for (const auto& name : order) {
        if (areRequiredDependenciesSatisfied(name)) {
            startComponent(name);
        }
    }
}

void DependencyManager::stopAllComponents() {
    auto order = getShutdownOrder();
    for (const auto& name : order) {
        auto component = getComponent(name);
        if (component && component->getState() == Component::State::STARTED) {
            // 在停止所有组件时，跳过依赖检查
            try {
                component->executeStop();
                logVerbose("Component stopped: " + name);
            } catch (const std::exception& e) {
                logError("Failed to stop component " + name + ": " + e.what());
            }
        }
    }
}

// 私有方法实现

void DependencyManager::buildDependencyGraph(std::map<std::string, std::vector<std::string>>& graph) const {
    graph.clear();

    // 初始化所有节点
    for (const auto& [name, component] : components_) {
        graph[name] = std::vector<std::string>();
    }

    // 添加依赖边：如果A依赖B，那么边是 B -> A
    // 这样在拓扑排序中，B会先于A被处理
    for (const auto& [name, component] : components_) {
        for (const auto& dependency : component->getDependencies()) {
            auto matches = findMatchingComponents(dependency);
            for (const auto& match : matches) {
                // 如果name依赖match，那么边是 match -> name
                graph[match].push_back(name);
            }
        }
    }
}

void DependencyManager::buildReverseDependencyGraph(std::map<std::string, std::vector<std::string>>& graph) const {
    graph.clear();

    // 初始化所有节点
    for (const auto& [name, component] : components_) {
        graph[name] = std::vector<std::string>();
    }

    // 添加反向依赖边
    for (const auto& [name, component] : components_) {
        for (const auto& dependency : component->getDependencies()) {
            auto matches = findMatchingComponents(dependency);
            for (const auto& match : matches) {
                graph[match].push_back(name);
            }
        }
    }
}

std::vector<std::string> DependencyManager::topologicalSort() const {
    std::map<std::string, std::vector<std::string>> graph;
    buildDependencyGraph(graph);

    std::unordered_map<std::string, int> in_degree;
    for (const auto& [node, neighbors] : graph) {
        in_degree[node] = 0;
    }

    for (const auto& [node, neighbors] : graph) {
        for (const auto& neighbor : neighbors) {
            in_degree[neighbor]++;
        }
    }

    // 使用优先队列确保确定性排序（按字母顺序）
    std::priority_queue<std::string, std::vector<std::string>, std::greater<std::string>> queue;
    for (const auto& [node, degree] : in_degree) {
        if (degree == 0) {
            queue.push(node);
        }
    }

    std::vector<std::string> result;
    while (!queue.empty()) {
        auto node = queue.top();
        queue.pop();
        result.push_back(node);

        for (const auto& neighbor : graph[node]) {
            in_degree[neighbor]--;
            if (in_degree[neighbor] == 0) {
                queue.push(neighbor);
            }
        }
    }

    if (result.size() != components_.size()) {
        throw std::runtime_error("Circular dependency detected");
    }

    return result;
}

void DependencyManager::checkAndStartComponent(const std::string& component_name) {
    auto component = getComponent(component_name);
    if (!component) return;

    if (component->getState() != Component::State::INITIALIZED) return;
    if (!component->hasStartFunction()) return;
    if (!areRequiredDependenciesSatisfied(component_name)) return;

    try {
        startComponent(component_name);
    } catch (const std::exception& e) {
        logError("Failed to start component " + component_name + ": " + e.what());
    }
}

void DependencyManager::checkAndStopComponent(const std::string& component_name) {
    auto component = getComponent(component_name);
    if (!component) return;

    if (component->getState() != Component::State::STARTED) return;
    if (!component->hasStopFunction()) return;

    // 检查是否有其他组件依赖此组件
    auto dependents = getDependents(component_name);
    for (const auto& dependent : dependents) {
        auto dep_component = getComponent(dependent);
        if (dep_component && dep_component->getState() == Component::State::STARTED) {
            return; // 有正在运行的依赖组件，不能停止
        }
    }

    try {
        stopComponent(component_name);
    } catch (const std::exception& e) {
        logError("Failed to stop component " + component_name + ": " + e.what());
    }
}

void DependencyManager::initializeComponent(const std::string& component_name) {
    auto component = getComponent(component_name);
    if (component && component->getState() == Component::State::UNINITIALIZED) {
        component->setState(Component::State::INITIALIZED);
        logVerbose("Component initialized: " + component_name);
    }
}

void DependencyManager::handleDependencyAdded(const std::string& component_name, const Dependency& dependency) {
    auto component = getComponent(component_name);
    if (component && component->hasAddDependencyFunction()) {
        component->executeAddDependency(dependency.getName());
    }
}

void DependencyManager::handleDependencyRemoved(const std::string& component_name, const std::string& dependency_name) {
    auto component = getComponent(component_name);
    if (component && component->hasRemoveDependencyFunction()) {
        component->executeRemoveDependency(dependency_name);
    }

    // 检查被移除的依赖组件是否可以停止
    if (auto_lifecycle_enabled_) {
        checkAndStopComponent(dependency_name);
    }
}

void DependencyManager::handleComponentRegistered(const std::string& component_name) {
    logVerbose("Component registered event: " + component_name);
}

void DependencyManager::handleComponentUnregistered(const std::string& component_name) {
    logVerbose("Component unregistered event: " + component_name);
}

std::vector<std::string> DependencyManager::findMatchingComponents(const Dependency& dependency) const {
    std::vector<std::string> matches;

    if (dependency.getName().empty()) {
        return matches;
    }

    // 如果依赖名称是具体的组件名
    auto component = getComponent(dependency.getName());
    if (component) {
        if (dependency.getConditions().empty() ||
            dependency.matchesConditions(component->getAllAttributes())) {
            matches.push_back(dependency.getName());
        }
    }

    return matches;
}

void DependencyManager::logVerbose(const std::string& message) const {
    if (verbose_logging_) {
        std::cout << "[DependencyManager] " << message << std::endl;
    }
}

void DependencyManager::logError(const std::string& message) const {
    std::cerr << "[DependencyManager ERROR] " << message << std::endl;
}

bool DependencyManager::isValidComponentName(const std::string& name) const {
    if (name.empty()) return false;

    // 检查名称是否只包含有效字符
    for (char c : name) {
        if (!std::isalnum(c) && c != '_' && c != '-') {
            return false;
        }
    }

    return true;
}

void DependencyManager::validateDependency(const std::string& component_name, const Dependency& dependency) const {
    if (dependency.getName().empty()) {
        throw std::invalid_argument("Dependency name cannot be empty");
    }

    if (dependency.getName() == component_name) {
        throw std::invalid_argument("Component cannot depend on itself");
    }
}

// 调试和诊断

void DependencyManager::printDependencyGraph() const {
    std::cout << "Dependency Graph:" << std::endl;
    std::map<std::string, std::vector<std::string>> graph;
    buildDependencyGraph(graph);

    for (const auto& [node, neighbors] : graph) {
        std::cout << "  " << node;
        if (!neighbors.empty()) {
            std::cout << " -> ";
            for (size_t i = 0; i < neighbors.size(); ++i) {
                if (i > 0) std::cout << ", ";
                std::cout << neighbors[i];
            }
        }
        std::cout << std::endl;
    }
}

void DependencyManager::printComponentStates() const {
    std::cout << "Component States:" << std::endl;
    for (const auto& [name, component] : components_) {
        std::cout << "  " << name << ": " << component->stateToString(component->getState()) << std::endl;
    }
}

std::string DependencyManager::getDependencyGraphAsDot() const {
    std::stringstream ss;
    ss << "digraph DependencyGraph {" << std::endl;

    std::map<std::string, std::vector<std::string>> graph;
    buildDependencyGraph(graph);

    for (const auto& [node, neighbors] : graph) {
        for (const auto& neighbor : neighbors) {
            ss << "  \"" << node << "\" -> \"" << neighbor << "\";" << std::endl;
        }
    }

    ss << "}" << std::endl;
    return ss.str();
}

} // namespace rope
