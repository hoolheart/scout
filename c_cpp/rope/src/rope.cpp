#include "rope/rope.h"
#include <stdexcept>
#include <algorithm>
#include <sstream>

namespace rope {

// 内部实现类
class Rope::Impl {
public:
    // 节点类型
    enum class NodeType {
        LEAF,   // 叶子节点，存储实际字符串
        NODE    // 内部节点，存储子节点
    };

    // 节点结构
    struct Node {
        NodeType type;
        std::string data;           // 叶子节点：存储字符串
        std::vector<Node*> children; // 内部节点：存储子节点
        size_t weight;              // 左子树的总长度

        Node() : type(NodeType::LEAF), weight(0) {}
        explicit Node(const std::string& str) : type(NodeType::LEAF), data(str), weight(str.length()) {}
        ~Node() {
            for (auto child : children) {
                delete child;
            }
        }
    };

    Node* root;
    size_t total_length;

    Impl() : root(nullptr), total_length(0) {}

    explicit Impl(const std::string& str) : root(new Node(str)), total_length(str.length()) {}

    ~Impl() {
        delete root;
    }

    // 深拷贝
    Impl(const Impl& other) : root(nullptr), total_length(other.total_length) {
        if (other.root) {
            root = copyNode(other.root);
        }
    }

    // 移动
    Impl(Impl&& other) noexcept : root(other.root), total_length(other.total_length) {
        other.root = nullptr;
        other.total_length = 0;
    }

    // 赋值
    Impl& operator=(const Impl& other) {
        if (this != &other) {
            delete root;
            root = other.root ? copyNode(other.root) : nullptr;
            total_length = other.total_length;
        }
        return *this;
    }

    // 移动赋值
    Impl& operator=(Impl&& other) noexcept {
        if (this != &other) {
            delete root;
            root = other.root;
            total_length = other.total_length;
            other.root = nullptr;
            other.total_length = 0;
        }
        return *this;
    }

    // 递归复制节点
    Node* copyNode(Node* node) {
        if (!node) return nullptr;

        Node* newNode = new Node();
        newNode->type = node->type;
        newNode->data = node->data;
        newNode->weight = node->weight;

        for (auto child : node->children) {
            newNode->children.push_back(copyNode(child));
        }

        return newNode;
    }

    // 在指定位置插入字符串
    void insert(size_t pos, const std::string& str) {
        if (pos > total_length) {
            throw std::out_of_range("Position out of range");
        }

        if (!root) {
            root = new Node(str);
            total_length = str.length();
            return;
        }

        // 简单的实现：转换为字符串，插入，再重建
        // 实际应用中应该实现更高效的树操作
        std::string current = toString();
        current.insert(pos, str);
        delete root;
        root = new Node(current);
        total_length = current.length();
    }

    // 删除指定范围的字符
    void erase(size_t pos, size_t len) {
        if (pos >= total_length) {
            throw std::out_of_range("Position out of range");
        }

        if (pos + len > total_length) {
            len = total_length - pos;
        }

        std::string current = toString();
        current.erase(pos, len);
        delete root;
        root = current.empty() ? nullptr : new Node(current);
        total_length = current.length();
    }

    // 追加字符串
    void append(const std::string& str) {
        insert(total_length, str);
    }

    // 获取长度
    size_t length() const {
        return total_length;
    }

    // 获取指定位置的字符
    char at(size_t pos) const {
        if (pos >= total_length) {
            throw std::out_of_range("Position out of range");
        }

        return toString()[pos];
    }

    // 转换为字符串
    std::string toString() const {
        if (!root) return "";

        std::ostringstream oss;
        toStringHelper(root, oss);
        return oss.str();
    }

    // 辅助函数：递归转换为字符串
    void toStringHelper(Node* node, std::ostringstream& oss) const {
        if (!node) return;

        if (node->type == NodeType::LEAF) {
            oss << node->data;
        } else {
            for (auto child : node->children) {
                toStringHelper(child, oss);
            }
        }
    }

    // 清空
    void clear() {
        delete root;
        root = nullptr;
        total_length = 0;
    }

    // 获取子串
    Rope substring(size_t pos, size_t len) const {
        if (pos >= total_length) {
            throw std::out_of_range("Position out of range");
        }

        if (pos + len > total_length) {
            len = total_length - pos;
        }

        std::string str = toString();
        return Rope(str.substr(pos, len));
    }
};

// Rope类实现

Rope::Rope() : pImpl(std::make_unique<Impl>()) {}

Rope::Rope(const std::string& str) : pImpl(std::make_unique<Impl>(str)) {}

Rope::Rope(const Rope& other) : pImpl(std::make_unique<Impl>(*other.pImpl)) {}

Rope::Rope(Rope&& other) noexcept = default;

Rope::~Rope() = default;

Rope& Rope::operator=(const Rope& other) {
    if (this != &other) {
        pImpl = std::make_unique<Impl>(*other.pImpl);
    }
    return *this;
}

Rope& Rope::operator=(Rope&& other) noexcept = default;

void Rope::insert(size_t pos, const std::string& str) {
    pImpl->insert(pos, str);
}

void Rope::insert(size_t pos, const Rope& other) {
    pImpl->insert(pos, other.toString());
}

void Rope::erase(size_t pos, size_t len) {
    pImpl->erase(pos, len);
}

void Rope::append(const std::string& str) {
    pImpl->append(str);
}

void Rope::append(const Rope& other) {
    pImpl->append(other.toString());
}

size_t Rope::length() const {
    return pImpl->length();
}

char Rope::at(size_t pos) const {
    return pImpl->at(pos);
}

std::string Rope::toString() const {
    return pImpl->toString();
}

bool Rope::empty() const {
    return pImpl->length() == 0;
}

void Rope::clear() {
    pImpl->clear();
}

Rope Rope::substring(size_t pos, size_t len) const {
    return pImpl->substring(pos, len);
}

Rope Rope::concat(const Rope& other) const {
    Rope result = *this;
    result.append(other);
    return result;
}

// 工厂函数
Rope makeRope(const std::string& str) {
    return Rope(str);
}

} // namespace rope
