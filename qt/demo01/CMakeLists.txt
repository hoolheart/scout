cmake_minimum_required(VERSION 3.16)
project(QtDemo01 VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Qt5 directory - can be set via environment variable or -DCMAKE_PREFIX_PATH
# Example: cmake -DCMAKE_PREFIX_PATH="C:/Qt/5.15.2/msvc2019_64/lib/cmake" ..
set(CMAKE_PREFIX_PATH "C:/Qt/5.15.2/msvc2019_64/lib/cmake" CACHE PATH "Qt installation path")
find_package(Qt5 REQUIRED COMPONENTS Core Widgets Gui)

# Generate MOC and UIC files
qt5_wrap_cpp(MOC_SRCS mainwindow.h)
qt5_wrap_ui(UIC_SRCS mainwindow.ui)

# Add executable
add_executable(${PROJECT_NAME}
    main.cpp
    mainwindow.cpp
    ${MOC_SRCS}
    ${UIC_SRCS}
)

# Link Qt5 libraries
target_link_libraries(${PROJECT_NAME}
    Qt5::Core
    Qt5::Widgets
    Qt5::Gui
)

# Include directory for generated UI headers
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
