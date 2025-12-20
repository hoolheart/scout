#include "rope/component.h"
#include <stdexcept>
#include <algorithm>
#include <regex>
#include <sstream>
#include <iostream>

namespace rope {

// Dependency 类实现

Dependency::Dependency(const std::string& name, Type type, Cardinality cardinality)
    : name_(name), type_(type), cardinality_(cardinality) {
}

void Dependency::addCondition(const std::string& attribute, const std::string& value,
                            MatchOperator op) {
    conditions_[attribute] = std::make_pair(op, value);
}

void Dependency::removeCondition(const std::string& attribute) {
    conditions_.erase(attribute);
}

const std::map<std::string, std::pair<Dependency::MatchOperator, std::string>>&
Dependency::getConditions() const {
    return conditions_;
}

bool Dependency::matchesConditions(const std::map<std::string, std::string>& attributes) const {
    for (const auto& [attr, condition_pair] : conditions_) {
        auto [op, value] = condition_pair;

        // 检查组件是否有该属性
        auto it = attributes.find(attr);
        if (it == attributes.end()) {
            return false;
        }

        const std::string& component_value = it->second;

        // 根据操作符进行匹配
        switch (op) {
            case MatchOperator::EQUALS:
                if (component_value != value) return false;
                break;
            case MatchOperator::NOT_EQUALS:
                if (component_value == value) return false;
                break;
            case MatchOperator::CONTAINS:
                if (component_value.find(value) == std::string::npos) return false;
                break;
            case MatchOperator::STARTS_WITH:
                if (component_value.substr(0, value.length()) != value) return false;
                break;
            case MatchOperator::ENDS_WITH:
                if (component_value.length() < value.length() ||
                    component_value.substr(component_value.length() - value.length()) != value) {
                    return false;
                }
                break;
            case MatchOperator::GREATER: {
                try {
                    double comp_num = std::stod(component_value);
                    double cond_num = std::stod(value);
                    if (comp_num <= cond_num) return false;
                } catch (const std::exception&) {
                    return false; // 无法转换为数字
                }
                break;
            }
            case MatchOperator::GREATER_OR_EQUAL: {
                try {
                    double comp_num = std::stod(component_value);
                    double cond_num = std::stod(value);
                    if (comp_num < cond_num) return false;
                } catch (const std::exception&) {
                    return false; // 无法转换为数字
                }
                break;
            }
            case MatchOperator::LESS: {
                try {
                    double comp_num = std::stod(component_value);
                    double cond_num = std::stod(value);
                    if (comp_num >= cond_num) return false;
                } catch (const std::exception&) {
                    return false; // 无法转换为数字
                }
                break;
            }
            case MatchOperator::LESS_OR_EQUAL: {
                try {
                    double comp_num = std::stod(component_value);
                    double cond_num = std::stod(value);
                    if (comp_num > cond_num) return false;
                } catch (const std::exception&) {
                    return false; // 无法转换为数字
                }
                break;
            }
            case MatchOperator::REGEX: {
                try {
                    std::regex pattern(value);
                    if (!std::regex_match(component_value, pattern)) return false;
                } catch (const std::exception&) {
                    return false; // 无效的正则表达式
                }
                break;
            }
        }
    }
    return true;
}

// Component 类实现

void Component::setAttribute(const std::string& key, const std::string& value) {
    attributes_[key] = value;
}

std::string Component::getAttribute(const std::string& key) const {
    auto it = attributes_.find(key);
    if (it != attributes_.end()) {
        return it->second;
    }
    return "";
}

bool Component::hasAttribute(const std::string& key) const {
    return attributes_.find(key) != attributes_.end();
}

void Component::removeAttribute(const std::string& key) {
    attributes_.erase(key);
}

void Component::setAttributes(const std::map<std::string, std::string>& attrs) {
    attributes_ = attrs;
}

void Component::addDependency(const Dependency& dependency) {
    // 检查是否已存在同名依赖
    for (const auto& dep : dependencies_) {
        if (dep.getName() == dependency.getName()) {
            // 替换现有依赖
            auto it = std::find(dependencies_.begin(), dependencies_.end(), dep);
            if (it != dependencies_.end()) {
                *it = dependency;
            }
            return;
        }
    }
    // 添加新依赖
    dependencies_.push_back(dependency);
}

void Component::removeDependency(const std::string& dependency_name) {
    dependencies_.erase(
        std::remove_if(dependencies_.begin(), dependencies_.end(),
                      [&dependency_name](const Dependency& dep) {
                          return dep.getName() == dependency_name;
                      }),
        dependencies_.end()
    );
}

bool Component::hasDependency(const std::string& dependency_name) const {
    for (const auto& dep : dependencies_) {
        if (dep.getName() == dependency_name) {
            return true;
        }
    }
    return false;
}

void Component::executeStart() {
    if (execute_start_) {
        try {
            setState(State::STARTING);
            execute_start_();
            setState(State::STARTED);
        } catch (const std::exception& e) {
            setState(State::ERROR);
            throw;
        }
    }
}

void Component::executeStop() {
    if (execute_stop_) {
        try {
            setState(State::STOPPING);
            execute_stop_();
            setState(State::STOPPED);
        } catch (const std::exception& e) {
            setState(State::ERROR);
            throw;
        }
    }
}

void Component::executeAddDependency(const std::string& dependency_name) {
    if (execute_add_dep_) {
        execute_add_dep_(dependency_name);
    }
}

void Component::executeRemoveDependency(const std::string& dependency_name) {
    if (execute_remove_dep_) {
        execute_remove_dep_(dependency_name);
    }
}

std::string Component::stateToString(State state) const {
    switch (state) {
        case State::UNINITIALIZED: return "UNINITIALIZED";
        case State::INITIALIZING: return "INITIALIZING";
        case State::INITIALIZED: return "INITIALIZED";
        case State::STARTING: return "STARTING";
        case State::STARTED: return "STARTED";
        case State::STOPPING: return "STOPPING";
        case State::STOPPED: return "STOPPED";
        case State::ERROR: return "ERROR";
        default: return "UNKNOWN";
    }
}

} // namespace rope
