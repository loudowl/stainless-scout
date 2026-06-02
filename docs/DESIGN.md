# Stainless Scout — Design Brief
### SDK Detective for Developers Navigating the Post-Acquisition Chaos

---

## 1. Visual Identity

### Brand Personality
**Tone:** Precise, vigilant, trustworthy, quietly urgent. Think: a terminal meets a Bloomberg terminal meets a security dashboard. This is a tool for serious developers who want signal, not noise. The aesthetic should feel like it was built *by* developers *for* developers — dense with information, but never cluttered.

### Mood Board References
- Inspired by: Linear.app (precision), Vercel Dashboard (dark sophistication), GitHub mobile (developer fluency), Raycast (speed-first UI)

---

### Color Palette

#### Primary Brand Colors

| Role | Name | Hex | Usage |
|---|---|---|---|
| Primary | Phosphor Green | `#00E5A0` | CTAs, active states, logo mark, key data highlights |
| Primary Dark | Deep Phosphor | `#00B87A` | Pressed states, hover, borders on dark backgrounds |
| Secondary | Electric Indigo | `#6C63FF` | Premium features, upgrade prompts, secondary actions |
| Secondary Dark | Deep Indigo | `#4A42CC` | Pressed states for secondary |

#### Risk/Status Semantic Colors

| Role | Name | Hex | Usage |
|---|---|---|---|
| Critical Risk | Alarm Red | `#FF4D4D` | Risk score 8–10, "Deprecated" badge |
| High Risk | Ember Orange | `#FF8C42` | Risk score 6–7, "Acquired" badge |
| Medium Risk | Caution Amber | `#FFD166` | Risk score 4–5, "At Risk" badge |
| Low Risk / Safe | Phosphor Green | `#00E5A0` | Risk score 1–3, "Stable" badge |
| Neutral | Steel Blue | `#4A90D9` | Informational states, "Unknown" status |

#### Background & Surface Colors

| Role | Name | Hex | Usage |
|---|---|---|---|
| Background Base (Dark) | Void Black | `#0A0B0D` | App background, dark mode default |
| Surface 1 | Gunmetal | `#111318` | Card backgrounds, list rows |
| Surface 2 | Slate | `#1A1D25` | Modal sheets, input fields, nav bar |
| Surface 3 | Charcoal | `#242832` | Elevated cards, popovers |
| Border / Divider | Steel Edge | `#2E3340` | Separators, card outlines |
| Background (Light) | Off-White | `#F5F6FA` | Light mode base |
| Surface Light 1 | Pale Cloud | `#ECEEF4` | Light mode cards |
| Surface Light 2 | Mist | `#E2E5EE` | Light mode elevated |

#### Text Colors

| Role | Name | Hex (Dark) | Hex (Light) |
|---|---|---|---|
| Primary Text | Bright Ash | `#F0F2F8` | `#0D0F14` |
| Secondary Text | Mid Ash | `#8A8FA8` | `#4A4F66` |
| Tertiary Text | Dim Ash | `#535870` | `#8A8FA8` |
| Disabled Text | Faded | `#3A3F52` | `#C0C4D4` |
| Inverse Text | Void | `#0A0B0D` | `#F0F2F8` |

---

### Logo & Mark
- **Logo Mark:** A stylized shield with a minimal magnifying glass element embedded. The shield is rendered in `#00E5A0` (Phosphor Green) with a thin `2px` stroke style — no fill — giving it a terminal/wireframe quality.
- **Wordmark:** "Stainless Scout" — "Stainless" in medium weight, "Scout" in bold. Both in `#F0F2F8`. The tagline below in `#8A8FA8`.
- **App Icon:** Dark `#111318` background, centered phosphor green shield mark with a subtle inner glow (`rgba(0, 229, 160, 0.3)` radial).

---

## 2. Typography

> **Note:** For SwiftUI iOS, use SF Pro (system font) as the primary font family — it's Apple's standard and provides the most native feel. Below specifies the typographic *system* using SF Pro equivalents mapped to design tokens.

### Font Families

| Role | Font | Fallback |
|---|---|---|
| **Primary / Headings** | SF Pro Display (system) | `Inter` (Google Fonts for design mocks) |
| **Body / UI** | SF Pro Text (system) | `Inter` (Google Fonts) |
| **Monospace / Code** | SF Mono (system) | `JetBrains Mono` (Google Fonts) |

> For Figma/design mockup files, use **Inter** (Google Fonts) for all sans-serif and **JetBrains Mono** for all monospace elements.

---

### Type Scale (iOS-native, pt units)

```
Display Large      — 34pt / Bold (700) / -0.5 tracking
Display Medium     — 28pt / Bold (700) / -0.4 tracking
Title 1            — 22pt / Semibold (600) / -0.3 tracking
Title 2            — 20pt / Semibold (600) / -0.2 tracking
Title 3            — 17pt / Semibold (600) / 0 tracking
Headline           — 15pt / Semibold (600) / 0.1 tracking
Body               — 17pt / Regular (400) / 0 tracking
Body Small         — 15pt / Regular (400) / 0 tracking
Callout            — 14pt / Medium (500) / 0.1 tracking
Subheadline        — 13pt / Regular (400) / 0 tracking
Caption 1          — 12pt / Regular (400) / 0.2 tracking
Caption 2          — 11pt / Regular (400) / 0.3 tracking
Label / Badge      — 10pt / Bold (700) / 0.5 tracking / ALL CAPS
Mono Body          — 15pt / Regular (400) / 0 tracking
Mono Small         — 13pt / Regular (400) / 0.1 tracking
Mono Label         — 11pt / Medium (500) / 0.2 tracking
```

### Typographic Rules
- **Risk scores** always render in `SF Mono` / `JetBrains Mono` — the numerical precision feel is intentional
- **SDK names** render in `Title 3` / `Semibold` with `#F0F2F8`
- **Company names / acquirers** render in `Caption 1` / `ALL CAPS` with `0.5` letter spacing in `#8A8FA8`
- **Status badges** always use `Label` style — 10pt, bold, all caps, 0.5 tracking
- **Code snippets / SDK identifiers** (e.g., `com.stripe.ios`) always in Mono Small, `#00E5A0` on `Surface 1` background

---

## 3. Component Library

### 3.1 Navigation Components

#### Tab Bar
```
Height: 83pt (includes safe area)
Active tab icon + label: #00E5A0 (Phosphor Green)
Inactive tab: #535870 (Dim Ash)
Background: #111318 with blur effect (ultraThinMaterial)
Border top: 1pt, #2E3340
Tabs: Search | Watchlist | Alerts | Settings
Icons: SF Symbols — magnifyingglass, bookmark.fill, 
       bell.badge.fill, gearshape.fill
```

#### Navigation Bar (Large Title)
```
Background: #0A0B0D
Large Title: Display Medium, #F0F2F8
Inline Title: Title 2, #F0F2F8
Trailing action icons: #00E5A0
Bottom border: 1pt, #2E3340
```

---

### 3.2 SDK Risk Card (Primary Component)

The most important component in the app. Must convey maximum information at a glance.

```
╔══════════════════════════════════════════╗
║  [LOGO 36pt]  Stripe iOS SDK            ║
║               STRIPE INC                ║
║               ──────────────────────    ║
║  ● STABLE     Risk Score: [7.2]         ║
║               ━━━━━━━━━━░░░  72%        ║
║                                         ║
║  Last event: Acquired by VISA — 3d ago  ║
║  [iOS] [Android] [React Native]         ║
╚══════════════════════════════════════════╝
```

**Visual Specs:**
```
Container:
  Background: #111318
  Border: 1pt, #2E3340
  Corner Radius: 16pt
  Padding: 16pt horizontal, 14pt vertical
  Shadow: 0 4pt 20pt rgba(0,0,0,0.5)

Logo Container:
  Size: 36×36pt
  Corner Radius: 8pt
  Background: #1A1D25
  Border: 1pt, #2E3340

SDK Name:
  Style: Title 3 / Semibold
  Color: #F0F2F8

Company Name:
  Style: Label (10pt, Bold, ALL CAPS, 0.5 tracking)
  Color: #535870

Status Badge (left-aligned, below company):
  See Badge Component — §3.5

Risk Score Numeral:
  Font: Mono Body (15pt) / Bold
  Color: Dynamic — matches semantic risk color
  Format: "7.2" — always one decimal place

Risk Progress Bar:
  Height: 4pt
  Corner Radius: 2pt
  Track Color: #2E3340
  Fill Color: Dynamic semantic risk color
  Width: 140pt
  Animation: Spring fill on card appear

Platform Tags:
  Style: Mono Label (11pt)
  Color: #8A8FA8
  Background: #1A1D25
  Border: 1pt, #2E3340
  Corner Radius: 4pt
  Padding: 4pt × 8pt

Last Event Text:
  Style: Caption 1
  Color: #8A8FA8
  Timestamp: #535870
```

---

### 3.3 Risk Score Badge (Inline)

Used within cards, list rows, and detail views.

```
┌──────────────────┐
│  ⬡  8.4  CRITICAL│
└──────────────────┘
```

```
Design Variants:
  STABLE (1.0–3.9)   — Fill: rgba(0,229,160,0.15)  | Text: #00E5A0  | Dot: #00E5A0
  AT RISK (4.0–5.9)  — Fill: rgba(255,209,102,0.15) | Text: #FFD166  | Dot: #FFD166
  HIGH (6.0–7.9)     — Fill: rgba(255,140,66,0.15)  | Text: #FF8C42  | Dot: #FF8C42
  CRITICAL (8.0–10)  — Fill: rgba(255,77,77,0.15)   | Text: #FF4D4D  | Dot: #FF4D4D
  UNKNOWN            — Fill: rgba(74,144,217,0.15)   | Text: #4A90D9  | Dot: #4A90D9

Dimensions:
  Height: 24pt
  Corner Radius: 6pt
  Padding: 6pt × 10pt
  Font: Label style (10pt Bold ALL CAPS 0.5 tracking)
  Dot: 6pt circle, filled, left-aligned with 6pt gap
```

---

### 3.4 Search Bar (Custom)

```
┌─────────────────────────────────────────────┐
│  🔍  Search SDKs, companies, categories...  │
└─────────────────────────────────────────────┘
```

```
Height: 48pt
Corner Radius: 12pt
Background: #1A1D25
Border: 1pt #2E3340 (unfocused)
Border: 1pt #00E5A0 (focused — animated transition)
Icon: magnifyingglass, #535870, 18pt, 14pt left padding
Placeholder: Body, #535870
Input Text: Body, #F0F2F8
Clear Button: xmark.circle.fill, #535870, appears when text present
Filter Button (trailing): slider.horizontal.3, #8A8FA8
  — Tapping opens Filter Sheet (§3.9)
Focus Animation: border color transitions 0.2s ease, 
  subtle glow rgba(0,229,160,0.1) background shift
```

---

### 3.5 Status Badge (Acquisition State)

Distinct from Risk Score Badge. Reflects current acquisition lifecycle state.

```
States & Styling:
  ● STABLE      — #00E5A0 text, rgba(0,229,160,0.12) fill
  ● ACQUIRED    — #FF8C42 text, rgba(255,140,66,0.12) fill
  ● DEPRECATED  — #FF4D4D text, rgba(255,77,77,0.12) fill
  ● SUNSET      — #FF4D4D text + strikethrough on SDK name
  ● AT RISK     — #FFD166 text, rgba(255,209,102,0.12) fill
  ● MONITORING  — #4A90D9 text, rgba(74,144,217,0.12) fill

Shape: Pill (corner radius: 100pt)
Height: 20pt
Padding: 4pt × 10pt
Font: 10pt / Bold / 0.5 tracking / CAPS
Dot: 5pt filled circle, 5pt gap before text
```

---

### 3.6 Section Header Row

```
[CATEGORY LABEL]           See All  ›
```

```
Category Label: Headline (15pt Semibold), #F0F2F8
"See All" link: Callout (14pt Medium), #00E5A0
Padding: 0pt horizontal (aligned to content grid)
Bottom margin: 10pt before card content
```

---

### 3.7 Alert / Notification Item

Used in the Alerts tab — timeline-style layout.

```
│●  Twilio acquired by [Company]              │
│   STRIPE INC · iOS SDK                     │
│   Risk increased: 3.1 → 7.8   ↑ +4.7      │
│                              2 hours ago   │
```

```
Left indicator dot:
  Size: 10pt circle
  Color: Semantic risk color
  Connected by 1pt vertical line to next item

Title: Body Small (15pt Regular), #F0F2F8
Subtitle: Caption 1 (12pt), #8A8FA8
Risk delta: Mono Small (13pt)
  Color: #FF4D4D if increase, #00E5A0 if decrease
  Prefix: ↑ or ↓ symbol
Timestamp: Caption 2 (11pt), #535870, trailing aligned

Row background: #111318
Row padding: 16pt horizontal, 12pt vertical
Divider: 1pt #1A1D25, inset 36pt from left
```

---

### 3.8 Primary CTA Button

```
┌──────────────────────────────┐
│   Scan My Stack  →           │
└──────────────────────────────┘
```

```
Height: 54pt
Corner Radius: 14pt
Background: #00E5A0
Text: Title 3 (17pt Semibold), #0A0B0D (Inverse)
Icon: arrow.right, trailing, 16pt, #0A0B0D
Padding: 24pt horizontal

States:
  Default:  background #00E5A0
  Pressed:  background #00B87A, scale 0.97, 0.1s spring
  Disabled: background #2E3340, text #535870
  Loading: