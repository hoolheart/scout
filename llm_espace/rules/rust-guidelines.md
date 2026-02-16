# Rust Development Agent Rules

Based on official Rust API Guidelines (https://rust-lang.github.io/api-guidelines/) and Clippy lints (https://rust-lang.github.io/rust-clippy/).

## Role Definition

You are a **Rust development agent** specialized in writing idiomatic, safe, and performant Rust code following official Rust conventions and best practices.

## Core Principles

1. **Safety First**: Leverage Rust's type system to prevent bugs at compile time
2. **Idiomatic Code**: Follow Rust naming conventions and patterns
3. **Zero-Cost Abstractions**: Write clean code that compiles to efficient machine code
4. **Explicit Over Implicit**: Make costs and behavior clear
5. **Documentation**: Document public APIs with examples

## Naming Conventions (RFC 430)

| Item | Convention | Example |
|------|------------|---------|
| Crates | `snake_case` (no `-rs` suffix) | `my_crate` |
| Modules | `snake_case` | `my_module` |
| Types (structs, enums, unions) | `UpperCamelCase` | `MyStruct`, `MyError` |
| Traits | `UpperCamelCase` | `MyTrait` |
| Enum variants | `UpperCamelCase` | `VariantName` |
| Functions | `snake_case` | `my_function` |
| Methods | `snake_case` | `my_method` |
| Macros | `snake_case!` | `my_macro!` |
| Local variables | `snake_case` | `my_var` |
| Statics | `SCREAMING_SNAKE_CASE` | `MAX_SIZE` |
| Constants | `SCREAMING_SNAKE_CASE` | `PI` |
| Type parameters | `UpperCamelCase` (short) | `T`, `K`, `V` |
| Lifetimes | `snake_case` (short) | `'a`, `'de`, `'src` |
| Features | `snake_case` (no prefix) | `serde`, not `use-serde` |

### Conversion Method Naming

| Prefix | Cost | Ownership |
|--------|------|-----------|
| `as_` | Free | borrowed -> borrowed |
| `to_` | Expensive | borrowed -> owned |
| `into_` | Variable | owned -> owned |

**Examples:**
- `as_bytes()` - free view conversion
- `to_lowercase()` - allocates new String
- `into_inner()` - consumes self, returns wrapped value

### Getter Naming

- **DO NOT** use `get_` prefix for simple getters
- Use field name directly: `fn first(&self) -> &First`
- Mutable getter: `fn first_mut(&mut self) -> &mut First`
- Use `get_` only for runtime validated access (e.g., `Cell::get`)

## Code Organization

### Module Structure

```rust
// lib.rs or main.rs structure
#![warn(clippy::all, clippy::pedantic)]
#![warn(missing_docs)]

pub mod module_a;
pub mod module_b;

// Re-export commonly used items
pub use module_a::MyType;

// Private modules
mod internal;
```

### Visibility

- Use `pub(crate)` for crate-internal items
- Keep struct fields private by default
- Use `#[doc(hidden)]` for implementation details
- Prefer non-consuming builders over consuming ones

## Type System Best Practices

### Common Trait Implementations

Types should eagerly implement these standard traits when applicable:

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
pub struct MyType {
    // fields
}
```

**Required traits for public types:**
- `Debug` - always implement for all public types
- `Clone` - if type needs duplication
- `Copy` - for simple value types (implies Clone)
- `PartialEq`/`Eq` - for equality comparison
- `PartialOrd`/`Ord` - for ordering
- `Hash` - for use in HashMap/HashSet
- `Default` - for default construction

### Conversion Traits

**Implement these (preferred):**
- `From<T>` - infallible conversion
- `TryFrom<T>` - fallible conversion
- `AsRef<T>` - cheap reference conversion
- `AsMut<T>` - cheap mutable reference conversion

**DO NOT implement these directly** (blanket impls exist):
- `Into<T>`
- `TryInto<T>`

### Newtype Pattern

Use newtypes for static type distinctions:

```rust
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Miles(pub u64);

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Kilometers(pub u64);
```

### Error Types

```rust
use std::error::Error;
use std::fmt::{self, Display};

#[derive(Debug)]
pub struct MyError {
    message: String,
}

impl Display for MyError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.message)
    }
}

impl Error for MyError {}

// Must be Send + Sync for multithreading
fn assert_send_sync<T: Send + Sync>() {}
```

## Functions and Methods

### Constructor Patterns

```rust
impl MyType {
    // Primary constructor
    pub fn new() -> Self {
        Self::default()
    }
    
    // Conversion constructor
    pub fn from_parts(parts: Vec<Part>) -> Self {
        // ...
    }
    
    // Builder pattern for complex construction
    pub fn builder() -> MyTypeBuilder {
        MyTypeBuilder::new()
    }
}
```

### Method Design

```rust
impl MyType {
    // Borrowing methods
    pub fn get(&self) -> &Value;           // shared borrow
    pub fn get_mut(&mut self) -> &mut Value; // exclusive borrow
    
    // Consuming methods
    pub fn into_inner(self) -> Inner;      // consume and return
    
    // Fallible getters with bounds checking
    pub fn get(&self, index: usize) -> Option<&T>;
    pub unsafe fn get_unchecked(&self, index: usize) -> &T;
}
```

### Iterator Methods

For collections, provide:

```rust
impl MyCollection<T> {
    pub fn iter(&self) -> Iter<'_, T>;           // Iter implements Iterator<Item = &T>
    pub fn iter_mut(&mut self) -> IterMut<'_, T>; // Iterator<Item = &mut T>
    pub fn into_iter(self) -> IntoIter<T>;       // Iterator<Item = T>
}
```

## Documentation Standards

### Documentation Comments

```rust
/// Brief description of the function.
///
/// More detailed explanation if needed. Can include code examples.
///
/// # Examples
///
/// ```
/// use my_crate::MyType;
///
/// let value = MyType::new();
/// assert!(value.is_valid());
/// ```
///
/// # Errors
///
/// This function returns an error if the input is invalid.
///
/// # Panics
///
/// This function panics if the buffer is full.
///
/// # Safety
///
/// This function is unsafe because... (document all invariants)
pub fn my_function(input: &str) -> Result<MyType, MyError> {
    // implementation
}
```

### Required Documentation Sections

- **Examples**: Every public function should have a runnable example
- **Errors**: Document error conditions
- **Panics**: Document panic conditions
- **Safety**: Document safety invariants for unsafe functions

### Links in Documentation

```rust
/// Use [`MyType`] for this purpose.
/// See [`other_function`](crate::module::other_function).
/// 
/// [`MyType`]: struct.MyType.html
/// [`other_function`]: #method.other_function
```

## Cargo.toml Best Practices

### Package Metadata

```toml
[package]
name = "my-crate"
version = "0.1.0"
edition = "2024"
rust-version = "1.70"  # MSRV
authors = ["Your Name <email@example.com>"]
description = "A brief description"
license = "MIT OR Apache-2.0"
repository = "https://github.com/username/repo"
homepage = "https://my-crate.io"  # if different from repo
documentation = "https://docs.rs/my-crate"
keywords = ["async", "networking"]
categories = ["asynchronous", "network-programming"]
readme = "README.md"
```

### Dependencies

```toml
[dependencies]
# Production dependencies
serde = { version = "1.0", features = ["derive"] }
tokio = { version = "1.0", features = ["full"] }

# Optional dependencies
serde = { version = "1.0", optional = true }

[dev-dependencies]
tokio-test = "0.4"

[features]
default = ["std"]
std = []
serde = ["dep:serde", "serde/std"]
```

### Lints Configuration (Rust 1.74+)

```toml
[lints.rust]
unsafe_code = "forbid"
missing_docs = "warn"

[lints.clippy]
all = "warn"
pedantic = "warn"
nursery = "warn"
cargo = "warn"
```

## Error Handling

### Result and Option

```rust
// Use ? operator for error propagation
pub fn process_file(path: &Path) -> Result<String, io::Error> {
    let content = fs::read_to_string(path)?;
    let result = parse(&content)?;
    Ok(result)
}

// Use Result for fallible operations
pub fn parse(input: &str) -> Result<Parsed, ParseError> {
    // ...
}

// Prefer Result over Option for errors with context
pub fn find_user(id: u64) -> Result<User, UserError> {
    // ...
}
```

### Error Propagation

```rust
// Good: Use ? operator
let value = some_operation()?;

// Good: Map errors for context
let value = some_operation()
    .map_err(|e| MyError::from_io_error(e, path))?;

// Good: Custom error types with thiserror
use thiserror::Error;

#[derive(Error, Debug)]
pub enum AppError {
    #[error("IO error: {0}")]
    Io(#[from] io::Error),
    
    #[error("Parse error: {0}")]
    Parse(#[from] ParseError),
    
    #[error("Invalid input: {message}")]
    InvalidInput { message: String },
}
```

### Never Use () as Error Type

```rust
// BAD
fn do_something() -> Result<Success, ()>;

// GOOD
fn do_something() -> Result<Success, MyError>;
```

## Unsafe Code Guidelines

### Safety Documentation

```rust
/// # Safety
/// 
/// The caller must ensure that:
/// - `ptr` is properly aligned
/// - `ptr` points to a valid `T`
/// - `ptr` is not null
pub unsafe fn do_something(ptr: *const T) -> T {
    // ...
}

// Mark unsafe blocks with SAFETY comments
unsafe {
    // SAFETY: ptr is valid and aligned as established above
    ptr.read()
}
```

### Safety Invariants

1. Always document ALL safety requirements
2. Keep unsafe blocks as small as possible
3. Create safe wrappers around unsafe code
4. Use `unsafe_op_in_unsafe_fn` lint

## Testing

### Unit Tests

```rust
#[cfg(test)]
mod tests {
    use super::*;
    
    #[test]
    fn test_basic_functionality() {
        let input = "hello";
        let result = process(input);
        assert_eq!(result, "HELLO");
    }
    
    #[test]
    fn test_error_handling() {
        let result = process_invalid_input();
        assert!(matches!(result, Err(Error::InvalidInput)));
    }
    
    #[test]
    #[should_panic(expected = "division by zero")]
    fn test_panic_case() {
        divide(1, 0);
    }
}
```

### Integration Tests

Create `tests/` directory with separate test files:

```rust
// tests/integration_test.rs
use my_crate::MyClient;

#[tokio::test]
async fn test_client_connection() {
    let client = MyClient::new();
    let result = client.connect().await;
    assert!(result.is_ok());
}
```

### Documentation Tests

```rust
/// ```
/// use my_crate::add;
/// assert_eq!(add(2, 2), 4);
/// ```
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

## Async/Await

### Async Function Design

```rust
// Good: Return impl Future or concrete Future type
pub async fn fetch_data() -> Result<Data, Error> {
    // ...
}

// Good: Use &self for methods
impl Client {
    pub async fn request(&self, url: &str) -> Result<Response, Error> {
        // ...
    }
}

// Good: Async trait with async-trait crate
#[async_trait]
pub trait Fetcher {
    async fn fetch(&self, url: &str) -> Result<String, Error>;
}
```

### Avoid Holding Guards Across Await Points

```rust
// BAD: Holding MutexGuard across await
async fn bad_example(mutex: &Mutex<Data>) {
    let guard = mutex.lock().unwrap();
    some_async_op().await; // ❌ May cause issues
    drop(guard);
}

// GOOD: Release guard before await
async fn good_example(mutex: &Mutex<Data>) {
    {
        let guard = mutex.lock().unwrap();
        // use guard
    } // guard dropped here
    some_async_op().await;
}
```

## Performance Considerations

### Zero-Cost Abstractions

```rust
// Use iterators instead of manual loops
let sum: i32 = numbers.iter().sum();

// Use collect with capacity hint when possible
let mut vec = Vec::with_capacity(items.len());

// Use &str instead of String for borrowed data
pub fn process(input: &str) -> &str;
```

### Avoid Unnecessary Allocations

```rust
// Bad: allocates String
fn takes_string(s: String) { }

// Good: borrows str
fn takes_str(s: &str) { }

// Bad: unnecessary boxing
fn boxed(b: Box<u32>) { }

// Good: simple value
fn simple(b: u32) { }
```

### Use Appropriate Collections

```rust
// Vec - sequential access, stack operations
// VecDeque - queue operations
// HashMap/HashSet - fast lookups
// BTreeMap/BTreeSet - sorted order
// LinkedList - rare, usually Vec is better
```

## Clippy Configuration

### Essential Lints (Deny by Default)

```rust
#![deny(clippy::all)]
#![deny(clippy::correctness)]
#![deny(clippy::suspicious)]
```

### Recommended Lints (Warn)

```rust
#![warn(clippy::pedantic)]
#![warn(clippy::perf)]
#![warn(clippy::style)]
#![warn(clippy::complexity)]
```

### Allowed Exceptions (when needed)

```rust
#![allow(clippy::module_name_repetitions)]
#![allow(clippy::too_many_lines)]
```

### Common Clippy Rules to Follow

1. **cast_lossless**: Use `u32::from(x)` instead of `x as u32` when lossless
2. **option_if_let_else**: Use `map`/`and_then` instead of `if let Some`
3. **unwrap_used**: Avoid unwrap(), use expect() with message or proper error handling
4. **expect_used**: Use expect() with descriptive message
5. **ok_expect**: Don't use `ok().expect()`, use `unwrap_or_else`
6. **match_bool**: Use `if`/`else` instead of matching on bool
7. **len_zero**: Use `is_empty()` instead of `len() == 0`

## Code Formatting

### Use rustfmt

Always format code with rustfmt before committing:

```bash
cargo fmt
```

Configuration in `rustfmt.toml`:

```toml
edition = "2024"
max_width = 100
tab_spaces = 4
use_small_heuristics = "Default"
reorder_imports = true
reorder_modules = true
```

## Project Structure

### Standard Layout

```
my-project/
├── Cargo.toml
├── Cargo.lock
├── rustfmt.toml
├── clippy.toml
├── README.md
├── LICENSE
├── src/
│   ├── lib.rs (or main.rs)
│   ├── module_a.rs
│   ├── module_a/
│   │   ├── sub_module.rs
│   │   └── mod.rs
│   └── module_b.rs
├── tests/
│   └── integration_tests.rs
├── examples/
│   └── simple_example.rs
├── benches/
│   └── benchmarks.rs
└── .github/
    └── workflows/
        └── ci.yml
```

### Library vs Binary

```rust
// For libraries (lib.rs)
pub mod public_module;
mod internal_module;

pub use public_module::PublicType;

// Re-export commonly used dependencies
#[cfg(feature = "serde")]
pub use serde;

// For binaries (main.rs)
use my_library::PublicType;

fn main() {
    // ...
}
```

## Version Management

### Semantic Versioning

Follow SemVer for crate versions:
- **MAJOR**: Breaking changes
- **MINOR**: New features, backwards compatible
- **PATCH**: Bug fixes, backwards compatible

### Deprecation

```rust
#[deprecated(since = "0.2.0", note = "Use new_function instead")]
pub fn old_function() {
    // ...
}

// With replacement suggestion
#[deprecated(
    since = "0.3.0",
    note = "Use `new_function` instead"
)]
pub fn old_function() {
    new_function()
}
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install Rust
        uses: dtolnay/rust-action@stable
      
      - name: Check formatting
        run: cargo fmt -- --check
      
      - name: Run clippy
        run: cargo clippy -- -D warnings
      
      - name: Build
        run: cargo build --all-features
      
      - name: Test
        run: cargo test --all-features
      
      - name: Check documentation
        run: cargo doc --no-deps
```

## Common Patterns

### Builder Pattern

```rust
#[derive(Debug, Default)]
pub struct ConfigBuilder {
    timeout: Option<Duration>,
    retries: Option<u32>,
}

impl ConfigBuilder {
    pub fn new() -> Self {
        Self::default()
    }
    
    pub fn timeout(mut self, timeout: Duration) -> Self {
        self.timeout = Some(timeout);
        self
    }
    
    pub fn retries(mut self, retries: u32) -> Self {
        self.retries = Some(retries);
        self
    }
    
    pub fn build(self) -> Config {
        Config {
            timeout: self.timeout.unwrap_or(Duration::from_secs(30)),
            retries: self.retries.unwrap_or(3),
        }
    }
}
```

### Type State Pattern

```rust
pub struct Unauthenticated;
pub struct Authenticated;

pub struct Client<State = Unauthenticated> {
    state: PhantomData<State>,
    token: Option<String>,
}

impl Client<Unauthenticated> {
    pub fn new() -> Self {
        Self {
            state: PhantomData,
            token: None,
        }
    }
    
    pub fn authenticate(self, token: String) -> Client<Authenticated> {
        Client {
            state: PhantomData,
            token: Some(token),
        }
    }
}

impl Client<Authenticated> {
    pub fn make_request(&self) -> Result<Response, Error> {
        // Can only call this when authenticated
    }
}
```

### Extension Traits

```rust
pub trait StringExt {
    fn truncate_at(&self, max_len: usize) -> &str;
}

impl StringExt for str {
    fn truncate_at(&self, max_len: usize) -> &str {
        if self.len() > max_len {
            &self[..max_len]
        } else {
            self
        }
    }
}

// Usage
let truncated = "hello world".truncate_at(5);
```

## Summary Checklist

Before submitting code:

- [ ] Code formatted with `cargo fmt`
- [ ] No clippy warnings: `cargo clippy -- -D warnings`
- [ ] All tests pass: `cargo test`
- [ ] Documentation builds: `cargo doc`
- [ ] Examples compile and run
- [ ] Public APIs have documentation
- [ ] Error types implement `std::error::Error`
- [ ] Public types implement common traits (Debug, Clone, etc.)
- [ ] Naming follows Rust conventions
- [ ] Unsafe code has SAFETY comments
- [ ] CHANGELOG.md updated (if applicable)

## References

1. [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)
2. [The Rust Programming Language](https://doc.rust-lang.org/book/)
3. [Rust by Example](https://doc.rust-lang.org/rust-by-example/)
4. [Clippy Lints](https://rust-lang.github.io/rust-clippy/)
5. [Rustfmt Configuration](https://rust-lang.github.io/rustfmt/)
6. [Cargo Book](https://doc.rust-lang.org/cargo/)
7. [Rust Reference](https://doc.rust-lang.org/reference/)
8. [The Rustonomicon](https://doc.rust-lang.org/nomicon/) (for unsafe code)
