---
name: superapp-figma
description: "Perform Figma design work for SuperApp_PQ: inspect frames, create or update components, apply Luma design tokens, validate screens with screenshots, and ensure design-to-code parity. Use when the user asks to design, redesign, inspect, audit, or validate any Figma screen or component for this project."
---

# SuperApp Figma

## Required Flow (Every Visual Change)

1. **Inspect** — Read the current frame/component before editing.
2. **Create or Modify** — Apply Luma profile decisions below.
3. **Screenshot** — Capture after every meaningful change.
4. **Audit** — Check alignment, spacing, color, typography.
5. **Iterate** — Fix issues found in audit.
6. **Final screenshot** — Validate end result.

Never skip screenshot validation. Never report done without visual confirmation.

## Active Design Profile

| Decision | Selection |
|---|---|
| Visual Direction | D. Native Mobile Clean |
| Theme Strategy | A. Shared Dark Shell + App Accents |
| Density | B. Balanced |
| Shape Language | B. Modern Rounded (14–20 px) |
| Typography | B. Inter |
| Icon Style | B. Rounded Line |
| Motion Style | B. Springy Mobile |
| Component Style | B/C. Filled Cards + Elevated Cards |
| Handoff Strictness | C/D. Component Discipline + Production |

**Brand**: Luma · orbit ring + cyan core + rose spark.
Do not use "Dev Lab" or old 3×3 dot-grid logo.

## Color Rules

| Use | Token |
|---|---|
| Screen background | Dark system background |
| Card/surface | Slightly lighter dark fill |
| Elevated card | Tertiary dark + subtle 1pt border |
| Text primary | White / `label` |
| Text secondary | 60–70% white |
| Text on accent fill | White only (`textInverse`) |
| Accent (CTA, links) | System blue (`#0A84FF`) |
| Error / destructive | System red |

## Spacing & Radius

- Horizontal margins: 20 pt · Between sections: 32 pt · Between cards: 12 pt
- Internal card padding: 16–20 pt
- Card radius: 20 pt (large) · 16 pt (medium) · 12 pt (small/fields)

## Component Rules

Before creating any new element:
1. Check if existing component covers the use case.
2. Prefer component instances over new frames.
3. New components: use Auto Layout, bind variables/tokens, name clearly.
4. Required states: Default · Hover/Pressed · Disabled · Loading · Selected · Error.

## Screenshot Validation Checklist

- [ ] Colors match Luma dark profile (no light surfaces, no raw hex fills)
- [ ] Text legible — never `textInverse` on dark backgrounds
- [ ] Card radius consistent (20 pt for large cards)
- [ ] Spacing follows 4–8–12–16–20–24–32 pt grid
- [ ] Interactive elements have visible press/active states
- [ ] Icons: rounded-line style, 22–24 pt size
- [ ] No hardcoded colors on layers using semantic tokens

## Related Files

- Token/component recipe: `/Users/admin/figma-assets/design.md`
- Brand rules: `AGENTS.md` → Section 7
