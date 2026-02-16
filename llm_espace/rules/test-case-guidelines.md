# Test Case Guidelines

> Based on ISTQB (International Software Testing Qualifications Board), ISO/IEC/IEEE 29119 Standards, IEEE 829-2008, and Modern Testing Frameworks

## Role Definition

You are a **Test Engineering Agent** specialized in designing, writing, and maintaining comprehensive test cases following ISTQB, ISO/IEC/IEEE standards, and industry best practices. You create tests that are specific, measurable, achievable, relevant, and time-bound (SMART).

## Agent Quick Start

1. **Identify test scope**: Unit | Integration | E2E | Performance | Security
2. **Select design technique**: Equivalence Partitioning | Boundary Value | Decision Table | State Transition
3. **Apply test case template** with required components (ID, Title, Steps, Expected Results)
4. **Follow naming**: `[Action]_[Object]_[Condition]` format
5. **Ensure traceability**: Link to requirements and maintain version control
6. **Validate**: Check against SMART criteria and anti-patterns

**Key Principles:**
- One assertion per test (when possible)
- Independent, isolated tests
- Explicit over implicit
- Data-driven over hardcoded
- Maintainable over clever

## Overview

These guidelines establish comprehensive standards for creating, managing, and maintaining test cases across all software testing activities. They combine:
- ISTQB best practices and test design techniques
- ISO/IEC/IEEE 29119 software testing standards
- IEEE 829-2008 test documentation standard
- Modern testing framework conventions (JUnit, pytest, Jest, Mocha, Cypress, Playwright, etc.)
- Behavior-Driven Development (BDD) and Test-Driven Development (TDD) principles
- Agile and DevOps testing practices

---

## Table of Contents

1. [Role Definition](#role-definition)
2. [Agent Quick Start](#agent-quick-start)
3. [Test Case Fundamentals](#test-case-fundamentals)
4. [Test Case Structure and Components](#test-case-structure-and-components)
5. [Test Case Writing Best Practices](#test-case-writing-best-practices)
6. [Test Types and Levels](#test-types-and-levels)
7. [Test Case Design Techniques](#test-case-design-techniques)
8. [Test Data Management](#test-data-management)
9. [Test Case Templates and Examples](#test-case-templates-and-examples)
10. [Test Automation Guidelines](#test-automation-guidelines)
11. [AI Test Generation Guidelines](#ai-test-generation-guidelines)
12. [Test Case Review Process](#test-case-review-process)
13. [Test Case Maintenance](#test-case-maintenance)
14. [Common Anti-Patterns and How to Avoid Them](#common-anti-patterns-and-how-to-avoid-them)
15. [Test Documentation Standards](#test-documentation-standards)
16. [Test Metrics and Reporting](#test-metrics-and-reporting)
17. [Specialized Testing Considerations](#specialized-testing-considerations)
18. [Related Guidelines](#related-guidelines)

---

## Test Case Fundamentals

### What is a Test Case?

A test case is a set of preconditions, inputs, actions (where applicable), and expected results, developed to verify whether a specific requirement or feature of a software system functions correctly. Test cases serve as the foundation for systematic software testing and quality assurance.

#### Formal Definition (ISO/IEC/IEEE 29119-1:2022)

> A test case is a set of test inputs, execution conditions, and expected results developed for a particular objective, such as to exercise a particular program path or to verify compliance with a specific requirement.

### Purpose of Test Cases

- **Verify Requirements**: Confirm that software meets specified functional and non-functional requirements
- **Detect Defects**: Identify bugs, errors, and inconsistencies before production deployment
- **Prevent Regressions**: Ensure new changes don't break existing functionality
- **Document Behavior**: Serve as executable specifications and living documentation
- **Enable Automation**: Provide foundation for automated testing and CI/CD pipelines
- **Support Compliance**: Demonstrate adherence to regulatory and quality standards
- **Facilitate Communication**: Bridge understanding between stakeholders, developers, and testers
- **Enable Traceability**: Link requirements to verification activities
- **Measure Quality**: Provide data for quality metrics and release decisions

### When to Create Test Cases

#### Development Phase
- **Requirements Analysis**: Create high-level test scenarios and acceptance criteria
- **Design Phase**: Develop detailed test cases based on design specifications
- **Implementation Phase**: Write unit and integration tests alongside code (TDD/BDD)
- **Testing Phase**: Execute manual and automated test suites

#### Continuous Activities
- **Regression Testing**: Maintain and update existing test suites
- **Exploratory Testing**: Document findings as formal test cases
- **Bug Fix Verification**: Create tests to reproduce and verify fixes
- **Release Preparation**: Validate release candidates against test suites

### Test Case vs Test Scenario vs Test Script

| Aspect | Test Scenario | Test Case | Test Script |
|--------|---------------|-----------|-------------|
| **Definition** | High-level description of what to test | Detailed steps with inputs and expected results | Executable code for automated testing |
| **Granularity** | Coarse-grained | Fine-grained | Implementation-level |
| **Purpose** | Guide test planning | Guide test execution | Automate test execution |
| **Example** | "Verify user login functionality" | "Enter valid username 'john_doe' and password 'Secure123!'..." | `test('login', () => { ... })` |
| **Audience** | Stakeholders, Test Managers | Testers, QA Engineers | Developers, Automation Engineers |
| **Format** | Text description | Structured document | Programming code |

---

## Test Case Structure and Components

### Required Components

#### Test Case Definition (Design-Time Fields)

These fields are defined when creating the test case and remain relatively static:

| Component | Format | Example | Key Guidelines |
|-----------|--------|---------|----------------|
| **Test Case ID** | `[PROJECT]-[MODULE]-[TYPE]-[NUMBER]` | `ECOM-AUTH-LOG-001` | 3-4 char project code, module abbreviation, type code, sequential number |
| **Title** | `[Action] [Object] [Condition]` | `Verify User Login with Valid Credentials` | Under 80 chars, action verbs, specific |
| **Description** | Context and rationale | "Validates authenticated users can access dashboard with valid credentials" | Explain why it matters, reference requirements |
| **Preconditions** | Bullet list of required state | User account exists, active status, app accessible | List all dependencies, data setup, environment state |
| **Test Steps** | Numbered actions | 1. Navigate to /login 2. Enter username... | One action per step, imperative voice, specific values |
| **Test Data** | Table with Field/Value/Type/Source | \| username \| john_doe \| String \| Test Set A \| | Realistic values, document sources, include edge cases |
| **Expected Results** | Explicit outcomes per step or overall | Step 1: Page loads (HTTP 200). Overall: Redirect to /dashboard within 3s | Specific, measurable, include performance expectations |
| **Priority** | Business criticality | P0/Critical, P1/High, P2/Medium, P3/Low | Based on business impact, frequency of use, compliance |

#### Test Execution (Runtime Fields)

These fields are populated during test execution and capture actual outcomes:

| Component | Format | Example | Key Guidelines |
|-----------|--------|---------|----------------|
| **Actual Results** | Captured during execution | Step 1: PASS - 1.2s. Step 5: FAIL - Wrong redirect | Exact observations, timestamps, screenshots for failures |
| **Status** | Execution state | NOT EXECUTED, PASSED, FAILED, BLOCKED, SKIPPED, UNSTABLE | Update immediately, include date/time stamp |

### Optional Components

#### Test Category/Type
- Unit Test
- Integration Test
- System Test
- E2E Test
- Performance Test
- Security Test
- Accessibility Test
- Regression Test
- Smoke Test
- Sanity Test

#### Requirements Traceability
```
Format: Links to requirements, user stories, or specifications

Example:
Requirements Coverage:
- REQ-AUTH-001: User authentication
- REQ-SEC-003: Password validation
- US-123: As a user, I want to log in
- SRS Section 4.2.1: Login Requirements

Traceability Matrix Entry:
| Test Case ID | Requirement ID | Coverage Type |
|--------------|----------------|---------------|
| ECOM-AUTH-LOG-001 | REQ-AUTH-001 | Full |
```

#### Automation Status
```
Values:
- MANUAL: Only executed manually
- AUTO: Fully automated
- AUTO-IN-PROGRESS: Being automated
- AUTO-DEPRECATED: Automation outdated
- CANDIDATE: Identified for automation
- NOT-AUTO: Not suitable for automation

Automation Metadata:
- Framework: Jest, Cypress, Selenium, etc.
- Script Location: /tests/e2e/login.spec.ts
- Execution Time: ~45 seconds
- Last Automated: 2024-01-15
```

#### Environment Requirements
```
Example:
Minimum Environment:
- Browser: Chrome 120+, Firefox 121+, Safari 17+
- OS: Windows 11, macOS 14, Ubuntu 22.04
- Screen Resolution: 1920x1080 minimum
- Network: Broadband connection (5+ Mbps)
- Database: PostgreSQL 15 with test data

Mobile Environment:
- iOS: 16+ (iPhone 12 and newer)
- Android: 13+ (API level 33+)
- Device Orientations: Portrait, Landscape
```

#### Execution History
```
Format: Log of past executions

| Date | Executed By | Build | Status | Duration | Notes |
|------|-------------|-------|--------|----------|-------|
| 2024-01-15 | Jane Smith | v2.3.1 | PASSED | 45s | - |
| 2024-01-14 | John Doe | v2.3.0 | FAILED | 30s | Issue AUTH-456 |
| 2024-01-13 | Jane Smith | v2.3.0 | PASSED | 42s | - |
```

#### Attachments
- Screenshots (PNG, JPG)
- Video recordings (MP4)
- Log files (TXT, LOG)
- Data files (CSV, JSON, XML)
- Network traces (HAR)
- Accessibility reports

---

## Test Case Writing Best Practices

### SMART Criteria for Test Cases

Apply SMART principles to ensure test cases are effective and actionable:

#### Specific
```
❌ BAD: "Test the login feature"

✅ GOOD: "Verify that registered users can log in using a valid email 
          address and password combination, and are redirected to the 
          dashboard within 3 seconds"

Checklist:
- [ ] Test objective is clearly stated
- [ ] Specific data values are provided
- [ ] UI elements are precisely identified
- [ ] Expected results are unambiguous
```

#### Measurable
```
❌ BAD: "Page should load quickly"

✅ GOOD: "Page must load completely within 2 seconds on a 4G connection"

Checklist:
- [ ] Quantifiable acceptance criteria
- [ ] Performance thresholds defined
- [ ] Success/failure criteria binary
- [ ] Output can be objectively verified
```

#### Achievable
```
❌ BAD: "Test that the application works on all devices ever made"

✅ GOOD: "Test login functionality on Chrome 120+, Firefox 121+, and 
          Safari 17+ on Windows, macOS, and mobile devices (iOS 16+, Android 13+)"

Checklist:
- [ ] Test can be executed with available resources
- [ ] Preconditions are realistic
- [ ] Test environment is accessible
- [ ] Test data is obtainable
```

#### Relevant
```
❌ BAD: "Verify that the company logo is blue" (unless brand-critical)

✅ GOOD: "Verify that password reset emails are sent within 60 seconds 
          to prevent user abandonment"

Checklist:
- [ ] Tests business-critical functionality
- [ ] Aligned with user requirements
- [ ] Addresses risk areas
- [ ] Provides value to stakeholders
```

#### Time-bound
```
❌ BAD: "System should eventually respond"

✅ GOOD: "API must return response within 500ms; if exceeded, 
          retry logic triggers within 2 seconds"

Checklist:
- [ ] Time limits specified where applicable
- [ ] Timeout values defined
- [ ] Duration expectations clear
- [ ] SLA requirements referenced
```

### Test Case Naming Conventions

#### Format Template
```
[Action Verb] + [Object/Feature] + [Condition/Context]

Examples:
- Verify User Registration with Valid Email
- Validate Password Reset Flow for Locked Account
- Test Shopping Cart Checkout with Invalid Payment
- Confirm Email Notification Sent on Order Placement
- Check Search Results Sorting by Price (Low to High)
```

#### Action Verbs to Use
```
Verification Actions:
- Verify, Validate, Confirm, Check, Ensure, Assert

Functional Actions:
- Test, Exercise, Demonstrate, Prove, Show

Negative Testing:
- Attempt, Try, Reject, Deny, Prevent

Boundary Testing:
- Bound, Limit, Restrict, Maximize, Minimize
```

#### Structure Guidelines
```
1. Start with action verb
2. Identify the feature being tested
3. Specify the condition or context
4. Keep it under 80 characters when possible
5. Avoid technical jargon when possible
6. Be consistent across the test suite
```

### Writing Clear Test Steps

#### One Action Per Step
```
❌ BAD:
Step 1: Enter username and password, then click login button and wait for page to load

✅ GOOD:
Step 1: Enter username "john_doe" in the Username field
Step 2: Enter password "Secure123!" in the Password field
Step 3: Click the "Login" button
Step 4: Wait for the Dashboard page to load (max 5 seconds)
```

#### Use Imperative Voice
```
❌ BAD:
Step 1: The user should enter their username

✅ GOOD:
Step 1: Enter username in the Username field
```

#### Include Specific Values
```
❌ BAD:
Step 1: Enter valid username

✅ GOOD:
Step 1: Enter username "testuser123" in the Username field
```

#### Reference UI Elements Precisely
```
❌ BAD:
Step 1: Click the button to proceed

✅ GOOD:
Step 1: Click the blue "Continue" button located at the bottom right of the form
```

### Writing Effective Expected Results

#### Be Specific and Observable
```
❌ BAD:
Expected: User should be logged in successfully

✅ GOOD:
Expected Results:
- User is redirected to /dashboard (HTTP 302)
- Dashboard loads completely within 3 seconds
- User's full name appears in the top navigation bar
- Session cookie "auth_token" is set with 24-hour expiration
- URL changes from /login to /dashboard
```

#### Include Negative Conditions
```
Expected Results:
- Success Case: Order confirmation page displays with order number
- Failure Case (insufficient funds): Error message displays: "Payment declined. 
  Please use a different payment method."
- Failure Case (network error): Retry button appears with message: 
  "Connection lost. Click to retry."
```

#### Document State Changes
```
Database State:
- Before: User record has login_attempts = 0
- After: User record has login_attempts = 1, last_login timestamp updated

System State:
- Before: User is unauthenticated
- After: User is authenticated, session active
```

### Test Case Independence

#### Principle
Each test case should be able to run independently without relying on other test cases.

#### Implementation
```
❌ BAD (Dependencies Between Tests):
Test Case 1: Create new user
Test Case 2: Login with the user created in Test Case 1

✅ GOOD (Independent Tests):
Test Case 1: Create new user
  Preconditions: None
  Cleanup: Delete created user

Test Case 2: Login with valid credentials
  Preconditions: User "existing_user" exists (created via setup script)
  Cleanup: Logout user
```

#### Setup and Teardown
```
Template:
Preconditions:
- Database is in known state (restored from baseline)
- Required test data exists (loaded via seed script)
- User session is not active
- Application cache is cleared

Cleanup/Teardown:
- Delete any created test data
- Reset modified records to original state
- Clear cookies and local storage
- Log out any authenticated sessions
- Close all browser tabs/windows
```

### Test Case Traceability

#### Requirements Mapping
```
Format:
Test Case ID: ECOM-CART-ADD-001
Related Requirements:
  - REQ-CART-001: Users can add items to cart
  - REQ-CART-002: Cart persists across sessions
  - US-456: As a shopper, I want to add items to cart
  - SRS Section 3.4.1: Shopping Cart Functionality

Traceability Matrix:
| Requirement ID | Test Case IDs | Coverage % |
|----------------|---------------|------------|
| REQ-CART-001 | ECOM-CART-ADD-001, ECOM-CART-ADD-002 | 100% |
| REQ-CART-002 | ECOM-CART-PERS-001, ECOM-CART-PERS-002 | 100% |
```

#### Bidirectional Traceability
```
Forward: Requirement → Test Cases → Test Results
Backward: Defect → Test Case → Requirement

Example Workflow:
1. Requirement REQ-AUTH-001 is defined
2. Test cases ECOM-AUTH-LOG-001 through ECOM-AUTH-LOG-010 are created
3. Test execution reveals failure in ECOM-AUTH-LOG-003
4. Bug BUG-789 is logged and linked to test case
5. Fix is verified by re-running ECOM-AUTH-LOG-003
6. Requirement status updated to "Verified"
```

### Test Case Version Control

#### Change Management
```
Version Format: MAJOR.MINOR.PATCH
- MAJOR: Significant change to test objective or scope
- MINOR: Addition/removal of test steps or data
- PATCH: Typos, clarifications, metadata updates

Example:
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2024-01-01 | John Doe | Initial test case created |
| 1.1.0 | 2024-01-15 | Jane Smith | Added edge case for empty password |
| 1.1.1 | 2024-01-16 | John Doe | Fixed typo in step 3 |
| 2.0.0 | 2024-02-01 | Jane Smith | Updated for new UI design |
```

---

## Test Types and Levels

### Unit Testing

#### Definition
Testing individual units or components of software in isolation from the rest of the system.

#### Characteristics
```
Scope: Single function, method, or class
Isolation: Dependencies mocked or stubbed
Speed: Fast execution (< 100ms per test)
Frequency: Run on every code change
Author: Developers
Tools: Jest, Mocha, JUnit, pytest, NUnit, xUnit
```

#### Best Practices
```typescript
// Example: Unit test for user validation function

describe('UserValidator', () => {
  describe('validateEmail', () => {
    it('should return true for valid email format', () => {
      const result = UserValidator.validateEmail('user@example.com');
      expect(result).toBe(true);
    });

    it('should return false for invalid email format', () => {
      const result = UserValidator.validateEmail('invalid-email');
      expect(result).toBe(false);
    });

    it('should return false for empty string', () => {
      const result = UserValidator.validateEmail('');
      expect(result).toBe(false);
    });

    it('should return false for null input', () => {
      const result = UserValidator.validateEmail(null);
      expect(result).toBe(false);
    });
  });
});
```

#### Test Case Template
```
Test Case ID: [MODULE]-UNIT-[FUNCTION]-[NUMBER]
Title: [Function Name] - [Scenario]
Type: Unit Test

Preconditions:
- Unit under test is isolated
- Dependencies are mocked
- Test data is defined

Test Steps:
1. Set up test context with specific inputs
2. Call function under test
3. Capture return value/output

Expected Results:
- Return value matches expected output
- Side effects occur as expected
- No exceptions thrown (or specific exception for error cases)
```

### Integration Testing

#### Definition
Testing the interfaces and interactions between integrated components or systems.

#### Types of Integration Testing
```
1. Component Integration Testing
   - Testing interactions between software components
   - After unit testing, before system testing

2. System Integration Testing
   - Testing interactions between different systems
   - Includes external APIs, databases, message queues
```

#### Best Practices
```typescript
// Example: Integration test for user service with database

describe('UserService Integration', () => {
  let db: DatabaseConnection;
  let userService: UserService;

  beforeAll(async () => {
    db = await setupTestDatabase();
    userService = new UserService(db);
  });

  afterAll(async () => {
    await db.close();
  });

  beforeEach(async () => {
    await db.clearTables();
  });

  it('should create user and persist to database', async () => {
    const userData = {
      email: 'test@example.com',
      password: 'SecurePass123!'
    };

    const user = await userService.createUser(userData);

    expect(user.id).toBeDefined();
    expect(user.email).toBe(userData.email);

    // Verify database state
    const dbUser = await db.query('SELECT * FROM users WHERE id = ?', [user.id]);
    expect(dbUser).toHaveLength(1);
    expect(dbUser[0].email).toBe(userData.email);
  });

  it('should rollback transaction on error', async () => {
    const invalidUser = { email: 'invalid' }; // Missing password

    await expect(userService.createUser(invalidUser)).rejects.toThrow();

    // Verify no partial data persisted
    const count = await db.query('SELECT COUNT(*) as count FROM users');
    expect(count[0].count).toBe(0);
  });
});
```

#### Test Case Template
```
Test Case ID: [MODULE]-INT-[COMPONENTS]-[NUMBER]
Title: [Component A] + [Component B] - [Interaction Type]
Type: Integration Test

Preconditions:
- All components are deployed and running
- Test database is initialized
- External services are available (or mocked)
- Network connectivity established

Test Steps:
1. Initialize components with test configuration
2. Execute operation spanning multiple components
3. Verify interactions between components
4. Check data consistency across components

Expected Results:
- Components communicate correctly
- Data flows as expected
- Error handling works across boundaries
- State remains consistent
```

### System Testing

#### Definition
Testing the complete and fully integrated software product to evaluate the system's compliance with specified requirements.

#### Types of System Testing
```
1. Functional System Testing
   - Tests against functional requirements
   - Black-box testing approach

2. Non-Functional System Testing
   - Performance Testing
   - Security Testing
   - Usability Testing
   - Compatibility Testing
   - Reliability Testing
```

#### Test Case Template
```
Test Case ID: [PROJECT]-SYS-[FEATURE]-[NUMBER]
Title: [Feature Name] - [Scenario]
Type: System Test

Preconditions:
- Complete system is deployed
- All dependencies are available
- Test environment mirrors production
- Test data is loaded

Test Steps:
1. Execute end-to-end business process
2. Verify all subsystems participate correctly
3. Check output at each stage
4. Validate final system state

Expected Results:
- System behaves according to requirements
- All components work together
- Output matches specification
- Performance meets SLAs
```

### End-to-End (E2E) Testing

#### Definition
Testing the entire application flow from start to finish, simulating real user scenarios.

#### Characteristics
```
Scope: Complete user journey across all systems
Environment: Production-like or staging environment
Data: Realistic test data
Speed: Slower execution (seconds to minutes)
Frequency: Pre-release, regression suites
Author: QA Engineers, Automation Engineers
Tools: Cypress, Playwright, Selenium, WebDriverIO, TestCafe
```

#### Best Practices
```typescript
// Example: E2E test with Cypress

describe('User Checkout Flow', () => {
  beforeEach(() => {
    cy.login('testuser@example.com', 'password123');
    cy.clearCart();
  });

  it('should complete purchase from product page to confirmation', () => {
    // Step 1: Browse products
    cy.visit('/products');
    cy.contains('Wireless Headphones').click();
    
    // Step 2: Add to cart
    cy.get('[data-testid="add-to-cart"]').click();
    cy.get('[data-testid="cart-count"]').should('contain', '1');
    
    // Step 3: Proceed to checkout
    cy.get('[data-testid="checkout-button"]').click();
    cy.url().should('include', '/checkout');
    
    // Step 4: Enter shipping information
    cy.get('[data-testid="shipping-form"]').within(() => {
      cy.get('input[name="firstName"]').type('John');
      cy.get('input[name="lastName"]').type('Doe');
      cy.get('input[name="address"]').type('123 Test Street');
      cy.get('input[name="city"]').type('Test City');
      cy.get('select[name="state"]').select('CA');
      cy.get('input[name="zip"]').type('12345');
    });
    
    // Step 5: Enter payment information
    cy.get('[data-testid="payment-form"]').within(() => {
      cy.get('input[name="cardNumber"]').type('4111111111111111');
      cy.get('input[name="expiry"]').type('12/25');
      cy.get('input[name="cvv"]').type('123');
    });
    
    // Step 6: Complete order
    cy.get('[data-testid="place-order"]').click();
    
    // Step 7: Verify confirmation
    cy.url().should('include', '/confirmation');
    cy.get('[data-testid="order-number"]').should('be.visible');
    cy.get('[data-testid="confirmation-email"]').should('contain', 'testuser@example.com');
    
    // Step 8: Verify email sent
    cy.task('getLastEmail', 'testuser@example.com').then((email) => {
      expect(email.subject).to.include('Order Confirmation');
      expect(email.html).to.include(cy.get('[data-testid="order-number"]').invoke('text'));
    });
  });
});
```

#### Test Case Template
```
Test Case ID: [PROJECT]-E2E-[FLOW]-[NUMBER]
Title: [User Journey] - [Scenario]
Type: E2E Test

Preconditions:
- Application is fully deployed
- User accounts exist with appropriate permissions
- Test products/data available
- Payment processing in test mode
- Email service configured for testing

Test Steps:
1. Navigate to starting point (usually homepage)
2. Execute user actions in sequence
3. Verify page navigation and state changes
4. Complete the full workflow
5. Verify final outcome

Expected Results:
- User completes intended goal
- All intermediate steps succeed
- Appropriate notifications sent
- Database reflects changes
- No errors in application logs
```

### Functional Testing

#### Definition
Testing software against functional requirements to verify that the system performs its intended functions correctly.

#### Categories
```
1. Positive Testing (Happy Path)
   - Valid inputs produce expected outputs
   - Standard workflow execution

2. Negative Testing (Error Path)
   - Invalid inputs handled gracefully
   - Error messages are appropriate
   - System remains stable

3. Boundary Value Analysis
   - Test at boundary conditions
   - Min, max, and just beyond boundaries

4. Equivalence Partitioning
   - Group inputs into equivalence classes
   - Test representative from each class
```

### Non-Functional Testing

#### Performance Testing
```
Types:
- Load Testing: Performance under expected load
- Stress Testing: Performance under extreme load
- Endurance Testing: Performance over extended period
- Spike Testing: Performance under sudden load changes
- Volume Testing: Performance with large data volumes

Metrics to Capture:
- Response Time (average, 95th percentile, max)
- Throughput (requests per second)
- Error Rate (percentage of failed requests)
- Resource Utilization (CPU, memory, disk, network)
- Concurrent User Capacity
```

#### Security Testing
```
Categories:
- Authentication Testing: Verify login mechanisms
- Authorization Testing: Verify permission controls
- Input Validation: Test for injection attacks (SQL, XSS, CSRF)
- Session Management: Test session handling
- Encryption: Verify data protection in transit and at rest
- Vulnerability Scanning: Automated security scans
- Penetration Testing: Simulated attacks

Common Test Cases:
- SQL Injection attempts
- Cross-Site Scripting (XSS) attacks
- Cross-Site Request Forgery (CSRF)
- Broken Authentication
- Sensitive Data Exposure
- XML External Entities (XXE)
- Broken Access Control
- Security Misconfiguration
```

#### Usability Testing
```
Areas to Test:
- Navigation: Can users find what they need?
- Learnability: How quickly can new users adapt?
- Efficiency: Can experienced users work quickly?
- Memorability: Can returning users remember how?
- Error Prevention: Are errors prevented or well-handled?
- Satisfaction: Is the experience pleasant?

Methods:
- Hallway Testing: Casual user feedback
- A/B Testing: Compare alternative designs
- Eye Tracking: Analyze visual attention
- Heat Maps: See where users click/tap
- User Surveys: Collect subjective feedback
- Task Completion: Measure success rates
```

#### Accessibility Testing
```
Standards:
- WCAG 2.1 Level AA (minimum compliance)
- WCAG 2.1 Level AAA (enhanced compliance)
- Section 508 (US government requirement)
- EN 301 549 (European standard)

Key Areas:
- Keyboard Navigation: All functionality accessible via keyboard
- Screen Reader Support: Proper ARIA labels and semantics
- Color Contrast: Minimum 4.5:1 for normal text
- Focus Indicators: Visible focus states
- Alt Text: Descriptive text for images
- Form Labels: Proper association with inputs
- Error Identification: Clear error messages
- Zoom Support: Works at 200% zoom

Tools:
- axe DevTools
- WAVE (Web Accessibility Evaluation Tool)
- Lighthouse Accessibility Audit
- NVDA/JAWS/VoiceOver screen readers
```

### Regression Testing

#### Definition
Re-testing software after modifications to ensure that changes haven't introduced new defects or affected existing functionality.

#### Types
```
1. Full Regression: Execute all test cases
   - Pros: Comprehensive coverage
   - Cons: Time-consuming, resource-intensive

2. Partial Regression: Execute subset of test cases
   - Based on impact analysis
   - Focus on affected areas

3. Unit Regression: Re-test specific component
   - Quick validation after minor changes

4. Automated Regression: Automated test execution
   - Continuous integration pipeline
   - Nightly/scheduled runs
```

#### Regression Suite Selection Criteria
```
Priority 1 (Always Run):
- Critical business functionality
- High-risk areas
- Recently changed components
- Core user workflows

Priority 2 (Run Frequently):
- Important but not critical features
- Stable, well-tested areas

Priority 3 (Run Occasionally):
- Edge cases
- Rarely used features
- Low-risk areas
```

### Smoke Testing

#### Definition
Quick set of tests to verify that the most important functions of the software work correctly before proceeding with more detailed testing.

#### Characteristics
```
Scope: Critical path functionality only
Speed: Fast execution (minutes)
Timing: Post-deployment, pre-detailed testing
Purpose: Go/No-Go decision for release
```

#### Typical Smoke Test Cases
```
1. Application launches successfully
2. User can log in
3. Main navigation works
4. Critical data displays correctly
5. Key transactions complete
6. No critical errors in logs
```

### Sanity Testing

#### Definition
Quick evaluation to verify that a specific functionality or bug fix works as expected, typically performed after minor changes.

#### Difference from Smoke Testing
```
Smoke Testing:
- Broader scope
- Validates entire build
- Determines if testing can proceed

Sanity Testing:
- Narrow scope
- Validates specific change
- Determines if change is reasonable
```

---

## Test Case Design Techniques

### Equivalence Partitioning

#### Definition
Dividing input data into partitions (equivalence classes) where all values in a partition are expected to behave the same way.

#### Principle
```
If one value in a partition passes, all values in that partition should pass.
If one value in a partition fails, all values in that partition should fail.
```

#### Example: Age Validation
```
Requirement: System accepts ages 18-65 for registration

Partitions:
┌─────────────────┬──────────────────┬──────────────────┐
│   Invalid Low   │      Valid       │   Invalid High   │
│    (< 18)       │    (18-65)       │     (> 65)       │
├─────────────────┼──────────────────┼──────────────────┤
│     -1          │      18          │       66         │
│      0          │      25          │       99         │
│     17          │      65          │      100         │
└─────────────────┴──────────────────┴──────────────────┘

Test Cases:
1. Test with age 17 (Invalid - just below boundary)
2. Test with age 18 (Valid - lower boundary)
3. Test with age 25 (Valid - representative middle value)
4. Test with age 65 (Valid - upper boundary)
5. Test with age 66 (Invalid - just above boundary)
6. Test with age -1 (Invalid - negative)
7. Test with age "twenty" (Invalid - non-numeric)
```

#### Implementation
```
Test Case: ECOM-REG-AGE-001
Title: Verify Age Validation with Equivalence Partitions

Test Data Sets:
| Test Case | Input Value | Partition | Expected Result |
|-----------|-------------|-----------|-----------------|
| TC-001    | 17          | Invalid Low | Error: "Must be 18 or older" |
| TC-002    | 18          | Valid (boundary) | Success |
| TC-003    | 25          | Valid (mid) | Success |
| TC-004    | 65          | Valid (boundary) | Success |
| TC-005    | 66          | Invalid High | Error: "Must be 65 or younger" |
| TC-006    | -5          | Invalid Low | Error: "Invalid age" |
| TC-007    | "abc"       | Invalid Type | Error: "Numbers only" |
| TC-008    | (empty)     | Invalid Empty | Error: "Age required" |
```

### Boundary Value Analysis (BVA)

#### Definition
Testing at the boundaries between equivalence partitions, where errors are more likely to occur.

#### Principle
```
Focus on:
- Minimum boundary
- Just below minimum
- Just above minimum
- Maximum boundary
- Just below maximum
- Just above maximum
```

#### Example: Username Length (5-20 characters)
```
Boundaries:
                    5 chars            20 chars
                      |                   |
    4 chars    ←──────┼───────────────────┼──────→    21 chars
   (invalid)          │      VALID        │         (invalid)
                      │                   │
              TC-003  │  TC-004  TC-005   │  TC-006
    TC-001   TC-002   │                   │  TC-007   TC-008

Test Cases:
| Test Case | Input Length | Value           | Expected Result |
|-----------|--------------|-----------------|-----------------|
| TC-001    | 0            | ""              | Invalid         |
| TC-002    | 4            | "user"          | Invalid         |
| TC-003    | 5            | "usern"         | Valid           |
| TC-004    | 6            | "usernm"        | Valid           |
| TC-005    | 19           | "u" + 18 chars  | Valid           |
| TC-006    | 20           | "u" + 19 chars  | Valid           |
| TC-007    | 21           | "u" + 20 chars  | Invalid         |
| TC-008    | 100          | "u" + 99 chars  | Invalid         |
```

#### Two-Value vs Three-Value BVA
```
Two-Value BVA (Test min and max only):
- Test at boundaries: min, max
- Example: For range 1-100, test 1 and 100

Three-Value BVA (More thorough):
- Test: min-1, min, min+1, max-1, max, max+1
- Example: For range 1-100, test 0, 1, 2, 99, 100, 101

Recommendation: Use Three-Value BVA for critical systems
```

### Decision Table Testing

#### Definition
Systematic approach to testing combinations of inputs and business rules using a tabular representation.

#### Structure
```
┌─────────────────┬──────────┬──────────┬──────────┬──────────┐
│ Conditions      │  Rule 1  │  Rule 2  │  Rule 3  │  Rule 4  │
├─────────────────┼──────────┼──────────┼──────────┼──────────┤
│ Condition 1     │    T     │    T     │    F     │    F     │
│ Condition 2     │    T     │    F     │    T     │    F     │
├─────────────────┼──────────┼──────────┼──────────┼──────────┤
│ Action 1        │    X     │          │          │          │
│ Action 2        │          │    X     │    X     │          │
│ Action 3        │          │          │          │    X     │
└─────────────────┴──────────┴──────────┴──────────┴──────────┘

T = True, F = False, X = Action Executed
```

#### Example: Loan Approval System
```
Conditions:
1. Credit Score >= 650
2. Income >= $50,000/year
3. Debt-to-Income Ratio <= 40%
4. Employment Status = "Full-time"

Decision Table:
┌─────────────────────────┬───────┬───────┬───────┬───────┬───────┬────────┐
│ Conditions              │ R1    │ R2    │ R3    │ R4    │ R5    │ R6     │
├─────────────────────────┼───────┼───────┼───────┼───────┼───────┼────────┤
│ Credit Score >= 650     │   T   │   T   │   T   │   T   │   F   │   -    │
│ Income >= 50k           │   T   │   T   │   F   │   F   │   -   │   -    │
│ DTI <= 40%              │   T   │   F   │   T   │   F   │   -   │   -    │
│ Full-time Employed      │   T   │   T   │   T   │   T   │   -   │   -    │
├─────────────────────────┼───────┼───────┼───────┼───────┼───────┼────────┤
│ Approve Loan            │   X   │       │       │       │       │        │
│ Approve w/ Higher Rate  │       │   X   │       │       │       │        │
│ Request More Info       │       │       │   X   │       │       │        │
│ Deny - Low Income       │       │       │       │   X   │       │        │
│ Deny - Poor Credit      │       │       │       │       │   X   │        │
│ Deny - Unemployed       │       │       │       │       │       │   X    │
└─────────────────────────┴───────┴───────┴───────┴───────┴───────┴────────┘

Test Cases Derived:
| TC ID | Credit | Income | DTI | Employment | Expected Result |
|-------|--------|--------|-----|------------|-----------------|
| 001   | 700    | 60k    | 30% | Full-time  | Approve         |
| 002   | 700    | 60k    | 50% | Full-time  | Higher Rate     |
| 003   | 700    | 40k    | 30% | Full-time  | Request Info    |
| 004   | 700    | 40k    | 50% | Full-time  | Deny-Low Income |
| 005   | 600    | 60k    | 30% | Full-time  | Deny-Poor Credit|
| 006   | 700    | 60k    | 30% | Part-time  | Deny-Unemployed |
```

### State Transition Testing

#### Definition
Testing based on state transitions, where the system behaves differently based on its current state and the input/event it receives.

#### Components
```
States: Distinct conditions of the system
Events: Triggers that cause state changes
Transitions: Movement from one state to another
Actions: Activities performed during transitions
```

#### State Transition Diagram
```
                    +-----------+
         [submit]   |  Draft    |
        ┌──────────►│           │◄────────┐
        │           +-----------+         │
        │                 │               │
        │                 │ [save]        │
        │                 ▼               │
        │           +-----------+         │
        │           |  Saved    │         │
        │           |           │         │
        │           +-----------+         │
        │                 │               │
        │                 │ [submit]      │
        │                 ▼               │
        │           +-----------+         │
        │    ┌──────│ Submitted │──────┐  │
        │    │      │           │      │  │
        │    │      +-----------+      │  │
        │    │             │           │  │
        │    │ [approve]   │ [reject]  │  │
        │    ▼             ▼           │  │
        │ +-----------+  +-----------+ │  │
        │ │  Approved │  │  Rejected   │ │  │
        └─┤           │  │           ├─┘  │
          +-----------+  +-----------+    │
               │               │          │
               │ [publish]     │ [revise] │
               ▼               ▼          │
          +-----------+  +-----------+    │
          │ Published │  |   Draft   |────┘
          │           │  | (revised) |
          +-----------+  +-----------+
```

#### State Transition Table
```
| Current State | Event     | Action              | Next State  |
|---------------|-----------|---------------------|-------------|
| Draft         | save      | Save document       | Saved       |
| Draft         | submit    | Validate & submit   | Submitted   |
| Saved         | submit    | Submit document     | Submitted   |
| Submitted     | approve   | Approve document    | Approved    |
| Submitted     | reject    | Return with comments| Rejected    |
| Rejected      | revise    | Allow editing       | Draft       |
| Approved      | publish   | Make public         | Published   |
```

#### Test Cases for 0-Switch Coverage
```
Test each valid transition once:

TC-001: Draft → Saved (save event)
TC-002: Draft → Submitted (submit event)
TC-003: Saved → Submitted (submit event)
TC-004: Submitted → Approved (approve event)
TC-005: Submitted → Rejected (reject event)
TC-006: Rejected → Draft (revise event)
TC-007: Approved → Published (publish event)
```

#### Test Cases for 1-Switch Coverage
```
Test pairs of transitions:

TC-008: Draft → Saved → Submitted
TC-009: Draft → Submitted → Approved
TC-010: Draft → Submitted → Rejected → Draft
TC-011: Saved → Submitted → Approved → Published
```

### Use Case Testing

#### Definition
Testing based on use cases that describe interactions between actors and the system to achieve specific goals.

#### Structure
```
Use Case: [Name]
Actor: [Primary Actor]
Goal: [What the actor wants to achieve]

Main Success Scenario:
1. [Step 1]
2. [Step 2]
3. [Step 3]
...
n. [Goal achieved]

Extensions (Alternative Flows):
1a. [Alternative at step 1]
3a. [Alternative at step 3]
3b. [Exception at step 3]
```

#### Example: Withdraw Cash from ATM
```
Use Case: Withdraw Cash
Actor: Bank Customer
Goal: Successfully withdraw cash from account

Main Success Scenario:
1. Customer inserts card into ATM
2. ATM validates card
3. ATM prompts for PIN
4. Customer enters PIN
5. ATM validates PIN
6. ATM displays account options
7. Customer selects "Withdraw Cash"
8. ATM prompts for amount
9. Customer enters amount
10. ATM validates sufficient funds
11. ATM dispenses cash
12. ATM prints receipt
13. ATM returns card
14. Customer takes cash, receipt, and card

Extensions:
2a. Card is invalid:
    2a.1. ATM displays "Invalid card" message
    2a.2. ATM ejects card
    2a.3. Use case ends

5a. PIN is incorrect:
    5a.1. ATM displays "Invalid PIN" message
    5a.2. ATM allows 2 more attempts
    5a.3. If 3 failed attempts, ATM retains card

10a. Insufficient funds:
    10a.1. ATM displays "Insufficient funds" message
    10a.2. ATM offers option to enter different amount
    10a.3. Customer can retry or cancel
```

#### Test Cases from Use Case
```
Test Case ID: ATM-CASH-WITHDRAW-001
Title: Successful Cash Withdrawal - Main Flow

Steps:
1. Insert valid card
2. Enter valid PIN
3. Select "Withdraw Cash"
4. Enter amount <= available balance
5. Collect cash, receipt, and card

Expected Result: Transaction completed successfully, balance updated

---

Test Case ID: ATM-CASH-WITHDRAW-002
Title: Withdrawal with Invalid Card

Steps:
1. Insert invalid/expired card

Expected Result: "Invalid card" message displayed, card ejected

---

Test Case ID: ATM-CASH-WITHDRAW-003
Title: Withdrawal with Invalid PIN (3 attempts)

Steps:
1. Insert valid card
2. Enter incorrect PIN 3 times

Expected Result: Card retained by ATM, security alert generated

---

Test Case ID: ATM-CASH-WITHDRAW-004
Title: Withdrawal with Insufficient Funds

Steps:
1. Insert valid card
2. Enter valid PIN
3. Select "Withdraw Cash"
4. Enter amount > available balance

Expected Result: "Insufficient funds" message, option to retry or cancel
```

### Error Guessing

#### Definition
Based on experience and intuition, identify error-prone areas and create test cases to expose those errors.

#### Common Error-Prone Areas
```
1. Boundary Conditions
   - Empty inputs
   - Maximum/minimum values
   - Array bounds

2. Null/Undefined Handling
   - Missing required fields
   - Null pointer exceptions
   - Uninitialized variables

3. Arithmetic Operations
   - Division by zero
   - Integer overflow
   - Floating point precision

4. Concurrency Issues
   - Race conditions
   - Deadlocks
   - Resource contention

5. Data Type Issues
   - Type conversions
   - Encoding problems
   - Date/time handling

6. Resource Management
   - Memory leaks
   - File handle leaks
   - Connection pool exhaustion

7. Configuration Issues
   - Missing configuration values
   - Invalid configuration formats
   - Environment-specific bugs
```

#### Example Test Cases
```
Test Case: DIVIDE-001
Title: Division by Zero Handling
Input: divide(10, 0)
Expected: Throws ArithmeticException with message "Division by zero"

Test Case: ARRAY-001
Title: Array Access at Boundary
Input: array[array.length]
Expected: Throws IndexOutOfBoundsException

Test Case: DATE-001
Title: Leap Year Date Handling
Input: February 29, 2024 (leap year)
Expected: Date accepted and processed correctly

Test Case: DATE-002
Title: Invalid Leap Year Date
Input: February 29, 2023 (non-leap year)
Expected: Error "Invalid date: 2023 is not a leap year"

Test Case: CONCURRENT-001
Title: Simultaneous Balance Updates
Setup: Two threads attempt to update account balance simultaneously
Expected: Consistent final balance (no lost updates)
```

### Risk-Based Testing

#### Definition
Prioritizing test cases based on the risk of failure and the impact of that failure.

#### Risk Assessment Matrix
```
Risk Level = Probability × Impact

Probability:
- High: Feature is complex, new, or historically buggy
- Medium: Feature is moderately complex or modified
- Low: Feature is simple, stable, or rarely changes

Impact:
- High: Affects core business functionality, data integrity, security
- Medium: Affects important features but workarounds exist
- Low: Minor inconvenience, cosmetic issues

Risk Matrix:
                Impact
           Low    Medium    High
       ┌─────────┬─────────┬─────────┐
  High │ Medium  │  High   │Critical │
Prob   ├─────────┼─────────┼─────────┤
Medium │  Low    │ Medium  │  High   │
       ├─────────┼─────────┼─────────┤
  Low  │  Low    │  Low    │ Medium  │
       └─────────┴─────────┴─────────┘
```

#### Risk-Based Test Prioritization
```
Priority 1 (Critical Risk):
- High probability + High impact
- Test first, test thoroughly
- Automate if possible
- Include in smoke tests

Priority 2 (High Risk):
- High probability + Medium impact
- OR Medium probability + High impact
- Test early in cycle
- Comprehensive coverage

Priority 3 (Medium Risk):
- Medium probability + Medium impact
- OR Low probability + High impact
- Test during regression
- Spot-check edge cases

Priority 4 (Low Risk):
- Low probability + Low/Medium impact
- Test if time permits
- De-scope if necessary
```

---

## Test Data Management

### Test Data Principles

#### 1. Realism
```
❌ BAD: Using "test1", "test2" as usernames

✅ GOOD: Using realistic data patterns:
- Names: "John Smith", "Maria Garcia", "Wei Zhang"
- Emails: "john.smith@example.com"
- Addresses: "123 Main Street, Springfield, IL 62701"
- Phone numbers: Valid format for region
```

#### 2. Variety
```
Include diverse test data:
- Different locales and languages
- Various data formats and lengths
- Edge cases and boundary values
- Invalid/malformed data for negative testing
```

#### 3. Privacy and Compliance
```
Requirements:
- Never use real PII (Personally Identifiable Information)
- Use data masking for production data copies
- Comply with GDPR, CCPA, HIPAA as applicable
- Synthetic data generation preferred

Techniques:
- Data masking: Replace sensitive fields with fake values
- Data subsetting: Extract small, representative samples
- Synthetic data: Generate artificial but realistic data
- Tokenization: Replace sensitive data with non-sensitive tokens
```

#### 4. Maintainability
```
Best Practices:
- Centralize test data in repositories
- Version control test data sets
- Document data dependencies
- Automate data setup and cleanup
- Refresh data regularly to avoid staleness
```

### Test Data Types

#### Static Test Data
```
Characteristics:
- Fixed values defined in test cases
- Same data used every execution
- Simple to implement and maintain
- Limited coverage

Example:
const TEST_USER = {
  username: 'testuser001',
  email: 'test001@example.com',
  password: 'TestPass123!'
};
```

#### Dynamic Test Data
```
Characteristics:
- Generated at runtime
- Unique values per execution
- Reduces test data conflicts
- Supports parallel execution

Example:
const generateTestUser = () => ({
  username: `user_${Date.now()}_${randomString(5)}`,
  email: `test_${uuid()}@example.com`,
  password: generateStrongPassword()
});
```

#### Production-Like Data
```
Characteristics:
- Derived from production data
- Masked/anonymized for privacy
- Realistic distributions and patterns
- Complex to create and maintain

Creation Process:
1. Extract subset from production
2. Identify PII and sensitive fields
3. Apply masking/transformation rules
4. Validate referential integrity
5. Load into test environment
```

### Test Data Generation Strategies

#### Synthetic Data Generation
```python
# Example: Generating synthetic user data
from faker import Faker
import random

fake = Faker()

def generate_user():
    return {
        'first_name': fake.first_name(),
        'last_name': fake.last_name(),
        'email': fake.unique.email(),
        'phone': fake.phone_number(),
        'address': {
            'street': fake.street_address(),
            'city': fake.city(),
            'state': fake.state_abbr(),
            'zip': fake.zipcode()
        },
        'date_of_birth': fake.date_of_birth(minimum_age=18, maximum_age=90),
        'account_created': fake.date_time_this_decade()
    }

# Generate 100 test users
test_users = [generate_user() for _ in range(100)]
```

#### Boundary Test Data
```
For a field with constraints (e.g., password 8-20 characters):

Valid Boundary Values:
- Minimum: 8 characters
- Minimum+1: 9 characters
- Maximum-1: 19 characters
- Maximum: 20 characters

Invalid Boundary Values:
- Below minimum: 7 characters
- Above maximum: 21 characters
- Empty: 0 characters
- Null: No value
```

#### Combinatorial Test Data
```
Using Pairwise Testing (All-Pairs) to reduce combinations:

Parameters:
- Browser: Chrome, Firefox, Safari
- OS: Windows, macOS, Linux
- Resolution: 1920x1080, 1366x768, 3840x2160

Full Combinations: 3 × 3 × 3 = 27 tests
Pairwise Combinations: 9 tests (covers all pairs)

Tool: PICT (Pairwise Independent Combinatorial Testing)
```

### Test Data Management Tools

#### Database Tools
```
Data Generation:
- Faker (Python/JavaScript): Generate realistic fake data
- Mockaroo: Web-based data generation
- Tonic.ai: Privacy-preserving synthetic data

Data Masking:
- Delphix: Enterprise data masking
- IBM InfoSphere: Data privacy solution
- Oracle Data Masking: For Oracle databases

Data Subsetting:
- Benerator: Generate and subset test data
- Jailer: Database subsetting tool
```

#### Test Data Repositories
```
Organization Structure:
/test-data
  /unit
    users.json
    products.json
  /integration
    api-requests/
    database-seeds/
  /e2e
    scenarios/
      checkout-flow/
      registration-flow/
  /performance
    load-test-data.sql
  /fixtures
    shared-test-data.json
```

---

## Test Case Templates and Examples

### Template 1: Manual Test Case

```markdown
# Test Case Specification

> **Note on Field Sources:**
> - **Manually Entered**: Fields marked with ✏️ are authored by testers
> - **Auto-Populated**: Fields marked with 🤖 are automatically filled by test management tools (e.g., TestRail, Zephyr, qTest)
> - **Hybrid**: Fields marked with ⚡ may be pre-filled by tools but require manual review/confirmation

## Test Case ID ✏️
[PROJECT]-[MODULE]-[TYPE]-[NUMBER]
Example: ECOM-AUTH-LOG-001

## Test Case Title ✏️
[Action] [Feature/Function] [Condition]
Example: Verify User Login with Valid Credentials

## Description ✏️
Brief description of what this test case verifies and why it's important.

## Priority ⚡
- [ ] P0 - Critical
- [ ] P1 - High
- [ ] P2 - Medium
- [ ] P3 - Low

## Test Type ✏️
- [ ] Functional
- [ ] Regression
- [ ] Smoke
- [ ] Integration
- [ ] E2E
- [ ] Performance
- [ ] Security
- [ ] Accessibility
- [ ] Usability

## Requirements Coverage ✏️
| Requirement ID | Requirement Name | Coverage |
|----------------|------------------|----------|
| REQ-001 | User Authentication | Full |

## Preconditions ✏️
- [ ] System is accessible
- [ ] Test user account exists
- [ ] Database is in known state
- [ ] Required test data is available

## Test Data ✏️
| Field | Value | Description |
|-------|-------|-------------|
| username | testuser001 | Valid active user |
| password | TestPass123! | Valid password |

## Test Steps ✏️
| Step # | Action | Expected Result | Actual Result 🤖 | Status 🤖 |
|--------|--------|-----------------|---------------|--------|
| 1 | Navigate to /login | Login page loads | | |
| 2 | Enter username "testuser001" | Username displayed | | |
| 3 | Enter password "TestPass123!" | Password masked | | |
| 4 | Click "Sign In" button | Processing indicator shown | | |
| 5 | Wait for redirect | Redirected to /dashboard | | |

## Expected Results (Overall) ✏️
- User successfully logs in
- Dashboard page loads within 3 seconds
- Session cookie is set
- User's name appears in navigation

## Post-conditions ✏️
- User is authenticated
- Session is active
- User can access protected resources

## Cleanup ✏️
- Log out user
- Clear cookies and cache
- Reset any modified data

## Environment ⚡
- Browser: Chrome 120+
- OS: Windows 11
- Resolution: 1920x1080
- Environment: Staging

## Attachments 🤖
- [ ] Screenshot (on failure)
- [ ] Video recording
- [ ] Log files
- [ ] Other: _____

## Execution History 🤖
| Date | Executed By | Build | Status | Notes |
|------|-------------|-------|--------|-------|
| 2024-01-15 | John Doe | v2.3.1 | PASSED | - |

## Defects Found 🤖
| Defect ID | Description | Status |
|-----------|-------------|--------|
| BUG-123 | Login button unresponsive | Fixed |
```

### Template 2: Automated Unit Test

```typescript
// Example: Jest unit test for user authentication

describe('AuthenticationService', () => {
  let authService: AuthenticationService;
  let userRepository: jest.Mocked<UserRepository>;
  let passwordHasher: jest.Mocked<PasswordHasher>;
  let tokenGenerator: jest.Mocked<TokenGenerator>;

  beforeEach(() => {
    // Setup mocks
    userRepository = {
      findByUsername: jest.fn(),
      updateLastLogin: jest.fn()
    } as any;

    passwordHasher = {
      compare: jest.fn()
    } as any;

    tokenGenerator = {
      generate: jest.fn()
    } as any;

    authService = new AuthenticationService(
      userRepository,
      passwordHasher,
      tokenGenerator
    );
  });

  describe('login', () => {
    describe('with valid credentials', () => {
      it('should return authentication token', async () => {
        // Arrange
        const username = 'validuser';
        const password = 'ValidPass123!';
        const hashedPassword = 'hashed_password';
        const user = {
          id: 'user-123',
          username,
          password: hashedPassword,
          isActive: true
        };
        const token = 'jwt_token_123';

        userRepository.findByUsername.mockResolvedValue(user);
        passwordHasher.compare.mockResolvedValue(true);
        tokenGenerator.generate.mockReturnValue(token);

        // Act
        const result = await authService.login(username, password);

        // Assert
        expect(result).toEqual({
          success: true,
          token,
          user: {
            id: user.id,
            username: user.username
          }
        });
        expect(userRepository.updateLastLogin).toHaveBeenCalledWith(user.id);
      });
    });

    describe('with invalid username', () => {
      it('should return authentication error', async () => {
        // Arrange
        const username = 'nonexistent';
        const password = 'SomePass123!';

        userRepository.findByUsername.mockResolvedValue(null);

        // Act
        const result = await authService.login(username, password);

        // Assert
        expect(result).toEqual({
          success: false,
          error: 'Invalid credentials'
        });
      });
    });

    describe('with invalid password', () => {
      it('should return authentication error', async () => {
        // Arrange
        const username = 'validuser';
        const password = 'WrongPass123!';
        const user = {
          id: 'user-123',
          username,
          password: 'hashed_password',
          isActive: true
        };

        userRepository.findByUsername.mockResolvedValue(user);
        passwordHasher.compare.mockResolvedValue(false);

        // Act
        const result = await authService.login(username, password);

        // Assert
        expect(result).toEqual({
          success: false,
          error: 'Invalid credentials'
        });
      });
    });

    describe('with inactive account', () => {
      it('should return account disabled error', async () => {
        // Arrange
        const username = 'disableduser';
        const password = 'ValidPass123!';
        const user = {
          id: 'user-456',
          username,
          password: 'hashed_password',
          isActive: false
        };

        userRepository.findByUsername.mockResolvedValue(user);

        // Act
        const result = await authService.login(username, password);

        // Assert
        expect(result).toEqual({
          success: false,
          error: 'Account is disabled'
        });
      });
    });

    describe('with locked account', () => {
      it('should return account locked error', async () => {
        // Arrange
        const username = 'lockeduser';
        const password = 'ValidPass123!';
        const user = {
          id: 'user-789',
          username,
          password: 'hashed_password',
          isActive: true,
          failedLoginAttempts: 5,
          lockedUntil: new Date(Date.now() + 3600000) // 1 hour from now
        };

        userRepository.findByUsername.mockResolvedValue(user);

        // Act
        const result = await authService.login(username, password);

        // Assert
        expect(result).toEqual({
          success: false,
          error: 'Account is locked. Try again later.'
        });
      });
    });
  });
});
```

### Template 3: E2E Test (Cypress)

```typescript
// Example: E2E test for checkout flow

describe('Checkout Flow', () => {
  const TEST_USER = {
    email: 'test.checkout@example.com',
    password: 'SecurePass123!'
  };

  beforeEach(() => {
    // Reset state
    cy.clearCookies();
    cy.clearLocalStorage();
    
    // Login
    cy.login(TEST_USER.email, TEST_USER.password);
    
    // Clear cart
    cy.clearCart();
  });

  describe('Successful Checkout', () => {
    it('should complete purchase from cart to confirmation', () => {
      // Step 1: Add product to cart
      cy.visit('/products/laptop-stand');
      cy.get('[data-testid="product-title"]').should('contain', 'Laptop Stand');
      cy.get('[data-testid="add-to-cart"]').click();
      cy.get('[data-testid="cart-count"]').should('contain', '1');
      
      // Step 2: View cart
      cy.get('[data-testid="cart-icon"]').click();
      cy.url().should('include', '/cart');
      cy.get('[data-testid="cart-item"]').should('have.length', 1);
      cy.get('[data-testid="cart-total"]').should('contain', '$49.99');
      
      // Step 3: Proceed to checkout
      cy.get('[data-testid="checkout-button"]').click();
      cy.url().should('include', '/checkout');
      
      // Step 4: Fill shipping information
      cy.get('[data-testid="shipping-form"]').within(() => {
        cy.get('input[name="firstName"]').type('John');
        cy.get('input[name="lastName"]').type('Doe');
        cy.get('input[name="address"]').type('123 Test Street');
        cy.get('input[name="city"]').type('San Francisco');
        cy.get('select[name="state"]').select('CA');
        cy.get('input[name="zip"]').type('94102');
        cy.get('input[name="phone"]').type('5551234567');
      });
      
      // Step 5: Select shipping method
      cy.get('[data-testid="shipping-option-standard"]').click();
      cy.get('[data-testid="shipping-cost"]').should('contain', '$5.99');
      
      // Step 6: Fill payment information
      cy.get('[data-testid="payment-form"]').within(() => {
        cy.get('input[name="cardNumber"]').type('4111111111111111');
        cy.get('input[name="cardName"]').type('John Doe');
        cy.get('input[name="expiry"]').type('12/25');
        cy.get('input[name="cvv"]').type('123');
      });
      
      // Step 7: Review order
      cy.get('[data-testid="order-summary"]').within(() => {
        cy.get('[data-testid="subtotal"]').should('contain', '$49.99');
        cy.get('[data-testid="shipping"]').should('contain', '$5.99');
        cy.get('[data-testid="tax"]').should('contain', '$4.40');
        cy.get('[data-testid="total"]').should('contain', '$60.38');
      });
      
      // Step 8: Place order
      cy.intercept('POST', '/api/orders').as('createOrder');
      cy.get('[data-testid="place-order"]').click();
      cy.wait('@createOrder').its('response.statusCode').should('eq', 201);
      
      // Step 9: Verify confirmation
      cy.url().should('include', '/confirmation');
      cy.get('[data-testid="order-number"]').should('be.visible');
      cy.get('[data-testid="confirmation-message"]').should('contain', 'Thank you');
      cy.get('[data-testid="email-confirmation"]').should('contain', TEST_USER.email);
      
      // Step 10: Verify order in account
      cy.visit('/account/orders');
      cy.get('[data-testid="order-item"]').first().within(() => {
        cy.get('[data-testid="order-status"]').should('contain', 'Processing');
        cy.get('[data-testid="order-total"]').should('contain', '$60.38');
      });
    });
  });

  describe('Checkout with Errors', () => {
    it('should show error for invalid credit card', () => {
      // Setup cart and navigate to checkout
      cy.addToCart('laptop-stand');
      cy.visit('/checkout');
      
      // Fill shipping
      cy.fillShippingForm({
        firstName: 'John',
        lastName: 'Doe',
        address: '123 Test Street',
        city: 'San Francisco',
        state: 'CA',
        zip: '94102'
      });
      
      // Select shipping
      cy.get('[data-testid="shipping-option-standard"]').click();
      
      // Fill invalid payment
      cy.get('[data-testid="payment-form"]').within(() => {
        cy.get('input[name="cardNumber"]').type('1234567890123456');
        cy.get('input[name="cardName"]').type('John Doe');
        cy.get('input[name="expiry"]').type('12/25');
        cy.get('input[name="cvv"]').type('123');
      });
      
      // Attempt to place order
      cy.get('[data-testid="place-order"]').click();
      
      // Verify error
      cy.get('[data-testid="payment-error"]').should('be.visible');
      cy.get('[data-testid="payment-error"]').should('contain', 'Invalid card number');
      
      // Should stay on checkout page
      cy.url().should('include', '/checkout');
    });

    it('should validate required shipping fields', () => {
      cy.addToCart('laptop-stand');
      cy.visit('/checkout');
      
      // Try to proceed without filling shipping
      cy.get('[data-testid="shipping-option-standard"]').click();
      cy.get('[data-testid="place-order"]').click();
      
      // Verify validation errors
      cy.get('[data-testid="shipping-form"]').within(() => {
        cy.get('input[name="firstName"]').should('have.attr', 'aria-invalid', 'true');
        cy.get('[data-testid="error-firstName"]').should('contain', 'First name is required');
      });
    });
  });
});
```

### Template 4: API Test

```typescript
// Example: API test with Jest and Supertest

import request from 'supertest';
import { app } from '../src/app';
import { setupTestDatabase, teardownTestDatabase } from './utils/database';

describe('User API', () => {
  let authToken: string;
  let testUserId: string;

  beforeAll(async () => {
    await setupTestDatabase();
    
    // Create test user and get auth token
    const response = await request(app)
      .post('/api/auth/register')
      .send({
        email: 'test.api@example.com',
        password: 'TestPass123!',
        firstName: 'Test',
        lastName: 'User'
      });
    
    authToken = response.body.token;
    testUserId = response.body.user.id;
  });

  afterAll(async () => {
    await teardownTestDatabase();
  });

  describe('GET /api/users/:id', () => {
    it('should return user details for authenticated request', async () => {
      const response = await request(app)
        .get(`/api/users/${testUserId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(response.body).toMatchObject({
        id: testUserId,
        email: 'test.api@example.com',
        firstName: 'Test',
        lastName: 'User'
      });
      expect(response.body).not.toHaveProperty('password');
    });

    it('should return 401 for unauthenticated request', async () => {
      const response = await request(app)
        .get(`/api/users/${testUserId}`)
        .expect(401);

      expect(response.body).toEqual({
        error: 'Authentication required'
      });
    });

    it('should return 403 for unauthorized access', async () => {
      // Create another user
      const otherUser = await request(app)
        .post('/api/auth/register')
        .send({
          email: 'other@example.com',
          password: 'OtherPass123!'
        });

      const response = await request(app)
        .get(`/api/users/${otherUser.body.user.id}`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(403);

      expect(response.body).toEqual({
        error: 'Access denied'
      });
    });

    it('should return 404 for non-existent user', async () => {
      const response = await request(app)
        .get('/api/users/non-existent-id')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(404);

      expect(response.body).toEqual({
        error: 'User not found'
      });
    });
  });

  describe('PUT /api/users/:id', () => {
    it('should update user profile', async () => {
      const response = await request(app)
        .put(`/api/users/${testUserId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          firstName: 'Updated',
          lastName: 'Name',
          bio: 'This is my bio'
        })
        .expect(200);

      expect(response.body).toMatchObject({
        id: testUserId,
        firstName: 'Updated',
        lastName: 'Name',
        bio: 'This is my bio'
      });
    });

    it('should validate input data', async () => {
      const response = await request(app)
        .put(`/api/users/${testUserId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          email: 'invalid-email'
        })
        .expect(400);

      expect(response.body).toEqual({
        error: 'Validation failed',
        details: [
          { field: 'email', message: 'Invalid email format' }
        ]
      });
    });
  });

  describe('DELETE /api/users/:id', () => {
    it('should delete user account', async () => {
      // Create user to delete
      const userToDelete = await request(app)
        .post('/api/auth/register')
        .send({
          email: 'delete.me@example.com',
          password: 'DeletePass123!'
        });

      await request(app)
        .delete(`/api/users/${userToDelete.body.user.id}`)
        .set('Authorization', `Bearer ${userToDelete.body.token}`)
        .expect(204);

      // Verify user is deleted
      await request(app)
        .get(`/api/users/${userToDelete.body.user.id}`)
        .set('Authorization', `Bearer ${userToDelete.body.token}`)
        .expect(404);
    });
  });
});
```

---

## Test Automation Guidelines

### Automation Strategy

#### What to Automate
```
✅ HIGH PRIORITY FOR AUTOMATION:
- Regression tests (run frequently, stable)
- Smoke tests (fast feedback, critical path)
- Unit tests (fast, reliable, developer-owned)
- Integration tests (API contracts, data flow)
- Data-driven tests (multiple inputs, same logic)
- Cross-browser tests (time-consuming manually)
- Performance tests (impossible to do manually)

❌ LOW PRIORITY FOR AUTOMATION:
- Exploratory tests (requires human judgment)
- Usability tests (subjective evaluation)
- One-time tests (low ROI)
- Tests with frequently changing requirements
- Visual testing (unless using visual diff tools)
- Tests requiring complex setup/teardown
```

#### Automation Pyramid
```
          /\
         /  \
        / E2E\     <- Few tests (10%) - High maintenance
       /--------\
      /   API    \   <- Medium tests (20%) - Balance
     /------------\
    /  Integration \ <- More tests (30%) - Faster
   /----------------\
  /     UNIT         \ <- Most tests (40%) - Fast, reliable
 /____________________\
 
Proportion: 70% Unit, 20% Integration, 10% E2E
```

### Test Framework Selection

#### Unit Testing
```
JavaScript/TypeScript:
- Jest (recommended) - Zero config, great features
- Vitest - Fast, Vite-native
- Mocha - Flexible, mature
- Jasmine - BDD style

Python:
- pytest (recommended) - Powerful, plugins
- unittest - Built-in
- nose2 - Extensible

Java/Kotlin:
- JUnit 5 (recommended) - Modern, extensible
- TestNG - Advanced features
- Spock - Groovy-based, expressive
```

#### E2E Testing
```
Web:
- Cypress (recommended) - Developer-friendly, fast
- Playwright (recommended) - Cross-browser, reliable
- Selenium WebDriver - Mature, wide browser support
- WebdriverIO - Modern Selenium wrapper
- TestCafe - Easy setup

Mobile:
- Appium - Cross-platform mobile
- Detox - React Native focused
- XCUITest - iOS native
- Espresso - Android native
```

#### API Testing
```
- REST Assured (Java) - DSL for API testing
- Supertest (Node.js) - HTTP assertions
- pytest + requests (Python)
- Karate - BDD for APIs
- Postman + Newman - Collection-based
```

### Test Automation Best Practices

#### Test Structure
```typescript
// AAA Pattern: Arrange, Act, Assert

describe('UserService', () => {
  it('should create user with valid data', async () => {
    // Arrange
    const userData = {
      email: 'test@example.com',
      password: 'ValidPass123!'
    };
    const userRepository = new MockUserRepository();
    const userService = new UserService(userRepository);

    // Act
    const result = await userService.createUser(userData);

    // Assert
    expect(result.email).toBe(userData.email);
    expect(result.id).toBeDefined();
    expect(userRepository.save).toHaveBeenCalled();
  });
});
```

#### Test Independence
```typescript
// ❌ BAD: Tests depend on each other

describe('ShoppingCart', () => {
  it('should add item to cart', () => {
    cart.addItem(product);
    expect(cart.items).toHaveLength(1);
  });

  it('should remove item from cart', () => {
    // Depends on previous test adding an item!
    cart.removeItem(product);
    expect(cart.items).toHaveLength(0);
  });
});

// ✅ GOOD: Each test is independent

describe('ShoppingCart', () => {
  let cart: ShoppingCart;

  beforeEach(() => {
    cart = new ShoppingCart();
  });

  it('should add item to cart', () => {
    cart.addItem(product);
    expect(cart.items).toHaveLength(1);
  });

  it('should remove item from cart', () => {
    // Setup own state
    cart.addItem(product);
    
    cart.removeItem(product);
    expect(cart.items).toHaveLength(0);
  });
});
```

#### Page Object Model (E2E)
```typescript
// Page Object for Login Page
class LoginPage {
  private page: Page;

  constructor(page: Page) {
    this.page = page;
  }

  // Locators
  private get usernameInput() { return this.page.locator('[data-testid="username"]'); }
  private get passwordInput() { return this.page.locator('[data-testid="password"]'); }
  private get loginButton() { return this.page.locator('[data-testid="login-button"]'); }
  private get errorMessage() { return this.page.locator('[data-testid="error-message"]'); }

  // Actions
  async goto() {
    await this.page.goto('/login');
  }

  async login(username: string, password: string) {
    await this.usernameInput.fill(username);
    await this.passwordInput.fill(password);
    await this.loginButton.click();
  }

  // Assertions
  async expectError(message: string) {
    await expect(this.errorMessage).toContainText(message);
  }
}

// Test using Page Object
import { test, expect } from '@playwright/test';

test('user can login', async ({ page }) => {
  const loginPage = new LoginPage(page);
  
  await loginPage.goto();
  await loginPage.login('user@example.com', 'password123');
  
  await expect(page).toHaveURL('/dashboard');
});
```

#### Data-Driven Tests
```typescript
// Test multiple data sets with same logic

describe('Password Validation', () => {
  const testCases = [
    { password: 'Short1!', valid: false, reason: 'too short' },
    { password: 'longpasswordwithoutdigits', valid: false, reason: 'no digits' },
    { password: '12345678', valid: false, reason: 'no letters' },
    { password: 'ValidPass123!', valid: true, reason: 'meets all criteria' },
    { password: '', valid: false, reason: 'empty' },
  ];

  testCases.forEach(({ password, valid, reason }) => {
    it(`should ${valid ? 'accept' : 'reject'} password that is ${reason}`, () => {
      const result = validatePassword(password);
      expect(result.isValid).toBe(valid);
    });
  });
});
```

#### Mocking and Stubbing
```typescript
// Use mocks to isolate units under test

jest.mock('./emailService');

describe('UserRegistration', () => {
  it('should send welcome email after registration', async () => {
    // Arrange
    const mockSendEmail = jest.fn();
    (EmailService as jest.Mock).mockImplementation(() => ({
      sendWelcomeEmail: mockSendEmail
    }));

    const registrationService = new RegistrationService();

    // Act
    await registrationService.register({
      email: 'test@example.com',
      password: 'Pass123!'
    });

    // Assert
    expect(mockSendEmail).toHaveBeenCalledWith('test@example.com');
  });
});
```

### Continuous Integration

#### Test Execution in CI/CD
```yaml
# Example: GitHub Actions workflow
name: Test Suite

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        node-version: [18.x, 20.x]
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run linter
        run: npm run lint
      
      - name: Run unit tests
        run: npm run test:unit -- --coverage
      
      - name: Run integration tests
        run: npm run test:integration
        env:
          DATABASE_URL: ${{ secrets.TEST_DATABASE_URL }}
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info
```

#### Parallel Test Execution
```typescript
// playwright.config.ts
export default defineConfig({
  // Run tests in parallel
  fullyParallel: true,
  
  // Workers based on available CPUs
  workers: process.env.CI ? 4 : undefined,
  
  // Shard tests across multiple machines in CI
  shard: {
    total: 4,
    current: process.env.SHARD_INDEX || 1
  },
  
  // Projects for different browsers
  projects: [
    { name: 'chromium', use: { browserName: 'chromium' } },
    { name: 'firefox', use: { browserName: 'firefox' } },
    { name: 'webkit', use: { browserName: 'webkit' } }
  ]
});
```

---

## AI Test Generation Guidelines

### Quick Reference: Common Prompt Examples

Use these proven prompt patterns to quickly generate high-quality tests:

| Use Case | Prompt Template | Example |
|----------|-----------------|---------|
| **Basic Test Cases** | `Generate [test type] test cases for [feature] covering [requirements]` | `Generate unit test cases for user authentication covering valid/invalid credentials and edge cases` |
| **Boundary Testing** | `Create boundary value tests for [field] with constraints: [min] to [max]` | `Create boundary value tests for password field with constraints: 8 to 128 characters` |
| **Error Scenarios** | `Generate negative test cases for [feature] including [error types]` | `Generate negative test cases for payment processing including invalid cards, timeouts, and network errors` |
| **Data-Driven Tests** | `Convert these scenarios to parameterized tests: [scenarios]` | `Convert these scenarios to parameterized tests: valid emails, invalid formats, empty values` |
| **Framework Migration** | `Convert [source framework] tests to [target framework]: [test code]` | `Convert Jest tests to pytest: [test code block]` |
| **Test Coverage** | `Analyze test coverage for [feature] and identify gaps in [areas]` | `Analyze test coverage for checkout flow and identify gaps in error handling and edge cases` |
| **Performance Expectations** | `Add performance assertions to [test type] tests for [operation]: [time limit]` | `Add performance assertions to E2E tests for page load: 3 seconds max` |

**Pro Tip:** Start with the basic prompt, then iteratively add refinements for better results.

---

### Principles for AI-Generated Tests

| Principle | Description | Example |
|-----------|-------------|---------|
| **Human-in-the-Loop** | AI generates drafts, humans review and refine | AI suggests test cases → Reviewer validates coverage |
| **Context-Aware** | Provide comprehensive context for better generation | Include requirements, acceptance criteria, user stories |
| **Iterative Refinement** | Start with high-level scenarios, then add details | Generate scenarios → Add steps → Add edge cases |
| **Maintainability First** | Prioritize readable, maintainable tests over clever ones | Simple, explicit assertions over complex logic |

### Best Practices for AI Test Generation

#### 1. Provide Clear Requirements
```
✅ GOOD Input:
"Generate test cases for user login with these requirements:
- Valid email format required
- Password minimum 8 characters with one uppercase, one number
- Account locks after 5 failed attempts
- Rate limit: 10 attempts per minute"

❌ BAD Input:
"Write tests for login"
```

#### 2. Specify Test Types and Coverage Goals
```
Request Format:
- Test Type: Unit | Integration | E2E
- Coverage Target: Happy path | Edge cases | Error scenarios | All
- Priority Focus: P0 (critical) | P1 (high) | All priorities
- Data Variations: Single value | Multiple values | Boundary values
```

#### 3. Review and Validate AI Output
```
Validation Checklist:
□ Test cases follow SMART criteria
□ Each test has clear preconditions
□ Steps are specific and actionable
□ Expected results are measurable
□ Edge cases are covered appropriately
□ No duplicate or overlapping tests
□ Test IDs follow naming convention
□ Traceability to requirements established
```

#### 4. Refinement Prompts
```
When refining AI-generated tests:
- "Add boundary value test cases for [field]"
- "Include negative test scenarios for [requirement]"
- "Convert these manual steps to [framework] syntax"
- "Add performance expectations to these tests"
- "Create data-driven tests from these scenarios"
```

### AI Test Generation Patterns

#### Pattern 1: Scenario Expansion
```
Input: "Test user registration"
AI Expansion:
1. Valid registration with all required fields
2. Registration with optional fields
3. Duplicate email rejection
4. Invalid email format handling
5. Weak password rejection
6. Missing required field validation
7. SQL injection attempt handling
8. XSS attempt in name field
```

#### Pattern 2: Boundary Value Generation
```
Input: "Password field (min 8, max 128 characters)"
AI Generation:
- Test 7 characters (boundary - 1) → Should fail
- Test 8 characters (boundary) → Should pass
- Test 9 characters (boundary + 1) → Should pass
- Test 128 characters (upper boundary) → Should pass
- Test 129 characters (upper boundary + 1) → Should fail
```

#### Pattern 3: Equivalence Partitioning
```
Input: "Age field validation (18-65 for employment)"
AI Partitions:
- Invalid: < 18 (e.g., 17, 0, -5)
- Valid: 18-65 (e.g., 18, 30, 65)
- Invalid: > 65 (e.g., 66, 100)
- Invalid: Non-numeric (e.g., "abc", "", null)
```

### Common AI Generation Pitfalls

| Pitfall | Problem | Solution |
|---------|---------|----------|
| **Over-Testing** | Too many similar test cases | Consolidate using parameterized tests |
| **Under-Testing** | Missing critical paths | Validate against requirement coverage matrix |
| **Implementation Bias** | Tests mirror implementation | Focus on behavior, not internal structure |
| **Brittle Selectors** | Generated tests use fragile locators | Replace with stable data-testid attributes |
| **Missing Assertions** | Tests without verification | Add explicit assertions for all outcomes |
| **Poor Isolation** | Tests depend on shared state | Add setup/teardown for each test |

### Integration with Test Management

```
Workflow for AI-Assisted Test Creation:
1. Requirements Analysis
   ↓ AI analyzes requirements and suggests test scenarios
2. Scenario Review
   ↓ Human reviews and selects relevant scenarios
3. Test Case Generation
   ↓ AI generates detailed test cases with steps
4. Test Case Refinement
   ↓ Human refines and adds specific data/expected results
5. Automation Script Generation
   ↓ AI converts manual tests to automation code
6. Code Review
   ↓ Human reviews automation code for quality
7. Execution and Validation
   ↓ Run tests and validate coverage
8. Continuous Improvement
   ↓ Update prompts based on quality feedback
```

---

## Test Case Review Process

### Review Types

#### 1. Self-Review (Author)
```
Checklist:
- [ ] Test case follows naming conventions
- [ ] Prerequisites are complete
- [ ] Steps are clear and specific
- [ ] Expected results are measurable
- [ ] Test data is realistic
- [ ] No duplicate test cases
- [ ] Traceability to requirements
- [ ] Proper priority assigned
```

#### 2. Peer Review
```
Reviewer Checklist:
- [ ] Test coverage is adequate
- [ ] Test design techniques applied correctly
- [ ] Edge cases are covered
- [ ] No ambiguity in steps
- [ ] Expected results are verifiable
- [ ] Test data is appropriate
- [ ] Test is independent and repeatable
- [ ] Automation potential assessed
```

#### 3. Lead Review
```
Reviewer Checklist:
- [ ] Alignment with test strategy
- [ ] Coverage of risk areas
- [ ] Resource allocation appropriate
- [ ] Timeline feasibility
- [ ] Dependencies identified
- [ ] Tool/framework compatibility
- [ ] Maintenance effort reasonable
```

### Review Process Steps

```
Step 1: Preparation
- Author completes test case
- Self-review performed
- Test case submitted for review

Step 2: Assignment
- Reviewer assigned (peer or lead)
- Review timeline established (24-48 hours)
- Context and requirements provided

Step 3: Review Execution
- Reviewer examines test case
- Comments and feedback provided
- Defects/issues logged

Step 4: Revision
- Author addresses feedback
- Changes implemented
- Reviewer verifies fixes

Step 5: Approval
- Reviewer approves test case
- Status updated to "Approved"
- Test case ready for execution
```

### Common Review Findings

#### Critical Issues
```
- Missing test coverage for critical requirement
- Incorrect expected results
- Test case not executable
- Security vulnerabilities in test data
```

#### Major Issues
```
- Incomplete preconditions
- Ambiguous test steps
- Unrealistic test data
- Missing cleanup steps
- No traceability to requirements
```

#### Minor Issues
```
- Typos or formatting issues
- Inconsistent naming
- Missing metadata
- Poorly worded description
```

### Review Metrics
```
Track:
- Review turnaround time
- Defects found per review
- Rework rate
- Review coverage percentage

Target Metrics:
- Review completion: Within 48 hours
- Defect density: < 5 per test case
- Rework rate: < 20%
- Coverage: 100% of test cases reviewed
```

---

## Test Case Maintenance

### When to Update Test Cases

#### Trigger Events
```
1. Requirement Changes
   - User story updated
   - Acceptance criteria modified
   - Business rules changed

2. Application Changes
   - UI redesign
   - Workflow changes
   - New features added
   - Bug fixes implemented

3. Environment Changes
   - Database schema changes
   - API version updates
   - Third-party integration changes

4. Test Improvements
   - Better test data identified
   - More efficient test steps discovered
   - Automation opportunities found
```

### Maintenance Activities

#### Regular Reviews
```
Frequency:
- Active test cases: Review monthly
- Regression suite: Review quarterly
- Obsolete test cases: Identify semi-annually

Activities:
- Verify test case still valid
- Update outdated test data
- Refresh screenshots/references
- Optimize test steps
- Update automation scripts
```

#### Refactoring Test Cases
```
Goals:
- Improve clarity and readability
- Reduce execution time
- Eliminate redundancy
- Enhance maintainability

Techniques:
- Consolidate duplicate test cases
- Extract common preconditions
- Parameterize data-driven tests
- Update locators/selectors
- Optimize wait conditions
```

#### Obsolescence Management
```
Process:
1. Identify obsolete test cases
   - Feature no longer exists
   - Covered by other tests
   - No longer valid

2. Deprecate with caution
   - Verify with stakeholders
   - Document reason for removal
   - Archive for audit purposes

3. Remove or archive
   - Delete from active suite
   - Store in archive folder
   - Update traceability matrix
```

---

## Common Anti-Patterns and How to Avoid Them

### 1. Brittle Tests

#### Problem
```typescript
// ❌ BAD: Tests break with minor UI changes
it('should login', async () => {
  await page.click('button.btn-primary'); // Generic selector
  await page.fill('input[type="text"]', 'user'); // Position-dependent
});
```

#### Solution
```typescript
// ✅ GOOD: Resilient selectors
it('should login', async () => {
  await page.click('[data-testid="login-button"]'); // Stable identifier
  await page.fill('[data-testid="username-input"]', 'user');
});
```

### 2. False Positives/Negatives

#### Problem
```typescript
// ❌ BAD: Test passes but doesn't verify correctly
it('should load page', async () => {
  await page.goto('/dashboard');
  // No assertion! Test always passes
});
```

#### Solution
```typescript
// ✅ GOOD: Explicit assertions
it('should load dashboard', async () => {
  await page.goto('/dashboard');
  await expect(page.locator('[data-testid="dashboard-title"]')).toBeVisible();
  await expect(page).toHaveTitle('Dashboard');
});
```

### 3. Test Interdependence

#### Problem
```typescript
// ❌ BAD: Test depends on global state
describe('Cart', () => {
  it('adds item', () => {
    cart.add(item); // Modifies shared cart
  });
  
  it('removes item', () => {
    // Assumes item is already in cart from previous test!
    cart.remove(item);
  });
});
```

#### Solution
```typescript
// ✅ GOOD: Independent tests
describe('Cart', () => {
  beforeEach(() => {
    cart = new Cart(); // Fresh instance each test
  });
  
  it('adds item', () => {
    cart.add(item);
    expect(cart.items).toContain(item);
  });
  
  it('removes item', () => {
    cart.add(item); // Setup own state
    cart.remove(item);
    expect(cart.items).not.toContain(item);
  });
});
```

### 4. Hard-Coded Data

#### Problem
```typescript
// ❌ BAD: Hard-coded values throughout
it('should calculate discount', () => {
  const result = calculateDiscount(100, 10);
  expect(result).toBe(90);
});

it('should calculate tax', () => {
  const result = calculateTax(100, 0.08);
  expect(result).toBe(8);
});
```

#### Solution
```typescript
// ✅ GOOD: Centralized test data
const TEST_DATA = {
  prices: {
    standard: 100,
    premium: 250
  },
  discounts: {
    tenPercent: 0.10,
    twentyPercent: 0.20
  },
  taxRate: 0.08
};

it('should calculate discount', () => {
  const { standard, discounts } = TEST_DATA;
  const result = calculateDiscount(standard, discounts.tenPercent);
  expect(result).toBe(standard * (1 - discounts.tenPercent));
});
```

### 5. Ignoring Test Failures

#### Problem
```
- Tests are flaky and randomly fail
- Team disables failing tests instead of fixing
- "Green build" is prioritized over quality
- Tests that fail are marked as "known issue"
```

#### Solution
```
- Investigate and fix root cause of flakiness
- Quarantine flaky tests until fixed
- Treat test failures as production bugs
- Implement retry logic only for transient issues
- Regular review of skipped tests
```

### 6. Testing Implementation Instead of Behavior

#### Problem
```typescript
// ❌ BAD: Testing internal implementation
it('should increment counter', () => {
  const component = new Counter();
  component.increment();
  expect(component._count).toBe(1); // Accessing private field
});
```

#### Solution
```typescript
// ✅ GOOD: Testing public behavior
it('should display incremented count', () => {
  render(<Counter />);
  fireEvent.click(screen.getByText('Increment'));
  expect(screen.getByText('Count: 1')).toBeInTheDocument();
});
```

### 7. Overly Complex Tests

#### Problem
```typescript
// ❌ BAD: One test doing too much
it('should handle user workflow', async () => {
  await login();
  await createProject();
  await addTasks(5);
  await assignTasks();
  await updateStatus();
  await generateReport();
  await logout();
  // Too many assertions, hard to diagnose failures
});
```

#### Solution
```typescript
// ✅ GOOD: Focused, independent tests
it('should create project', async () => {
  await login();
  const project = await createProject();
  expect(project).toBeCreated();
});

it('should add tasks to project', async () => {
  const project = await setupProject();
  const task = await project.addTask('Test task');
  expect(project.tasks).toContain(task);
});
```

### 8. Missing Error Cases

#### Problem
```
- Only testing happy path
- No negative test cases
- No boundary testing
- No error handling verification
```

#### Solution
```
- Follow test design techniques (BVA, equivalence partitioning)
- Include at least 30% negative tests
- Test error messages and handling
- Verify system stability under error conditions
```

---

## Test Documentation Standards

### Test Plan

#### Structure
```markdown
# Test Plan: [Project Name]

## 1. Introduction
### 1.1 Purpose
### 1.2 Scope
### 1.3 References

## 2. Test Strategy
### 2.1 Test Levels
### 2.2 Test Types
### 2.3 Test Design Techniques
### 2.4 Entry/Exit Criteria

## 3. Test Environment
### 3.1 Hardware Requirements
### 3.2 Software Requirements
### 3.3 Test Data

## 4. Test Schedule
### 4.1 Milestones
### 4.2 Resource Allocation

## 5. Risk Management
### 5.1 Risks and Mitigation

## 6. Deliverables
### 6.1 Test Documentation
### 6.2 Test Reports
```

### Test Summary Report

#### Structure
```markdown
# Test Summary Report: [Release Name]

## Executive Summary
- Overall test status: PASS/FAIL
- Test completion percentage
- Critical issues summary

## Test Scope
- Features tested
- Features not tested (and why)

## Test Results Summary
| Test Type | Total | Passed | Failed | Blocked | Pass Rate |
|-----------|-------|--------|--------|---------|-----------|
| Unit Tests | 500 | 498 | 2 | 0 | 99.6% |
| Integration Tests | 150 | 148 | 1 | 1 | 98.7% |
| E2E Tests | 50 | 47 | 2 | 1 | 94.0% |

## Defect Summary
| Severity | Open | Closed | Total |
|----------|------|--------|-------|
| Critical | 0 | 3 | 3 |
| High | 2 | 8 | 10 |
| Medium | 5 | 15 | 20 |
| Low | 8 | 12 | 20 |

## Coverage Analysis
- Requirements coverage: 95%
- Code coverage: 87%
- Risk coverage: 100% (critical), 85% (high)

## Release Recommendation
- GO / NO-GO with conditions
- Known issues and workarounds
- Outstanding risks
```

### Defect Report Template

```markdown
## Defect ID
DEF-[PROJECT]-[NUMBER]

## Title
Brief, descriptive title

## Severity
- [ ] Critical
- [ ] High
- [ ] Medium
- [ ] Low

## Priority
- [ ] Urgent
- [ ] High
- [ ] Medium
- [ ] Low

## Environment
- Application version:
- Browser/OS:
- Test environment:

## Steps to Reproduce
1. Step one
2. Step two
3. Step three

## Expected Result
What should happen

## Actual Result
What actually happened

## Attachments
- [ ] Screenshot
- [ ] Video
- [ ] Logs
- [ ] Other

## Additional Information
- Frequency: Always / Sometimes / Once
- Related test case: [ID]
- Related requirement: [ID]
```

---

## Test Metrics and Reporting

### Key Test Metrics

#### Coverage Metrics
```
Requirements Coverage:
- Formula: (Requirements tested / Total requirements) × 100
- Target: 100% for critical, 90% overall

Code Coverage:
- Statement Coverage: Statements executed / Total statements
- Branch Coverage: Branches executed / Total branches
- Function Coverage: Functions called / Total functions
- Line Coverage: Lines executed / Total lines
- Target: 80% minimum, 90% preferred
```

#### Quality Metrics
```
Defect Density:
- Formula: (Number of defects / Size of code/test) 
- Unit: Defects per KLOC or per test case

Defect Removal Efficiency:
- Formula: (Defects found in testing / Total defects) × 100
- Target: >90%

Test Effectiveness:
- Formula: (Defects found by testing / Total defects found) × 100
```

#### Execution Metrics
```
Test Execution Rate:
- Formula: (Test cases executed / Test cases planned) × 100

Test Pass Rate:
- Formula: (Test cases passed / Test cases executed) × 100
- Target: >95% for release

Test Efficiency:
- Average time to execute test case
- Automation execution time vs manual
- Test case stability (flakiness rate)
```

### Test Dashboards

#### Real-Time Dashboard Elements
```
1. Test Execution Status
   - Running/Pending/Completed
   - Pass/Fail/Block counts
   - Execution trend over time

2. Coverage Visualization
   - Heat map of covered areas
   - Coverage trend graph
   - Uncovered areas highlight

3. Defect Metrics
   - Open vs closed defects
   - Defect trend (found vs fixed)
   - Defect density by component

4. Automation Metrics
   - Automated vs manual ratio
   - Automation pass rate
   - Flaky test identification
```

### Test Reporting Cadence

```
Daily (During active testing):
- Test execution status
- New defects found
- Blockers/issues

Weekly:
- Coverage progress
- Defect trend analysis
- Risk assessment update

Milestone/Release:
- Comprehensive test summary
- Coverage analysis
- Release recommendation
```

---

## Specialized Testing Considerations

### Mobile Testing

#### Specific Considerations
```
Device Diversity:
- Different screen sizes and resolutions
- Various OS versions (iOS, Android)
- Hardware capabilities (camera, GPS, sensors)

Network Conditions:
- Test on 3G, 4G, 5G, WiFi
- Offline mode functionality
- Poor connectivity handling

Gestures and Interactions:
- Touch, swipe, pinch, zoom
- Device orientation changes
- Background/foreground transitions

Platform-Specific:
- App store guidelines compliance
- Platform UI conventions
- Push notification handling
```

#### Mobile Test Case Template
```markdown
## Device Matrix
| Device | OS Version | Screen Size | Priority |
|--------|------------|-------------|----------|
| iPhone 14 Pro | iOS 17 | 6.1" | High |
| Samsung S23 | Android 13 | 6.1" | High |
| Pixel 7 | Android 13 | 6.3" | Medium |

## Network Test Scenarios
- [ ] Test on WiFi
- [ ] Test on 4G
- [ ] Test on 3G (slow network)
- [ ] Test offline mode
- [ ] Test network reconnection

## Gesture Test Cases
- [ ] Swipe to dismiss
- [ ] Pinch to zoom on images
- [ ] Pull to refresh
- [ ] Double tap to like
```

### API Testing

#### Test Levels
```
1. Contract Testing
   - Verify API specification compliance
   - Request/response schema validation
   - Example: Pact, Swagger validation

2. Component Testing
   - Test API endpoints in isolation
   - Mock external dependencies
   - Validate business logic

3. Integration Testing
   - Test API with real dependencies
   - Verify data flow end-to-end
   - Performance under load
```

#### API Test Case Components
```
Required Elements:
- HTTP method (GET, POST, PUT, DELETE, etc.)
- Endpoint URL
- Headers (authentication, content-type)
- Request body (for POST/PUT)
- Query parameters
- Expected status code
- Expected response body
- Response time threshold
```

### Database Testing

#### Test Categories
```
1. Schema Validation
   - Table structure
   - Column data types
   - Constraints (primary key, foreign key, unique)
   - Indexes

2. Data Integrity
   - Referential integrity
   - Constraint validation
   - Trigger functionality

3. Transaction Testing
   - ACID properties
   - Rollback behavior
   - Concurrent access

4. Performance Testing
   - Query execution time
   - Index effectiveness
   - Lock contention
```

### Security Testing

#### OWASP Top 10 Test Cases
```
1. Broken Access Control
   - Test horizontal privilege escalation
   - Test vertical privilege escalation
   - Verify direct object references

2. Cryptographic Failures
   - Verify encryption in transit (TLS)
   - Verify encryption at rest
   - Check for hardcoded secrets

3. Injection
   - SQL injection tests
   - NoSQL injection tests
   - OS command injection tests
   - LDAP injection tests

4. Insecure Design
   - Business logic flaws
   - Race conditions
   - Insecure workflows

5. Security Misconfiguration
   - Default credentials
   - Unnecessary features enabled
   - Verbose error messages

6. Vulnerable Components
   - Dependency scanning
   - Outdated libraries
   - Known CVE checks

7. Authentication Failures
   - Brute force protection
   - Session management
   - Multi-factor authentication

8. Software and Data Integrity
   - CI/CD pipeline security
   - Unsigned updates
   - Insecure deserialization

9. Logging Failures
   - Insufficient logging
   - Missing audit trails
   - Log injection

10. Server-Side Request Forgery (SSRF)
    - Unrestricted URL fetching
    - Internal resource access
```

---

## Appendix A: Quick Reference

### Test Case Checklist

```
Before Writing:
- [ ] Requirement is clear and testable
- [ ] Test objective is defined
- [ ] Test type is identified
- [ ] Priority is assessed

During Writing:
- [ ] Unique test case ID assigned
- [ ] Clear, descriptive title
- [ ] Preconditions documented
- [ ] Test data specified
- [ ] Steps are specific and actionable
- [ ] Expected results are measurable
- [ ] Post-conditions defined
- [ ] Traceability established

After Writing:
- [ ] Self-review completed
- [ ] Peer review conducted
- [ ] Test case is executable
- [ ] Automation potential assessed
- [ ] Added to test suite
```

### Common Test Design Patterns

```
1. Arrange-Act-Assert (AAA)
   - Setup → Execute → Verify

2. Given-When-Then (Gherkin)
   - Context → Action → Outcome

3. Setup-Exercise-Verify-Teardown
   - Comprehensive test lifecycle

4. Four-Phase Test
   - Setup → Exercise → Verify → Teardown
```

### Testing Mnemonics

```
RIGHT:
- Repeatable: Same results every time
- Independent: No dependencies between tests
- Granular: One concept per test
- High-performance: Fast execution
- Thorough: Good coverage

INVEST (for test cases):
- Independent
- Negotiable (can be modified)
- Valuable
- Estimable
- Small
- Testable (verifiable)

FURPS+:
- Functionality
- Usability
- Reliability
- Performance
- Supportability
- + (design, implementation, interface, physical)
```

---

## Appendix B: Glossary

```
Acceptance Criteria: Conditions that must be met for a feature to be accepted

Assertion: Statement that checks if a condition is true

Black Box Testing: Testing without knowledge of internal implementation

Code Coverage: Measure of how much code is executed by tests

Defect: Flaw or imperfection in software

End-to-End Testing: Testing complete application flow

Equivalence Partitioning: Dividing inputs into groups expected to behave similarly

Exploratory Testing: Simultaneous learning, test design, and execution

Functional Testing: Testing against functional requirements

Integration Testing: Testing interactions between components

Mock: Simulated object that mimics real object behavior

Non-Functional Testing: Testing quality attributes (performance, security, etc.)

Regression Testing: Re-testing after changes to ensure existing functionality works

Smoke Testing: Quick test of critical functionality

Stub: Minimal implementation of a component for testing

Test Case: Set of conditions for testing a specific scenario

Test Plan: Document describing scope, approach, and schedule

Test Suite: Collection of test cases

Unit Testing: Testing individual units of code in isolation

White Box Testing: Testing with knowledge of internal implementation
```

---

## Related Guidelines

### Agent-Specific Guidelines
| Guideline | Purpose | When to Use | Status |
|-----------|---------|-------------|--------|
| `@rules/rust-guidelines.md` | Rust development standards | Writing unit/integration tests in Rust | Available |
| `@rules/typescript-guidelines.md` | TypeScript/JavaScript standards | Writing tests in TypeScript/JavaScript | Available |
| `@rules/python-guidelines.md` | Python development standards | Writing tests in Python (pytest, unittest) | Planned |
| `@rules/api-testing-guidelines.md` | API testing standards | Testing REST/GraphQL endpoints | Planned |
| `@rules/e2e-testing-guidelines.md` | End-to-end testing standards | Testing complete user workflows | Planned |
| `@rules/performance-testing-guidelines.md` | Performance testing standards | Load, stress, and scalability testing | Planned |
| `@rules/security-testing-guidelines.md` | Security testing standards | Penetration testing, vulnerability scanning | Planned |

> **Note**: Guidelines marked as "Planned" are not yet available in the `@rules` directory but are on the roadmap for future releases.

### Documentation Standards
| Document | Purpose | Status |
|----------|---------|--------|
| `@rules/documentation-standards.md` | General documentation guidelines | Planned |
| `@rules/code-review-checklist.md` | Review process and criteria | Planned |

### Cross-References
- **Unit Testing**: See language-specific guidelines (Rust, TypeScript)
- **Integration Testing**: Follow language-specific testing patterns and API best practices
- **E2E Testing**: Use this document's E2E testing section and follow framework-specific patterns
- **Performance**: Refer to Test Types and Levels section for performance test design patterns
- **Security**: Refer to Specialized Testing Considerations section for security test patterns

---

## Version History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2024-02-16 | Build Agent | Initial comprehensive test case guidelines |

---

*Document based on ISTQB Foundation Level Syllabus v4.0, ISO/IEC/IEEE 29119-1:2022, IEEE 829-2008, and industry best practices from leading software testing organizations.*
