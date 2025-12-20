#ifndef ROPE_EXPORT_H
#define ROPE_EXPORT_H

// 根据构建类型和平台定义导出宏
#if defined(_WIN32) || defined(__CYGWIN__)
    // Windows平台
    #ifdef ROPE_BUILDING_LIBRARY
        // 构建库时导出符号
        #define ROPE_API __declspec(dllexport)
    #else
        // 使用库时导入符号
        #define ROPE_API __declspec(dllimport)
    #endif
#else
    // Linux、macOS等其他平台
    #if __GNUC__ >= 4
        // GCC 4.0及以上版本
        #define ROPE_API __attribute__((visibility("default")))
    #else
        // 其他编译器
        #define ROPE_API
    #endif
#endif

// 如果未定义ROPE_API（例如静态库构建），则定义为空
#ifndef ROPE_API
    #define ROPE_API
#endif

#endif // ROPE_EXPORT_H
