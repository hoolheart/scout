# 示例目录的CMakeLists.txt

# 基本用法示例
add_executable(basic_usage
    basic_usage.cpp
)

# 链接库
target_link_libraries(basic_usage
    PRIVATE
    rope
)

# 包含目录
target_include_directories(basic_usage PRIVATE
    ${CMAKE_SOURCE_DIR}/include
)

# 设置C++标准
set_target_properties(basic_usage PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
)

# 安装示例
install(TARGETS basic_usage
    RUNTIME DESTINATION bin/examples
)
