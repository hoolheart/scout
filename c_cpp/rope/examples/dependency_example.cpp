#include "rope/component.h"
#include "rope/dependency_manager.h"
#include <iostream>
#include <memory>
#include <thread>
#include <chrono>

// 示例服务类

class DatabaseService {
private:
    std::string connection_string_;
    bool connected_ = false;

public:
    void connect(const std::string& conn_str) {
        connection_string_ = conn_str;
        connected_ = true;
        std::cout << "[DatabaseService] Connected to: " << conn_str << std::endl;
    }

    void disconnect() {
        connected_ = false;
        std::cout << "[DatabaseService] Disconnected from database" << std::endl;
    }

    void onDependencyAdded(const std::string& dependency_name) {
        std::cout << "[DatabaseService] Dependency added: " << dependency_name << std::endl;
    }

    void onDependencyRemoved(const std::string& dependency_name) {
        std::cout << "[DatabaseService] Dependency removed: " << dependency_name << std::endl;
    }

    bool isConnected() const { return connected_; }
    const std::string& getConnectionString() const { return connection_string_; }
};

class CacheService {
private:
    std::string backend_type_;
    bool initialized_ = false;

public:
    void initialize(const std::string& backend) {
        backend_type_ = backend;
        initialized_ = true;
        std::cout << "[CacheService] Initialized with backend: " << backend << std::endl;
    }

    void shutdown() {
        initialized_ = false;
        std::cout << "[CacheService] Shutdown completed" << std::endl;
    }

    void onDependencyAdded(const std::string& dependency_name) {
        std::cout << "[CacheService] Dependency added: " << dependency_name << std::endl;
    }

    void onDependencyRemoved(const std::string& dependency_name) {
        std::cout << "[CacheService] Dependency removed: " << dependency_name << std::endl;
    }

    bool isInitialized() const { return initialized_; }
    const std::string& getBackendType() const { return backend_type_; }
};

class ApplicationService {
private:
    std::shared_ptr<DatabaseService> database_;
    std::shared_ptr<CacheService> cache_;
    bool initialized_ = false;

public:
    void setDatabase(std::shared_ptr<DatabaseService> db) {
        database_ = db;
        std::cout << "[ApplicationService] Database service injected" << std::endl;
    }

    void setCache(std::shared_ptr<CacheService> cache) {
        cache_ = cache;
        std::cout << "[ApplicationService] Cache service injected" << std::endl;
    }

    void initialize() {
        if (!database_ || !database_->isConnected()) {
            throw std::runtime_error("Database service not available");
        }

        if (!cache_ || !cache_->isInitialized()) {
            throw std::runtime_error("Cache service not available");
        }

        initialized_ = true;
        std::cout << "[ApplicationService] Application initialized successfully" << std::endl;
    }

    void shutdown() {
        initialized_ = false;
        std::cout << "[ApplicationService] Application shutdown completed" << std::endl;
    }

    void onDatabaseDependencyAdded(const std::string& dependency_name) {
        std::cout << "[ApplicationService] Database dependency added: " << dependency_name << std::endl;
        if (database_) {
            setDatabase(database_);
        }
    }

    void onCacheDependencyAdded(const std::string& dependency_name) {
        std::cout << "[ApplicationService] Cache dependency added: " << dependency_name << std::endl;
        if (cache_) {
            setCache(cache_);
        }
    }

    void onDependencyRemoved(const std::string& dependency_name) {
        std::cout << "[ApplicationService] Dependency removed: " << dependency_name << std::endl;
        if (dependency_name == "database") {
            database_.reset();
        } else if (dependency_name == "cache") {
            cache_.reset();
        }

        if (initialized_) {
            shutdown();
        }
    }

    bool isInitialized() const { return initialized_; }
};

int main() {
    std::cout << "=== Dependency Management Framework Example ===" << std::endl;

    try {
        // 创建依赖管理器
        rope::DependencyManager manager;
        manager.setVerboseLogging(true);

        // 创建服务实例
        auto db_service = std::make_shared<DatabaseService>();
        auto cache_service = std::make_shared<CacheService>();
        auto app_service = std::make_shared<ApplicationService>();

        // 创建数据库组件
        auto db_component = std::make_shared<rope::Component>("database", db_service);
        db_component->setAttributes({
            {"type", "postgresql"},
            {"version", "13.0"},
            {"host", "localhost"},
            {"port", "5432"}
        });

        // 设置数据库组件的生命周期函数
        db_component->setStartFunction<DatabaseService>([](std::shared_ptr<DatabaseService> db) {
            std::cout << "[DatabaseService] Starting..." << std::endl;
            db->connect("postgresql://localhost:5432/mydb");
        });

        db_component->setStopFunction<DatabaseService>([](std::shared_ptr<DatabaseService> db) {
            std::cout << "[DatabaseService] Stopping..." << std::endl;
            db->disconnect();
        });

        db_component->setAddDependencyFunction<DatabaseService>([](std::shared_ptr<DatabaseService> db, const std::string& dep_name) {
            db->onDependencyAdded(dep_name);
        });

        db_component->setRemoveDependencyFunction<DatabaseService>([](std::shared_ptr<DatabaseService> db, const std::string& dep_name) {
            db->onDependencyRemoved(dep_name);
        });

        // 创建缓存组件
        auto cache_component = std::make_shared<rope::Component>("cache", cache_service);
        cache_component->setAttributes({
            {"type", "redis"},
            {"version", "6.2"},
            {"cluster_mode", "true"}
        });

        // 设置缓存组件的生命周期函数
        cache_component->setStartFunction<CacheService>([](std::shared_ptr<CacheService> cache) {
            std::cout << "[CacheService] Starting..." << std::endl;
            cache->initialize("redis-cluster");
        });

        cache_component->setStopFunction<CacheService>([](std::shared_ptr<CacheService> cache) {
            std::cout << "[CacheService] Stopping..." << std::endl;
            cache->shutdown();
        });

        cache_component->setAddDependencyFunction<CacheService>([](std::shared_ptr<CacheService> cache, const std::string& dep_name) {
            cache->onDependencyAdded(dep_name);
        });

        cache_component->setRemoveDependencyFunction<CacheService>([](std::shared_ptr<CacheService> cache, const std::string& dep_name) {
            cache->onDependencyRemoved(dep_name);
        });

        // 创建应用组件
        auto app_component = std::make_shared<rope::Component>("application", app_service);
        app_component->setAttributes({
            {"type", "web-app"},
            {"version", "1.0.0"},
            {"framework", "cpp-web"}
        });

        // 设置应用组件的生命周期函数
        app_component->setStartFunction<ApplicationService>([app_service](std::shared_ptr<ApplicationService> app) {
            std::cout << "[ApplicationService] Starting..." << std::endl;
            app->initialize();
        });

        app_component->setStopFunction<ApplicationService>([app_service](std::shared_ptr<ApplicationService> app) {
            std::cout << "[ApplicationService] Stopping..." << std::endl;
            app->shutdown();
        });

        app_component->setAddDependencyFunction<ApplicationService>([app_service, db_service, cache_service](std::shared_ptr<ApplicationService> app, const std::string& dep_name) {
            if (dep_name == "database") {
                app->setDatabase(db_service);
            } else if (dep_name == "cache") {
                app->setCache(cache_service);
            }
            app->onDatabaseDependencyAdded(dep_name);
        });

        app_component->setRemoveDependencyFunction<ApplicationService>([app_service](std::shared_ptr<ApplicationService> app, const std::string& dep_name) {
            app->onDependencyRemoved(dep_name);
        });

        std::cout << "\n--- Step 1: Register Components ---" << std::endl;

        // 声明式注册组件
        manager.registerComponent(db_component);
        manager.registerComponent(cache_component);
        manager.registerComponent(app_component);

        // 执行注册操作
        manager.run();

        std::cout << "\n--- Step 2: Add Dependencies ---" << std::endl;

        // 应用依赖数据库（必要依赖）
        rope::Dependency app_db_dep("database", rope::Dependency::Type::REQUIRED);
        app_db_dep.addCondition("type", "postgresql");
        app_db_dep.addCondition("version", "12", rope::Dependency::MatchOperator::GREATER);
        manager.addDependency("application", app_db_dep);

        // 应用依赖缓存（必要依赖）
        rope::Dependency app_cache_dep("cache", rope::Dependency::Type::REQUIRED);
        app_cache_dep.addCondition("type", "redis");
        manager.addDependency("application", app_cache_dep);

        // 执行依赖添加操作
        manager.run();

        std::cout << "\n--- Step 3: Component States ---" << std::endl;
        manager.printComponentStates();

        std::cout << "\n--- Step 4: Dependency Graph ---" << std::endl;
        manager.printDependencyGraph();

        std::cout << "\n--- Step 5: Startup Order ---" << std::endl;
        auto startup_order = manager.getStartupOrder();
        std::cout << "Startup order: ";
        for (size_t i = 0; i < startup_order.size(); ++i) {
            if (i > 0) std::cout << " -> ";
            std::cout << startup_order[i];
        }
        std::cout << std::endl;

        std::cout << "\n--- Step 6: Manual Lifecycle Control ---" << std::endl;

        // 手动启动所有组件（按依赖顺序）
        manager.startAllComponents();

        std::cout << "\n--- Step 7: Component States After Startup ---" << std::endl;
        manager.printComponentStates();

        std::cout << "\n--- Step 8: Dynamic Dependency Removal ---" << std::endl;

        // 移除应用的数据库依赖
        std::cout << "Removing database dependency from application..." << std::endl;
        manager.removeDependency("application", "database");
        manager.run();

        std::cout << "\n--- Step 9: Component States After Dependency Removal ---" << std::endl;
        manager.printComponentStates();

        std::cout << "\n--- Step 10: Shutdown ---" << std::endl;

        // 停止所有组件
        manager.stopAllComponents();

        std::cout << "\n--- Step 11: Component States After Shutdown ---" << std::endl;
        manager.printComponentStates();

        std::cout << "\n--- Step 12: Advanced Features ---" << std::endl;

        // 演示条件匹配
        std::cout << "Demonstrating conditional dependency matching..." << std::endl;

        // 创建一个新的数据库组件（不同版本）
        auto db_service_v12 = std::make_shared<DatabaseService>();
        auto db_component_v12 = std::make_shared<rope::Component>("database-v12", db_service_v12);
        db_component_v12->setAttributes({
            {"type", "postgresql"},
            {"version", "12.5"},
            {"host", "backup-server"}
        });

        db_component_v12->setStartFunction<DatabaseService>([](std::shared_ptr<DatabaseService> db) {
            db->connect("postgresql://backup-server:5432/mydb");
        });

        db_component_v12->setStopFunction<DatabaseService>([](std::shared_ptr<DatabaseService> db) {
            db->disconnect();
        });

        manager.registerComponent(db_component_v12);
        manager.run();

        // 创建一个需要特定版本数据库的应用
        auto app_v12_service = std::make_shared<ApplicationService>();
        auto app_v12_component = std::make_shared<rope::Component>("app-v12", app_v12_service);

        app_v12_component->setStartFunction<ApplicationService>([app_v12_service](std::shared_ptr<ApplicationService> app) {
            try {
                app->initialize();
            } catch (const std::exception& e) {
                std::cout << "[App-v12] Failed to initialize: " << e.what() << std::endl;
            }
        });

        manager.registerComponent(app_v12_component);

        // 添加对特定版本数据库的依赖
        rope::Dependency v12_db_dep("database-v12", rope::Dependency::Type::REQUIRED);
        v12_db_dep.addCondition("version", "12", rope::Dependency::MatchOperator::GREATER_OR_EQUAL);
        v12_db_dep.addCondition("type", "postgresql");

        manager.addDependency("app-v12", v12_db_dep);
        manager.run();

        std::cout << "\n--- Final Component States ---" << std::endl;
        manager.printComponentStates();

        std::cout << "\n=== Example completed successfully! ===" << std::endl;

    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }

    return 0;
}
