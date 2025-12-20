#include <gtest/gtest.h>
#include "rope/rope.h"
#include <string>

using namespace rope;

// 测试构造函数
TEST(RopeTest, DefaultConstructor) {
    Rope rope;
    EXPECT_TRUE(rope.empty());
    EXPECT_EQ(rope.length(), 0);
}

TEST(RopeTest, StringConstructor) {
    std::string test_str = "Hello, World!";
    Rope rope(test_str);
    EXPECT_FALSE(rope.empty());
    EXPECT_EQ(rope.length(), test_str.length());
    EXPECT_EQ(rope.toString(), test_str);
}

// 测试拷贝和移动
TEST(RopeTest, CopyConstructor) {
    Rope rope1("Hello");
    Rope rope2(rope1);
    EXPECT_EQ(rope2.toString(), "Hello");
    EXPECT_EQ(rope1.toString(), "Hello"); // 原对象不变
}

TEST(RopeTest, MoveConstructor) {
    Rope rope1("Hello");
    std::string original = rope1.toString();
    Rope rope2(std::move(rope1));
    EXPECT_EQ(rope2.toString(), original);
}

TEST(RopeTest, CopyAssignment) {
    Rope rope1("Hello");
    Rope rope2;
    rope2 = rope1;
    EXPECT_EQ(rope2.toString(), "Hello");
}

TEST(RopeTest, MoveAssignment) {
    Rope rope1("Hello");
    std::string original = rope1.toString();
    Rope rope2;
    rope2 = std::move(rope1);
    EXPECT_EQ(rope2.toString(), original);
}

// 测试插入操作
TEST(RopeTest, InsertString) {
    Rope rope("Hello World");
    rope.insert(5, ",");
    EXPECT_EQ(rope.toString(), "Hello, World");

    rope.insert(0, "Start: ");
    EXPECT_EQ(rope.toString(), "Start: Hello, World");

    rope.insert(rope.length(), " End");
    EXPECT_EQ(rope.toString(), "Start: Hello, World End");
}

TEST(RopeTest, InsertRope) {
    Rope rope1("Hello");
    Rope rope2(" World");
    rope1.insert(5, rope2);
    EXPECT_EQ(rope1.toString(), "Hello World");
}

// 测试删除操作
TEST(RopeTest, Erase) {
    Rope rope("Hello, World!");
    rope.erase(5, 1); // 删除逗号
    EXPECT_EQ(rope.toString(), "Hello World!");

    rope.erase(0, 6); // 删除"Hello "
    EXPECT_EQ(rope.toString(), "World!");
}

TEST(RopeTest, EraseOutOfRange) {
    Rope rope("Hello");
    EXPECT_THROW(rope.erase(10, 5), std::out_of_range);
}

// 测试追加操作
TEST(RopeTest, AppendString) {
    Rope rope("Hello");
    rope.append(", ");
    rope.append("World");
    rope.append("!");
    EXPECT_EQ(rope.toString(), "Hello, World!");
}

TEST(RopeTest, AppendRope) {
    Rope rope1("Hello");
    Rope rope2(", World!");
    rope1.append(rope2);
    EXPECT_EQ(rope1.toString(), "Hello, World!");
}

// 测试访问操作
TEST(RopeTest, At) {
    Rope rope("Hello");
    EXPECT_EQ(rope.at(0), 'H');
    EXPECT_EQ(rope.at(1), 'e');
    EXPECT_EQ(rope.at(4), 'o');
}

TEST(RopeTest, AtOutOfRange) {
    Rope rope("Hello");
    EXPECT_THROW(rope.at(10), std::out_of_range);
}

// 测试长度和空检查
TEST(RopeTest, Length) {
    Rope rope1;
    EXPECT_EQ(rope1.length(), 0);

    Rope rope2("Hello");
    EXPECT_EQ(rope2.length(), 5);

    Rope rope3("Hello, World!");
    EXPECT_EQ(rope3.length(), 13);
}

TEST(RopeTest, Empty) {
    Rope rope1;
    EXPECT_TRUE(rope1.empty());

    Rope rope2("Hello");
    EXPECT_FALSE(rope2.empty());

    rope2.clear();
    EXPECT_TRUE(rope2.empty());
}

// 测试清空操作
TEST(RopeTest, Clear) {
    Rope rope("Hello, World!");
    EXPECT_FALSE(rope.empty());
    rope.clear();
    EXPECT_TRUE(rope.empty());
    EXPECT_EQ(rope.length(), 0);
}

// 测试子串操作
TEST(RopeTest, Substring) {
    Rope rope("Hello, World!");
    Rope sub1 = rope.substring(0, 5);
    EXPECT_EQ(sub1.toString(), "Hello");

    Rope sub2 = rope.substring(7, 5);
    EXPECT_EQ(sub2.toString(), "World");

    Rope sub3 = rope.substring(7, 10); // 超出范围
    EXPECT_EQ(sub3.toString(), "World!");
}

TEST(RopeTest, SubstringOutOfRange) {
    Rope rope("Hello");
    EXPECT_THROW(rope.substring(10, 5), std::out_of_range);
}

// 测试拼接操作
TEST(RopeTest, Concat) {
    Rope rope1("Hello");
    Rope rope2(", World!");
    Rope result = rope1.concat(rope2);
    EXPECT_EQ(result.toString(), "Hello, World!");
}

// 测试工厂函数
TEST(RopeTest, MakeRope) {
    Rope rope = makeRope("Hello, World!");
    EXPECT_EQ(rope.toString(), "Hello, World!");
}

// 测试大字符串操作
TEST(RopeTest, LargeString) {
    std::string large_str(10000, 'a');
    Rope rope(large_str);
    EXPECT_EQ(rope.length(), 10000);
    EXPECT_EQ(rope.toString(), large_str);

    rope.insert(5000, "INSERTED");
    EXPECT_EQ(rope.length(), 10008);
    EXPECT_EQ(rope.substring(5000, 8).toString(), "INSERTED");
}

// 测试多次操作
TEST(RopeTest, MultipleOperations) {
    Rope rope;

    // 多次插入
    for (int i = 0; i < 10; ++i) {
        rope.append("test");
    }
    EXPECT_EQ(rope.length(), 40);

    // 删除部分
    rope.erase(10, 20);
    EXPECT_EQ(rope.length(), 20);

    // 插入
    rope.insert(10, "INSERTED");
    EXPECT_EQ(rope.length(), 28);
}
