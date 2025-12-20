#include "rope/rope.h"
#include <iostream>
#include <string>

using namespace rope;

int main() {
    std::cout << "=== Rope Library Basic Usage Example ===" << std::endl;

    // 1. 创建Rope对象
    std::cout << "\n1. Creating Rope objects:" << std::endl;
    Rope rope1("Hello");
    Rope rope2(", World!");
    std::cout << "rope1: \"" << rope1.toString() << "\"" << std::endl;
    std::cout << "rope2: \"" << rope2.toString() << "\"" << std::endl;

    // 2. 拼接操作
    std::cout << "\n2. Concatenation:" << std::endl;
    Rope result = rope1.concat(rope2);
    std::cout << "rope1.concat(rope2): \"" << result.toString() << "\"" << std::endl;

    // 3. 插入操作
    std::cout << "\n3. Insertion:" << std::endl;
    Rope rope3("Hello World");
    std::cout << "Original: \"" << rope3.toString() << "\"" << std::endl;
    rope3.insert(5, ",");
    std::cout << "After inserting ',' at position 5: \"" << rope3.toString() << "\"" << std::endl;

    rope3.insert(0, "Start: ");
    std::cout << "After inserting \"Start: \" at position 0: \"" << rope3.toString() << "\"" << std::endl;

    // 4. 删除操作
    std::cout << "\n4. Deletion:" << std::endl;
    Rope rope4("Hello, World!");
    std::cout << "Original: \"" << rope4.toString() << "\"" << std::endl;
    rope4.erase(5, 1); // 删除逗号
    std::cout << "After erasing 1 char at position 5: \"" << rope4.toString() << "\"" << std::endl;

    // 5. 子串操作
    std::cout << "\n5. Substring:" << std::endl;
    Rope rope5("Hello, World!");
    Rope sub1 = rope5.substring(0, 5);
    Rope sub2 = rope5.substring(7, 5);
    std::cout << "Original: \"" << rope5.toString() << "\"" << std::endl;
    std::cout << "substring(0, 5): \"" << sub1.toString() << "\"" << std::endl;
    std::cout << "substring(7, 5): \"" << sub2.toString() << "\"" << std::endl;

    // 6. 访问字符
    std::cout << "\n6. Character access:" << std::endl;
    Rope rope6("Hello");
    std::cout << "Rope: \"" << rope6.toString() << "\"" << std::endl;
    std::cout << "rope6.at(0) = '" << rope6.at(0) << "'" << std::endl;
    std::cout << "rope6.at(1) = '" << rope6.at(1) << "'" << std::endl;
    std::cout << "rope6.at(4) = '" << rope6.at(4) << "'" << std::endl;

    // 7. 长度和空检查
    std::cout << "\n7. Length and empty check:" << std::endl;
    Rope rope7("Hello, World!");
    std::cout << "rope7.length() = " << rope7.length() << std::endl;
    std::cout << "rope7.empty() = " << (rope7.empty() ? "true" : "false") << std::endl;

    Rope rope8;
    std::cout << "rope8.length() = " << rope8.length() << std::endl;
    std::cout << "rope8.empty() = " << (rope8.empty() ? "true" : "false") << std::endl;

    // 8. 清空操作
    std::cout << "\n8. Clear operation:" << std::endl;
    Rope rope9("Hello, World!");
    std::cout << "Before clear: length = " << rope9.length() << std::endl;
    rope9.clear();
    std::cout << "After clear: length = " << rope9.length() << std::endl;
    std::cout << "After clear: empty = " << (rope9.empty() ? "true" : "false") << std::endl;

    // 9. 工厂函数
    std::cout << "\n9. Factory function:" << std::endl;
    Rope rope10 = makeRope("Created by factory function");
    std::cout << "makeRope result: \"" << rope10.toString() << "\"" << std::endl;

    // 10. 大字符串操作
    std::cout << "\n10. Large string operations:" << std::endl;
    std::string large_str(1000, 'a');
    Rope large_rope(large_str);
    std::cout << "Created rope with " << large_rope.length() << " characters" << std::endl;

    large_rope.insert(500, "INSERTED");
    std::cout << "After inserting \"INSERTED\" at position 500: length = " << large_rope.length() << std::endl;

    Rope large_sub = large_rope.substring(500, 8);
    std::cout << "Substring at position 500: \"" << large_sub.toString() << "\"" << std::endl;

    std::cout << "\n=== Example completed successfully! ===" << std::endl;

    return 0;
}
