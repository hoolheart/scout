cmake_minimum_required(VERSION 3.10)
project(rope CXX)

# 设置C++标准
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# 选项：构建共享库（动态库）或静态库，默认为动态库
option(BUILD_SHARED_LIBS "Build shared libraries (DLLs)" ON)

# 选项：启用测试
option(ENABLE_TESTS "Enable unit tests" ON)

# 设置输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)

# 包含目录
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)

# 源文件
set(ROPE_SOURCES
    src/rope.cpp
    src/dependency.cpp
    src/dependency_manager.cpp
)

# 头文件
set(ROPE_HEADERS
    include/rope/rope.h
    include/rope/rope_export.h
)

# 创建库
add_library(rope ${ROPE_SOURCES} ${ROPE_HEADERS})

# 设置库属性
set_target_properties(rope PROPERTIES
    VERSION 1.0.0
    SOVERSION 1
    PUBLIC_HEADER "${ROPE_HEADERS}"
)

# 安装规则
install(TARGETS rope
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    PUBLIC_HEADER DESTINATION include/rope
)

# 安装文档
install(DIRECTORY doc/ DESTINATION share/doc/rope)

# 测试配置
if(ENABLE_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

# 示例配置
option(BUILD_EXAMPLES "Build examples" ON)
if(BUILD_EXAMPLES)
    add_subdirectory(examples)
endif()

# 平台特定配置
if(WIN32)
    # Windows平台：定义导出宏
    target_compile_definitions(rope PRIVATE ROPE_BUILDING_LIBRARY)
endif()
