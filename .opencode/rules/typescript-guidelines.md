# TypeScript Development Guidelines

> Based on TypeScript Official Documentation, Google TypeScript Style Guide, Microsoft TypeScript Team Guidelines, TypeScript ESLint, and Airbnb Conventions

## Overview

These guidelines ensure TypeScript code is type-safe, maintainable, and follows industry best practices. They combine:
- TypeScript official best practices and handbook recommendations
- Google's TypeScript style guide (widely used in production)
- Microsoft TypeScript team's internal coding guidelines
- TypeScript ESLint recommended and strict configurations
- Airbnb JavaScript/TypeScript conventions

---

## TypeScript Configuration

### Required `tsconfig.json`

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["ES2022"],
    "module": "ESNext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "allowJs": true,
    "checkJs": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "removeComments": false,
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictBindCallApply": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noImplicitReturns": true,
    "noFallthroughCasesInSwitch": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "forceConsistentCasingInFileNames": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "isolatedModules": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts", "**/*.spec.ts"]
}
```

### Required ESLint Configuration

```javascript
// eslint.config.mjs
import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';

export default tseslint.config(
  eslint.configs.recommended,
  ...tseslint.configs.strictTypeChecked,
  ...tseslint.configs.stylisticTypeChecked,
  {
    languageOptions: {
      parserOptions: {
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
      },
    },
  },
  {
    rules: {
      // Type Safety
      '@typescript-eslint/no-explicit-any': 'error',
      '@typescript-eslint/no-unsafe-argument': 'error',
      '@typescript-eslint/no-unsafe-assignment': 'error',
      '@typescript-eslint/no-unsafe-call': 'error',
      '@typescript-eslint/no-unsafe-member-access': 'error',
      '@typescript-eslint/no-unsafe-return': 'error',
      
      // Code Quality
      '@typescript-eslint/no-floating-promises': 'error',
      '@typescript-eslint/no-misused-promises': 'error',
      '@typescript-eslint/await-thenable': 'error',
      '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
      '@typescript-eslint/prefer-nullish-coalescing': 'error',
      '@typescript-eslint/prefer-optional-chain': 'error',
      
      // Naming and Style
      '@typescript-eslint/naming-convention': [
        'error',
        {
          selector: 'default',
          format: ['camelCase'],
          leadingUnderscore: 'allow',
          trailingUnderscore: 'allow',
        },
        {
          selector: 'variable',
          format: ['camelCase', 'UPPER_CASE', 'PascalCase'],
          leadingUnderscore: 'allow',
          trailingUnderscore: 'allow',
        },
        {
          selector: 'typeLike',
          format: ['PascalCase'],
        },
        {
          selector: 'enumMember',
          format: ['PascalCase'],
        },
        {
          selector: 'interface',
          format: ['PascalCase'],
          custom: {
            regex: '^I[A-Z]',
            match: false,
          },
        },
      ],
      
      // Best Practices
      '@typescript-eslint/explicit-function-return-type': 'off',
      '@typescript-eslint/explicit-module-boundary-types': 'error',
      '@typescript-eslint/no-empty-function': ['error', { allow: ['arrowFunctions'] }],
      '@typescript-eslint/no-non-null-assertion': 'error',
      '@typescript-eslint/prefer-readonly': 'error',
    },
  },
);
```

---

## Naming Conventions

### DO: Use PascalCase for Type Names

```typescript
// GOOD
class UserProfile { }
interface ApiResponse { }
enum HttpStatus { }
type UserId = string;

// BAD
class userProfile { }
interface apiResponse { }
enum httpStatus { }
```

### DO: Use camelCase for Variables, Functions, and Methods

```typescript
// GOOD
const userName = 'John';
let itemCount = 0;
function fetchUser() { }
class User {
  getFullName() { }
}

// BAD
const UserName = 'John';
let ItemCount = 0;
function FetchUser() { }
```

### DO: Use UPPER_CASE for Constants

```typescript
// GOOD
const MAX_RETRY_COUNT = 3;
const API_BASE_URL = 'https://api.example.com';
const DEFAULT_TIMEOUT = 5000;

// BAD
const maxRetryCount = 3;
const apiBaseUrl = 'https://api.example.com';
```

### DO: Use PascalCase for Enum Members

```typescript
// GOOD
enum Status {
  Pending,
  Active,
  Inactive,
}

// BAD
enum Status {
  pending,
  active,
  inactive,
}
```

### DO NOT: Use "I" Prefix for Interfaces

```typescript
// GOOD
interface User {
  name: string;
}

// BAD
interface IUser {
  name: string;
}
```

---

## Type System Best Practices

### DO: Prefer `interface` over `type` for Object Shapes

```typescript
// GOOD - Use interface for object shapes
interface User {
  id: number;
  name: string;
  email: string;
}

interface Admin extends User {
  permissions: string[];
}

// GOOD - Use type for unions, tuples, and utility types
type Status = 'active' | 'inactive' | 'pending';
type Point = [number, number];
type Nullable<T> = T | null;
```

### DO: Use Strict Null Checks

```typescript
// GOOD - Explicitly handle null/undefined
function getUserName(user: User | undefined): string {
  if (user === undefined) {
    return 'Anonymous';
  }
  return user.name;
}

// GOOD - Use nullish coalescing
const userName = user?.name ?? 'Anonymous';

// BAD - Ignoring potential null/undefined
function getUserName(user: User | undefined): string {
  return user.name; // Error with strictNullChecks
}
```

### DO: Avoid `any` Type

```typescript
// GOOD - Use unknown for values of uncertain type
function processData(data: unknown): void {
  if (typeof data === 'string') {
    console.log(data.toUpperCase());
  }
}

// GOOD - Use specific types or generics
function identity<T>(value: T): T {
  return value;
}

// BAD - Using any disables type checking
function processData(data: any): void {
  console.log(data.toUpperCase()); // No error, but may fail at runtime
}
```

### DO: Use Readonly for Immutable Data

```typescript
// GOOD - Use readonly to prevent mutations
interface Config {
  readonly apiUrl: string;
  readonly timeout: number;
}

function processItems(items: readonly string[]): void {
  // items.push('new'); // Error: Cannot mutate readonly array
  items.forEach(item => console.log(item));
}

// GOOD - Use Readonly<T> for immutable objects
type ImmutableUser = Readonly<User>;
```

---

## Functions

### DO: Use Arrow Functions for Callbacks

```typescript
// GOOD - Arrow functions preserve this context
const numbers = [1, 2, 3];
const doubled = numbers.map(n => n * 2);

class Counter {
  private count = 0;

  start() {
    setInterval(() => {
      this.count++; // `this` correctly refers to Counter instance
    }, 1000);
  }
}

// BAD - Regular function loses this context
class Counter {
  private count = 0;

  start() {
    setInterval(function() {
      this.count++; // Error: `this` is not Counter
    }, 1000);
  }
}
```

### DO: Use Explicit Return Types for Public APIs

```typescript
// GOOD - Explicit return type for public API
export function calculateTotal(
  items: CartItem[],
  discount?: number
): number {
  const subtotal = items.reduce((sum, item) => sum + item.price, 0);
  const discountAmount = discount ? subtotal * discount : 0;
  return subtotal - discountAmount;
}

// GOOD - Return type inferred for internal function
function formatCurrency(amount: number) {
  return `$${amount.toFixed(2)}`;
}
```

### DO: Use Default Parameters

```typescript
// GOOD - Use default parameters
function greet(name: string, greeting: string = 'Hello'): string {
  return `${greeting}, ${name}!`;
}

// GOOD - Default parameters with destructuring
function createUser({
  name,
  role = 'user',
  active = true,
}: {
  name: string;
  role?: string;
  active?: boolean;
}): User {
  return { name, role, active };
}

// BAD - Manual default handling
function greet(name: string, greeting?: string): string {
  const actualGreeting = greeting || 'Hello';
  return `${actualGreeting}, ${name}!`;
}
```

---

## Classes

### DO: Use Access Modifiers

```typescript
// GOOD - Explicit access modifiers
class UserService {
  private readonly apiUrl: string;
  protected cache: Map<string, User>;

  constructor(apiUrl: string) {
    this.apiUrl = apiUrl;
    this.cache = new Map();
  }

  public async getUser(id: string): Promise<User> {
    if (this.cache.has(id)) {
      return this.cache.get(id)!;
    }
    const user = await this.fetchUser(id);
    this.cache.set(id, user);
    return user;
  }

  private async fetchUser(id: string): Promise<User> {
    // Implementation
  }
}

// GOOD - Use parameter properties
class UserService {
  constructor(
    private readonly apiUrl: string,
    protected cache: Map<string, User> = new Map()
  ) {}
}
```

### DO: Implement Common Interfaces

```typescript
// GOOD - Implement toString for better debugging
class User {
  constructor(
    private readonly id: string,
    private readonly name: string
  ) {}

  toString(): string {
    return `User(${this.id}): ${this.name}`;
  }
}

// GOOD - Implement custom equality if needed
class Point {
  constructor(
    public readonly x: number,
    public readonly y: number
  ) {}

  equals(other: Point): boolean {
    return this.x === other.x && this.y === other.y;
  }
}
```

### DO NOT: Use Classes as Namespaces

```typescript
// BAD - Using class as namespace
class MathUtils {
  static PI = 3.14159;
  static calculateArea(radius: number): number {
    return this.PI * radius * radius;
  }
}

// GOOD - Use module-level functions and constants
export const PI = 3.14159;

export function calculateArea(radius: number): number {
  return PI * radius * radius;
}
```

---

## Async Programming

### DO: Always Handle Promises

```typescript
// GOOD - Always await or handle promises
async function loadData(): Promise<void> {
  const data = await fetchData();
  processData(data);
}

// GOOD - Explicitly mark promise as intentionally unawaited
function fireAndForget(): void {
  void analytics.track('event');
}

// BAD - Floating promise
function loadData(): void {
  fetchData(); // Promise is not awaited or handled
}
```

### DO: Use try-catch for Error Handling

```typescript
// GOOD - Proper async error handling
async function fetchUserData(userId: string): Promise<User> {
  try {
    const response = await fetch(`/api/users/${userId}`);
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}`);
    }
    return await response.json();
  } catch (error) {
    if (error instanceof NetworkError) {
      logger.warn('Network error, retrying...');
      return fetchUserData(userId);
    }
    throw error;
  }
}

// GOOD - Use Result type pattern for expected failures
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

async function parseJson(input: string): Promise<Result<unknown>> {
  try {
    return { success: true, data: JSON.parse(input) };
  } catch (error) {
    return { success: false, error: error as Error };
  }
}
```

---

## Modules and Imports

### DO: Use ES Modules

```typescript
// GOOD - Named exports
export interface User {
  id: string;
  name: string;
}

export function createUser(name: string): User {
  return { id: generateId(), name };
}

export class UserRepository {
  // Implementation
}

// GOOD - Import organization
import { readFile } from 'node:fs/promises'; // Built-in modules
import express from 'express'; // External modules
import { User } from './user'; // Internal modules
import type { Config } from './config'; // Type-only imports
```

### DO: Use `import type` for Type-Only Imports

```typescript
// GOOD - Use import type when only importing types
import type { User, UserRole } from './user';
import type { Config } from './config';

// GOOD - Inline type imports
import { type User, createUser } from './user';

// This ensures type imports are removed at compile time
```

### DO NOT: Use Namespaces

```typescript
// BAD - Do not use namespaces
namespace Utils {
  export function formatDate(date: Date): string {
    return date.toISOString();
  }
}

// GOOD - Use modules instead
export function formatDate(date: Date): string {
  return date.toISOString();
}

// In another file:
import { formatDate } from './utils';
```

---

## Error Handling

### DO: Use Custom Error Classes

```typescript
// GOOD - Define custom error classes
export class ValidationError extends Error {
  constructor(
    message: string,
    public readonly field?: string
  ) {
    super(message);
    this.name = 'ValidationError';
  }
}

export class NotFoundError extends Error {
  constructor(
    message: string,
    public readonly resource: string,
    public readonly id: string
  ) {
    super(message);
    this.name = 'NotFoundError';
  }
}

// GOOD - Type guards for error handling
function isValidationError(error: unknown): error is ValidationError {
  return error instanceof ValidationError;
}

async function handleRequest(): Promise<void> {
  try {
    await processData();
  } catch (error) {
    if (isValidationError(error)) {
      return res.status(400).json({
        error: error.message,
        field: error.field,
      });
    }
    throw error;
  }
}
```

### DO: Preserve Error Stack Traces

```typescript
// GOOD - Preserve original error
async function loadConfig(): Promise<Config> {
  try {
    const data = await readFile('config.json', 'utf-8');
    return JSON.parse(data);
  } catch (error) {
    throw new Error(
      `Failed to load config: ${error instanceof Error ? error.message : 'Unknown error'}`,
      { cause: error }
    );
  }
}

// GOOD - Use error cause for chaining
class ServiceError extends Error {
  constructor(
    message: string,
    options?: { cause?: unknown }
  ) {
    super(message, options);
    this.name = 'ServiceError';
  }
}
```

---

## Generics

### DO: Use Descriptive Generic Names

```typescript
// GOOD - Descriptive generic names
interface Repository<TEntity> {
  findById(id: string): Promise<TEntity | null>;
  save(entity: TEntity): Promise<void>;
}

interface ApiResponse<TData> {
  data: TData;
  status: number;
  message?: string;
}

// GOOD - Single letter for simple, obvious cases
function identity<T>(value: T): T {
  return value;
}

function pair<T, U>(first: T, second: U): [T, U] {
  return [first, second];
}
```

### DO: Add Constraints to Generics

```typescript
// GOOD - Constrained generics
interface HasId {
  id: string;
}

function findById<T extends HasId>(items: T[], id: string): T | null {
  return items.find(item => item.id === id) ?? null;
}

// GOOD - Multiple constraints
interface Serializable {
  serialize(): string;
}

function cache<T extends HasId & Serializable>(item: T): void {
  const key = item.id;
  const value = item.serialize();
  // Cache implementation
}
```

---

## Utility Types

### DO: Leverage Built-in Utility Types

```typescript
// GOOD - Use built-in utility types
interface User {
  id: string;
  name: string;
  email: string;
  password: string;
}

// Pick - Select specific properties
type UserCredentials = Pick<User, 'email' | 'password'>;

// Omit - Exclude specific properties
type PublicUser = Omit<User, 'password'>;

// Partial - Make all properties optional
type UserUpdate = Partial<User>;

// Required - Make all properties required
type StrictUser = Required<User>;

// Readonly - Make all properties readonly
type ImmutableUser = Readonly<User>;

// Record - Define object with specific key/value types
type UserMap = Record<string, User>;

// ReturnType - Extract return type of function
type ApiResponse = ReturnType<typeof fetchUser>;

// Parameters - Extract parameter types
type FetchUserParams = Parameters<typeof fetchUser>;
```

---

## Documentation

### DO: Use JSDoc for Public APIs

```typescript
/**
 * Represents a user in the system.
 */
interface User {
  /** Unique identifier for the user */
  id: string;
  /** User's display name */
  name: string;
  /** User's email address (must be unique) */
  email: string;
}

/**
 * Fetches a user by their unique identifier.
 *
 * @param id - The unique identifier of the user
 * @returns A promise that resolves to the user, or null if not found
 * @throws {NotFoundError} If the user does not exist
 * @throws {NetworkError} If the request fails due to network issues
 *
 * @example
 * ```typescript
 * const user = await fetchUser('user-123');
 * if (user) {
 *   console.log(user.name);
 * }
 * ```
 */
export async function fetchUser(id: string): Promise<User | null> {
  // Implementation
}
```

---

## Testing Guidelines

### DO: Write Type-Safe Tests

```typescript
// GOOD - Type-safe test with proper assertions
import { describe, it, expect } from 'vitest';
import { createUser } from './user';

describe('createUser', () => {
  it('should create a user with the given name', () => {
    const user = createUser('John Doe');
    
    expect(user.name).toBe('John Doe');
    expect(user.id).toBeDefined();
    expect(user.createdAt).toBeInstanceOf(Date);
  });

  it('should throw for empty name', () => {
    expect(() => createUser('')).toThrow(ValidationError);
  });
});

// GOOD - Test async functions
import { describe, it, expect } from 'vitest';
import { fetchUser } from './api';

describe('fetchUser', () => {
  it('should return user for valid id', async () => {
    const user = await fetchUser('valid-id');
    expect(user).not.toBeNull();
    expect(user?.id).toBe('valid-id');
  });

  it('should return null for non-existent user', async () => {
    const user = await fetchUser('non-existent');
    expect(user).toBeNull();
  });
});
```

---

## Performance Guidelines

### DO: Use Proper Data Structures

```typescript
// GOOD - Use Set for unique values and fast lookup
const uniqueIds = new Set<string>();
uniqueIds.add('id-1');
uniqueIds.add('id-2');
const hasId = uniqueIds.has('id-1'); // O(1)

// GOOD - Use Map for key-value lookups
const userCache = new Map<string, User>();
userCache.set('user-1', user);
const cached = userCache.get('user-1'); // O(1)

// BAD - Using array for lookups
const users: User[] = [];
const hasUser = users.some(u => u.id === 'id-1'); // O(n)
```

### DO: Lazy Load Expensive Operations

```typescript
// GOOD - Lazy initialization
class ExpensiveService {
  private _data: ExpensiveData | null = null;

  get data(): ExpensiveData {
    if (this._data === null) {
      this._data = this.loadExpensiveData();
    }
    return this._data;
  }

  private loadExpensiveData(): ExpensiveData {
    // Expensive operation
    return {};
  }
}

// GOOD - Use memoization
function memoize<T, R>(fn: (arg: T) => R): (arg: T) => R {
  const cache = new Map<T, R>();
  return (arg: T) => {
    if (!cache.has(arg)) {
      cache.set(arg, fn(arg));
    }
    return cache.get(arg)!;
  };
}

const fibonacci = memoize((n: number): number => {
  if (n < 2) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
});
```

---

## Code Organization

### DO: Group Related Exports

```typescript
// types.ts - Centralize type definitions
export interface User {
  id: string;
  name: string;
}

export interface CreateUserRequest {
  name: string;
  email: string;
}

export interface UpdateUserRequest {
  name?: string;
  email?: string;
}

// user.ts - Implementation
import type { User, CreateUserRequest } from './types';

export function createUser(request: CreateUserRequest): User {
  // Implementation
}

export function updateUser(
  user: User,
  request: UpdateUserRequest
): User {
  // Implementation
}

// index.ts - Re-export public API
export type { User, CreateUserRequest, UpdateUserRequest } from './types';
export { createUser, updateUser } from './user';
```

---

## Summary Checklist

Before submitting TypeScript code:

- [ ] TypeScript compiler strict mode enabled
- [ ] No `any` types without explicit justification
- [ ] All promises are awaited or explicitly voided
- [ ] Proper error handling with try-catch
- [ ] Public APIs have explicit return types
- [ ] JSDoc comments for public functions and types
- [ ] Naming conventions followed (PascalCase types, camelCase functions)
- [ ] No floating promises
- [ ] Proper null/undefined handling
- [ ] Tests pass with `npm test`
- [ ] TypeScript compiles without errors (`tsc --noEmit`)
- [ ] ESLint passes (`eslint .`)

---

## References

1. [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
2. [Google TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html)
3. [Microsoft TypeScript Coding Guidelines](https://github.com/microsoft/TypeScript/wiki/Coding-guidelines)
4. [TypeScript ESLint Rules](https://typescript-eslint.io/rules/)
5. [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
6. [TypeScript Deep Dive](https://basarat.gitbook.io/typescript/)
7. [TypeScript Best Practices](https://docs.gitlab.com/ee/development/typescript/index.html)

---

## Version

- Created: 2025-02-16
- Based on: TypeScript 5.4+
- Last Updated: 2025-02-16
