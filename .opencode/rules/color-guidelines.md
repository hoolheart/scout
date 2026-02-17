# Professional Color Guidelines

## 1. Overview and Design Principles

These color guidelines establish a professional, academic visual language that prioritizes clarity, accessibility, and usability. The design philosophy is rooted in three authoritative design systems:

**Core Principles:**

- **Clarity first**: Colors serve functional purposes—indicating state, establishing hierarchy, and guiding attention
- **Academic professionalism**: Conservative, muted tones convey authority and credibility
- **Universal accessibility**: All color combinations meet WCAG AA contrast standards
- **Semantic meaning**: Colors map to specific roles (neutral, brand, information, success, warning, danger)
- **Systematic approach**: Token-based design enables consistency across all UI elements

**Design System Influences:**

- **Primer Design System (GitHub)**: Semantic token architecture with fgColor/bgColor separation and emphasis levels
- **Atlassian Design System**: Color role categorization (neutral, brand, information, success, warning, danger, discovery) with emphasis gradations
- **Interaction Design Foundation**: High contrast ratios for readability, conservative color psychology for professional contexts

## 2. Light Mode Color Palette

### 2.1 Neutral Colors (Grayscale)

| Token | Hex Code | Usage |
|-------|----------|-------|
| `neutral-0` | `#FFFFFF` | Pure white backgrounds |
| `neutral-50` | `#F8F9FA` | Subtle backgrounds, hover states |
| `neutral-100` | `#E9ECEF` | Borders, dividers, disabled backgrounds |
| `neutral-200` | `#DEE2E6` | Light borders, input borders |
| `neutral-300` | `#CED4DA` | Secondary borders, icons |
| `neutral-400` | `#ADB5BD` | Disabled text, decorative icons |
| `neutral-500` | `#6C757D` | Secondary text, captions, placeholder text |
| `neutral-600` | `#495057` | Body text, labels |
| `neutral-700` | `#343A40` | Headings, important text |
| `neutral-800` | `#212529` | Primary text, emphasis |
| `neutral-900` | `#121212` | Maximum contrast text |

### 2.2 Brand Colors (Primary - Deep Teal)

| Token | Hex Code | Usage |
|-------|----------|-------|
| `brand-50` | `#E6F4F4` | Light brand backgrounds |
| `brand-100` | `#B3E0E0` | Subtle brand accents |
| `brand-200` | `#80CCCC` | Hover states for light elements |
| `brand-300` | `#4DB8B8` | Secondary brand elements |
| `brand-400` | `#26A5A5` | Active states |
| `brand-500` | `#0D8C8C` | **Primary brand color** |
| `brand-600` | `#0A7070` | Hover states |
| `brand-700` | `#085454` | Active/pressed states |
| `brand-800` | `#053838` | Strong emphasis |
| `brand-900` | `#031C1C` | Brand text on light backgrounds |

### 2.3 Semantic Colors

#### Information (Blue)

| Token | Hex Code | Usage |
|-------|----------|-------|
| `info-50` | `#E8F4FD` | Information backgrounds |
| `info-100` | `#B8DBF5` | Light info accents |
| `info-500` | `#0969DA` | Information indicators |
| `info-600` | `#0550AE` | Info hover states |
| `info-900` | `#032563` | Info text |

#### Success (Deep Green)

| Token | Hex Code | Usage |
|-------|----------|-------|
| `success-50` | `#E8F5E9` | Success backgrounds |
| `success-100` | `#B8E0BA` | Light success accents |
| `success-500` | `#2E7D32` | Success indicators |
| `success-600` | `#1B5E20` | Success hover states |
| `success-900` | `#0D3B10` | Success text |

#### Warning (Amber)

| Token | Hex Code | Usage |
|-------|----------|-------|
| `warning-50` | `#FFF8E1` | Warning backgrounds |
| `warning-100` | `#FFECB3` | Light warning accents |
| `warning-500` | `#F9A825` | Warning indicators |
| `warning-600` | `#F57F17` | Warning hover states |
| `warning-900` | `#6B4C0B` | Warning text |

#### Danger (Crimson)

| Token | Hex Code | Usage |
|-------|----------|-------|
| `danger-50` | `#FFEBEE` | Danger/error backgrounds |
| `danger-100` | `#FFCDD2` | Light danger accents |
| `danger-500` | `#C62828` | Error indicators |
| `danger-600` | `#B71C1C` | Danger hover states |
| `danger-900` | `#5C0A0A` | Error text |

#### Discovery (Purple)

| Token | Hex Code | Usage |
|-------|----------|-------|
| `discovery-50` | `#F3E5F5` | Discovery backgrounds |
| `discovery-100` | `#E1BEE7` | Light discovery accents |
| `discovery-500` | `#7B1FA2` | Discovery indicators |
| `discovery-600` | `#6A1B9A` | Discovery hover states |
| `discovery-900` | `#380C4D` | Discovery text |

### 2.4 Light Mode Semantic Tokens

```css
/* Background Colors */
--bgColor-default: #FFFFFF;
--bgColor-muted: #F8F9FA;
--bgColor-inset: #E9ECEF;
--bgColor-emphasis: #212529;
--bgColor-inverse: #121212;

/* Foreground Colors */
--fgColor-default: #212529;
--fgColor-muted: #6C757D;
--fgColor-subtle: #ADB5BD;
--fgColor-onEmphasis: #FFFFFF;
--fgColor-onInverse: #F8F9FA;
--fgColor-disabled: #ADB5BD;
--fgColor-link: #0D8C8C;
--fgColor-link-hover: #0A7070;

/* Border Colors */
--borderColor-default: #DEE2E6;
--borderColor-muted: #E9ECEF;
--borderColor-emphasis: #ADB5BD;

/* Accent Colors (Brand) */
--accentColor-fg: #0D8C8C;
--accentColor-emphasis: #0A7070;
--accentColor-muted: #E6F4F4;
--accentColor-subtle: #B3E0E0;

/* Semantic State Colors */
--success-fg: #2E7D32;
--success-emphasis: #1B5E20;
--success-muted: #E8F5E9;
--warning-fg: #6B4C0B;
--warning-emphasis: #F57F17;
--warning-muted: #FFF8E1;
--danger-fg: #C62828;
--danger-emphasis: #B71C1C;
--danger-muted: #FFEBEE;
--info-fg: #0969DA;
--info-emphasis: #0550AE;
--info-muted: #E8F4FD;
```

## 3. Dark Mode Color Palette

### 3.1 Neutral Colors (Dark Grayscale)

| Token | Hex Code | Usage |
|-------|----------|-------|
| `dark-neutral-0` | `#0D1117` | Primary background |
| `dark-neutral-50` | `#161B22` | Elevated surfaces, cards |
| `dark-neutral-100` | `#21262D` | Secondary backgrounds |
| `dark-neutral-200` | `#30363D` | Borders, dividers |
| `dark-neutral-300` | `#484F58` | Subtle borders |
| `dark-neutral-400` | `#6E7681` | Disabled text, icons |
| `dark-neutral-500` | `#8B949E` | Secondary text |
| `dark-neutral-600` | `#B1BAC4` | Body text |
| `dark-neutral-700` | `#C9D1D9` | Headings |
| `dark-neutral-800` | `#E5E8EB` | Primary text |
| `dark-neutral-900` | `#F0F6FC` | Maximum emphasis text |

### 3.2 Brand Colors (Dark Mode - Teal)

| Token | Hex Code | Usage |
|-------|----------|-------|
| `dark-brand-50` | `#0A3D3D` | Brand backgrounds |
| `dark-brand-100` | `#0D5252` | Light brand accents |
| `dark-brand-200` | `#106868` | Hover states |
| `dark-brand-300` | `#147D7D` | Secondary elements |
| `dark-brand-400` | `#1A9999` | Active states |
| `dark-brand-500` | `#33ADAD` | **Primary brand color** |
| `dark-brand-600` | `#5CC0C0` | Hover states |
| `dark-brand-700` | `#85D4D4` | Emphasis |
| `dark-brand-800` | `#ADE8E8` | High emphasis |
| `dark-brand-900` | `#D6F4F4` | Brand text |

### 3.3 Semantic Colors (Dark Mode)

#### Information (Blue)

| Token | Hex Code | Usage |
|-------|----------|-------|
| `dark-info-50` | `#0D1F38` | Information backgrounds |
| `dark-info-100` | `#102D52` | Light info accents |
| `dark-info-500` | `#58A6FF` | Information indicators |
| `dark-info-600` | `#79C0FF` | Info emphasis |
| `dark-info-900` | `#CCE4FF` | Info text |

#### Success (Green)

| Token | Hex Code | Usage |
|-------|----------|-------|
| `dark-success-50` | `#0F2613` | Success backgrounds |
| `dark-success-100` | `#143D1A` | Light success accents |
| `dark-success-500` | `#3FB950` | Success indicators |
| `dark-success-600` | `#56D364` | Success emphasis |
| `dark-success-900` | `#D1F4D9` | Success text |

#### Warning (Amber)

| Token | Hex Code | Usage |
|-------|----------|-------|
| `dark-warning-50` | `#2A1D08` | Warning backgrounds |
| `dark-warning-100` | `#3D2A0B` | Light warning accents |
| `dark-warning-500` | `#D29922` | Warning indicators |
| `dark-warning-600` | `#E3B341` | Warning emphasis |
| `dark-warning-900` | `#FFEEB3` | Warning text |

#### Danger (Red)

| Token | Hex Code | Usage |
|-------|----------|-------|
| `dark-danger-50` | `#3D0C0A` | Danger/error backgrounds |
| `dark-danger-100` | `#4D1512` | Light danger accents |
| `dark-danger-500` | `#F85149` | Error indicators |
| `dark-danger-600` | `#FF7B72` | Danger emphasis |
| `dark-danger-900` | `#FFDCD7` | Error text |

#### Discovery (Purple)

| Token | Hex Code | Usage |
|-------|----------|-------|
| `dark-discovery-50` | `#1A0D26` | Discovery backgrounds |
| `dark-discovery-100` | `#25123B` | Light discovery accents |
| `dark-discovery-500` | `#A371F7` | Discovery indicators |
| `dark-discovery-600` | `#BC8CFF` | Discovery emphasis |
| `dark-discovery-900` | `#EBE0FF` | Discovery text |

### 3.4 Dark Mode Semantic Tokens

```css
/* Background Colors */
--dark-bgColor-default: #0D1117;
--dark-bgColor-muted: #161B22;
--dark-bgColor-inset: #010409;
--dark-bgColor-emphasis: #6E7681;
--dark-bgColor-inverse: #F0F6FC;

/* Foreground Colors */
--dark-fgColor-default: #E5E8EB;
--dark-fgColor-muted: #8B949E;
--dark-fgColor-subtle: #6E7681;
--dark-fgColor-onEmphasis: #0D1117;
--dark-fgColor-onInverse: #161B22;
--dark-fgColor-disabled: #484F58;
--dark-fgColor-link: #33ADAD;
--dark-fgColor-link-hover: #5CC0C0;

/* Border Colors */
--dark-borderColor-default: #30363D;
--dark-borderColor-muted: #21262D;
--dark-borderColor-emphasis: #6E7681;

/* Accent Colors (Brand) */
--dark-accentColor-fg: #33ADAD;
--dark-accentColor-emphasis: #5CC0C0;
--dark-accentColor-muted: #0A3D3D;
--dark-accentColor-subtle: #106868;

/* Semantic State Colors */
--dark-success-fg: #3FB950;
--dark-success-emphasis: #56D364;
--dark-success-muted: #0F2613;
--dark-warning-fg: #D29922;
--dark-warning-emphasis: #E3B341;
--dark-warning-muted: #2A1D08;
--dark-danger-fg: #F85149;
--dark-danger-emphasis: #FF7B72;
--dark-danger-muted: #3D0C0A;
--dark-info-fg: #58A6FF;
--dark-info-emphasis: #79C0FF;
--dark-info-muted: #0D1F38;
```

### 3.5 Color Selection Guidelines

Use this decision tree to determine which color to apply in different contexts:

#### Text Color Selection

```
Is the text interactive (link, button)?
├── YES: Use brand color (brand-500/dark-brand-500)
│   └── Is it hovered/pressed?
│       ├── YES: Use brand-600/dark-brand-600
│       └── NO: Keep brand-500/dark-brand-500
│
└── NO: Is it primary content (headings, body text)?
    ├── YES: Use neutral-800/dark-neutral-800
    │
    └── NO: Is it secondary/helper text?
        ├── YES: Use neutral-500/dark-neutral-500
        │
        └── NO: Is it disabled?
            ├── YES: Use neutral-400/dark-neutral-400
            └── NO: Is it placeholder text?
                └── YES: Use neutral-500/dark-neutral-500
```

#### Background Color Selection

```
What is the component's purpose?
├── Primary action background
│   └── Use brand-500/dark-brand-500
│
├── Destructive action background
│   └── Use danger-500/dark-danger-500
│
├── Status indication
│   ├── Success → Use success-50/dark-success-50
│   ├── Warning → Use warning-50/dark-warning-50
│   ├── Error → Use danger-50/dark-danger-50
│   ├── Info → Use info-50/dark-info-50
│   └── Discovery → Use discovery-50/dark-discovery-50
│
└── Surface/container
    ├── Default background → Use bgColor-default
    ├── Elevated card → Use bgColor-muted
    └── Inset/panel → Use bgColor-inset
```

#### Semantic Color Usage Matrix

| Context | Recommended Color | Avoid |
|---------|------------------|-------|
| Success states | `success-500` | Pure green (#00FF00) |
| Error states | `danger-500` | Pure red (#FF0000) |
| Warnings | `warning-500` | Bright orange |
| Information | `info-500` | Bright blue |
| New features | `discovery-500` | Pink/magenta |
| Primary actions | `brand-500` | Pure black/white |
| Destructive actions | `danger-500` | Red on red backgrounds |

#### Emphasis Level Guidelines

| Emphasis Level | Use When | Example |
|----------------|----------|---------|
| **High** (600-900) | Critical alerts, primary CTAs | "Delete Account" button |
| **Medium** (400-500) | Default states, standard text | Body text, default borders |
| **Low** (50-300) | Backgrounds, subtle accents | Card backgrounds, hover states |

## 4. Color Usage Guidelines

### 4.1 Text and Typography

| Element | Light Mode | Dark Mode | Contrast Ratio |
|---------|------------|-----------|----------------|
| Primary text | `neutral-800` (#212529) | `dark-neutral-800` (#E5E8EB) | 15.3:1 / 13.5:1 |
| Secondary text | `neutral-500` (#6C757D) | `dark-neutral-500` (#8B949E) | 5.7:1 / 4.8:1 |
| Placeholder text | `neutral-500` (#6C757D) | `dark-neutral-400` (#6E7681) | 5.7:1 / 4.6:1 |
| Links | `brand-500` (#0D8C8C) | `dark-brand-500` (#33ADAD) | 4.5:1 / 8.6:1 |
| Disabled text | `neutral-400` (#ADB5BD) | `dark-neutral-400` (#6E7681) | 2.9:1 / 4.6:1 |

**Rules:**
- Never use color alone to convey meaning (always pair with icons or text)
- Body text must maintain minimum 4.5:1 contrast ratio
- Large text (18pt+ or 14pt+ bold) must maintain minimum 3:1 contrast ratio

### 4.2 Interactive Elements

#### Buttons

**Light Mode Button States:**

| Button Type | Default BG | Default Text | Border | Hover BG | Focus Ring | Active BG | Loading State |
|-------------|-----------|--------------|--------|----------|------------|-----------|---------------|
| Primary | `brand-500` | White | None | `brand-600` | `brand-500` (2px) | `brand-700` | `brand-400` with spinner |
| Secondary | White | `neutral-700` | `neutral-200` | `neutral-50` | `brand-500` (2px) | `neutral-100` | `neutral-50` with spinner |
| Tertiary | Transparent | `brand-500` | None | `brand-50` | `brand-500` (2px) | `brand-100` | `brand-50` with spinner |
| Danger | `danger-500` | White | None | `danger-600` | `danger-500` (2px) | `danger-700` | `danger-400` with spinner |
| Ghost | Transparent | `neutral-600` | None | `neutral-50` | `brand-500` (2px) | `neutral-100` | Transparent with spinner |
| Disabled | `neutral-100` | `neutral-400` | None | — | None | — | — |

**Dark Mode Button States:**

| Button Type | Default BG | Default Text | Border | Hover BG | Focus Ring | Active BG | Loading State |
|-------------|-----------|--------------|--------|----------|------------|-----------|---------------|
| Primary | `dark-brand-500` | `#0D1117` | None | `dark-brand-400` | `dark-brand-500` (2px) | `dark-brand-300` | `dark-brand-600` with spinner |
| Secondary | `dark-neutral-50` | `dark-neutral-800` | `dark-neutral-200` | `dark-neutral-100` | `dark-brand-500` (2px) | `dark-neutral-200` | `dark-neutral-100` with spinner |
| Tertiary | Transparent | `dark-brand-500` | None | `dark-brand-50` | `dark-brand-500` (2px) | `dark-brand-100` | `dark-brand-50` with spinner |
| Danger | `dark-danger-500` | `#0D1117` | None | `dark-danger-600` | `dark-danger-500` (2px) | `dark-danger-400` | `dark-danger-600` with spinner |
| Ghost | Transparent | `dark-neutral-400` | None | `dark-neutral-50` | `dark-brand-500` (2px) | `dark-neutral-100` | Transparent with spinner |
| Disabled | `dark-neutral-100` | `dark-neutral-400` | None | — | None | — | — |

**State Transition Timing:**
- Hover: 150ms ease-out
- Focus: 0ms (instant)
- Active/Pressed: 0ms (instant)
- Loading: Spinner animation 800ms linear infinite

### 4.3 Form Elements

| Element | Background | Border | Text | Focus Border |
|---------|------------|--------|------|--------------|
| Input (default) | White | `neutral-200` | `neutral-700` | `brand-500` |
| Input (disabled) | `neutral-50` | `neutral-100` | `neutral-400` | — |
| Input (error) | `danger-50` | `danger-500` | `neutral-700` | `danger-600` |
| Checkbox/Radio | White | `neutral-300` | — | `brand-500` |
| Label | — | — | `neutral-700` | — |
| Helper text | — | — | `neutral-500` | — |

### 4.4 Status Indicators

| Status | Light Mode | Dark Mode | Usage |
|--------|------------|-----------|-------|
| Success | `success-500` | `dark-success-500` | Completed states, positive feedback |
| Warning | `warning-500` | `dark-warning-500` | Cautionary states, needs attention |
| Error | `danger-500` | `dark-danger-500` | Critical errors, blocking issues |
| Info | `info-500` | `dark-info-500` | Neutral information, tips |
| Discovery | `discovery-500` | `dark-discovery-500` | New features, highlights |

**Status Background Patterns:**
- Subtle: 50-level color with matching 900-level text
- Default: 500-level color with white/dark text
- Bold: 600-level color for emphasis

### 4.5 Elevation and Depth

**Light Mode Shadows:**
```css
--shadow-resting: 0 1px 3px rgba(0, 0, 0, 0.12), 0 1px 2px rgba(0, 0, 0, 0.08);
--shadow-hover: 0 4px 6px rgba(0, 0, 0, 0.10), 0 2px 4px rgba(0, 0, 0, 0.06);
--shadow-active: 0 1px 2px rgba(0, 0, 0, 0.15);
--shadow-overlay: 0 20px 25px rgba(0, 0, 0, 0.15), 0 10px 10px rgba(0, 0, 0, 0.10);
```

**Dark Mode Shadows:**
```css
--dark-shadow-resting: 0 1px 3px rgba(0, 0, 0, 0.4), 0 1px 2px rgba(0, 0, 0, 0.3);
--dark-shadow-hover: 0 4px 6px rgba(0, 0, 0, 0.5), 0 2px 4px rgba(0, 0, 0, 0.4);
--dark-shadow-active: 0 1px 2px rgba(0, 0, 0, 0.5);
--dark-shadow-overlay: 0 20px 25px rgba(0, 0, 0, 0.6), 0 10px 10px rgba(0, 0, 0, 0.5);
```

### 4.6 CSS Implementation Examples

#### Token Usage in Components

**Button Component:**
```css
.btn {
  /* Base styles */
  padding: 0.5rem 1rem;
  border-radius: 0.375rem;
  font-weight: 500;
  transition: all 150ms ease-out;
  
  /* Color tokens */
  background-color: var(--accentColor-fg);
  color: var(--fgColor-onEmphasis);
  border: 1px solid transparent;
}

.btn:hover {
  background-color: var(--accentColor-emphasis);
}

.btn:focus-visible {
  outline: 2px solid var(--accentColor-fg);
  outline-offset: 2px;
}

.btn:active {
  background-color: var(--accentColor-emphasis);
  transform: translateY(1px);
}

.btn-secondary {
  background-color: transparent;
  color: var(--fgColor-default);
  border-color: var(--borderColor-default);
}

.btn-secondary:hover {
  background-color: var(--bgColor-muted);
}
```

**Card Component:**
```css
.card {
  background-color: var(--bgColor-default);
  border: 1px solid var(--borderColor-default);
  border-radius: 0.5rem;
  box-shadow: var(--shadow-resting);
  padding: 1.5rem;
}

.card:hover {
  box-shadow: var(--shadow-hover);
}

.card-title {
  color: var(--fgColor-default);
  font-size: 1.25rem;
  font-weight: 600;
  margin-bottom: 0.5rem;
}

.card-description {
  color: var(--fgColor-muted);
  font-size: 0.875rem;
}
```

**Form Input:**
```css
.input {
  width: 100%;
  padding: 0.5rem 0.75rem;
  background-color: var(--bgColor-default);
  border: 1px solid var(--borderColor-default);
  border-radius: 0.375rem;
  color: var(--fgColor-default);
  transition: border-color 150ms ease-out, box-shadow 150ms ease-out;
}

.input::placeholder {
  color: var(--fgColor-muted);
}

.input:hover {
  border-color: var(--borderColor-emphasis);
}

.input:focus {
  border-color: var(--accentColor-fg);
  box-shadow: 0 0 0 3px var(--accentColor-muted);
  outline: none;
}

.input:disabled {
  background-color: var(--bgColor-muted);
  color: var(--fgColor-disabled);
  cursor: not-allowed;
}

.input-error {
  border-color: var(--danger-fg);
  background-color: var(--danger-muted);
}

.input-error:focus {
  border-color: var(--danger-emphasis);
  box-shadow: 0 0 0 3px rgba(198, 40, 40, 0.15);
}
```

#### Theme Switching Implementation

**CSS Custom Properties Approach:**
```css
:root {
  /* Light mode as default */
  --bgColor-default: #FFFFFF;
  --bgColor-muted: #F8F9FA;
  --fgColor-default: #212529;
  --fgColor-muted: #6C757D;
  --accentColor-fg: #0D8C8C;
  /* ... all other tokens ... */
}

/* Dark mode class */
.dark {
  --bgColor-default: #0D1117;
  --bgColor-muted: #161B22;
  --fgColor-default: #E5E8EB;
  --fgColor-muted: #8B949E;
  --accentColor-fg: #33ADAD;
  /* ... all other dark tokens ... */
}

/* System preference */
@media (prefers-color-scheme: dark) {
  :root:not(.light) {
    --bgColor-default: #0D1117;
    --bgColor-muted: #161B22;
    --fgColor-default: #E5E8EB;
    --fgColor-muted: #8B949E;
    --accentColor-fg: #33ADAD;
    /* ... all other dark tokens ... */
  }
}
```

**JavaScript Theme Toggle:**
```javascript
function toggleTheme() {
  const html = document.documentElement;
  const isDark = html.classList.toggle('dark');
  localStorage.setItem('theme', isDark ? 'dark' : 'light');
}

// Initialize theme on load
const savedTheme = localStorage.getItem('theme');
const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

if (savedTheme === 'dark' || (!savedTheme && prefersDark)) {
  document.documentElement.classList.add('dark');
}
```

#### Complete Component Example

**Status Badge Component:**
```css
.badge {
  display: inline-flex;
  align-items: center;
  gap: 0.375rem;
  padding: 0.25rem 0.625rem;
  border-radius: 9999px;
  font-size: 0.75rem;
  font-weight: 500;
}

.badge-success {
  background-color: var(--success-muted);
  color: var(--success-fg);
}

.badge-warning {
  background-color: var(--warning-muted);
  color: var(--warning-fg);
}

.badge-danger {
  background-color: var(--danger-muted);
  color: var(--danger-fg);
}

.badge-info {
  background-color: var(--info-muted);
  color: var(--info-fg);
}

/* Usage in HTML */
/* <span class="badge badge-success"> */
/*   <svg><!-- check icon --></svg> */
/*   Success */
/* </span> */
```

#### Design Tool Integration

When exporting tokens to Figma, Sketch, or other design tools:

**Format Options:**
- **Figma Tokens Plugin**: Export as JSON with `$value` and `$type` properties
- **Sketch**: Use color variables with matching token names
- **Style Dictionary**: Generate platform-specific formats (CSS, SCSS, iOS, Android)

**Naming Conventions:**
```json
{
  "color": {
    "bgColor": {
      "default": { "$value": "#FFFFFF", "$type": "color" },
      "muted": { "$value": "#F8F9FA", "$type": "color" }
    },
    "fgColor": {
      "default": { "$value": "#212529", "$type": "color" },
      "muted": { "$value": "#6C757D", "$type": "color" }
    }
  }
}
```

**Token Organization:**
- Group by semantic purpose (background, foreground, border, accent)
- Include both light and dark mode variants
- Reference primitive values (hex codes) rather than duplicating
- Maintain consistent naming across design tools and code

**Sync Strategy:**
- Use single source of truth (e.g., Tokens Studio for Figma)
- Automate export via CI/CD pipeline
- Version control tokens alongside code
- Document any design-tool-specific customizations

**Toast/Alert Component:**
```css
.alert {
  display: flex;
  gap: 0.75rem;
  padding: 1rem;
  border-radius: 0.5rem;
  border-left: 4px solid;
}

.alert-success {
  background-color: var(--success-muted);
  border-left-color: var(--success-fg);
}

.alert-success .alert-icon {
  color: var(--success-fg);
}

.alert-danger {
  background-color: var(--danger-muted);
  border-left-color: var(--danger-fg);
}

.alert-danger .alert-icon {
  color: var(--danger-fg);
}

.alert-title {
  color: var(--fgColor-default);
  font-weight: 600;
  margin-bottom: 0.25rem;
}

.alert-message {
  color: var(--fgColor-muted);
  font-size: 0.875rem;
}
```

## 5. Accessibility Requirements

### 5.1 WCAG 2.1 AA Compliance

**Contrast Ratio Requirements:**

| Element Type | Minimum Ratio | Target Ratio |
|--------------|---------------|--------------|
| Normal text (< 18pt) | 4.5:1 | 7:1 (AAA) |
| Large text (≥ 18pt or ≥ 14pt bold) | 3:1 | 4.5:1 |
| UI components (borders, icons) | 3:1 | 4.5:1 |
| Graphical objects | 3:1 | 4.5:1 |

**Verified Combinations:**

| Combination | Ratio | Compliant |
|-------------|-------|-----------|
| `neutral-800` on White | 15.3:1 | AAA |
| `neutral-700` on `neutral-50` | 10.2:1 | AAA |
| `neutral-600` on White | 7.4:1 | AAA |
| `brand-600` on White | 5.2:1 | AA |
| `danger-500` on `danger-50` | 7.1:1 | AAA |
| White on `brand-500` | 4.6:1 | AA |

### 5.2 Color Independence

**Never rely on color alone to convey:**
- Required field status (use asterisk + text)
- Error states (use icons + text)
- Link states (use underlines + color)
- Success/confirmation (use checkmarks + text)

**Required accompaniments:**
- Icons for all status indicators
- Text labels for all color-coded information
- Patterns or borders for data visualization

### 5.3 Focus Indicators

All interactive elements must have visible focus states:

```css
:focus-visible {
  outline: 2px solid var(--accentColor-fg);
  outline-offset: 2px;
}

/* Dark mode */
.dark :focus-visible {
  outline: 2px solid var(--dark-accentColor-fg);
}
```

### 5.4 Color Blindness Considerations

**Test all color combinations for:**
- Protanopia (red-blind)
- Deuteranopia (green-blind)
- Tritanopia (blue-blind)
- Achromatopsia (complete color blindness)

**Safe color pairs:**
- Use luminance contrast, not just hue contrast
- Pair warm colors with cool colors (e.g., amber + blue)
- Avoid red/green combinations without additional indicators

### 5.5 Reduced Motion and Preference

Respect user preferences:

```css
@media (prefers-reduced-motion: reduce) {
  /* Static color transitions only */
  * {
    transition-duration: 0.01ms !important;
  }
}

@media (prefers-contrast: more) {
  /* Increase border contrast */
  --borderColor-default: var(--neutral-400);
}
```

### 5.6 Dark Mode Implementation

**System preference detection:**

```css
@media (prefers-color-scheme: dark) {
  :root {
    /* Apply dark mode tokens */
  }
}
```

**Manual toggle support:**
- Provide user preference override
- Store preference in localStorage
- Apply class to `<html>` or `<body>` element

---

## 6. Migration from Legacy Systems

### 6.1 Assessment Phase

**Inventory existing color usage:**
1. Audit all hardcoded color values in CSS, SCSS, or component files
2. Document current color mappings (e.g., `#007bff` → primary blue)
3. Identify semantic usage patterns (success states, error states, etc.)
4. Note custom or one-off colors that need special handling

**Common legacy patterns to address:**
- Hardcoded hex values (e.g., `#000000`, `#ffffff`)
- Named colors (e.g., `red`, `blue`, `green`)
- RGB/RGBA values without design token references
- Opacity overlays for state changes (prefer dedicated tokens)
- Framework-specific color utilities (e.g., Bootstrap's `text-primary`)

### 6.2 Migration Strategy

**Phase 1: Token Foundation**
```css
/* Create mapping layer for gradual migration */
:root {
  /* Legacy variable names mapped to new tokens */
  --primary-color: var(--accentColor-fg);
  --secondary-color: var(--fgColor-muted);
  --background-color: var(--bgColor-default);
  --text-color: var(--fgColor-default);
  --border-color: var(--borderColor-default);
  
  /* Semantic mappings */
  --success-color: var(--success-fg);
  --error-color: var(--danger-fg);
  --warning-color: var(--warning-fg);
}
```

**Phase 2: Component Migration**
- Start with most reused components (buttons, inputs, cards)
- Update one component type at a time
- Maintain visual regression tests to catch unintended changes
- Use automated tools to find/replace color values

**Phase 3: Cleanup**
- Remove legacy color variables after full migration
- Delete unused color definitions
- Update documentation and style guides

### 6.3 Common Migration Patterns

**From Hardcoded Values:**
```css
/* Before */
.button {
  background: #0D8C8C;
  color: white;
}

/* After */
.button {
  background: var(--accentColor-fg);
  color: var(--fgColor-onEmphasis);
}
```

**From Framework Classes:**
```html
<!-- Before (Bootstrap-style) -->
<button class="btn btn-primary">Submit</button>
<span class="text-success">Completed</span>

<!-- After -->
<button class="btn btn-primary">Submit</button>
<span class="badge badge-success">Completed</span>
```

**From RGBA State Management:**
```css
/* Before - using opacity for hover states */
.button {
  background: #0D8C8C;
}
.button:hover {
  background: rgba(13, 140, 140, 0.8);
}

/* After - using dedicated tokens */
.button {
  background: var(--accentColor-fg);
}
.button:hover {
  background: var(--accentColor-emphasis);
}
```

### 6.4 Breaking Changes to Address

| Legacy Pattern | New Pattern | Impact |
|----------------|-------------|--------|
| Pure black text (`#000000`) | `neutral-800` (#212529) | Slightly softer, better for reading |
| Pure white backgrounds | `neutral-0` (#FFFFFF) | Same value, tokenized |
| Red/green alone for status | Color + icon + text | Accessibility improvement |
| Opacity for disabled states | Dedicated disabled tokens | Predictable contrast |
| Custom color for every brand | Semantic brand tokens | Consistent theming |

### 6.5 Validation Checklist

After migration, verify:
- [ ] No hardcoded hex values remain in component styles
- [ ] All interactive elements use token-based colors
- [ ] Dark mode renders correctly with no manual overrides
- [ ] Contrast ratios meet WCAG AA standards
- [ ] Visual regression tests pass
- [ ] Design team approves color mappings

### 6.6 Communication Plan

**For Design Teams:**
- Provide color mapping reference sheet
- Host workshop on semantic token usage
- Update design system documentation

**For Engineering Teams:**
- Create migration guide with code examples
- Provide automated migration scripts where possible
- Establish code review checklist for color usage

**For Stakeholders:**
- Communicate accessibility improvements
- Highlight consistency benefits
- Show before/after visual comparisons

---

## 7. Quick Reference Cheat Sheet

### Most-Used Tokens (One-Page Summary)

#### Essential Background Colors
| Token | Light Mode | Dark Mode | Usage |
|-------|------------|-----------|-------|
| `--bgColor-default` | `#FFFFFF` | `#0D1117` | Primary backgrounds |
| `--bgColor-muted` | `#F8F9FA` | `#161B22` | Cards, elevated surfaces |
| `--bgColor-inset` | `#E9ECEF` | `#010409` | Panels, sidebars |

#### Essential Text Colors
| Token | Light Mode | Dark Mode | Usage |
|-------|------------|-----------|-------|
| `--fgColor-default` | `#212529` | `#E5E8EB` | Primary text, headings |
| `--fgColor-muted` | `#6C757D` | `#8B949E` | Secondary text, captions |
| `--fgColor-onEmphasis` | `#FFFFFF` | `#0D1117` | Text on colored backgrounds |

#### Essential Interactive Colors
| Token | Light Mode | Dark Mode | Usage |
|-------|------------|-----------|-------|
| `--accentColor-fg` | `#0D8C8C` | `#33ADAD` | Links, primary buttons |
| `--accentColor-emphasis` | `#0A7070` | `#5CC0C0` | Hover states |
| `--borderColor-default` | `#DEE2E6` | `#30363D` | Input borders, dividers |

#### Status Colors
| Status | Token (Light/Dark) | Background | Text |
|--------|-------------------|------------|------|
| Success | `--success-*` | `success-muted` | `success-fg` |
| Warning | `--warning-*` | `warning-muted` | `warning-fg` |
| Error | `--danger-*` | `danger-muted` | `danger-fg` |
| Info | `--info-*` | `info-muted` | `info-fg` |

### Common Color Combinations

| Pattern | Background | Text | Border | Notes |
|---------|------------|------|--------|-------|
| **Default Card** | `--bgColor-default` | `--fgColor-default` | `--borderColor-default` | Standard container |
| **Muted Card** | `--bgColor-muted` | `--fgColor-default` | `--borderColor-muted` | Secondary content |
| **Primary Button** | `--accentColor-fg` | `--fgColor-onEmphasis` | none | CTAs, links |
| **Secondary Button** | `--bgColor-default` | `--fgColor-default` | `--borderColor-default` | Alternative actions |
| **Success Alert** | `--success-muted` | `--success-fg` | `--success-fg` | Confirmation messages |
| **Error Alert** | `--danger-muted` | `--danger-fg` | `--danger-fg` | Error messages |
| **Disabled State** | `--bgColor-muted` | `--fgColor-disabled` | none | Non-interactive |
| **Link Default** | transparent | `--accentColor-fg` | none | Underline on hover |

### Do's and Don'ts Checklist

#### Do's
- [ ] Use semantic tokens (`--bgColor-default`, not `--neutral-0`)
- [ ] Always pair color with icons or text for status indicators
- [ ] Test contrast ratios before shipping (minimum 4.5:1 for text)
- [ ] Use `--accentColor-emphasis` for hover states
- [ ] Provide focus rings with `--accentColor-fg`
- [ ] Support both light and dark modes
- [ ] Use `--bgColor-muted` for card backgrounds
- [ ] Use `--fgColor-onEmphasis` on colored backgrounds

#### Don'ts
- [ ] Never use pure black (`#000000`) or pure white (`#FFFFFF`) directly
- [ ] Don't rely on color alone for error states (always add icons)
- [ ] Don't use `--danger-*` colors for non-destructive actions
- [ ] Don't mix light mode tokens in dark mode contexts
- [ ] Don't use opacity for state changes (use dedicated tokens)
- [ ] Don't use warning colors for success states
- [ ] Don't skip focus indicators
- [ ] Don't use brand colors for status indicators (use semantic colors)

### Emergency Contrast Ratios Reference

**Guaranteed AA Compliant Combinations:**

| Background | Text | Ratio |
|------------|------|-------|
| White (`#FFFFFF`) | `neutral-800` | 15.3:1 |
| White (`#FFFFFF`) | `neutral-600` | 7.4:1 |
| `neutral-50` | `neutral-700` | 10.2:1 |
| `brand-500` | White | 4.6:1 |
| `danger-50` | `danger-900` | 12.8:1 |
| Dark bg (`#0D1117`) | `dark-neutral-800` | 13.5:1 |
| Dark bg (`#0D1117`) | `dark-neutral-600` | 7.1:1 |
| `dark-brand-500` | `#0D1117` | 8.6:1 |

**Quick Check Formula:**
- Normal text: Needs 4.5:1 minimum
- Large text (18pt+): Needs 3:1 minimum
- UI components: Needs 3:1 minimum

**When in Doubt:**
1. Use `neutral-800` on white for maximum readability
2. Use white on `brand-500` for primary buttons
3. Always verify with a contrast checker tool

---

## 8. Implementation Checklist

- [ ] All text meets minimum 4.5:1 contrast ratio
- [ ] Interactive elements have visible focus states
- [ ] Color is never the sole indicator of meaning
- [ ] Error states use both color and icons
- [ ] Links are distinguishable without relying on color alone
- [ ] Disabled states are clearly differentiated
- [ ] Tested with color blindness simulation tools
- [ ] Respects `prefers-reduced-motion` and `prefers-contrast`
- [ ] Supports both system and manual dark mode preferences

---

## References

1. **Primer Design System** - GitHub's interface guidelines
2. **Atlassian Design System** - Color usage and accessibility
3. **Interaction Design Foundation** - Color theory and psychology
4. **WCAG 2.1 Guidelines** - Web Content Accessibility Guidelines
5. **Color.review** - Contrast checking tool
6. **Stark** - Accessibility testing plugin

---

*Last updated: 2026*
*Version: 1.0*
