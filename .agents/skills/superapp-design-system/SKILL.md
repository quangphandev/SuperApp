---
name: superapp-design-system
description: "Apply SuperApp_PQ DesignSystem and Luma UI rules when creating or changing UIKit screens, reusable components, custom buttons, custom animations, colors, typography, spacing, radius, shadows, or visual polish."
---

# SuperApp Design System Skill

Read `references/tokens.md` in this skill folder for the full token reference before implementing.

## Source Paths

```
SuperApp_PQ/DesignSystem/Foundation/   ← AppColor, AppFont, AppSpacing, AppRadius, AppShadow, AppAnimation
SuperApp_PQ/DesignSystem/Components/   ← AppButton, AppCardView, AppChip, AppBadgeView, AppTextField,
                                          AppIconButton, AppDivider, StateView, ToastView,
                                          PrimaryButton, SecondaryButton
```

## Workflow

1. Read `references/tokens.md` to confirm available token names.
2. Check if an existing component covers the use case before creating a new one.
3. Define component states: normal, highlighted, disabled, loading, selected, error.
4. Build using tokens — never raw hex, pt, or string literals.
5. Place reusable components in `DesignSystem/Components/`, feature-local variants in `Features/<Name>/Components/`.

## Quick Rules

| ✅ Do | ❌ Don't |
|---|---|
| `AppColor.accent` | `UIColor.systemBlue` or `#0A84FF` |
| `AppFont.headline` | `UIFont.systemFont(ofSize: 17, weight: .semibold)` |
| `AppSpacing.xLarge` | `20` |
| `AppRadius.medium` | `layer.cornerRadius = 12` (magic) |
| `AppButton(style: .primary)` | Custom button that duplicates AppButton |
| `AppColor.textInverse` on accent fill | `UIColor.white` hardcoded |
| `AppAnimation.spring(...)` | Raw `UIView.animate(...)` for interactive controls |

## Component States Checklist

For every interactive component:
- [ ] **Normal** — default appearance
- [ ] **Highlighted / Pressed** — visual feedback (scale down or color shift)
- [ ] **Disabled** — reduced opacity, non-interactive
- [ ] **Loading** — spinner or shimmer, non-interactive
- [ ] **Selected / Active** — accent fill or border
- [ ] **Error** — `AppColor.error` border or label

## Adding A New Component

1. Subclass `BaseView` or `UIView`.
2. Init with `init(frame:)` and mark `required init?(coder:)` unavailable.
3. Call `setupViews()` → `setupConstraints()` in `init`.
4. Expose only the minimum public API needed.
5. Write a brief `// MARK: - Public API` section.
