#include <gtest/gtest.h>
#include "rope/component.h"
#include "rope/dependency_manager.h"
#include <memory>
#include <stdexcept>

using namespace rope;

// 测试用的简单服务类
class TestService {
public:
    std::string name;
    bool started = false;
    bool stopped = false;

    TestService(const std::string& n = "") : name(n) {}

    void start() {
        started = true;
        stopped = false;
    }

    void stop() {
        started = false;
        stopped = true;
    }

    void onDependencyAdded(const std::string& dep_name) {
        // 测试用，实际不做任何操作
    }

    void onDependencyRemoved(const std::string& dep_name) {
        // 测试用，实际不做任何操作
    }
};

class DependencyManagerTest : public ::testing::Test {
protected:
    void SetUp() override {
        manager = std::make_unique<DependencyManager>();
        manager->setVerboseLogging(false);
    }

    void TearDown() override {
        manager.reset();
    }

    std::unique_ptr<DependencyManager> manager;
};

// 测试组件注册
TEST_F(DependencyManagerTest, RegisterComponent) {
    auto service = std::make_shared<TestService>("test");
    auto component = std::make_shared<Component>("test_component", service);

    EXPECT_FALSE(manager->hasComponent("test_component"));

    manager->registerComponent(component);
    manager->run();

    EXPECT_TRUE(manager->hasComponent("test_component"));
    EXPECT_EQ(manager->getComponent("test_component"), component);
}

// 测试组件注销
TEST_F(DependencyManagerTest, UnregisterComponent) {
    auto service = std::make_shared<TestService>("test");
    auto component = std::make_shared<Component>("test_component", service);

    manager->registerComponent(component);
    manager->run();
    EXPECT_TRUE(manager->hasComponent("test_component"));

    manager->unregisterComponent("test_component");
    manager->run();
    EXPECT_FALSE(manager->hasComponent("test_component"));
}

// 测试依赖添加
TEST_F(DependencyManagerTest, AddDependency) {
    auto service1 = std::make_shared<TestService>("service1");
    auto service2 = std::make_shared<TestService>("service2");
    auto component1 = std::make_shared<Component>("component1", service1);
    auto component2 = std::make_shared<Component>("component2", service2);

    manager->registerComponent(component1);
    manager->registerComponent(component2);
    manager->run();

    Dependency dep("component1", Dependency::Type::REQUIRED);
    manager->addDependency("component2", dep);
    manager->run();

    auto component = manager->getComponent("component2");
    EXPECT_TRUE(component->hasDependency("component1"));
}

// 测试依赖移除
TEST_F(DependencyManagerTest, RemoveDependency) {
    auto service1 = std::make_shared<TestService>("service1");
    auto service2 = std::make_shared<TestService>("service2");
    auto component1 = std::make_shared<Component>("component1", service1);
    auto component2 = std::make_shared<Component>("component2", service2);

    manager->registerComponent(component1);
    manager->registerComponent(component2);
    manager->run();

    Dependency dep("component1", Dependency::Type::REQUIRED);
    manager->addDependency("component2", dep);
    manager->run();

    EXPECT_TRUE(component2->hasDependency("component1"));

    manager->removeDependency("component2", "component1");
    manager->run();

    EXPECT_FALSE(component2->hasDependency("component1"));
}

// 测试依赖解析
TEST_F(DependencyManagerTest, DependencyResolution) {
    auto service1 = std::make_shared<TestService>("service1");
    auto service2 = std::make_shared<TestService>("service2");
    auto service3 = std::make_shared<TestService>("service3");

    auto component1 = std::make_shared<Component>("service1", service1);
    auto component2 = std::make_shared<Component>("service2", service2);
    auto component3 = std::make_shared<Component>("service3", service3);

    // 设置生命周期函数
    component1->setStartFunction<TestService>([](std::shared_ptr<TestService> s) { s->start(); });
    component1->setStopFunction<TestService>([](std::shared_ptr<TestService> s) { s->stop(); });

    component2->setStartFunction<TestService>([](std::shared_ptr<TestService> s) { s->start(); });
    component2->setStopFunction<TestService>([](std::shared_ptr<TestService> s) { s->stop(); });

    component3->setStartFunction<TestService>([](std::shared_ptr<TestService> s) { s->start(); });
    component3->setStopFunction<TestService>([](std::shared_ptr<TestService> s) { s->stop(); });

    manager->registerComponent(component1);
    manager->registerComponent(component2);
    manager->registerComponent(component3);
    manager->run();

    // service2 依赖 service1
    Dependency dep1("service1", Dependency::Type::REQUIRED);
    manager->addDependency("service2", dep1);

    // service3 依赖 service2
    Dependency dep2("service2", Dependency::Type::REQUIRED);
    manager->addDependency("service3", dep2);

    manager->run();

    // 测试启动顺序
    auto startup_order = manager->getStartupOrder();
    EXPECT_EQ(startup_order.size(), 3);
    EXPECT_EQ(startup_order[0], "service1");
    EXPECT_EQ(startup_order[1], "service2");
    EXPECT_EQ(startup_order[2], "service3");

    // 测试停止顺序
    auto shutdown_order = manager->getShutdownOrder();
    EXPECT_EQ(shutdown_order.size(), 3);
    EXPECT_EQ(shutdown_order[0], "service3");
    EXPECT_EQ(shutdown_order[1], "service2");
    EXPECT_EQ(shutdown_order[2], "service1");
}

// 测试循环依赖检测
TEST_F(DependencyManagerTest, CircularDependencyDetection) {
    auto service1 = std::make_shared<TestService>("service1");
    auto service2 = std::make_shared<TestService>("service2");

    auto component1 = std::make_shared<Component>("service1", service1);
    auto component2 = std::make_shared<Component>("service2", service2);

    manager->registerComponent(component1);
    manager->registerComponent(component2);
    manager->run();

    // 创建循环依赖
    Dependency dep1("service2", Dependency::Type::REQUIRED);
    Dependency dep2("service1", Dependency::Type::REQUIRED);

    manager->addDependency("service1", dep1);
    manager->addDependency("service2", dep2);
    manager->run();

    EXPECT_TRUE(manager->detectCircularDependency());
}

// 测试条件匹配
TEST_F(DependencyManagerTest, ConditionMatching) {
    auto service = std::make_shared<TestService>("service");
    auto component = std::make_shared<Component>("service", service);

    component->setAttributes({
        {"type", "database"},
        {"version", "1.2.3"},
        {"host", "localhost"}
    });

    manager->registerComponent(component);
    manager->run();

    // 测试等于条件
    Dependency dep1("service", Dependency::Type::REQUIRED);
    dep1.addCondition("type", "database");
    EXPECT_TRUE(dep1.matchesConditions(component->getAllAttributes()));

    // 测试不等于条件
    Dependency dep2("service", Dependency::Type::REQUIRED);
    dep2.addCondition("type", "cache", Dependency::MatchOperator::NOT_EQUALS);
    EXPECT_TRUE(dep2.matchesConditions(component->getAllAttributes()));

    // 测试包含条件
    Dependency dep3("service", Dependency::Type::REQUIRED);
    dep3.addCondition("host", "host", Dependency::MatchOperator::CONTAINS);
    EXPECT_TRUE(dep3.matchesConditions(component->getAllAttributes()));

    // 测试数字比较
    Dependency dep4("service", Dependency::Type::REQUIRED);
    dep4.addCondition("version", "1.0", Dependency::MatchOperator::GREATER);
    EXPECT_TRUE(dep4.matchesConditions(component->getAllAttributes()));
}

// 测试生命周期管理
TEST_F(DependencyManagerTest, LifecycleManagement) {
    auto service1 = std::make_shared<TestService>("service1");
    auto service2 = std::make_shared<TestService>("service2");

    auto component1 = std::make_shared<Component>("service1", service1);
    auto component2 = std::make_shared<Component>("service2", service2);

    component1->setStartFunction<TestService>([](std::shared_ptr<TestService> s) { s->start(); });
    component1->setStopFunction<TestService>([](std::shared_ptr<TestService> s) { s->stop(); });

    component2->setStartFunction<TestService>([](std::shared_ptr<TestService> s) { s->start(); });
    component2->setStopFunction<TestService>([](std::shared_ptr<TestService> s) { s->stop(); });

    manager->registerComponent(component1);
    manager->registerComponent(component2);
    manager->run();

    // service2 依赖 service1
    Dependency dep("service1", Dependency::Type::REQUIRED);
    manager->addDependency("service2", dep);
    manager->run();

    // 启动所有组件
    manager->startAllComponents();

    EXPECT_TRUE(service1->started);
    EXPECT_TRUE(service2->started);
    EXPECT_FALSE(service1->stopped);
    EXPECT_FALSE(service2->stopped);

    // 停止所有组件
    manager->stopAllComponents();

    EXPECT_FALSE(service1->started);
    EXPECT_FALSE(service2->started);
    EXPECT_TRUE(service1->stopped);
    EXPECT_TRUE(service2->stopped);
}

// 测试组件属性
TEST_F(DependencyManagerTest, ComponentAttributes) {
    auto service = std::make_shared<TestService>("service");
    auto component = std::make_shared<Component>("service", service);

    // 测试属性设置和获取
    component->setAttribute("type", "database");
    component->setAttribute("version", "1.0");

    EXPECT_EQ(component->getAttribute("type"), "database");
    EXPECT_EQ(component->getAttribute("version"), "1.0");
    EXPECT_TRUE(component->hasAttribute("type"));
    EXPECT_FALSE(component->hasAttribute("nonexistent"));

    // 测试批量设置
    std::map<std::string, std::string> attrs = {
        {"host", "localhost"},
        {"port", "5432"}
    };
    component->setAttributes(attrs);

    EXPECT_EQ(component->getAttribute("host"), "localhost");
    EXPECT_EQ(component->getAttribute("port"), "5432");
    EXPECT_FALSE(component->hasAttribute("type")); // 旧属性应该被清除

    // 测试属性移除
    component->removeAttribute("host");
    EXPECT_FALSE(component->hasAttribute("host"));
    EXPECT_TRUE(component->hasAttribute("port"));
}

// 测试依赖基数
TEST_F(DependencyManagerTest, DependencyCardinality) {
    auto service = std::make_shared<TestService>("service");
    auto component = std::make_shared<Component>("service", service);

    // 测试单基数依赖
    Dependency single_dep("other_service", Dependency::Type::REQUIRED, Dependency::Cardinality::SINGLE);
    EXPECT_EQ(single_dep.getCardinality(), Dependency::Cardinality::SINGLE);

    // 测试多基数依赖
    Dependency multiple_dep("other_service", Dependency::Type::REQUIRED, Dependency::Cardinality::MULTIPLE);
    EXPECT_EQ(multiple_dep.getCardinality(), Dependency::Cardinality::MULTIPLE);
}

// 测试依赖优先级
TEST_F(DependencyManagerTest, DependencyPriority) {
    Dependency dep("service", Dependency::Type::REQUIRED);

    EXPECT_EQ(dep.getPriority(), 0); // 默认优先级

    dep.setPriority(10);
    EXPECT_EQ(dep.getPriority(), 10);

    dep.setDelayedStart(true);
    EXPECT_TRUE(dep.isDelayedStart());
}

// 测试错误处理
TEST_F(DependencyManagerTest, ErrorHandling) {
    // 测试注册空组件
    manager->registerComponent(nullptr);
    manager->run();
    EXPECT_EQ(manager->getComponentNames().size(), 0);

    // 测试注册无效名称的组件
    auto service = std::make_shared<TestService>("service");
    auto invalid_component = std::make_shared<Component>("", service);
    manager->registerComponent(invalid_component);
    manager->run();
    EXPECT_EQ(manager->getComponentNames().size(), 0);

    // 测试访问不存在的组件
    EXPECT_EQ(manager->getComponent("nonexistent"), nullptr);
    EXPECT_FALSE(manager->hasComponent("nonexistent"));
}

// 测试依赖描述
TEST_F(DependencyManagerTest, DependencyDescription) {
    Dependency dep("service", Dependency::Type::REQUIRED);

    EXPECT_TRUE(dep.getDescription().empty()); // 默认描述为空

    dep.setDescription("This is a test dependency");
    EXPECT_EQ(dep.getDescription(), "This is a test dependency");
}

// 测试组件状态转换
TEST_F(DependencyManagerTest, ComponentStateTransitions) {
    auto service = std::make_shared<TestService>("service");
    auto component = std::make_shared<Component>("service", service);

    // 初始状态
    EXPECT_EQ(component->getState(), Component::State::UNINITIALIZED);

    // 设置为已初始化
    component->setState(Component::State::INITIALIZED);
    EXPECT_EQ(component->getState(), Component::State::INITIALIZED);

    // 测试状态字符串转换
    EXPECT_EQ(component->stateToString(Component::State::STARTED), "STARTED");
    EXPECT_EQ(component->stateToString(Component::State::STOPPED), "STOPPED");
    EXPECT_EQ(component->stateToString(Component::State::ERROR), "ERROR");
}

// 主函数
int main(int argc, char** argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
