cmake_minimum_required(VERSION 3.10)
set(PROJ_NAME rt_arch)
project(${PROJ_NAME} C)

# 设置C标准
set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

# 添加头文件路径
include_directories(${PROJECT_SOURCE_DIR}/common/include)

# 添加源文件
file(GLOB_RECURSE SOURCES ${PROJECT_SOURCE_DIR}/common/src/*.c)

# 添加可执行文件
add_executable(${PROJ_NAME}
    ${SOURCES}
    main.c
)
