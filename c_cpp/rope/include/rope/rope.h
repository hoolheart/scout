#ifndef ROPE_H
#define ROPE_H

#include <string>
#include <memory>
#include <vector>
#include "rope_export.h"

namespace rope {

/**
 * @brief Rope数据结构 - 用于高效字符串操作
 *
 * Rope是一种树形数据结构，用于高效地存储和操作长字符串。
 * 它通过将字符串分割成多个小块来避免昂贵的复制操作。
 */
class ROPE_API Rope {
public:
    /**
     * @brief 构造函数
     */
    Rope();

    /**
     * @brief 从字符串构造Rope
     * @param str 初始字符串
     */
    explicit Rope(const std::string& str);

    /**
     * @brief 拷贝构造函数
     */
    Rope(const Rope& other);

    /**
     * @brief 移动构造函数
     */
    Rope(Rope&& other) noexcept;

    /**
     * @brief 析构函数
     */
    ~Rope();

    /**
     * @brief 拷贝赋值运算符
     */
    Rope& operator=(const Rope& other);

    /**
     * @brief 移动赋值运算符
     */
    Rope& operator=(Rope&& other) noexcept;

    /**
     * @brief 在指定位置插入字符串
     * @param pos 插入位置
     * @param str 要插入的字符串
     */
    void insert(size_t pos, const std::string& str);

    /**
     * @brief 在指定位置插入另一个Rope
     * @param pos 插入位置
     * @param other 要插入的Rope
     */
    void insert(size_t pos, const Rope& other);

    /**
     * @brief 删除指定范围的字符
     * @param pos 起始位置
     * @param len 删除长度
     */
    void erase(size_t pos, size_t len);

    /**
     * @brief 追加字符串
     * @param str 要追加的字符串
     */
    void append(const std::string& str);

    /**
     * @brief 追加另一个Rope
     * @param other 要追加的Rope
     */
    void append(const Rope& other);

    /**
     * @brief 获取字符串长度
     * @return 字符串长度
     */
    size_t length() const;

    /**
     * @brief 获取指定位置的字符
     * @param pos 字符位置
     * @return 指定位置的字符
     */
    char at(size_t pos) const;

    /**
     * @brief 转换为标准字符串
     * @return 转换后的字符串
     */
    std::string toString() const;

    /**
     * @brief 检查是否为空
     * @return 如果为空返回true
     */
    bool empty() const;

    /**
     * @brief 清空Rope内容
     */
    void clear();

    /**
     * @brief 获取子串
     * @param pos 起始位置
     * @param len 子串长度
     * @return 子串对应的Rope
     */
    Rope substring(size_t pos, size_t len) const;

    /**
     * @brief 拼接两个Rope
     * @param other 要拼接的Rope
     * @return 拼接后的新Rope
     */
    Rope concat(const Rope& other) const;

private:
    class Impl;

    std::unique_ptr<Impl> pImpl;
};

/**
 * @brief 创建Rope的工厂函数
 * @param str 初始字符串
 * @return 创建的Rope对象
 */
ROPE_API Rope makeRope(const std::string& str);

} // namespace rope

#endif // ROPE_H
