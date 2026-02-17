# Figma Design Guidelines

> Based on Figma Official Best Practices, Design Systems Documentation, and Industry Standards

---

## Figma Setup

### File Structure

**Visual:**
```
✅ CORRECT - Recommended File Organization:

📁 Project Name
│
├── 📄 00 - Cover
│   └── Project thumbnail and overview
│
├── 📄 01 - Foundation
│   ├── Color Palette
│   ├── Typography Scale
│   ├── Spacing System
│   └── Icon Library
│
├── 📄 02 - Components
│   ├── Atoms
│   ├── Molecules
│   └── Organisms
│
├── 📄 03 - Patterns
│   ├── Form Patterns
│   ├── Navigation Patterns
│   └── Data Display
│
├── 📄 04 - Templates
│   ├── Web Layouts
│   └── Mobile Layouts
│
├── 📄 05 - Prototypes
│   └── User Flows
│
└── 📄 06 - Archive
    └── Deprecated components
```

### Page Structure

**Visual:**
```
✅ CORRECT - Page Naming Convention:

📄 00 - Cover                    (Always first for thumbnail)
📄 01 - Foundation              (Design tokens and styles)
📄 02 - Components              (Main component library)
📄 03 - Patterns                (Composite patterns)
📄 04 - Templates               (Page-level layouts)
📄 05 - Prototypes              (Interactive flows)
📄 06 - Documentation           (Usage guidelines)
📄 07 - Archive                 (Deprecated items)
📄 99 - Playground              (Experimentation space)
```

### Essential Plugins

**Visual:**
```
✅ CORRECT - Recommended Plugin Stack:

Design System Plugins:
├── Tokens Studio for Figma        (Design tokens management)
├── Stark Accessibility            (Color contrast, color blindness)
├── Autoflow                       (User flow diagrams)
└── Content Reel                   (Realistic placeholder content)

Productivity Plugins:
├── Unsplash                       (Stock photography)
├── Iconify                        (Icon library access)
├── Lorem ipsum                    (Placeholder text)
└── Rename It                      (Batch layer renaming)

Developer Handoff:
├── Figma to Code                  (Code generation)
├── Measure                        (Spacing measurements)
└── HTML to Figma                  (Import existing code)
```

### Grid Setup Standards

**Visual:**
```
✅ CORRECT - Grid Configuration:

8px Baseline Grid:
┌─────────────────────────────────────┐
│                                     │
│ ───────────────────  0px            │
│                                     │
│ ───────────────────  8px            │
│                                     │
│ ───────────────────  16px           │
│                                     │
│ ───────────────────  24px           │
│                                     │
│ ───────────────────  32px           │
│                                     │
└─────────────────────────────────────┘
Settings: Grid size: 8px, Color: #FF0000, Opacity: 10%

Column Grid (Desktop - 1200px):
┌─────────────────────────────────────┐
│ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │
│ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │
│ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │
│ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │ │
└─────────────────────────────────────┘
Columns: 12, Gutter: 24px, Margin: 120px

Column Grid (Tablet - 768px):
┌─────────────────────────┐
│ │ │ │ │ │ │ │ │ │ │ │ │ │
│ │ │ │ │ │ │ │ │ │ │ │ │ │
│ │ │ │ │ │ │ │ │ │ │ │ │ │
└─────────────────────────┘
Columns: 8, Gutter: 16px, Margin: 40px

Column Grid (Mobile - 375px):
┌─────────────┐
│ │ │ │ │ │ │ │
│ │ │ │ │ │ │ │
└─────────────┘
Columns: 4, Gutter: 16px, Margin: 16px
```

### DON'T: Mix Grid Systems

**Visual:**
```
❌ INCORRECT - Inconsistent Grid Usage:

Page 1: 12-column, 20px gutter
Page 2: 10-column, 24px gutter
Page 3: No grid, arbitrary spacing

✅ CORRECT - Consistent Grid System:

All Pages:
├── Desktop: 12-col, 24px gutter
├── Tablet: 8-col, 16px gutter
└── Mobile: 4-col, 16px gutter
```

### Default Styles to Create First

**Visual:**
```
✅ CORRECT - Foundation Styles Priority:

Priority 1 - Create First:
├── Colors (Primitive)
│   ├── Brand/50, 100, 200... 900
│   ├── Neutral/White, 100, 200... 900, Black
│   ├── Semantic/Success, Warning, Error, Info
│   └── Alpha/Black-A10...A80, White-A10...A80
│
├── Typography
│   ├── Heading/H1, H2, H3, H4, H5, H6
│   ├── Body/Large, Medium, Small
│   ├── Caption
│   └── Code/Monospace
│
└── Effects
    ├── Shadow/Small, Medium, Large, Extra Large
    └── Blur/Backdrop, Focus Ring

Priority 2 - Next:
├── Spacing variables (4, 8, 16, 24, 32, 48, 64)
├── Border radius tokens
└── Layout grids

Priority 3 - Component Styles:
└── Component-specific styles (buttons, inputs, etc.)
```

---

## Overview

These guidelines ensure Figma designs are consistent, maintainable, and scalable across teams. They combine:
- Figma's official component and variant best practices
- Design systems architecture recommendations
- Atomic design methodology principles
- Developer handoff optimization techniques
- Team collaboration standards

---

## Variables

### Variable Types and Use Cases

**Visual:**
```
✅ CORRECT - Variable Categories:

┌─────────────────────────────────────────────────────────┐
│                   Figma Variables                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  📏 Number Variables                                    │
│  ├── Spacing: 4, 8, 16, 24, 32, 48, 64, 96             │
│  ├── Border Radius: 4, 8, 12, 16, 24, 9999 (full)      │
│  ├── Font Sizes: 12, 14, 16, 18, 20, 24, 32, 40        │
│  └── Line Heights: 16, 20, 24, 28, 32, 40, 48, 56      │
│                                                         │
│  🎨 Color Variables                                     │
│  ├── Primitives: Red-500, Blue-500, etc.               │
│  ├── Semantic: Background-Primary, Text-Primary        │
│  └── Component: Button-Primary-BG, Button-Text         │
│                                                         │
│  📝 String Variables                                    │
│  ├── Content: "Submit", "Cancel", "Learn More"         │
│  ├── URLs: "https://example.com"                       │
│  └── Keys: "button-primary-label"                      │
│                                                         │
│  ✅ Boolean Variables                                   │
│  ├── showIcon: true/false                              │
│  ├── isVisible: true/false                             │
│  └── hasShadow: true/false                             │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### DO: Use Variables for Spacing

**Visual:**
```
✅ CORRECT - Spacing Variable System:

Variable Name              Value    Usage
─────────────────────────────────────────────
spacing/4                   4px     Tight gaps, icon padding
spacing/8                   8px     Default gap between items
spacing/12                 12px     Button padding (vertical)
spacing/16                 16px     Default container padding
spacing/24                 24px     Card padding, section gaps
spacing/32                 32px     Large section spacing
spacing/48                 48px     Major section breaks
spacing/64                 64px     Page-level spacing

Application:
┌─────────────────────────────────────────┐
│                                         │
│     ┌─────────────────────────────┐     │
│     │                             │     │  spacing/32 (32px)
│     │    spacing/24 (24px)        │     │
│     │    ┌─────────────────┐      │     │
│     │    │  [Icon]  Text   │      │     │  spacing/16 (16px)
│     │    │       ↑         │      │     │  ↑ gap: spacing/8
│     │    └─────────────────┘      │     │
│     │                             │     │
│     └─────────────────────────────┘     │
│                                         │
└─────────────────────────────────────────┘
```

### DO: Create Color Variable Modes

**Visual:**
```
✅ CORRECT - Color Variable Modes:

Variable: Color/Background/Primary
├── Mode: Light  →  #FFFFFF
├── Mode: Dark   →  #0A0A0A
└── Mode: Dim    →  #141414

Variable: Color/Text/Primary
├── Mode: Light  →  #000000
├── Mode: Dark   →  #FFFFFF
└── Mode: Dim    →  #E6E6E6

Application in Component:
┌─────────────────────────┐
│                         │
│    Button Primary       │  ← Uses Color/Background/Primary
│                         │     Auto-switches with mode
└─────────────────────────┘

Mode Switching:
Light Mode: White BG, Black Text
Dark Mode:  Black BG, White Text
Dim Mode:   Dark Gray BG, Light Gray Text
```

### DON'T: Hardcode Values

**Visual:**
```
❌ INCORRECT - Hardcoded Values:

Card Component:
┌─────────────────────────┐
│  Padding: 20px         │  ← Hardcoded (not divisible by 4)
│  Gap: 15px             │  ← Hardcoded
│  Border Radius: 13px   │  ← Hardcoded (odd number)
└─────────────────────────┘

✅ CORRECT - Using Variables:

Card Component:
┌─────────────────────────┐
│  Padding: spacing/24   │  ← 24px
│  Gap: spacing/8        │  ← 8px
│  Border Radius: 8      │  ← radius/md
└─────────────────────────┘
```

### DO: Organize Variable Collections

**Visual:**
```
✅ CORRECT - Collection Structure:

🗂️ Collection: Primitives
├── Primitive/Color/Brand/Red/500
├── Primitive/Color/Brand/Blue/500
├── Primitive/Number/Spacing/8
└── Primitive/Number/Radius/8

🗂️ Collection: Semantic
├── Semantic/Color/Background/Primary
├── Semantic/Color/Text/Primary
├── Semantic/Color/Border/Default
└── Semantic/Color/Action/Primary

🗂️ Collection: Component Tokens
├── Component/Button/Background/Primary
├── Component/Button/Text/Primary
├── Component/Input/Border/Focus
└── Component/Card/Background

Hierarchy:
Primitives → Semantic → Component
(Concrete)  → (Meaning) → (Usage)
```

### Variable Scoping

**Visual:**
```
✅ CORRECT - Variable Scoping:

Local Variables (File Only):
┌─────────────────────────────┐
│  📄 File: Homepage Design   │
│  ├── Local/Spacing/Custom   │
│  └── Local/Color/Brand-Alt  │
└─────────────────────────────┘
                          ↑
                          Only available in this file

Library Variables (Published):
┌─────────────────────────────┐
│  🌍 Library: Design System  │
│  ├── DS/Spacing/8           │
│  ├── DS/Color/Primary       │
│  └── DS/Number/Radius/8     │
└─────────────────────────────┘
                          ↑
                          Available across all files

Best Practice:
- Use library variables for shared values
- Use local variables for file-specific needs only
- Publish library updates for global changes
```

### DO: Use Variable Aliasing

**Visual:**
```
✅ CORRECT - Variable Aliasing:

Token Hierarchy:
┌──────────────────────────────────────────┐
│  Brand Color: Red-500 = #EF4444          │
│       ↓                                  │
│  Semantic: Action-Primary → Red-500      │
│       ↓                                  │
│  Component: Button-BG-Primary → Action-Primary│
└──────────────────────────────────────────┘

Benefits:
1. Change Brand-500 once → cascades everywhere
2. Multiple brands: Swap primitive collection
3. Theming: Different semantic mappings per mode

Change Brand Color:
Brand/Red/500: #EF4444 → #DC2626
    ↓
Button-BG-Primary automatically updates
```

### Variable Modes and Context

**Visual:**
```
✅ CORRECT - Mode Configuration:

Collections with Modes:

🎨 Collection: Colors
├── Mode: Light (default)
├── Mode: Dark
└── Mode: High Contrast

📏 Collection: Density
├── Mode: Compact (smaller spacing)
├── Mode: Default
└── Mode: Spacious (larger spacing)

📱 Collection: Platform
├── Mode: Desktop
├── Mode: Tablet
└── Mode: Mobile

Applying Modes to Frames:
┌─────────────────────────────┐
│  Frame: Dashboard           │
│  ├── Colors: Dark          │
│  ├── Density: Compact      │
│  └── Platform: Desktop     │
└─────────────────────────────┘
    ↓
All nested components use these mode values
```

---

## Design Tokens

### Token Hierarchy

**Visual:**
```
✅ CORRECT - Token Architecture:

┌─────────────────────────────────────────────────────────┐
│                   TOKEN HIERARCHY                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Level 1: PRIMITIVE TOKENS                              │
│  └── Raw values, platform-agnostic                      │
│                                                         │
│      color.red.500 = #EF4444                           │
│      color.blue.500 = #3B82F6                          │
│      spacing.4 = 4px                                   │
│      spacing.8 = 8px                                   │
│                                                         │
│            ↓                                            │
│                                                         │
│  Level 2: SEMANTIC TOKENS                               │
│  └── Meaning and purpose                                │
│                                                         │
│      color.background.primary = color.white            │
│      color.text.primary = color.gray.900               │
│      color.action.primary = color.blue.500             │
│      spacing.section = spacing.32                      │
│                                                         │
│            ↓                                            │
│                                                         │
│  Level 3: COMPONENT TOKENS                              │
│  └── Component-specific usage                           │
│                                                         │
│      button.background.primary = color.action.primary  │
│      button.text.primary = color.white                 │
│      button.padding = spacing.4 spacing.8             │
│      card.background = color.background.secondary      │
│                                                         │
└─────────────────────────────────────────────────────────┘

Token Flow:
Primitive → Semantic → Component → Implementation
```

### Token Naming Conventions

**Visual:**
```
✅ CORRECT - Naming Pattern:

Format: [category]/[type]/[variant]/[state]

color/background/primary/default
color/background/primary/hover
color/text/primary/default
color/text/secondary/disabled
color/border/default/focus
color/action/primary/default
color/action/primary/hover

spacing/4, spacing/8, spacing/16, spacing/24
spacing/component/button/padding-x
spacing/component/button/padding-y
spacing/component/card/gap

font/size/small, font/size/medium, font/size/large
font/weight/regular, font/weight/bold
font/line-height/20, font/line-height/24

radius/small (4px), radius/medium (8px)
radius/large (16px), radius/full (9999px)

Naming Rules:
✓ Use lowercase only
✓ Use hyphens for multi-word (-)
✓ Use forward slashes for hierarchy (/)
✓ Be descriptive but concise
✗ No spaces, no camelCase
```

### DO: Sync Tokens with Code

**Visual:**
```
✅ CORRECT - Token Sync Workflow:

Figma Tokens Studio                  Code Repository
        │                                    │
        │ Export: tokens.json                │
        │ ────────────────────────────────>  │
        │                                    │
        │                                    │ Transform: Style Dictionary
        │                                    │
        │                                    │ Generate: CSS, SCSS, JS, etc.
        │                                    │
        │ Import: Updated values             │
        │ <────────────────────────────────  │
        │                                    │

Token File Structure:
tokens/
├── primitive/
│   ├── colors.json
│   ├── spacing.json
│   └── typography.json
├── semantic/
│   ├── colors.json
│   └── spacing.json
└── component/
    ├── button.json
    └── card.json

Sync Commands:
1. Export from Figma: Tokens Studio → Export → tokens.json
2. Transform: npx style-dictionary build
3. Import to Figma: Tokens Studio → Import → tokens.json
```

### DON'T: Break Token References

**Visual:**
```
❌ INCORRECT - Breaking Token Chain:

Button Component:
Background: #3B82F6  ← Hardcoded color
    ↓
Theme change doesn't affect button

✅ CORRECT - Maintaining Token References:

Button Component:
Background: component.button.background.primary
    ↓
References: semantic.color.action.primary
    ↓
References: primitive.color.blue.500
    ↓
Value: #3B82F6

Theme Change:
primitive.color.blue.500 → primitive.color.red.500
    ↓
All components update automatically
```

---

## Components and Styles Management

### Atomic Design Approach

Structure your design system using the atomic design methodology: atoms → molecules → organisms → templates → pages.

```
📁 Design System
├── 🧬 Atoms (Foundation)
│   ├── Colors
│   ├── Typography
│   ├── Spacing
│   └── Effects
├── 🧪 Molecules (Simple Components)
│   ├── Buttons
│   ├── Inputs
│   └── Icons
├── 🦠 Organisms (Complex Components)
│   ├── Forms
│   ├── Cards
│   └── Navigation
├── 📐 Templates (Layouts)
└── 📄 Pages (Screens)
```

### DO: Build From the Ground Up

**Start with atoms** (colors, typography, spacing) and build up to complex components.

**Visual:**
```
✅ CORRECT:

Foundation           Components              Patterns
─────────          ───────────             ────────
[Red/500]     →    [Button Primary]   →    [Login Form]
[Text/Body]   →    [Input Field]      →    [Checkout Flow]
[Space/16]    →    [Icon Button]      →    [Navigation]
```

### DON'T: Create Isolated Components

**Visual:**
```
❌ INCORRECT:

[Login Button]     [Red Color]     [Body Text]
     ↓                 ↓                ↓
  (uses hardcoded   (unused)        (separate)
   values)
```

### DO: Create Reusable Components

Convert frequently used elements into main components. Place main components on dedicated "Components" page or in separate library files.

**Visual:**
```
✅ CORRECT:

Main Component                              Instances
──────────────                              ─────────
┌─────────────┐                    ┌─────────────┐  ┌─────────────┐
│   Button    │ ─────────────────→ │   Button    │  │   Button    │
│  Primary    │     (publish)      │  (Hover)    │  │ (Disabled)  │
│             │                    │             │  │             │
└─────────────┘                    └─────────────┘  └─────────────┘
   (Component Page)                  (Design Files)
```

### DON'T: Detach Components Without Reason

Detaching removes the link to the main component and prevents updates from propagating.

**Visual:**
```
❌ INCORRECT:

Main: [Button Primary] ──X──> [Detached Button] (manual edits, won't sync)
                                  ↓
                          (updates won't apply)

✅ CORRECT:

Main: [Button Primary] ──────> [Button Instance]
                                  ↓
                          (variants allow customization)
```

### DO: Use Variants Effectively

Combine related component states into a single component with variants.

**Visual:**
```
✅ CORRECT - Single Component with Variants:

Component: Button
Variants:
├── Type: Primary | Secondary | Tertiary | Ghost
├── Size: Small | Medium | Large
├── State: Default | Hover | Active | Disabled | Loading
└── Icon: None | Left | Right | Only

Total combinations: 4 × 3 × 5 × 4 = 240 (in one component!)
```

### DON'T: Create Separate Components for States

**Visual:**
```
❌ INCORRECT:

Components:
├── Button Primary Default
├── Button Primary Hover
├── Button Primary Active
├── Button Primary Disabled
├── Button Secondary Default
├── Button Secondary Hover
... (24+ separate components for basic button)
```

### DO: Publish and Share Libraries

Organize shared libraries by team or product area.

**Visual:**
```
✅ CORRECT:

🌍 Organization Library
   └── Core Design System
       ├── Primitives (colors, type, spacing)
       ├── Components
       └── Patterns

📁 Team Libraries
   ├── Product A Library
   ├── Product B Library
   └── Marketing Library
```

---

## Component Architecture

### DO: Use Nested Components

Build complex components from smaller, reusable pieces.

**Visual:**
```
✅ CORRECT - Nested Structure:

Card Component
├── Header (nested component)
│   ├── Avatar (nested component)
│   └── Title Text
├── Body Content
├── Actions Row
│   ├── Button Primary (nested component)
│   └── Button Secondary (nested component)
└── Footer
```

### DO: Enable Instance Swapping

Set up components to allow swapping nested instances without detaching.

**Visual:**
```
✅ CORRECT:

Modal Component Structure:
┌─────────────────────────────────┐
│         Modal Header            │
│   ┌─────────────────────┐       │
│   │  [Icon Component]   │ ←── Swap for any icon
│   └─────────────────────┘       │
├─────────────────────────────────┤
│         Modal Body              │
│   ┌─────────────────────┐       │
│   │ [Content Component] │ ←── Swap for card/form/etc
│   └─────────────────────┘       │
├─────────────────────────────────┤
│         Modal Footer            │
│   ┌─────────┐  ┌─────────┐      │
│   │[Button] │  │[Button] │ ←── Swap button variants
│   └─────────┘  └─────────┘      │
└─────────────────────────────────┘
```

### Component Properties

**Visual:**
```
✅ CORRECT - Property Types:

Boolean Properties (Show/Hide):
┌───────────────────────────┐
│ ┌─────────────────────┐   │
│ │   [Icon]  Label     │   │  hasIcon: true
│ └─────────────────────┘   │
├───────────────────────────┤
│                           │
│       Label Only          │  hasIcon: false
│                           │
└───────────────────────────┘
Property: "hasIcon" (boolean)
  - true: Show icon layer
  - false: Hide icon layer

Instance Swap Properties:
┌───────────────────────────┐
│ ┌─────────────────────┐   │
│ │    [Icon Placeholder]│   │  ← Swap for any icon
│ └─────────────────────┘   │     Property: "icon"
│       Card Title          │
└───────────────────────────┘

Text Properties:
┌───────────────────────────┐
│ ┌─────────────────────┐   │
│ │  [Button Text]      │   │  ← Override text
│ └─────────────────────┘   │     Property: "label"
└───────────────────────────┘

Variant Properties:
Component: Button
├── Property: Type (Primary, Secondary, Tertiary)
├── Property: Size (Small, Medium, Large)
└── Property: State (Default, Hover, Disabled)
```

### Property Naming Conventions

**Visual:**
```
✅ CORRECT - Naming Properties:

Boolean Properties:
├── hasIcon (not "showIcon" or "icon")
├── isVisible (not "visible")
├── hasShadow (not "shadow")
└── isExpanded (not "expanded")

Text Properties:
├── label (not "text" or "copy")
├── title (for headings)
├── description (for body text)
└── placeholder (for hints)

Instance Swap:
├── icon (not "iconType")
├── leadingIcon (for left side)
├── trailingIcon (for right side)
└── thumbnail (for images)

Variant Properties:
├── type (not "kind" or "variant")
├── size (Small, Medium, Large)
├── state (Default, Hover, Active)
└── alignment (Left, Center, Right)
```

### DO: Set Up Constraints and Layout Grids

Define how components respond to resizing.

**Visual:**
```
✅ CORRECT - Constraint Setup:

┌────────────────────────────────────────────┐
│  [Logo]      Center Title         [Menu]   │
│  (Left+Top)   (Center+Top)       (Right+Top)│
├────────────────────────────────────────────┤
│                                            │
│           Content Area                     │
│         (Scale or Hug)                     │
│                                            │
├────────────────────────────────────────────┤
│         [Footer Content]                   │
│         (Left+Bottom)                      │
└────────────────────────────────────────────┘

Constraints:
- Fixed elements: Use specific constraints (Left, Right, Top, Bottom)
- Fluid elements: Use Scale or Center
- Text: Usually Left+Top with Auto Width/Height
```

### DO: Use Auto Layout Effectively

**Visual:**
```
✅ CORRECT - Auto Layout Patterns:

Horizontal Auto Layout (Buttons Row):
┌─────────┐  ┌─────────┐  ┌─────────┐
│ Cancel  │→ │  Save   │→ │ Publish │  Direction: Right
│ (100px) │  │ (100px) │  │ (100px) │  Gap: 16px
└─────────┘  └─────────┘  └─────────┘  Padding: 0

Vertical Auto Layout (Card):
┌─────────────────────────┐
│        Header           │  Direction: Down
├─────────────────────────┤  Gap: 0
│        Image            │  Padding: 24px
├─────────────────────────┤
│        Body             │  Fill container: Yes
│        Text             │
├─────────────────────────┤
│     [Actions]           │
└─────────────────────────┘

Nested Auto Layout (Button):
┌───────────────────────────┐
│  [Icon]  →  "Label"  →  │  Hug contents
└───────────────────────────┘  Gap: 8px
                               Padding: 12px 24px
```

### Advanced Auto Layout Features

**Visual:**
```
✅ CORRECT - Advanced Auto Layout:

Min/Max Width/Height:
┌───────────────────────────────────┐
│                                   │
│   [Content with constraints]     │
│                                   │
│   Min Width: 200px               │
│   Max Width: 400px               │
│                                   │
└───────────────────────────────────┘

Text Truncation:
┌─────────────────────────┐
│ This is a long title... │  ← Truncated at container edge
└─────────────────────────┘
Setting: Text layer → Truncate

Wrap for Responsive Grids:
┌───────────────────────────────┐
│ [Item] [Item] [Item]         │
│ [Item] [Item]                │  Wrap enabled
└───────────────────────────────┘
Setting: Auto Layout → Wrap

Absolute Positioning:
┌────────────────────────────────┐
│  ┌──────────────────────┐     │
│  │                      │ 👆   │
│  │                      │  ↑   │
│  │   Card Content       │ Badge (absolute)
│  │                      │     │
│  └──────────────────────┘     │
└────────────────────────────────┘
Use: Select layer → Right-click → Absolute Position

Spacing Modes:
├── Packed: Items touch with gap between
├── Space Between: Items distributed evenly
└── Space Around: Equal space on all sides
```

### DON'T: Manual Positioning for Repeated Elements

**Visual:**
```
❌ INCORRECT:

Navigation Items (manually positioned):
┌────────┬────────┬────────┬────────┐
│ Home   │ About  │Contact │  More  │  (x: 20, x: 100, x: 180, x: 260)
└────────┘────────┘────────┘────────┘

Adding item requires manual repositioning of all items

✅ CORRECT:

Navigation (Auto Layout):
┌────────┐→┌────────┐→┌────────┐→┌────────┐
│ Home   │ │ About  │ │Contact │ │  More  │  Auto spacing
└────────┘ └────────┘ └────────┘ └────────┘

Adding item automatically adjusts spacing
```

### DO: Handle Cropping and Clip Content

Use "Clip content" for containers with overflow.

**Visual:**
```
✅ CORRECT:

Image Container (Clip Content: ON):
┌───────────────────┐
│  ┌─────────────┐  │
│  │   Image     │  │  Image larger than container
│  │   (part)    │  │  is clipped at edges
│  └─────────────┘  │
└───────────────────┘

Card Component (Clip Content: ON):
┌─────────────────┐
│   ┌─────────┐   │
│   │ Image   │   │  Rounded corners clip
│   │(cropped)│   │  image edges
│   └─────────┘   │
│                 │
│   Card Content  │
└─────────────────┘
```

### DO: Use Show/Hide Techniques

Use boolean properties or layer visibility for conditional content.

**Visual:**
```
✅ CORRECT - Boolean Properties:

Card Component Variants:
┌───────────────────┐    ┌───────────────────┐
│                   │    │                   │
│     [Image]       │    │    [Image]        │
│                   │    │                   │
├───────────────────┤    ├───────────────────┤
│     Title         │    │     Title         │
│     Description   │    │     Description   │
│ ┌───────────────┐ │    └───────────────────┘
│ │ [Action Btn]  │ │    (showActions: false)
│ └───────────────┘ │
│   showActions: true│
└───────────────────┘

Property: showActions (boolean)
- true: Action button layer visible
- false: Action button layer hidden
```

---

## Naming and Organization

### DO: Use Forward Slash Naming Conventions

Use `/` to create hierarchical organization that appears as folders in the assets panel.

**Visual:**
```
✅ CORRECT - Slash Naming:

Components:
├── Button / Primary / Default
├── Button / Primary / Hover
├── Button / Secondary / Default
├── Card / Default
├── Card / With Image
├── Input / Text / Default
├── Input / Text / Error
├── Input / Textarea / Default
└── Navigation / Header / Default

Result in Assets Panel:
📁 Button
   ├── Primary
   │   ├── Default
   │   └── Hover
   └── Secondary
       └── Default
📁 Card
   ├── Default
   └── With Image
📁 Input
   └── Text
       ├── Default
       └── Error
```

### DON'T: Flat Naming Structure

**Visual:**
```
❌ INCORRECT:

Components (flat):
├── Button Primary Default
├── Button Primary Hover
├── Button Secondary Default
├── Button Secondary Hover
├── Card Default
├── Card With Image
├── Input Text Default
├── Input Text Error
├── Input Textarea Default
├── Navigation Header Default

Result in Assets Panel:
(Long flat list, hard to find components)
```

### DO: Organize Pages and Frames

Structure your file with clear page organization.

**Visual:**
```
✅ CORRECT - Page Structure:

📄 Cover
   └── Project thumbnail and info

📄 Foundation
   ├── Color Palette
   ├── Typography Scale
   ├── Spacing System
   └── Shadow & Effects

📄 Components
   ├── Atoms
   ├── Molecules
   └── Organisms

📄 Patterns
   ├── Forms
   ├── Lists
   └── Navigation

📄 Templates
   ├── Web Layouts
   └── Mobile Layouts

📄 Prototypes
   └── User flows and interactions

📄 Archive
   └── Deprecated components
```

### DO: Name Styles Consistently

**Visual:**
```
✅ CORRECT - Style Naming:

Colors:
├── Primary / 50
├── Primary / 100
├── Primary / 500 (Main)
├── Primary / 900
├── Semantic / Success / 500
├── Semantic / Error / 500
├── Semantic / Warning / 500
├── Neutral / White
├── Neutral / Gray / 100
├── Neutral / Gray / 900
└── Neutral / Black

Typography:
├── Heading / H1 / Desktop
├── Heading / H1 / Mobile
├── Heading / H2 / Desktop
├── Body / Large / Regular
├── Body / Large / Bold
├── Body / Small / Regular
└── Caption / Regular

Effects:
├── Shadow / Small
├── Shadow / Medium
├── Shadow / Large
└── Blur / Backdrop
```

### DO: Add Component Descriptions

Document what each component is for and when to use it.

**Visual:**
```
✅ CORRECT - Component Documentation:

Component: Button
Description: "Interactive element that triggers an action when clicked. 
Use Primary for main actions, Secondary for alternative actions, 
and Tertiary for low-priority actions."

Properties documented:
- Type: Visual hierarchy (Primary, Secondary, Tertiary, Ghost)
- Size: Button dimensions (Small, Medium, Large)
- State: Interaction state (Default, Hover, Active, Disabled, Loading)
- Icon: Icon placement (None, Left, Right, Icon Only)

Usage Guidelines:
✓ Use for form submissions, navigation, actions
✗ Don't use multiple Primary buttons in one view
✗ Don't use disabled state without explanation

Accessibility:
- Minimum touch target: 44×44px
- Color contrast ratio: 4.5:1 minimum
- Keyboard focus visible
```

---

## Design System Best Practices

### DO: Know When to Use Variants vs Separate Components

**Visual:**
```
✅ CORRECT - Variants vs Separate:

USE VARIANTS (same component):
├── Button
│   ├── Type: Primary | Secondary | Tertiary
│   ├── Size: Small | Medium | Large
│   └── State: Default | Hover | Active | Disabled
│
└── Same structure, just different appearances

USE SEPARATE COMPONENTS (different structure):
├── Button (simple clickable action)
├── Input Field (user text entry)
├── Checkbox (binary selection)
├── Radio Button (single selection from group)
├── Toggle (on/off state)
│
└── Different interaction patterns and use cases
```

### DO: Handle States Properly

Define all interactive states for components.

**Visual:**
```
✅ CORRECT - State Management:

Button States (all variants should have):
┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│  Default    │  │   Hover     │  │   Active    │  │  Disabled   │
│  (normal)   │→ │  (cursor    │→ │  (pressed)  │→ │  (inactive) │
│             │  │   over)     │  │             │  │             │
└─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘
     ↓                ↓                ↓                ↓
  opacity: 1      opacity: 0.9    scale: 0.98     opacity: 0.4
  shadow: sm      shadow: md      shadow: none    cursor: not-allowed

Additional states to consider:
- Loading (spinner inside button)
- Focus (keyboard navigation)
- Error (validation failed)
```

### DON'T: Forget Focus States

**Visual:**
```
❌ INCORRECT:

Button without focus state:
┌─────────────┐
│   Submit    │  ← No visual indicator for keyboard users
└─────────────┘

✅ CORRECT:

Button with visible focus:
┌─────────────┐
│ ╔═════════╗ │  ← Visible outline for keyboard navigation
│ ║ Submit  ║ │     (high contrast ring)
│ ╚═════════╝ │
└─────────────┘
```

### DO: Manage Theming and Colors

Use semantic color naming for easier theming.

**Visual:**
```
✅ CORRECT - Semantic Color System:

Color Tokens:
├── Background
│   ├── Primary    →  #FFFFFF (Light) / #000000 (Dark)
│   ├── Secondary  →  #F5F5F5 (Light) / #1A1A1A (Dark)
│   └── Tertiary   →  #EEEEEE (Light) / #2D2D2D (Dark)
├── Text
│   ├── Primary    →  #000000 (Light) / #FFFFFF (Dark)
│   ├── Secondary  →  #666666 (Light) / #AAAAAA (Dark)
│   └── Disabled   →  #999999 (Light) / #555555 (Dark)
├── Border
│   ├── Default    →  #E0E0E0 (Light) / #333333 (Dark)
│   └── Focus      →  #0066FF (both themes)
└── Action
    ├── Primary    →  #0066FF (both themes)
    ├── Hover      →  #0052CC (both themes)
    └── Disabled   →  #CCCCCC (Light) / #444444 (Dark)

Usage in components:
Button Background → Action/Primary
Button Text       → Text/On-Primary (always white)
Input Border      → Border/Default
Input Border:     → Border/Focus (on focus)
```

### DON'T: Hardcode Colors

**Visual:**
```
❌ INCORRECT:

Component using hardcoded colors:
Button Fill: #0066FF (hardcoded)
    ↓
Theme change requires updating every button instance

✅ CORRECT:

Component using color styles:
Button Fill: Action/Primary (style)
    ↓
Theme change: Update Action/Primary style
    ↓
All buttons update automatically
```

### DO: Preserve Text Overrides

Structure components so text content can be changed without breaking.

**Visual:**
```
✅ CORRECT - Text Override Setup:

Button Component Structure:
┌─────────────────────────────┐
│  [Icon]  "Button Label"    │  ← Text layer named generically
└─────────────────────────────┘

Layer name: "Button Label"
- Allows text override in instances
- Change to: "Submit", "Cancel", "Learn More"

Text properties that preserve overrides:
✓ Font family
✓ Font size
✓ Font weight
✗ Text content (intended to change)
```

**Visual:**
```
❌ INCORRECT - Text Override Issues:

Button Component:
┌─────────────────────────────┐
│  [Icon]  "Submit"          │  ← Text layer named "Submit"
└─────────────────────────────┘

Instance override:
Change text to "Cancel"
    ↓
Main component updated
    ↓
Instance text resets to "Submit" (override lost!)
```

---

## File and Library Organization

### DO: Structure Single vs Multiple Libraries

**Visual:**
```
✅ CORRECT - Library Architecture:

SINGLE LIBRARY (small team/product):
🌍 Core Design System
├── Foundation
├── Components
├── Patterns
└── Assets (icons, illustrations)

MULTIPLE LIBRARIES (enterprise/scale):
🌍 Core Primitives (shared across all)
   ├── Colors
   ├── Typography
   ├── Spacing
   └── Effects

📁 Product A Library
   └── Components built on Core

📁 Product B Library
   └── Components built on Core

📁 Marketing Library
   └── Brand-specific components

Structure:
Core Primitives ←── Product A Library
         ↑
         └─────── Product B Library
         ↑
         └─────── Marketing Library
```

### DO: Follow Design System Structure

**Visual:**
```
✅ CORRECT - Design System File Structure:

📁 Design System v2.0
│
├── 📄 00 - Getting Started
│   ├── Overview
│   ├── How to use this library
│   ├── Changelog
│   └── Roadmap
│
├── 📄 01 - Foundation
│   ├── Color Palette
│   ├── Typography
│   ├── Layout & Spacing
│   ├── Iconography
│   └── Motion & Animation
│
├── 📄 02 - Components
│   ├── Atoms
│   │   ├── Buttons
│   │   ├── Inputs
│   │   ├── Icons
│   │   └── Tags
│   ├── Molecules
│   │   ├── Search Bar
│   │   ├── Form Groups
│   │   └── Cards
│   └── Organisms
│       ├── Header
│       ├── Footer
│       └── Navigation
│
├── 📄 03 - Patterns
│   ├── Forms
│   ├── Lists & Tables
│   ├── Navigation
│   └── Search & Filtering
│
├── 📄 04 - Templates
│   ├── Page Layouts
│   ├── Grid Systems
│   └── Responsive Breakpoints
│
└── 📄 05 - Resources
    ├── Icons (all sizes)
    ├── Illustrations
    └── Device Mockups
```

### DO: Document Changes and Updates

**Visual:**
```
✅ CORRECT - Documentation Practices:

Component Page Structure:
┌─────────────────────────────────────────────┐
│ Component Name: Button                      │
├─────────────────────────────────────────────┤
│ Description:                                │
│ Primary interactive element for actions     │
├─────────────────────────────────────────────┤
│ Usage:                                      │
│ ✓ Use for form submissions                  │
│ ✓ Use for navigation actions                │
│ ✗ Don't use multiple primary buttons        │
├─────────────────────────────────────────────┤
│ Properties:                                 │
│ • Type: Primary, Secondary, Tertiary        │
│ • Size: Small, Medium, Large                │
│ • State: Default, Hover, Active, Disabled   │
├─────────────────────────────────────────────┤
│ Anatomy:                                    │
│ [Visual diagram showing layers]             │
├─────────────────────────────────────────────┤
│ Accessibility:                              │
│ • Min touch target: 44×44px                 │
│ • Focus visible: Yes                        │
│ • ARIA label: Required for icon-only        │
├─────────────────────────────────────────────┤
│ Changelog:                                  │
│ v2.1 - Added loading state                  │
│ v2.0 - Updated color tokens                 │
│ v1.5 - Added tertiary variant               │
└─────────────────────────────────────────────┘
```

---

## Dev Mode

### Marking Frames for Dev Mode

**Visual:**
```
✅ CORRECT - Preparing for Dev Mode:

Frame Organization:
┌────────────────────────────────────────────┐
│ 📱 Mobile - Home Screen                    │
│   ├── Section: Hero (marked for export)    │
│   ├── Section: Features (marked)           │
│   └── Section: Footer (marked)             │
└────────────────────────────────────────────┘

Dev Mode Ready Checklist:
□ Sections are named descriptively
□ Components use design tokens
□ Spacing uses variables (not arbitrary values)
□ Icons are components (not images)
□ Text styles are applied (not custom)
□ Auto Layout is properly configured
```

### Inspect Panel Usage

**Visual:**
```
✅ CORRECT - Inspect Panel Information:

Developer View:
┌────────────────────────────────────────────┐
│ Inspect Panel                              │
├────────────────────────────────────────────┤
│                                            │
│  Selected: Button Primary                  │
│                                            │
│  Position & Layout                         │
│  ├── X: 24px                               │
│  ├── Y: 48px                               │
│  ├── Width: 120px                          │
│  ├── Height: 44px                          │
│  └── Constraints: Left, Top                │
│                                            │
│  Typography                                │
│  ├── Font: Inter                           │
│  ├── Size: 16px                            │
│  ├── Weight: 600                           │
│  └── Line Height: 24px                     │
│                                            │
│  Colors                                    │
│  ├── Fill: ds-color-action-primary         │
│  └── Text: ds-color-text-on-primary        │
│                                            │
│  Effects                                   │
│  ├── Shadow: ds-shadow-medium              │
│  └── Border Radius: 8px                    │
│                                            │
└────────────────────────────────────────────┘
```

### Code Generation

**Visual:**
```
✅ CORRECT - Code Panel:

CSS Code Generated:
┌────────────────────────────────────────────┐
│ .button-primary {                          │
│   background-color: #0066FF;              │
│   color: #FFFFFF;                         │
│   padding: 12px 24px;                     │
│   border-radius: 8px;                     │
│   font-family: 'Inter', sans-serif;       │
│   font-size: 16px;                        │
│   font-weight: 600;                       │
│   box-shadow: 0 2px 4px rgba(0,0,0,0.1);  │
│ }                                          │
└────────────────────────────────────────────┘

Supported Languages:
├── CSS
├── SCSS/Sass
├── Tailwind CSS
├── React (JSX)
├── Swift (iOS)
├── Android (XML)
└── Flutter (Dart)

Plugin Extensions:
├── Tokens Studio (custom transforms)
├── Figma to Code (React/Vue)
└── Style Dictionary (token export)
```

### Asset Export Settings

**Visual:**
```
✅ CORRECT - Export Configuration:

Icons:
├── Format: SVG (vector)
├── Suffix: /icon-[name]
└── Size: 1x (vector scales)

Images:
├── Format: PNG (photos)
├── Format: WebP (web optimized)
├── Size: 1x, 2x, 3x
└── Quality: 80-90%

Illustrations:
├── Format: SVG (if vector-based)
├── Format: PNG (if raster)
└── Size: 1x, 2x

Export Suffixes:
├── [name].svg           (icons)
├── [name]@1x.png        (1x images)
├── [name]@2x.png        (retina images)
└── [name]@3x.png        (high-DPI images)
```

### DON'T: Leave Unnamed Layers

**Visual:**
```
❌ INCORRECT - Messy Layers for Dev:

Layers:
├── Frame 45
├── Frame 46
├── Group 12
├── Rectangle 5
├── Text 23
└── Ellipse 8

✅ CORRECT - Named Layers:

Layers:
├── Section/Hero
├── Hero/Background
├── Hero/Content-Wrapper
├── Hero/Headline
├── Hero/Subheadline
└── Hero/CTA-Button

Benefits:
- Better code generation
- Easier maintenance
- Clear component hierarchy
```

---

## Prototyping & Interactions

### Smart Animate

**Visual:**
```
✅ CORRECT - Smart Animate Usage:

Matching Layers (Auto-Animate):
Frame 1                      Frame 2
┌─────────────┐              ┌─────────────────┐
│  [Card]     │  ────────→   │  [Card]         │
│  ┌────────┐ │  Smart       │  ┌────────────┐ │
│  │  Img   │ │  Animate     │  │    Img     │ │
│  └────────┘ │              │  └────────────┘ │
│  Title      │              │  Title          │
│  Desc       │              │  Desc           │
└─────────────┘              └─────────────────┘

Smart Animate matches layers by:
- Layer name
- Layer hierarchy
- Smoothly animates: position, size, opacity

Requirements:
✓ Same layer names in both frames
✓ Same layer structure
✓ Identifiable matching elements
```

### Interaction Types

**Visual:**
```
✅ CORRECT - Interaction Types:

Trigger Types:
├── On Click/Tap
├── On Drag
├── While Hovering
├── While Pressing
├── After Delay (time-based)
├── Mouse Enter/Leave
└── Key/Gamepad (keyboard/gamepad)

Action Types:
├── Navigate To (frame change)
├── Open Overlay (modal, dropdown)
├── Swap With (replace current frame)
├── Back (return to previous)
├── Close Overlay
├── Smart Animate (matched layers)
└── Scroll To (within long frames)

Common Patterns:
Button Click → Navigate To: Next Screen
Card Hover → While Hovering: Scale 1.02
Menu Button → Open Overlay: Dropdown Menu
Modal Close → Close Overlay
```

### Overlay Positioning

**Visual:**
```
✅ CORRECT - Overlay Positioning:

Dropdown Menu:
┌─────────────────────────────────┐
│  [Menu Button]                  │
│        ↓                        │
│   ┌────────────┐               │
│   │ Option 1   │               │
│   │ Option 2   │  ← Overlay positioned
│   │ Option 3   │     below trigger
│   └────────────┘
└─────────────────────────────────┘
Position: Bottom Center
Behavior: Close when clicking outside

Modal Dialog:
┌─────────────────────────────────┐
│                                 │
│    ┌─────────────────────┐     │
│    │                     │     │
│    │   Modal Content     │     │
│    │                     │     │
│    └─────────────────────┘     │
│                                 │
└─────────────────────────────────┘
Position: Center
Background: Overlay (dim background)
Behavior: Close on background click

Toast Notification:
┌─────────────────────────────────┐
│                                 │
│   ┌─────────────────────┐      │
│   │  Success message!   │      │
│   └─────────────────────┘      │
│                                 │
└─────────────────────────────────┘
Position: Top Center
Behavior: Auto-close after delay
```

### Scroll Behaviors

**Visual:**
```
✅ CORRECT - Scroll Configuration:

Vertical Scroll:
┌─────────────────┐
│   Fixed Header  │  ← No Scroll
├─────────────────┤
│                 │
│  Scrollable     │  ← Scrolls
│  Content Area   │
│                 │
│                 │
│                 │
└─────────────────┘

Configuration:
- Container height: Fixed (e.g., 600px)
- Content height: Hug or larger than container
- Overflow: Vertical scrolling

Horizontal Scroll:
┌─────────────────────────────────────────────┐
│ [Card 1] [Card 2] [Card 3] [Card 4] [Card 5]│ →
└─────────────────────────────────────────────┘

Configuration:
- Container width: Fixed
- Content width: Hug
- Overflow: Horizontal scrolling

Fixed Elements:
- Set layer to "Fix position when scrolling"
- Header, navigation, floating buttons
```

### Prototype Flows Organization

**Visual:**
```
✅ CORRECT - Flow Organization:

Starting Points:
┌────────────────────────────────────────────┐
│ Flow: User Registration                    │
│ └── Starting Point: Signup Page            │
│                                            │
│ Flow: Checkout Process                     │
│ └── Starting Point: Cart Page              │
│                                            │
│ Flow: Password Reset                       │
│ └── Starting Point: Login Page             │
└────────────────────────────────────────────┘

Naming Convention:
[Flow Name] - [Context]
├── "Onboarding - Mobile"
├── "Onboarding - Desktop"
├── "Purchase Flow - Guest User"
└── "Purchase Flow - Logged In"

Organization Tips:
□ Group related flows together
□ Use descriptive names
□ Set clear starting points
□ Test all paths before sharing
```

---

## Accessibility

### Color Contrast (WCAG)

**Visual:**
```
✅ CORRECT - Contrast Ratios:

WCAG 2.1 Requirements:
├── AA Level (Minimum)
│   ├── Normal Text: 4.5:1 contrast ratio
│   └── Large Text (18pt+): 3:1 contrast ratio
│
└── AAA Level (Enhanced)
    ├── Normal Text: 7:1 contrast ratio
    └── Large Text (18pt+): 4.5:1 contrast ratio

Contrast Examples:

PASS - 7.2:1 (AAA)
┌─────────────────────────┐
│ White Text on Dark BG   │
│ #FFFFFF on #000000      │
└─────────────────────────┘

PASS - 4.6:1 (AA)
┌─────────────────────────┐
│ Dark Gray on White      │
│ #595959 on #FFFFFF      │
└─────────────────────────┘

FAIL - 2.8:1
┌─────────────────────────┐
│ Light Gray on White     │
│ #AAAAAA on #FFFFFF      │
└─────────────────────────┘

Testing:
- Use Stark plugin in Figma
- Use WebAIM Contrast Checker
- Test all text/background combinations
```

### Focus Indicators

**Visual:**
```
✅ CORRECT - Focus State Design:

Button Focus:
┌───────────────────────────────┐
│                               │
│   ┌───────────────────────┐   │
│   │ ╔═══════════════════╗ │   │
│   │ ║  Submit Button    ║ │   │  ← High contrast ring
│   │ ╚═══════════════════╝ │   │     (2-3px outline)
│   └───────────────────────┘   │
│                               │
└───────────────────────────────┘

Focus Ring Specifications:
├── Color: High contrast (complement brand)
├── Width: 2-3px
├── Offset: 2-4px from element
├── Style: Solid or dashed
└── Always visible on keyboard focus

Input Focus:
┌───────────────────────────────┐
│  ┌─────────────────────────┐  │
│  │ Email address           │  │
│  └─────────────────────────┘  │
│           ↓ Focus             │
│  ┌─────────────────────────┐  │
│  │ ╔═══════════════════╗   │  │  ← Border + shadow
│  │ ║ user@example.com  ║   │  │
│  │ ╚═══════════════════╝   │  │
│  └─────────────────────────┘  │
└───────────────────────────────┘
```

### Touch Targets

**Visual:**
```
✅ CORRECT - Touch Target Sizes:

Minimum Touch Target: 44×44px

Small Button (32px height):
┌──────────────────┐
│   Save           │  ← Visual: 32px height
│                  │
└──────────────────┘
   ↑ Actual touch target extended to 44px

Large Touch Target (48px):
┌───────────────────────────┐
│                           │
│       Submit Button       │  ← 48px minimum
│                           │
└───────────────────────────┘

Spacing Between Touch Targets:
┌────────┐   ┌────────┐   ┌────────┐
│  Yes   │   │  No    │   │Cancel  │  ← 8-12px gap minimum
└────────┘   └────────┘   └────────┘

WCAG Guidelines:
├── Minimum: 44×44px
├── Recommended: 48×48px
├── Spacing: 8px minimum between targets
└── Include padding in touch area
```

### Color Blindness Simulation

**Visual:**
```
✅ CORRECT - Color Blindness Testing:

Use Stark Plugin Views:
├── Protanopia (Red-blind)
├── Deuteranopia (Green-blind)
├── Tritanopia (Blue-blind)
└── Achromatopsia (Total color blindness)

Don't Rely on Color Alone:
❌ INCORRECT:
┌───────────────────────────────────────┐
│  Status: ● Active (green dot only)   │
└───────────────────────────────────────┘

✅ CORRECT:
┌───────────────────────────────────────┐
│  Status: 🟢 Active                    │
│          Icon + Color + Text          │
└───────────────────────────────────────┘

Status Indicators:
├── Success: 🟢 Green + Checkmark icon
├── Error:   🔴 Red + X icon
├── Warning: 🟡 Yellow + ⚠ icon
└── Info:    🔵 Blue + ℹ icon

Test Your Designs:
□ View in different color blindness modes
□ Ensure information is conveyed through:
    - Icons/symbols
    - Text labels
    - Patterns/texture
    - Not just color
```

### Screen Reader Considerations

**Visual:**
```
✅ CORRECT - Screen Reader Support:

Semantic Layer Names:
✓ "Submit-Button"
✓ "Email-Input-Field"
✓ "Main-Navigation"
✗ "Group 1"
✗ "Rectangle 5"
✗ "Frame 47"

Icon Button Labels:
┌───────────┐
│    ✕      │  ← Close icon
│           │
└───────────┘
Layer Name: "Close-Modal-Button"
(Not just "Icon-Close")

Image Descriptions:
┌───────────────────┐
│                   │
│   [Hero Image]    │  ← Layer: "Hero-Illustration"
│                   │
└───────────────────┘
Alt Text: "Team collaboration illustration"

Reading Order:
┌───────────────────────┐
│  1. Header            │
│  2. Navigation        │
│  3. Main Content      │
│  4. Sidebar           │
│  5. Footer            │
└───────────────────────┘
Organize layers top-to-bottom = left-to-right reading
```

---

## Performance Guidelines

### File Size Optimization

**Visual:**
```
✅ CORRECT - File Optimization:

Image Optimization:
├── Use WebP format when possible
├── Compress PNGs (TinyPNG, ImageOptim)
├── Resize to actual display size
├── Remove unused images
└── Use SVG for icons/illustrations

Best Practices:
├── Delete unused components
├── Remove hidden layers
├── Flatten complex vectors when appropriate
└── Use components instead of duplicating

File Size Limits:
├── Warning: >50MB
├── Critical: >100MB
└── Target: <30MB
```

### Library Performance

**Visual:**
```
✅ CORRECT - Library Best Practices:

Library Structure:
├── Keep primitives separate from components
├── Split large libraries by product area
├── Use nested components (don't flatten)
└── Publish incremental updates

Performance Tips:
├── Limit variants per component (<100 combinations)
├── Use boolean properties over excessive variants
├── Avoid deeply nested components (>5 levels)
├── Optimize component complexity
└── Use variables for theming (not variants)

Update Strategy:
├── Batch changes when possible
├── Test library before publishing
├── Announce breaking changes
└── Maintain backward compatibility
```

### Component Complexity Limits

**Visual:**
```
✅ CORRECT - Complexity Guidelines:

Layer Limits per Component:
├── Simple: <10 layers
├── Medium: 10-30 layers
├── Complex: 30-50 layers
└── Avoid: >50 layers

Variant Limits:
├── Reasonable: <50 variant combinations
├── Manageable: 50-100 combinations
└── Refactor: >100 combinations
(Use boolean properties instead)

Auto Layout Nesting:
├── Simple: 1-2 levels
├── Complex: 3 levels
└── Avoid: >3 levels deep

Optimization:
□ Flatten when possible
□ Use instance swapping
□ Remove hidden/unused layers
□ Combine similar elements
```

### Image Optimization

**Visual:**
```
✅ CORRECT - Image Guidelines:

Format Selection:
├── Photos: WebP or JPEG (80-90% quality)
├── Illustrations: SVG or PNG
├── Icons: SVG only
├── Screenshots: PNG (lossless)
└── Animations: GIF or Lottie

Resolution:
├── Display at 1x, export at 2x
├── Use Figma's "Export @2x" for retina
├── Don't upscale small images
└── Match export size to usage

File Naming:
├── Descriptive: hero-homepage.jpg
├── Context: icon-close-24px.svg
├── Not: image-1.png, img_123.jpg
└── Consistent: kebab-case

Optimization Tools:
├── Figma built-in compression
├── Squoosh.app (web)
├── ImageOptim (Mac)
├── TinyPNG (web)
└── SVGO (SVG optimization)
```

---

## Responsive Design

### Breakpoint Definitions

**Visual:**
```
✅ CORRECT - Breakpoint System:

Standard Breakpoints:
├── Mobile Small: 320px
├── Mobile: 375px
├── Mobile Large: 414px
├── Tablet: 768px
├── Desktop: 1024px
├── Desktop Large: 1440px
└── Desktop XL: 1920px

Common Breakpoint Patterns:

Mobile (320-767px):
┌─────────────────┐
│    Header       │
│    [Menu]       │
├─────────────────┤
│                 │
│   Content       │
│   (1 column)    │
│                 │
├─────────────────┤
│    Footer       │
└─────────────────┘

Tablet (768-1023px):
┌─────────────────────────┐
│        Header           │
│  [Logo]          [Nav]  │
├─────────────────────────┤
│  ┌─────────┬─────────┐  │
│  │ Col 1   │ Col 2   │  │
│  │         │         │  │
│  └─────────┴─────────┘  │
├─────────────────────────┤
│        Footer           │
└─────────────────────────┘

Desktop (1024px+):
┌─────────────────────────────────┐
│              Header             │
│  [Logo]  [Nav]          [User]  │
├─────────────────────────────────┤
│  ┌───────┬───────┬───────┐     │
│  │ Col 1 │ Col 2 │ Col 3 │     │
│  │       │       │       │     │
│  └───────┴───────┴───────┘     │
├─────────────────────────────────┤
│            Footer               │
└─────────────────────────────────┘
```

### Constraints + Auto Layout Together

**Visual:**
```
✅ CORRECT - Combined Approach:

Card Component (Responsive):
┌─────────────────────────────────────────┐
│                                         │
│  ┌─────────────────────────────────┐   │
│  │  [Image - Scale]                │   │  Constraint: Scale
│  │                                 │   │  Auto Layout: Hug
│  ├─────────────────────────────────┤   │
│  │                                 │   │
│  │  Title Text                     │   │  Constraint: Left+Right
│  │  (Fill container)               │   │  Auto Layout: Fill
│  │                                 │   │
│  │  Description text that wraps    │   │
│  │  to multiple lines...           │   │
│  │                                 │   │
│  ├─────────────────────────────────┤   │
│  │  [Button - Hug]        [Link]   │   │  Constraint: Left+Right
│  └─────────────────────────────────┘   │  Auto Layout: Space Between
│                                         │
└─────────────────────────────────────────┘
                          ↑
                    Min: 300px, Max: 400px

Responsive Behavior:
- Container scales with parent frame
- Image maintains aspect ratio
- Text fills available width
- Actions distribute evenly
```

### Fluid Components

**Visual:**
```
✅ CORRECT - Fluid Design Patterns:

Fluid Button:
┌─────────────────────────────────────────┐
│                                         │
│     ┌─────────────────────────────┐    │
│     │      Fluid Width Button     │    │
│     │      (Hug to Fill)          │    │
│     └─────────────────────────────┘    │
│                                         │
└─────────────────────────────────────────┘

Responsive Navigation:
Desktop:                     Mobile:
┌─────────────────────┐     ┌─────────┐
│ Logo  Home About ...│     │☰  Logo │
└─────────────────────┘     └─────────┘
                    (Menu collapses to hamburger)

Fluid Grid:
┌─────────────────────────────────────────┐
│                                         │
│ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐    │
│ │ Item │ │ Item │ │ Item │ │ Item │    │
│ └──────┘ └──────┘ └──────┘ └──────┘    │
│                                         │
│ Wrap enabled - items reflow on resize   │
│                                         │
└─────────────────────────────────────────┘
```

### Responsive Typography

**Visual:**
```
✅ CORRECT - Responsive Type Scales:

Desktop (1440px):
├── H1: 48px / 56px line-height
├── H2: 36px / 44px line-height
├── H3: 28px / 36px line-height
├── Body: 16px / 24px line-height
└── Caption: 14px / 20px line-height

Tablet (768px):
├── H1: 40px / 48px line-height
├── H2: 32px / 40px line-height
├── H3: 24px / 32px line-height
├── Body: 16px / 24px line-height
└── Caption: 14px / 20px line-height

Mobile (375px):
├── H1: 32px / 40px line-height
├── H2: 28px / 36px line-height
├── H3: 22px / 30px line-height
├── Body: 16px / 24px line-height
└── Caption: 14px / 20px line-height

Implementation:
- Create text styles for each breakpoint
- Use variable modes for sizes
- Maintain readable line lengths (60-75 chars)
- Minimum 16px for body text (no zoom on mobile)
```

---

## Version Control

### Branching Strategies

**Visual:**
```
✅ CORRECT - Branch Workflow:

Main Branch:
├── Current stable library version
├── Production-ready components
└── All team members consume this

Development Branches:
├── feature/new-button-variant
├── feature/dark-mode-tokens
├── bugfix/icon-alignment
└── experiment/new-grid-system

Workflow:
1. Create branch from Main
2. Make changes in isolation
3. Review with stakeholders
4. Merge to Main
5. Publish updated library

Best Practices:
├── Name branches descriptively
├── Keep branches short-lived
├── Review before merging
└── Test thoroughly in branch
```

### Publishing Library Updates

**Visual:**
```
✅ CORRECT - Publishing Workflow:

Before Publishing:
□ Review all changes
□ Test with pilot files
□ Check for breaking changes
□ Update changelog
□ Document new features

Version Numbers:
├── Major (1.0.0 → 2.0.0): Breaking changes
├── Minor (1.1.0 → 1.2.0): New features, backward compatible
└── Patch (1.1.1 → 1.1.2): Bug fixes only

Publishing Steps:
1. Make changes in main file
2. Add descriptions to new components
3. Update component documentation
4. Publish library (File → Publish styles and components)
5. Write release notes
6. Notify team members
7. Update any related documentation

Release Notes Template:
───
Version 2.1.0

New Features:
• Added Card component with 3 variants
• New dark mode color tokens

Improvements:
• Updated button focus states
• Improved spacing consistency

Bug Fixes:
• Fixed icon alignment in inputs

Breaking Changes:
• None
───
```

### Deprecation Strategies

**Visual:**
```
✅ CORRECT - Deprecation Process:

Phase 1: Mark as Deprecated (Day 0)
├── Add "[DEPRECATED]" to component name
├── Add deprecation note in description
├── Create replacement component
└── Announce to team

Phase 2: Support Period (30-90 days)
├── Keep component functional
├── No new features added
├── Bug fixes only
└── Monitor usage

Phase 3: Remove (After support period)
├── Move to Archive page
├── Remove from main library
├── Update documentation
└── Close related issues

Deprecation Notice Template:
───
[DEPRECATED] Button - Old Variant

⚠️ This component will be removed on [DATE]

Replacement:
Use "Button/V2" instead

Migration:
Replace instances with new component variant
No breaking changes to functionality
───
```

---

## Collaboration and Handoff

### DO: Prepare for Developer Handoff

**Visual:**
```
✅ CORRECT - Handoff Preparation:

Design File Checklist:
┌─────────────────────────────────────────┐
│ 1. Organized Layers                     │
│    ✓ Clear naming conventions           │
│    ✓ Logical grouping                   │
│    ✓ No hidden/unused layers            │
├─────────────────────────────────────────┤
│ 2. Consistent Spacing                   │
│    ✓ Uses spacing tokens (4, 8, 16...)  │
│    ✓ No arbitrary values                │
├─────────────────────────────────────────┤
│ 3. Component States                     │
│    ✓ All interactive states shown       │
│    ✓ Hover, active, disabled defined    │
│    ✓ Loading states included            │
├─────────────────────────────────────────┤
│ 4. Responsive Behavior                  │
│    ✓ Breakpoints defined                │
│    ✓ Mobile layouts provided            │
│    ✓ Tablet adaptations shown           │
├─────────────────────────────────────────┤
│ 5. Assets Exported                      │
│    ✓ Icons as SVG                       │
│    ✓ Images optimized                   │
│    ✓ 2x exports for retina              │
├─────────────────────────────────────────┤
│ 6. Documentation                        │
│    ✓ Component descriptions             │
│    ✓ Usage guidelines                   │
│    ✓ Edge cases covered                 │
└─────────────────────────────────────────┘
```

### DO: Add Meaningful Component Descriptions

**Visual:**
```
✅ CORRECT - Component Description Example:

Component: DataTable
Location: 📁 Organisms / DataTable

Description:
"A comprehensive data display component with sorting, 
filtering, and pagination capabilities. Use for displaying 
large datasets that require user interaction."

When to Use:
✓ Displaying 10+ rows of structured data
✓ Users need to sort or filter content
✓ Data requires pagination

When NOT to Use:
✗ Simple lists (use List component instead)
✗ Fewer than 5 rows (use Card layout)
✗ Read-only display without interaction

Properties:
┌──────────────┬──────────────────────────────────┐
│ rows         │ Number of visible rows           │
│ sortable     │ Enable column sorting            │
│ filterable   │ Enable column filtering          │
│ pagination   │ Enable pagination controls       │
│ selectable   │ Enable row selection             │
│ actions      │ Show action buttons column       │
└──────────────┴──────────────────────────────────┘

Anatomy:
[Header] → [Filter Row] → [Data Rows] → [Pagination]

Accessibility:
• Keyboard navigation: Arrow keys, Tab, Enter
• Screen reader: Announces row count, sort order
• Focus management: Visible focus on interactive elements

Related Components:
• TableCell - Individual cell styling
• Pagination - Navigation controls
• FilterChip - Active filter indicators
```

### DO: Organize for Team Consumption

**Visual:**
```
✅ CORRECT - Team-Ready Organization:

File Structure for Team:
📁 Project Name
│
├── 📄 00 - Project Info
│   ├── Cover
│   ├── Project Overview
│   ├── Team Members
│   └── Timeline
│
├── 📄 01 - Discovery
│   ├── User Research
│   ├── Competitive Analysis
│   └── Requirements
│
├── 📄 02 - Design
│   ├── Wireframes
│   ├── Visual Design
│   └── Prototypes
│
├── 📄 03 - Components
│   └── (using shared library)
│
├── 📄 04 - Handoff
│   ├── Developer Specs
│   ├── Assets
│   └── Documentation
│
└── 📄 99 - Archive
    ├── Old Iterations
    └── Rejected Concepts

Naming Conventions:
Pages: "## - Description" (numbered for ordering)
Frames: "[Status] Description" (e.g., "[WIP] Homepage")
Components: "Category/Name/Variant"
```

---

## Summary Checklist

Before publishing or handing off Figma designs:

### Components
- [ ] Components are created from atomic elements
- [ ] Variants are used instead of duplicate components
- [ ] All interactive states are defined (hover, active, disabled, focus)
- [ ] Nested components allow instance swapping
- [ ] Constraints are set for responsive behavior
- [ ] Auto Layout is used for fluid designs
- [ ] Boolean properties control conditional visibility
- [ ] Component properties are configured (boolean, text, instance swap)

### Variables & Tokens
- [ ] Variables used for spacing (4, 8, 16, 24, 32, 48, 64)
- [ ] Color variables applied consistently
- [ ] Variable modes set up for theming
- [ ] Design tokens follow hierarchy (primitive → semantic → component)
- [ ] Token naming conventions are consistent

### Naming & Organization
- [ ] Forward slash naming (`Category/Component/Variant`)
- [ ] Consistent style naming (colors, typography, effects)
- [ ] Pages are organized logically
- [ ] Layers are clearly named (no "Frame 47")
- [ ] Component descriptions are complete

### Design System
- [ ] Color tokens use semantic naming
- [ ] Typography scale is defined
- [ ] Spacing system follows consistent increments
- [ ] Text overrides are preserved properly
- [ ] Theming is possible via token updates

### File Structure
- [ ] Foundation styles are separated
- [ ] Components are on dedicated pages
- [ ] Library is published (if shared)
- [ ] Version is documented
- [ ] Changelog is maintained

### Dev Mode & Handoff
- [ ] All states are shown in design specs
- [ ] Responsive layouts are provided
- [ ] Assets are export-ready
- [ ] Spacing uses system values (no arbitrary numbers)
- [ ] Developer documentation is complete
- [ ] Dev Mode annotations added
- [ ] Assets exported correctly (SVG, 2x PNG)

### Prototyping
- [ ] Prototype flows created
- [ ] Flows are tested and working
- [ ] Smart Animate properly configured
- [ ] Interactions are logical
- [ ] Starting points are set

### Accessibility
- [ ] Color contrast meets WCAG AA (4.5:1)
- [ ] Focus indicators are visible
- [ ] Touch targets are 44×44px minimum
- [ ] Screen reader labels are descriptive
- [ ] Color blindness simulation tested
- [ ] Not relying on color alone

### Performance
- [ ] File size is optimized
- [ ] Images are compressed
- [ ] Unused components removed
- [ ] Library performance is good

### Collaboration
- [ ] File permissions are set correctly
- [ ] Comments and feedback are addressed
- [ ] Team members can find components easily
- [ ] Prototype flows are clear
- [ ] Changes are communicated to stakeholders

---

## References

1. [Figma Best Practices - Official Documentation](https://help.figma.com/hc/en-us/categories/360002051613)
2. [Figma Components and Variants](https://help.figma.com/hc/en-us/articles/360038662654-Create-and-use-variants)
3. [Figma Auto Layout](https://help.figma.com/hc/en-us/articles/5731482952599-Using-auto-layout)
4. [Figma Constraints](https://help.figma.com/hc/en-us/articles/360039957734-Constraints)
5. [Figma Shared Libraries](https://help.figma.com/hc/en-us/articles/360041521215-Manage-libraries)
6. [Atomic Design by Brad Frost](https://atomicdesign.bradfrost.com/)
7. [Design Systems by Figma](https://www.designsystems.com/)
8. [Figma Developer Handoff](https://help.figma.com/hc/en-us/articles/360039832154)
9. [Figma Accessibility Features](https://help.figma.com/hc/en-us/articles/360039825314-Check-contrast-with-a-color-blind-mode)
10. [Figma Variables Documentation](https://help.figma.com/hc/en-us/articles/14558191426211-Guide-to-variables-in-Figma)
11. [Figma Dev Mode](https://help.figma.com/hc/en-us/articles/15023124644247-Guide-to-Dev-Mode)
12. [Design Tokens Community Group](https://www.w3.org/community/design-tokens/)
13. [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)

---

## Version

- Created: 2025-02-16
- Based on: Figma 2025 Best Practices
- Last Updated: 2025-02-16
- Version: 2.0.0
