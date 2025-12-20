#include "rope/rope.h"
#include <iostream>
#include <cassert>
#include <string>

using namespace rope;

int main() {
    std::cout << "=== Simple Rope Test ===" << std::endl;

    // 测试1: 基本构造
    Rope rope1("Hello");
    assert(rope1.toString() == "Hello");
    assert(rope1.length() == 5);
    std::cout << "✓ Test 1: Basic construction passed" << std::endl;

    // 测试2: 拼接
    Rope rope2(", World!");
    Rope result = rope1.concat(rope2);
    assert(result.toString() == "Hello, World!");
    std::cout << "✓ Test 2: Concatenation passed" << std::endl;

    // 测试3: 插入
    Rope rope3("Hello World");
    rope3.insert(5, ",");
    assert(rope3.toString() == "Hello, World");
    std::cout << "✓ Test 3: Insertion passed" << std::endl;

    // 测试4: 删除
    Rope rope4("Hello, World!");
    rope4.erase(5, 1); // 删除逗号
    assert(rope4.toString() == "Hello World!");
    std::cout << "✓ Test 4: Erase passed" << std::endl;

    // 测试5: 追加
    Rope rope5("Hello");
    rope5.append(", World!");
    assert(rope5.toString() == "Hello, World!");
    std::cout << "✓ Test 5: Append passed" << std::endl;

    // 测试6: 字符访问
    Rope rope6("Hello");
    assert(rope6.at(0) == 'H');
    assert(rope6.at(4) == 'o');
    std::cout << "✓ Test 6: Character access passed" << std::endl;

    // 测试7: 子串
    Rope rope7("Hello, World!");
    Rope sub1 = rope7.substring(0, 5);
    Rope sub2 = rope7.substring(7, 5);
    assert(sub1.toString() == "Hello");
    assert(sub2.toString() == "World");
    std::cout << "✓ Test 7: Substring passed" << std::endl;

    // 测试8: 清空
    Rope rope8("Hello, World!");
    rope8.clear();
    assert(rope8.empty());
    assert(rope8.length() == 0);
    std::cout << "✓ Test 8: Clear passed" << std::endl;

    // 测试9: 工厂函数
    Rope rope9 = makeRope("Factory test");
    assert(rope9.toString() == "Factory test");
    std::cout << "✓ Test 9: Factory function passed" << std::endl;

    // 测试10: 大字符串操作
    std::string large_str(1000, 'a');
    Rope large_rope(large_str);
    large_rope.insert(500, "INSERTED");
    assert(large_rope.length() == 1008);
    Rope large_sub = large_rope.substring(500, 8);
    assert(large_sub.toString() == "INSERTED");
    std::cout << "✓ Test 10: Large string operations passed" << std::endl;

    std::cout << "\n=== All tests passed! ===" << std::endl;
    return 0;
}
