# Product Requirements Document (PRD) Guidelines

## Table of Contents
1. [PRD Purpose and Definition](#prd-purpose-and-definition)
2. [PRD Structure and Sections](#prd-structure-and-sections)
3. [User Story Writing Guidelines](#user-story-writing-guidelines)
4. [Writing Best Practices](#writing-best-practices)
5. [Review and Approval Process](#review-and-approval-process)
6. [PRD Template Examples](#prd-template-examples)

---

## PRD Purpose and Definition

### What is a PRD?
A Product Requirements Document (PRD) is a comprehensive document that defines the requirements, features, functionality, and behavior of a product or feature. It serves as the single source of truth for what needs to be built and why.

### Purpose of a PRD
- **Align stakeholders**: Ensure everyone (product, engineering, design, QA, business) shares the same understanding
- **Guide development**: Provide clear direction for engineering teams
- **Enable decision-making**: Support prioritization and scope management
- **Reduce ambiguity**: Minimize misinterpretation and rework
- **Track progress**: Serve as a reference for testing and validation

### When to Create a PRD
- New product development
- Major feature additions
- Significant product changes or refactoring
- Cross-functional initiatives requiring coordination

---

## PRD Structure and Sections

### 1. Document Header
```
Title: [Product/Feature Name]
Version: [X.Y.Z]
Date: [YYYY-MM-DD]
Author: [Product Owner Name]
Status: [Draft/In Review/Approved/Deprecated]
```

### 2. Executive Summary
A brief overview (2-3 paragraphs) covering:
- What is being built
- Why it matters (business context)
- Expected outcomes
- Key stakeholders

### 3. Objectives and Goals

#### Business Objectives
- What business problem are we solving?
- What opportunities are we capturing?
- Expected business impact (revenue, users, efficiency, etc.)

#### Product Objectives
- What user problems are we solving?
- How does this fit into the product vision?
- What is the success criteria?

#### SMART Goals Framework
- **S**pecific: Clear and unambiguous
- **M**easurable: Quantifiable outcomes
- **A**chievable: Realistic given constraints
- **R**elevant: Aligned with business strategy
- **T**ime-bound: Clear timeline

### 4. Out of Scope
Explicitly define what is NOT included in this PRD to prevent scope creep and manage expectations.

**Template:**
```markdown
## Out of Scope

The following items are explicitly excluded from this release:

| Item | Reason | Future Consideration |
|------|--------|---------------------|
| [Feature X] | [Why it's excluded] | [When it might be added] |
| [Integration Y] | [Technical limitation] | [Q3 2024] |
| [Platform Z] | [Resource constraint] | [Next phase] |

### Scope Boundaries
- ✅ In Scope: [Specific features/functionality included]
- ❌ Out of Scope: [Specific features/functionality excluded]
- 🔄 Future Phase: [Items deferred to future releases]
```

**Best Practices:**
- Be specific about exclusions
- Provide justification for each exclusion
- Indicate when excluded items might be reconsidered
- Review with stakeholders to confirm alignment

### 5. Assumptions
Document all assumptions made during PRD creation. These should be validated throughout the project lifecycle.

**Template:**
```markdown
## Assumptions

### Business Assumptions
| ID | Assumption | Validation Method | Owner | Due Date | Status |
|----|------------|-------------------|-------|----------|--------|
| BA-01 | [Assumption text] | [How to validate] | [Name] | [Date] | Pending/Validated/Invalidated |
| BA-02 | Users will adopt feature within 30 days | User acceptance testing | Product | 2024-02-15 | Pending |

### Technical Assumptions
| ID | Assumption | Validation Method | Owner | Due Date | Status |
|----|------------|-------------------|-------|----------|--------|
| TA-01 | API latency will remain under 100ms | Load testing | Engineering | 2024-02-01 | Pending |
| TA-02 | Third-party service availability > 99.9% | SLA review | DevOps | 2024-01-30 | Pending |

### User Assumptions
| ID | Assumption | Validation Method | Owner | Due Date | Status |
|----|------------|-------------------|-------|----------|--------|
| UA-01 | Users prefer mobile over desktop | Analytics review | UX Research | 2024-02-10 | Pending |
| UA-02 | Feature will reduce support tickets by 20% | Post-launch analysis | Support | 2024-03-01 | Pending |

### Validation Checklist
- [ ] All critical assumptions validated before development
- [ ] Assumption risks documented in Risk Register
- [ ] Fallback plans created for high-risk assumptions
- [ ] Stakeholders aware of assumption dependencies
```

### 6. User Personas

Define the target users using this format:

```markdown
### Persona: [Name]
- **Role**: [Job title/role]
- **Demographics**: [Age range, location, industry]
- **Goals**: [What they want to achieve]
- **Pain Points**: [Current frustrations]
- **Behaviors**: [How they currently work]
- **Tech Proficiency**: [Beginner/Intermediate/Advanced]
- **Quote**: [Representative statement]
```

**Best Practices:**
- Create 2-4 primary personas maximum
- Base personas on real user research
- Include both primary and secondary users
- Update personas as you learn more

#### Jobs-to-be-Done (JTBD) vs Personas

While personas describe WHO the user is, JTBD focuses on WHAT the user is trying to accomplish.

| Aspect | Personas | JTBD |
|--------|----------|------|
| **Focus** | User characteristics, demographics, behaviors | User's goal or "job" |
| **Format** | "Sarah, 35, marketing manager..." | "When I [situation], I want to [motivation], so I can [expected outcome]" |
| **Best for** | Understanding user context and preferences | Understanding functional needs and innovation |
| **Use when** | Designing for specific user types | Solving problems or creating new solutions |

**JTBD Format:**
```
When I [situation/context], 
I want to [motivation/intent], 
so I can [expected outcome].
```

**Example:**
```
Persona: "As a project manager, I want..."

JTBD: "When I'm preparing for a client presentation, I want to quickly generate 
a visual report of project milestones, so I can demonstrate progress 
without spending hours formatting data."
```

**Recommendation:** Use personas for understanding your users, use JTBD for understanding what they need to accomplish. Combine both for powerful insights.

### 7. User Stories

#### The 5W1H Framework (Based on 5W1H Method)
Every user story should answer these six questions based on the classic 5W1H (Who, When, Where, What, Why, How) problem-solving method:

| Element | Question | Description | 5W1H Mapping |
|---------|----------|-------------|--------------|
| **Who** | Who is the user? | The persona or user type | **W**ho |
| **When** | When does this happen? | The context or trigger | **W**hen |
| **Where** | Where does this occur? | The environment or platform | **W**here |
| **What** | What action do they take? | The specific functionality | **W**hat |
| **Why** | Why do they need this? | The goal or motivation | **W**hy |
| **How** | How do we define success? | Acceptance criteria/quality standards | **H**ow |

> **Note:** The 5W1H method (Five Ws and One H) is a questioning approach used in journalism, research, and problem-solving to gather comprehensive information. We've adapted it specifically for user story writing.

#### Classic Format (Atlassian Style)
```
As a [who], I want [do what], so that [why].
```

#### Expanded 5W1H Format
```
As a [who], when [when], where [where], I want to [do what], 
so that [why]. Success is defined by [how].
```

#### Example:
```
Classic: As a project manager, I want to export reports as PDF, 
so that I can share them with stakeholders who don't have system access.

5W1H Expanded: As a project manager (who), when reviewing monthly progress (when), 
in the web dashboard (where), I want to export reports as PDF (what), 
so that I can share them with stakeholders who don't have system access (why). 
Success is defined by: the export generates a properly formatted PDF within 5 seconds, 
includes all chart data, and maintains formatting across devices (how).
```

### 8. Functional Requirements

Organized by feature or epic:

```markdown
### Feature: [Feature Name]
**Priority**: [Must/Should/Could/Won't]
**Owner**: [Product Owner/Team]

#### Description
[Detailed description of the feature]

#### User Stories
[List of user stories related to this feature]

#### Functional Specifications
- Requirement 1: [Detailed description]
- Requirement 2: [Detailed description]

#### Business Rules
- Rule 1: [Business logic or constraint]
- Rule 2: [Business logic or constraint]

#### Edge Cases
- Edge case 1: [Description and expected behavior]
- Edge case 2: [Description and expected behavior]
```

### 9. Non-Functional Requirements

Define system qualities:

#### Performance
- Response time requirements (e.g., page load < 2 seconds)
- Throughput (e.g., support 1000 concurrent users)
- Resource usage (e.g., memory, CPU)

#### Security
- Authentication requirements
- Authorization levels
- Data encryption standards
- Compliance (GDPR, SOC2, etc.)

#### Reliability
- Uptime requirements (e.g., 99.9% SLA)
- Recovery time objectives (RTO)
- Recovery point objectives (RPO)

#### Scalability
- User growth projections
- Data volume expectations
- Horizontal/vertical scaling needs

#### Usability
- Accessibility standards (WCAG 2.1 AA)
- Browser/device support matrix
- Localization requirements

#### Maintainability
- Code documentation requirements
- API versioning strategy
- Technical debt considerations

### 10. Data & Analytics Requirements

Define data tracking, event instrumentation, and analytics needs.

#### Event Tracking Requirements
```markdown
### User Events
| Event Name | Trigger | Properties | Priority |
|------------|---------|------------|----------|
| feature_used | User clicks feature button | user_id, timestamp, feature_name, session_id | Required |
| export_completed | Export finishes successfully | user_id, file_type, file_size, duration_ms | Required |
| error_occurred | Error during operation | user_id, error_code, error_message, context | Required |

### System Events
| Event Name | Trigger | Properties | Priority |
|------------|---------|------------|----------|
| api_latency | API response received | endpoint, duration_ms, status_code | Required |
| database_query | Query executed | query_type, duration_ms, rows_returned | Optional |
```

#### Metrics Instrumentation
```markdown
### Business Metrics
- **Metric**: [Metric name]
  - **Definition**: [Clear definition]
  - **Calculation**: [How to calculate]
  - **Target**: [Goal value]
  - **Reporting Frequency**: [Daily/Weekly/Monthly]

### Product Metrics
- **Metric**: Feature adoption rate
  - **Definition**: % of active users who use feature within 7 days of availability
  - **Calculation**: (Users who used feature / Total active users) × 100
  - **Target**: >30% within first month
  - **Reporting Frequency**: Weekly

### Technical Metrics
- **Metric**: API response time p95
  - **Definition**: 95th percentile response time
  - **Target**: <200ms
  - **Alert Threshold**: >500ms
```

#### Dashboard Requirements
```markdown
### Product Dashboard
- **Audience**: Product Managers, Executives
- **Refresh Rate**: Real-time
- **Key Widgets**:
  - Feature usage trends (line chart, last 30 days)
  - User satisfaction score (gauge)
  - Conversion funnel (funnel chart)
  - Error rate by endpoint (bar chart)

### Technical Dashboard
- **Audience**: Engineering, DevOps
- **Refresh Rate**: 1-minute intervals
- **Key Widgets**:
  - API latency percentiles (heatmap)
  - Error rates by service (line chart)
  - Infrastructure health (status grid)
  - Database performance (time series)
```

#### Data Privacy & Compliance
- PII handling requirements
- Data retention policies
- GDPR/CCPA compliance for tracking
- User consent management

### 11. Design Considerations

#### User Experience
- User journey maps
- Key user flows
- Interaction patterns
- Error handling approach

#### Visual Design
- Design system references
- Brand guidelines
- UI mockups/wireframes (links)
- Responsive design requirements

#### Technical Architecture
- High-level architecture diagram
- Integration points
- Third-party dependencies
- API specifications

### 12. Timeline and Roadmap

```markdown
### Phase 1: MVP (Month 1-2)
- Feature A
- Feature B
- Success criteria: [Measurable outcome]

### Phase 2: Enhanced Features (Month 3-4)
- Feature C
- Feature D
- Success criteria: [Measurable outcome]

### Phase 3: Scale and Optimize (Month 5-6)
- Feature E
- Performance optimization
- Success criteria: [Measurable outcome]
```

### 13. Success Metrics

Define how you'll measure success:

#### Primary Metrics (North Star)
- The one metric that matters most
- Directly tied to business objectives

#### Secondary Metrics
- Supporting indicators
- Health metrics

#### Counter Metrics
- Guardrail metrics to watch for negative impacts

#### Measurement Plan
- How each metric will be tracked
- Baseline measurements
- Target values
- Reporting frequency

---

## User Story Writing Guidelines

### Principles of Good User Stories

#### INVEST Criteria
Every user story should be:
- **I**ndependent: Can be developed separately
- **N**egotiable: Details can be discussed and refined
- **V**aluable: Delivers clear value to users
- **E**stimable: Team can estimate effort
- **S**mall: Can be completed in one sprint
- **T**estable: Has clear acceptance criteria

### Deep Dive: The 5W1H Elements

#### 1. Who (Persona)
**Key Questions:**
- Which user type benefits from this?
- What is their role and context?
- Are there multiple user types affected?

**Best Practices:**
- Use specific persona names, not generic "user"
- Consider both primary and secondary users
- Include system actors if relevant (e.g., "As an API consumer")

**Examples:**
- ❌ "As a user..." (too vague)
- ✅ "As a first-time mobile app user..." (specific)
- ✅ "As a customer support agent handling escalations..." (context-rich)

#### 2. When (Context/Trigger)
**Key Questions:**
- What triggers this need?
- What is the user's state before this action?
- Is this time-sensitive?

**Best Practices:**
- Describe the scenario, not just time
- Include preconditions if relevant
- Consider frequency (one-time vs. recurring)

**Examples:**
- ❌ "When I want to..." (too vague)
- ✅ "When I've completed a purchase and want to track my order..."
- ✅ "When I'm viewing a report and need to share insights with my team..."

#### 3. Where (Environment)
**Key Questions:**
- On which platform/device?
- In which part of the application?
- Online or offline?

**Best Practices:**
- Specify platform (web, mobile iOS, mobile Android, desktop)
- Mention location in app if relevant
- Consider cross-platform needs

**Examples:**
- ✅ "In the mobile iOS app, on the dashboard screen..."
- ✅ "Across all platforms, in the settings section..."
- ✅ "In the browser extension, when viewing a product page..."

#### 4. What (Action)
**Key Questions:**
- What specific action does the user take?
- What is the expected system response?
- What are the steps involved?

**Best Practices:**
- Use action verbs
- Be specific about the functionality
- Focus on outcome, not implementation

**Examples:**
- ❌ "I want a button to export..." (implementation detail)
- ✅ "I want to export my data to Excel format..." (outcome-focused)
- ✅ "I want to filter search results by date range and category..."

#### 5. Why (Goal/Motivation)
**Key Questions:**
- What is the underlying need?
- What value does this provide?
- What problem does this solve?

**Best Practices:**
- Go beyond the obvious
- Connect to business value when possible
- Explain the "so what"

**Examples:**
- ❌ "So that I can export data" (restates the action)
- ✅ "So that I can analyze trends offline and present findings to stakeholders"
- ✅ "So that I can quickly find relevant information without scrolling through irrelevant results"

#### 6. How (Acceptance Criteria/Quality)
**Key Questions:**
- What defines "done"?
- How do we verify this works correctly?
- What are the quality standards?

**Best Practices:**
- Use Given-When-Then format for complex scenarios
- Include both functional and non-functional criteria
- Make criteria testable and measurable
- Cover happy path and edge cases

**Formats:**

**Simple Checklist:**
```
Acceptance Criteria:
- [ ] PDF export includes all chart data
- [ ] Export completes within 5 seconds
- [ ] File is properly formatted on mobile and desktop
- [ ] Error message displays if export fails
```

**Given-When-Then:**
```
Scenario: Successful PDF export
Given I am on the report page
And the report contains data
When I click "Export as PDF"
Then a PDF file should download within 5 seconds
And the PDF should contain all charts and tables
And the formatting should match the on-screen display
```

**Definition of Done Checklist:**
```
This story is complete when:
- [ ] Code is written and reviewed
- [ ] Unit tests pass (coverage > 80%)
- [ ] Integration tests pass
- [ ] QA validates acceptance criteria
- [ ] Documentation is updated
- [ ] Deployed to staging environment
- [ ] Product owner approves
```

### Special Story Types

Not all work fits the standard user story format. Document these special story types appropriately:

#### Technical Stories
Work that benefits the development team or system but has no direct user-facing value.

```markdown
**Type**: Technical Story
**Title**: [Brief description]

**Context**: [Why this technical work is needed]
**Technical Goal**: [What we're trying to achieve]
**Acceptance Criteria**:
- [ ] [Technical criterion 1]
- [ ] [Technical criterion 2]
- [ ] [Technical criterion 3]

**Value**: [How this enables future user value]
**Dependencies**: [Any blocking items]
```

**Example:**
```
Type: Technical Story
Title: Implement caching layer for product catalog API

Context: Current API calls take 800ms+ during peak traffic, 
causing slow page loads and poor user experience.

Technical Goal: Reduce API response time by implementing Redis caching 
for frequently accessed product data.

Acceptance Criteria:
- [ ] Cache hit rate > 80%
- [ ] Cache miss response time < 100ms
- [ ] Cache invalidation strategy implemented
- [ ] Stale cache fallback mechanism in place
- [ ] Monitoring alerts for cache performance

Value: Enables sub-200ms page loads, improving user experience 
and conversion rates.
```

#### Spikes (Research/Investigation)
Time-boxed research to reduce uncertainty before implementation.

```markdown
**Type**: Spike
**Title**: [Research question]
**Timebox**: [X hours/days]

**Question**: [What we need to learn]
**Context**: [Why this research is needed]
**Deliverables**:
- [ ] [Specific output 1]
- [ ] [Specific output 2]
- [ ] Recommendation document

**Success Criteria**: [How we know the spike is complete]
```

**Example:**
```
Type: Spike
Title: Evaluate third-party payment providers
Timebox: 3 days

Question: Which payment provider best meets our security, 
cost, and feature requirements?

Context: We need to add international payment support. 
Current provider doesn't support all required currencies.

Deliverables:
- [ ] Comparison matrix of 3 providers (Stripe, Adyen, Braintree)
- [ ] Security compliance assessment
- [ ] Cost analysis for projected volume
- [ ] API integration complexity evaluation
- [ ] Recommendation document with pros/cons

Success Criteria: Team can make informed decision on payment provider.
```

#### Bug Stories
Defects that need to be fixed.

```markdown
**Type**: Bug
**Severity**: [Critical/High/Medium/Low]
**Priority**: [Urgent/High/Medium/Low]

**Description**: [What is broken]
**Steps to Reproduce**:
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected Behavior**: [What should happen]
**Actual Behavior**: [What actually happens]
**Environment**: [Browser, OS, version]
**Acceptance Criteria**:
- [ ] [Fix verification criterion 1]
- [ ] [Regression test criterion 2]
```

#### Research/Design Stories
UX research or design work needed before development.

```markdown
**Type**: Research/Design
**Title**: [Research objective]

**Objective**: [What we need to understand/design]
**Methodology**: [How we'll conduct research]
**Deliverables**:
- [ ] [Research output 1]
- [ ] [Design artifact 2]

**Acceptance Criteria**:
- [ ] Research findings documented
- [ ] Design reviewed with stakeholders
- [ ] Handoff to engineering complete
```

### Story Splitting Patterns

When stories are too large for a single sprint, use these patterns to split them while maintaining value:

#### 1. Workflow Steps
Split by steps in a workflow when the full workflow is too large.

```
Original: As a user, I want to complete the entire checkout process...

Split into:
- Story 1: Enter shipping information
- Story 2: Select payment method
- Story 3: Review and confirm order
```

#### 2. Business Rule Variations
Split by different business rules or conditions.

```
Original: As an admin, I want to configure notification settings...

Split into:
- Story 1: Configure email notifications (MVP)
- Story 2: Configure SMS notifications (enhancement)
- Story 3: Configure push notifications (future)
```

#### 3. Happy Path vs Edge Cases
Implement the main flow first, then handle edge cases.

```
Original: As a user, I want to upload documents with validation...

Split into:
- Story 1: Upload document (happy path, valid files only)
- Story 2: Handle invalid file types and sizes
- Story 3: Handle upload errors and retries
```

#### 4. Simple vs Complex
Do the basic version first, then enhance.

```
Original: As a user, I want advanced search with filters...

Split into:
- Story 1: Basic keyword search
- Story 2: Add category filter
- Story 3: Add date range filter
- Story 4: Add advanced filters (multiple criteria)
```

#### 5. Platform Split
Split by platform when cross-platform support is complex.

```
Original: As a user, I want the feature on all platforms...

Split into:
- Story 1: Web implementation
- Story 2: iOS implementation
- Story 3: Android implementation
```

#### 6. Data Variations
Split by data types or sources.

```
Original: As a user, I want to import data from all sources...

Split into:
- Story 1: Import from CSV
- Story 2: Import from Excel
- Story 3: Import via API integration
```

#### Story Splitting Checklist
- [ ] Each split story delivers independent value
- [ ] Each story is estimable (typically 1-8 story points)
- [ ] Split doesn't create dependencies between stories
- [ ] Critical path is identified and prioritized
- [ ] MVP version delivers core user value

### User Story Examples by Type

#### Simple Feature
```
As a frequent shopper (who), when browsing products (when), 
on the mobile app product page (where), I want to see estimated delivery dates (what), 
so that I can make informed purchase decisions (why).

Acceptance Criteria:
- [ ] Delivery date displays for each shipping option
- [ ] Date is based on current inventory and user location
- [ ] Updates dynamically if user changes address
```

#### Complex Workflow
```
As a sales manager (who), when preparing for quarterly reviews (when), 
in the CRM analytics dashboard (where), I want to create custom sales reports 
with filters for region, product line, and time period (what), 
so that I can identify trends and make data-driven decisions (why).

Acceptance Criteria:
Given I have access to the analytics dashboard
When I select "Create Custom Report"
Then I can choose from available data fields
And apply multiple filters simultaneously
And save the report configuration for future use
And export results in CSV or PDF format
```

#### Technical Story
```
As a system administrator (who), when monitoring system health (when), 
in the admin dashboard (where), I want to receive automated alerts 
when API response time exceeds 2 seconds (what), 
so that I can proactively address performance issues before they impact users (why).

Acceptance Criteria:
- [ ] Alert triggers when 95th percentile response time > 2s for 5 minutes
- [ ] Alert includes endpoint, response time, and timestamp
- [ ] Alert sent via email and Slack
- [ ] Alert can be acknowledged and silenced
```

#### Real-World Complex Example with Dependencies
```
Story: Multi-platform notification system

As a project team member (who), when project status changes (when), 
across web, iOS, and Android platforms (where), I want to receive 
real-time notifications about task assignments and updates (what), 
so that I can stay informed and respond promptly regardless of device (why).

Dependencies:
- Requires: User authentication system (AUTH-123) - MUST be completed first
- Requires: Push notification infrastructure (INFRA-456) - CAN run in parallel
- Blocks: Mobile offline mode feature (MOBILE-789) - can start after notification core

Platform-Specific Acceptance Criteria:

Web:
- [ ] Browser notifications display when tab is not active
- [ ] Notifications appear in notification center
- [ ] Clicking notification navigates to relevant page

iOS:
- [ ] Push notifications display when app is backgrounded
- [ ] Deep linking opens correct screen from notification
- [ ] Notification grouping by project in Notification Center

Android:
- [ ] Push notifications with action buttons (Mark as read, Reply)
- [ ] Notification channels configured for Android 8+
- [ ] Notification history accessible in-app

Cross-Platform:
- [ ] Notification preferences sync across devices
- [ ] Read status synchronized in real-time
- [ ] Support for @mentions with different alert level

Release Phasing:
Phase 1: Web notifications (Sprint 1)
Phase 2: iOS notifications (Sprint 2)
Phase 3: Android notifications + cross-platform sync (Sprint 3)
```

#### Real-World Example with A/B Testing
```
Story: A/B Test - New Checkout Flow

As a product team (who), during Q2 optimization initiative (when), 
in the payment flow (where), we want to test a simplified 2-step checkout 
against the current 5-step checkout (what), 
to determine if conversion rate improves with reduced friction (why).

Experiment Design:
- Hypothesis: Reducing checkout steps from 5 to 2 will increase conversion by 15%
- Control Group: 50% of users see current 5-step checkout
- Treatment Group: 50% of users see new 2-step checkout
- Duration: 2 weeks or until statistical significance (p < 0.05)
- Success Metric: Checkout completion rate

Acceptance Criteria:
- [ ] Feature flag system implemented for gradual rollout
- [ ] Users randomly assigned to control or treatment group
- [ ] Assignment persists across sessions (same user always sees same version)
- [ ] All checkout events tracked with experiment variant
- [ ] Control and treatment have functional parity (same payment methods)
- [ ] Rollback capability within 5 minutes if issues detected

Analytics Requirements:
- Track: Checkout start, step completion, abandonment, completion
- Track: Time spent on each step
- Track: Error rates by step
- Track: Revenue per transaction (guardrail metric)
- Dashboard: Real-time conversion funnel by variant

Release Criteria:
- Statistical significance achieved OR
- 2 weeks elapsed with no critical issues OR
- Treatment group shows >20% negative impact (early termination)

Post-Experiment:
- Winner deployed to 100% of users within 48 hours
- Loser code removed in subsequent sprint
- Results documented in experiment repository
```

---

## Writing Best Practices

### Language and Clarity

#### Use Clear, Simple Language
- ❌ "The system shall facilitate the user in the exportation of data..."
- ✅ "Users can export their data..."

#### Be Specific
- ❌ "The app should be fast"
- ✅ "Pages should load within 2 seconds on 4G connections"

#### Avoid Ambiguity
- ❌ "The system should handle many users"
- ✅ "The system should support 10,000 concurrent users with <3s response time"

#### Use Active Voice
- ❌ "The report can be exported by the user"
- ✅ "Users can export reports"

### Acceptance Criteria Format

#### Structure Options

**Option 1: Bullet Points**
Best for simple stories with clear criteria.
```
Acceptance Criteria:
- [ ] User can select date range
- [ ] Results update immediately
- [ ] Invalid dates show error message
```

**Option 2: Given-When-Then (Gherkin)**
Best for complex scenarios with multiple conditions.
```
Scenario: Valid login
Given I am on the login page
And I have a valid account
When I enter correct credentials
And click "Sign In"
Then I should be redirected to the dashboard
And see a welcome message
```

**Option 3: Rules-Based**
Best for business logic requirements.
```
Business Rules:
1. Orders over $50 qualify for free shipping
2. Orders under $50 have $5.99 shipping fee
3. International orders have variable rates based on destination
```

### Release Criteria vs Acceptance Criteria

While acceptance criteria define when a feature is functionally complete, **release criteria** define when it's ready for production deployment.

| Aspect | Acceptance Criteria | Release Criteria |
|--------|-------------------|------------------|
| **Focus** | Feature functionality | Production readiness |
| **When** | Development complete | Before deployment |
| **Who validates** | Product/QA | Engineering/DevOps/Security |
| **Scope** | Individual story | Entire release |

#### Release Criteria Checklist (Go/No-Go)

```markdown
## Release Criteria

### Functional
- [ ] All acceptance criteria validated by QA
- [ ] Critical path user flows tested end-to-end
- [ ] No open P0 or P1 bugs
- [ ] Feature flags configured correctly

### Performance
- [ ] Load testing completed (target: 1000 concurrent users)
- [ ] API p95 latency < 200ms under load
- [ ] No memory leaks detected in 24-hour soak test
- [ ] Database query performance acceptable

### Security
- [ ] Security review completed
- [ ] No critical vulnerabilities in dependencies
- [ ] Authentication/authorization tested
- [ ] PII handling compliant with privacy policy

### Monitoring & Observability
- [ ] Error tracking configured
- [ ] Performance monitoring dashboards created
- [ ] Alert thresholds configured
- [ ] Runbook created for common issues

### Documentation
- [ ] User documentation updated
- [ ] API documentation updated
- [ ] Release notes prepared
- [ ] Rollback procedure documented

### Operational
- [ ] Database migrations tested in staging
- [ ] Feature can be disabled via feature flag
- [ ] Rollback plan tested in staging
- [ ] Support team briefed on changes

### Go/No-Go Decision
| Criterion | Status | Notes |
|-----------|--------|-------|
| Functional Complete | ✅/❌ | |
| Performance Acceptable | ✅/❌ | |
| Security Approved | ✅/❌ | |
| Monitoring Ready | ✅/❌ | |
| **DECISION** | **GO / NO-GO** | |
```

### Prioritization Methods

#### MoSCoW Method
Use MoSCoW method to prioritize requirements:

##### Must Have
- Essential for product success
- Non-negotiable
- Product won't work without these

##### Should Have
- Important but not critical
- Can be deferred if necessary
- Workarounds possible

##### Could Have
- Nice to have
- Delivered if time/resources permit
- Often cut in later releases

##### Won't Have (This Time)
- Explicitly excluded
- Acknowledged but not in scope
- May be future consideration

##### Prioritization Template
```markdown
| Priority | Feature | Justification |
|----------|---------|---------------|
| Must | User authentication | Cannot use product without login |
| Must | Payment processing | Required for revenue |
| Should | Social login | Improves conversion but email works |
| Should | Invoice generation | Manual workaround available |
| Could | Dark mode | Nice UX enhancement |
| Could | Multiple currencies | Current market is USD only |
| Won't | VR support | Out of scope for MVP |
```

#### RICE Scoring
A quantitative prioritization framework:

**Formula**: RICE Score = (Reach × Impact × Confidence) / Effort

| Factor | Description | Scale |
|--------|-------------|-------|
| **R**each | How many users will this affect in a given period? | Users/quarter (actual number) |
| **I**mpact | How much will this impact individual users? | 3 = Massive, 2 = High, 1 = Medium, 0.5 = Low, 0.25 = Minimal |
| **C**onfidence | How confident are we in our estimates? | 100% = High, 80% = Medium, 50% = Low |
| **E**ffort | How much work is required? | Person-months |

```markdown
### RICE Prioritization

| Feature | Reach (users/qtr) | Impact | Confidence | Effort (months) | RICE Score | Priority |
|---------|-------------------|--------|------------|-----------------|------------|----------|
| Feature A | 1000 | 3 | 80% | 2 | (1000×3×0.8)/2 = 1200 | 1 |
| Feature B | 500 | 2 | 100% | 1 | (500×2×1)/1 = 1000 | 2 |
| Feature C | 2000 | 1 | 50% | 3 | (2000×1×0.5)/3 = 333 | 3 |
```

#### Value/Effort Matrix
Visual prioritization based on value vs. effort:

```
     High │  Quick Wins       │  Major Projects
  Value  │  (Do First)       │  (Plan Carefully)
         │                   │
         ├───────────────────┼───────────────────
         │  Fill-ins         │  Time Sinks
         │  (Do Last)        │  (Avoid)
     Low │                   │
         └───────────────────┴───────────────────
              Low                 High
                    Effort
```

| Quadrant | Strategy | Examples |
|----------|----------|----------|
| **Quick Wins** (High Value, Low Effort) | Do first | Bug fixes, simple UX improvements |
| **Major Projects** (High Value, High Effort) | Plan carefully | New features, architecture changes |
| **Fill-ins** (Low Value, Low Effort) | Do when time permits | Minor polish, nice-to-haves |
| **Time Sinks** (Low Value, High Effort) | Avoid or defer | Complex features with unclear value |

### Additional Best Practices

#### Avoid Technical Jargon
Unless writing for a technical audience, focus on "what" not "how".

#### Include Visual References
- Wireframes
- Flow diagrams
- Mockups
- Data models

#### Consider Edge Cases
- Empty states
- Error conditions
- Maximum data loads
- Network failures
- Concurrent users

#### Keep Documents Version Controlled
- Track all changes
- Maintain change log
- Archive old versions

#### Make It Collaborative
- Share early drafts
- Invite feedback
- Iterate based on input

---

## Review and Approval Process

### PRD Lifecycle

```
Draft → Review → Revise → Approve → Implement → Update
```

### Review Stages

#### 1. Product Team Review
**Participants**: Product manager, product owner, business analyst
**Focus**: Completeness, clarity, alignment with strategy
**Checklist**:
- [ ] All sections are complete
- [ ] User stories follow 5W1H format
- [ ] Acceptance criteria are testable
- [ ] Business value is clear
- [ ] No contradictions or gaps

#### 2. Technical Review
**Participants**: Engineering lead, architects, senior developers
**Focus**: Feasibility, technical constraints, effort estimation
**Checklist**:
- [ ] Requirements are technically feasible
- [ ] Architecture considerations are addressed
- [ ] Dependencies are identified
- [ ] Non-functional requirements are realistic
- [ ] Risks are documented

#### 3. Design Review
**Participants**: UX/UI designers, design lead
**Focus**: User experience, design feasibility
**Checklist**:
- [ ] User flows are logical
- [ ] Design requirements are clear
- [ ] Accessibility needs are covered
- [ ] Mobile/responsive requirements are specified
- [ ] Brand guidelines are referenced

#### 4. Stakeholder Review
**Participants**: Business stakeholders, department heads, executives
**Focus**: Business alignment, ROI, priorities
**Checklist**:
- [ ] Objectives align with business goals
- [ ] Success metrics are measurable
- [ ] Timeline is realistic
- [ ] Resource needs are understood
- [ ] ROI is clear

#### 5. QA Review
**Participants**: QA lead, test engineers
**Focus**: Testability, edge cases, quality standards
**Checklist**:
- [ ] Acceptance criteria are testable
- [ ] Edge cases are documented
- [ ] Quality standards are defined
- [ ] Testing approach is feasible

### Lightweight Review Process (For Agile Teams)

For teams practicing continuous delivery or working on smaller features, use this streamlined process:

```markdown
## Lightweight Review Checklist

### Asynchronous Review (24-48 hour window)
- [ ] Product Owner reviews for completeness
- [ ] Tech Lead reviews for feasibility
- [ ] Designer reviews for UX clarity
- [ ] At least one stakeholder reviews for business alignment

### Sync Review Meeting (30 min max)
**Agenda**:
1. Product Owner walks through key decisions (5 min)
2. Technical feasibility discussion (10 min)
3. Open questions/clarifications (10 min)
4. Go/No-go decision (5 min)

### Approval
- 👍 = Approved to proceed
- 🤔 = Minor revisions needed (async follow-up)
- 🛑 = Major revisions needed (another review required)

### When to Use Lightweight Process
✅ Small features (< 2 weeks)
✅ Iterative improvements
✅ Well-understood domains
✅ Experienced teams with shared context

### When to Use Full Process
❌ New product launches
❌ Major architectural changes
❌ Cross-team dependencies
❌ High-risk or compliance-related features
```

### Approval Workflow

```markdown
| Stage | Approver | Sign-off Required |
|-------|----------|-------------------|
| Draft Complete | Product Owner | Yes |
| Technical Feasibility | Engineering Lead | Yes |
| Design Review | Design Lead | Yes |
| Business Alignment | Executive Sponsor | Yes |
| Final Approval | Product Director | Yes |
```

### Change Management

#### Minor Changes
- Typos, clarifications, formatting
- Can be made directly by author
- Update version number (patch: 1.0.1)

#### Medium Changes
- New requirements, scope adjustments
- Requires review by affected teams
- Update version number (minor: 1.1.0)

#### Major Changes
- Significant scope changes, timeline shifts
- Requires full re-review process
- Update version number (major: 2.0.0)

### Version Control Best Practices

```markdown
### Change Log

| Version | Date | Author | Changes | Approver |
|---------|------|--------|---------|----------|
| 1.0.0 | 2024-01-15 | Jane Smith | Initial PRD | John Doe |
| 1.1.0 | 2024-01-22 | Jane Smith | Added export feature requirements | John Doe |
| 1.1.1 | 2024-01-25 | Jane Smith | Fixed typos, clarified AC | - |
```

---

## PRD Template Examples

### Template 1: New Product PRD

```markdown
# Product Requirements Document: [Product Name]

**Version**: 1.0.0
**Date**: 2024-01-15
**Author**: [Product Owner]
**Status**: Draft

---

## 1. Executive Summary

### 1.1 Product Vision
[One-sentence vision statement]

### 1.2 Problem Statement
[What problem are we solving?]

### 1.3 Solution Overview
[High-level description of the solution]

### 1.4 Target Market
[Who will use this product?]

### 1.5 Success Metrics
- Metric 1: [Target value]
- Metric 2: [Target value]

---

## 2. Objectives and Goals

### 2.1 Business Objectives
1. [Objective 1 with measurable outcome]
2. [Objective 2 with measurable outcome]

### 2.2 Product Objectives
1. [Objective 1]
2. [Objective 2]

### 2.3 Key Results (OKRs)
- KR1: [Specific, measurable result]
- KR2: [Specific, measurable result]

---

## 3. Out of Scope

| Item | Reason | Future Consideration |
|------|--------|---------------------|
| [Feature X] | [Why excluded] | [When considered] |

---

## 4. Assumptions

| ID | Assumption | Validation | Owner | Due Date | Status |
|----|------------|------------|-------|----------|--------|
| A-01 | [Assumption] | [Method] | [Name] | [Date] | Pending |

---

## 5. User Personas

### 5.1 Primary Persona: [Name]
- **Role**: [Job title]
- **Demographics**: [Age, location, etc.]
- **Goals**: [What they want to achieve]
- **Pain Points**: [Current frustrations]
- **Quote**: "[Representative statement]"

### 5.2 Secondary Persona: [Name]
...

---

## 6. User Stories

### Epic 1: [Epic Name]

#### Story 1.1
**As a** [who], **when** [when], **where** [where], 
**I want to** [do what], **so that** [why].

**Acceptance Criteria:**
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

**Priority**: [Must/Should/Could/Won't]
**Story Points**: [Effort estimate]

#### Story 1.2
...

### Epic 2: [Epic Name]
...

---

## 7. Functional Requirements

### 7.1 Feature Set A
#### FR-001: [Requirement Name]
**Description**: [Detailed description]
**Priority**: [Must/Should/Could/Won't]
**User Stories**: [Related story IDs]

#### FR-002: [Requirement Name]
...

### 7.2 Feature Set B
...

---

## 8. Non-Functional Requirements

### 8.1 Performance
- [Performance requirement 1]
- [Performance requirement 2]

### 8.2 Security
- [Security requirement 1]
- [Security requirement 2]

### 8.3 Scalability
- [Scalability requirement 1]
- [Scalability requirement 2]

### 8.4 Reliability
- [Reliability requirement 1]
- [Reliability requirement 2]

---

## 9. Data & Analytics Requirements

### 9.1 Event Tracking
| Event | Trigger | Properties |
|-------|---------|------------|
| [event_name] | [trigger] | [properties] |

### 9.2 Metrics
- [Metric 1]: [Definition and target]

### 9.3 Dashboards
- [Dashboard 1]: [Audience and widgets]

---

## 10. Design Requirements

### 10.1 User Experience
- [UX requirement 1]
- [UX requirement 2]

### 10.2 Visual Design
- [Design requirement 1]
- [Design requirement 2]

### 10.3 Technical Architecture
- [Architecture requirement 1]
- [Architecture requirement 2]

---

## 11. Timeline and Roadmap

### Phase 1: MVP (Month 1-2)
- Feature 1
- Feature 2
**Success Criteria**: [Measurable outcome]

### Phase 2: Growth (Month 3-4)
- Feature 3
- Feature 4
**Success Criteria**: [Measurable outcome]

### Phase 3: Scale (Month 5-6)
- Feature 5
- Performance optimization
**Success Criteria**: [Measurable outcome]

---

## 12. Success Metrics

### 12.1 Primary Metrics
- **Metric Name**: [Definition]
  - Baseline: [Current value]
  - Target: [Goal value]
  - Timeline: [When to achieve]

### 12.2 Secondary Metrics
...

### 12.3 Counter Metrics
...

---

## 13. Release Criteria

### 13.1 Functional
- [ ] All acceptance criteria validated
- [ ] No critical bugs

### 13.2 Performance
- [ ] Load testing passed
- [ ] Latency requirements met

### 13.3 Go/No-Go Decision
**Status**: [GO / NO-GO]
**Date**: [Date]
**Approver**: [Name]

---

## 14. Open Questions and Risks

### 14.1 Open Questions
1. [Question 1]
2. [Question 2]

### 14.2 Risks
| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| [Risk 1] | High/Med/Low | High/Med/Low | [Strategy] |
| [Risk 2] | High/Med/Low | High/Med/Low | [Strategy] |

---

## 15. Dependencies

### 15.1 Technical Dependencies
- [Dependency 1]
- [Dependency 2]

### 15.2 Business Dependencies
- [Dependency 1]
- [Dependency 2]

### 15.3 External Dependencies
- [Dependency 1]
- [Dependency 2]

---

## 16. Appendices

### 16.1 Glossary
- **Term 1**: [Definition]
- **Term 2**: [Definition]

### 16.2 References
- [Link to research]
- [Link to designs]
- [Link to related documents]

### 16.3 Change Log
| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | 2024-01-15 | [Name] | Initial version |
```

### Template 2: Feature PRD

```markdown
# Feature Requirements Document: [Feature Name]

**Version**: 1.0.0
**Date**: 2024-01-15
**Author**: [Product Owner]
**Status**: Draft
**Related PRD**: [Link to parent PRD]

---

## 1. Overview

### 1.1 Feature Summary
[Brief description of the feature]

### 1.2 Business Justification
[Why are we building this?]

### 1.3 Success Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]

---

## 2. Out of Scope

[Explicitly what's NOT included]

---

## 3. Assumptions

| ID | Assumption | Status |
|----|------------|--------|
| A-01 | [Assumption] | Pending |

---

## 4. User Stories

### Primary User Story
**As a** [who], **when** [when], **where** [where], 
**I want to** [do what], **so that** [why].

**Acceptance Criteria:**
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

**Priority**: Must
**Effort**: [Story points or time estimate]

### Secondary User Stories
...

---

## 5. Functional Specifications

### 5.1 User Flow
[Step-by-step description or diagram reference]

### 5.2 UI Components
| Component | Description | Behavior |
|-----------|-------------|----------|
| [Component 1] | [Description] | [Behavior] |
| [Component 2] | [Description] | [Behavior] |

### 5.3 Business Rules
1. [Rule 1]
2. [Rule 2]

### 5.4 Edge Cases
| Scenario | Expected Behavior |
|----------|-------------------|
| [Edge case 1] | [Behavior] |
| [Edge case 2] | [Behavior] |

---

## 6. Technical Requirements

### 6.1 API Requirements
[API specifications or reference]

### 6.2 Data Requirements
[Data models, schema changes]

### 6.3 Integration Points
[Third-party integrations]

### 6.4 Performance Requirements
- [Requirement 1]
- [Requirement 2]

---

## 7. Data & Analytics

### 7.1 Events to Track
| Event | Properties |
|-------|------------|
| [event] | [props] |

### 7.2 Success Metrics
- [Metric 1]
- [Metric 2]

---

## 8. Design

### 8.1 Wireframes/Mockups
[Links to designs]

### 8.2 Interaction Design
[Key interactions and animations]

### 8.3 Responsive Behavior
[Mobile, tablet, desktop differences]

---

## 9. Testing Considerations

### 9.1 Test Scenarios
1. [Scenario 1]
2. [Scenario 2]

### 9.2 Test Data Requirements
[What data is needed for testing]

### 9.3 Browser/Device Testing
[List of supported browsers/devices]

---

## 10. Release Criteria

### 10.1 Go/No-Go Checklist
- [ ] [Criterion 1]
- [ ] [Criterion 2]

### 10.2 Rollout Plan
[Phased rollout, feature flags, etc.]

### 10.3 Monitoring
[What to monitor post-release]

### 10.4 Rollback Plan
[Procedure if issues arise]

---

## 11. Timeline

| Milestone | Date | Owner |
|-----------|------|-------|
| Design complete | [Date] | [Owner] |
| Development starts | [Date] | [Owner] |
| QA complete | [Date] | [Owner] |
| Release | [Date] | [Owner] |

---

## 12. Open Items

| Item | Owner | Due Date | Status |
|------|-------|----------|--------|
| [Item 1] | [Owner] | [Date] | Open |
| [Item 2] | [Owner] | [Date] | Open |
```

### Template 3: Sprint Planning Guide

```markdown
# Sprint Planning Guide: [Sprint Name]

**Sprint**: [Number/Name]
**Dates**: [Start Date] - [End Date]
**Goal**: [One-sentence sprint goal]
**Product Owner**: [Name]
**Scrum Master**: [Name]

---

## 1. Sprint Goal
[What we aim to achieve this sprint]

---

## 2. User Stories

### Story 1: [Title]
**As a** [who], **I want to** [do what], **so that** [why].

**Acceptance Criteria:**
- [ ] [Criterion 1]
- [ ] [Criterion 2]

**Priority**: Must
**Story Points**: [X]
**Assignee**: [Name]

### Story 2: [Title]
...

---

## 3. Sprint Backlog

| ID | Story | Points | Assignee | Status |
|----|-------|--------|----------|--------|
| 1 | [Story 1] | 5 | [Name] | To Do |
| 2 | [Story 2] | 3 | [Name] | To Do |

---

## 4. Definition of Done

- [ ] Code written and reviewed
- [ ] Unit tests passing (>80% coverage)
- [ ] Integration tests passing
- [ ] QA acceptance criteria met
- [ ] Documentation updated
- [ ] Product owner approval

---

## 5. Dependencies and Blockers

| Dependency | Status | Owner | Notes |
|------------|--------|-------|-------|
| [Dependency 1] | [Status] | [Owner] | [Notes] |
| [Blocker 1] | [Status] | [Owner] | [Notes] |

---

## 6. Notes and Decisions

- [Decision 1]
- [Decision 2]

---

## 7. Retrospective Notes

### What Went Well
- [Item 1]
- [Item 2]

### What Could Be Improved
- [Item 1]
- [Item 2]

### Action Items
| Action | Owner | Due Date |
|--------|-------|----------|
| [Action 1] | [Owner] | [Date] |
```

---

## Quick Reference Checklist

### Before Starting a PRD
- [ ] Understand the business problem
- [ ] Identify key stakeholders
- [ ] Research user needs
- [ ] Review existing documentation

### During PRD Writing
- [ ] Follow the 5W1H format for user stories
- [ ] Include specific, measurable acceptance criteria
- [ ] Consider edge cases
- [ ] Document assumptions
- [ ] Define what's out of scope
- [ ] Use MoSCoW prioritization

### Before Finalizing
- [ ] Review for clarity and completeness
- [ ] Validate with stakeholders
- [ ] Get technical feasibility confirmation
- [ ] Check for contradictions
- [ ] Ensure testability

### After Approval
- [ ] Share with the team
- [ ] Schedule kickoff meeting
- [ ] Set up tracking/tickets
- [ ] Plan review cadence

---

## Summary

This PRD guideline provides a comprehensive framework for product owners to create clear, actionable, and effective product requirements. By following the 5W1H framework (Who, When, Where, What, Why, How) based on the classic problem-solving method, and incorporating best practices from Atlassian and modern agile methodologies, you can:

1. **Reduce ambiguity**: Clear requirements lead to better implementation
2. **Improve collaboration**: Shared understanding across teams
3. **Increase success rates**: Well-defined requirements are more likely to meet user needs
4. **Enable better estimation**: Detailed stories allow for accurate effort estimation
5. **Facilitate testing**: Testable acceptance criteria ensure quality

Remember: A PRD is a living document. Iterate, gather feedback, and update as you learn more about your users and product.

---

*Document Version: 2.0.0*
*Last Updated: 2024*
