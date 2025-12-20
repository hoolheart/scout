#include "rope/component.h"
#include "rope/dependency_manager.h"
#include <iostream>
#include <memory>

// 简单的服务类
class SimpleService {
public:
    void start() {
        std::cout << "[SimpleService] Started" << std::endl;
    }

    void stop() {
        std::cout << "[SimpleService] Stopped" << std::endl;
    }

    void onDependencyAdded(const std::string& dep_name) {
        std::cout << "[SimpleService] Dependency added: " << dep_name << std::endl;
    }

    void onDependencyRemoved(const std::string& dep_name) {
        std::cout << "[SimpleService] Dependency removed: " << dep_name << std::endl;
    }
};

int main() {
    std::cout << "=== Rope 简单测试 ===" << std::endl;

    try {
        // 创建依赖管理器
        rope::DependencyManager manager;
        manager.setVerboseLogging(true);

        // 创建服务实例
        auto service1 = std::make_shared<SimpleService>();
        auto service2 = std::make_shared<SimpleService>();

        // 创建组件
        auto component1 = std::make_shared<rope::Component>("service1", service1);
        auto component2 = std::make_shared<rope::Component>("service2", service2);

        // 设置生命周期函数
        component1->setStartFunction<SimpleService>([](std::shared_ptr<SimpleService> s) {
            s->start();
        });

        component1->setStopFunction<SimpleService>([](std::shared_ptr<SimpleService> s) {
            s->stop();
        });

        component2->setStartFunction<SimpleService>([](std::shared_ptr<SimpleService> s) {
            s->start();
        });

        component2->setStopFunction<SimpleService>([](std::shared_ptr<SimpleService> s) {
            s->stop();
        });

        // 设置组件属性
        component1->setAttribute("type", "database");
        component1->setAttribute("version", "1.0");

        component2->setAttribute("type", "cache");
        component2->setAttribute("version", "2.0");

        std::cout << "\n--- 注册组件 ---" << std::endl;

        // 注册组件
        manager.registerComponent(component1);
        manager.registerComponent(component2);
        manager.run();

        std::cout << "\n--- 添加依赖 ---" << std::endl;

        // 添加依赖：service2 依赖 service1
        rope::Dependency dep("service1", rope::Dependency::Type::REQUIRED);
        manager.addDependency("service2", dep);
        manager.run();

        std::cout << "\n--- 组件状态 ---" << std::endl;
        manager.printComponentStates();

        std::cout << "\n--- 依赖关系图 ---" << std::endl;
        manager.printDependencyGraph();

        std::cout << "\n--- 启动顺序 ---" << std::endl;
        auto startup_order = manager.getStartupOrder();
        for (size_t i = 0; i < startup_order.size(); ++i) {
            if (i > 0) std::cout << " -> ";
            std::cout << startup_order[i];
        }
        std::cout << std::endl;

        std::cout << "\n--- 启动所有组件 ---" << std::endl;
        manager.startAllComponents();

        std::cout << "\n--- 启动后的状态 ---" << std::endl;
        manager.printComponentStates();

        std::cout << "\n--- 停止所有组件 ---" << std::endl;
        manager.stopAllComponents();

        std::cout << "\n--- 停止后的状态 ---" << std::endl;
        manager.printComponentStates();

        std::cout << "\n=== 测试完成 ===" << std::endl;

    } catch (const std::exception& e) {
        std::cerr << "错误: " << e.what() << std::endl;
        return 1;
    }

    return 0;
}
