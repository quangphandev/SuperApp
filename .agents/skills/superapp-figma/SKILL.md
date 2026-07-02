---
name: superapp-figma
description: "Perform Figma design work for SuperApp_PQ: inspect frames, create or update components, apply Luma design tokens, validate screens with screenshots, and ensure design-to-code parity. Use when the user asks to design, redesign, inspect, audit, or validate any Figma screen or component for this project."
---

# SuperApp Figma Skill

## Required Flow (Every Visual Change)

1. **Inspect** — Read the current frame/component before editing.
2. **Create or Modify** — Apply the Luma profile decisions below.
3. **Screenshot** — Capture after every meaningful change.
4. **Audit** — Check alignment, spacing, color, typography.
5. **Iterate** — Fix issues found in audit.
6. **Final screenshot** — Validate the end result.

Never skip the screenshot step. Never report a change as done without visual confirmation.

## Active Design Profile

From `AGENTS.md` — use this profile for all Figma work unless the user explicitly overrides it.

| Decision | Selection |
|---|---|
| Visual Direction | D. Native Mobile Clean |
| Theme Strategy | A. Shared Dark Shell + App Accents |
| Density | B. Balanced |
| Shape Language | B. Modern Rounded (14–20 px radius) |
| Color Intensity | B. Balanced Accent |
| Typography | B. Inter |
| Icon Style | B. Rounded Line |
| Motion Style | B. Springy Mobile |
| Component Style | B/C. Filled Cards + light Elevated Cards |
| Handoff Strictness | C/D. Component Discipline + Production Validation |

## Brand

- App name: **Luma**
- Logo mark: orbit ring + cyan core + rose spark
- Do not use "Dev Lab", "dev/lab", or old 3×3 dot-grid logo
- Splash screens: full Luma mark + name
- In-app shell: compact brand chip only where brand context is needed

## Color Rules

Always use semantic tokens. Never apply raw hex to surfaces or text.

| Use | Token / Approach |
|---|---|
| Screen background | Dark system background (#1C1C1E equivalent) |
| Card/surface | Slightly lighter dark fill (secondary grouped background) |
| Elevated card | Tertiary dark fill + subtle 1pt separator border |
| Text primary | White / `label` |
| Text secondary | 60–70% white / `secondaryLabel` |
| Text on accent fill | White only (`textInverse`) |
| Accent (CTA, links) | System blue (`#0A84FF`) |
| Secondary accent | System indigo |
| Error / destructive | System red |
| Success | System green |
| Warning | System orange |

## Typography Rules

- Use **Inter** for all body, label, and heading copy.
- Scale: 28 (large title), 22 (title), 17 (headline semibold), 15 (body/subheadline), 13 (caption).
- Monospaced digits for metrics, numbers, balances, timers.
- Minimum body size: 13 pt for readability.

## Spacing & Radius Rules

- Horizontal screen margins: 20 pt
- Between sections: 32 pt
- Between cards/rows: 12 pt
- Internal card padding: 16–20 pt
- Card radius: 20 pt (large cards), 16 pt (medium), 12 pt (small / fields)
- Button radius: 16 pt (large), 12 pt (medium)

## Component Rules

Before creating any new element:
1. Check if an existing component in the Figma file or library covers the use case.
2. Prefer instances of existing components over new frames.
3. If creating a new component: use **Auto Layout**, bind to variables/tokens, name clearly.
4. Required component states: **Default, Hover/Pressed, Disabled, Loading, Selected, Error**.

Refactor order for broad design work:
1. Define theme variables.
2. Normalize shell: page root, top bars, bottom nav.
3. Normalize base components: button, chip, card, row, tab, stat card.
4. Rebuild screens from components.
5. Validate by screenshot and audit.

## Figma MCP Tools Available

```
figma_take_screenshot       — capture current state
figma_get_selection         — inspect selected layer
figma_lint_design           — run automated design audit
figma_check_design_parity   — compare frame to code
figma_get_design_system_summary — overview of tokens and components
figma_set_fills             — set layer fill programmatically
figma_set_text              — set text content
figma_resize_node           — resize a frame or layer
figma_move_node             — reposition a layer
figma_clone_node            — clone existing component
figma_instantiate_component — place a component instance
figma_set_instance_properties — set props on a component instance
figma_audit_component_accessibility — check contrast and tap targets
figma_export_tokens         — export design tokens
```

## Screenshot Validation Checklist

After every change, capture a screenshot and verify:
- [ ] Colors match the Luma dark profile (no light surfaces, no raw hex fills)
- [ ] Text is legible — never use `textInverse` on dark backgrounds
- [ ] Card radius is consistent (20 pt for large cards)
- [ ] Spacing follows the 4–8–12–16–20–24–32 pt grid
- [ ] Interactive elements have visible press/active states
- [ ] Icons use rounded-line style, consistent size (22–24 pt)
- [ ] No hardcoded colors on layers that should use semantic tokens

## Related Files

- Design token and component recipe: `/Users/admin/figma-assets/design.md`
- Project brand rules: `AGENTS.md` → "Brand" section
