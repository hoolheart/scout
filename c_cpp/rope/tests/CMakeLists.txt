# 测试目录的CMakeLists.txt

# 尝试查找已安装的GoogleTest
find_package(GTest QUIET)

if(NOT GTest_FOUND)
    # 如果没有找到，尝试使用FetchContent下载GoogleTest
    include(FetchContent)

    # 设置超时和重试
    set(FETCHCONTENT_QUIET OFF)

    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://gitee.com/mirrors/googletest.git
        GIT_TAG v1.14.0
    )

    # 对于Windows: 使用静态库和共享CRT
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)

    # 强制使用Debug构建
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type" FORCE)
    set(CMAKE_CONFIGURATION_TYPES Debug CACHE STRING "Config types" FORCE)

    # 尝试下载，如果失败则跳过测试
    set(FETCHCONTENT_TRY_DOWNLOAD_DIRECTORY "${CMAKE_BINARY_DIR}/_deps")
    if(NOT EXISTS "${FETCHCONTENT_TRY_DOWNLOAD_DIRECTORY}/googletest-src")
        message(STATUS "GoogleTest not found and download failed, skipping tests...")
        return()
    endif()

    FetchContent_MakeAvailable(googletest)
endif()

# 简单测试（不依赖GoogleTest）
add_executable(simple_test
    simple_test.cpp
)

# 链接库
target_link_libraries(simple_test
    PRIVATE
    rope
)

# 包含目录
target_include_directories(simple_test PRIVATE
    ${CMAKE_SOURCE_DIR}/include
)

# 设置C++标准
set_target_properties(simple_test PROPERTIES
    CXX_STANDARD 17
    CXX_STANDARD_REQUIRED ON
)

# 安装简单测试
install(TARGETS simple_test
    RUNTIME DESTINATION bin/tests
)

# 如果GoogleTest可用，也构建完整的测试套件
if(GTest_FOUND OR EXISTS "${CMAKE_BINARY_DIR}/_deps/googletest-src")
    # 测试可执行文件
    add_executable(rope_tests
        test_rope.cpp
    )

    # 链接库
    target_link_libraries(rope_tests
        PRIVATE
        rope
        GTest::gtest_main
        GTest::gtest
    )

    # 包含目录
    target_include_directories(rope_tests PRIVATE
        ${CMAKE_SOURCE_DIR}/include
    )

    # 设置C++标准和运行时库
    set_target_properties(rope_tests PROPERTIES
        CXX_STANDARD 17
        CXX_STANDARD_REQUIRED ON
        MSVC_RUNTIME_LIBRARY "MultiThreadedDebugDLL"
    )

    # 确保GoogleTest也使用相同的运行时库
    if(TARGET GTest::gtest)
        set_target_properties(GTest::gtest PROPERTIES
            MSVC_RUNTIME_LIBRARY "MultiThreadedDebugDLL"
        )
    endif()
    if(TARGET GTest::gtest_main)
        set_target_properties(GTest::gtest_main PROPERTIES
            MSVC_RUNTIME_LIBRARY "MultiThreadedDebugDLL"
        )
    endif()

    # 注册测试
    include(GoogleTest)
    gtest_discover_tests(rope_tests)

    # 安装测试
    install(TARGETS rope_tests
        RUNTIME DESTINATION bin/tests
    )
endif()
