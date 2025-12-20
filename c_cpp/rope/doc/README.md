# Rope Library

A C++17 library implementing the Rope data structure for efficient string manipulation.

## Overview

Rope is a tree-based data structure designed for efficient storage and manipulation of large strings. Unlike traditional strings, Rope avoids expensive copy operations by splitting strings into smaller chunks.

## Features

- **Efficient String Operations**: O(log n) time complexity for insert, delete, and concatenate operations
- **Modern C++ Interface**: Move semantics, exception safety, RAII compliance
- **Cross-Platform**: Supports Windows, Linux, and macOS
- **Flexible Build**: Can be built as either static or shared library
- **Comprehensive Testing**: Unit tests using GoogleTest
- **Well-Documented**: Clear API documentation and usage examples

## Requirements

- C++17 compatible compiler
- CMake 3.10 or higher
- Git (for fetching GoogleTest)

## Building

### Basic Build

```bash
mkdir build
cd build
cmake ..
cmake --build .
```

### Build Options

- `BUILD_SHARED_LIBS`: Build as shared library (default: ON)
- `ENABLE_TESTS`: Enable unit tests (default: ON)
- `BUILD_EXAMPLES`: Build examples (default: ON)

### Examples

Build as static library:
```bash
cmake -DBUILD_SHARED_LIBS=OFF ..
```

Disable tests:
```bash
cmake -DENABLE_TESTS=OFF ..
```

### Build and Install

```bash
cmake --build .
cmake --install . --prefix /path/to/install
```

## Usage

### Basic Example

```cpp
#include "rope/rope.h"
#include <iostream>

using namespace rope;

int main() {
    // Create a Rope
    Rope rope("Hello, World!");

    // Insert text
    rope.insert(5, " Beautiful");

    // Get result
    std::cout << rope.toString() << std::endl; // "Hello Beautiful, World!"

    return 0;
}
```

### API Overview

#### Constructors

- `Rope()` - Default constructor
- `Rope(const std::string& str)` - Construct from string
- `Rope(const Rope& other)` - Copy constructor
- `Rope(Rope&& other)` - Move constructor

#### Modifiers

- `void insert(size_t pos, const std::string& str)` - Insert string at position
- `void insert(size_t pos, const Rope& other)` - Insert Rope at position
- `void erase(size_t pos, size_t len)` - Erase characters
- `void append(const std::string& str)` - Append string
- `void append(const Rope& other)` - Append Rope
- `void clear()` - Clear all content

#### Observers

- `size_t length() const` - Get length
- `char at(size_t pos) const` - Get character at position
- `std::string toString() const` - Convert to string
- `bool empty() const` - Check if empty

#### Operations

- `Rope substring(size_t pos, size_t len) const` - Get substring
- `Rope concat(const Rope& other) const` - Concatenate with another Rope

#### Factory Function

- `Rope makeRope(const std::string& str)` - Create Rope from string

## Testing

Run unit tests:

```bash
cd build
ctest
# or
./bin/rope_tests
```

## Installation

The library installs:
- Headers to `include/rope/`
- Library files to `lib/`
- Examples to `bin/examples/`
- Tests to `bin/tests/` (if built)
- Documentation to `share/doc/rope/`

## Platform-Specific Notes

### Windows
- Uses `__declspec(dllexport/dllimport)` for DLL exports
- Requires Visual Studio 2017 or later, or MinGW with C++17 support

### Linux
- Uses GCC visibility attributes
- Requires GCC 7+ or Clang 5+

### macOS
- Uses GCC visibility attributes
- Requires Xcode 10+ or Clang 5+

## License

This project is provided as-is for educational and commercial use.

## Contributing

Contributions are welcome! Please ensure:
- Code follows modern C++ best practices
- All tests pass
- New features include tests
- Documentation is updated
