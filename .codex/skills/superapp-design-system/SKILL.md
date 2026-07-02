---
name: superapp-design-system
description: "Apply SuperApp_PQ DesignSystem and Luma UI rules when creating or changing UIKit screens, reusable components, custom buttons, custom animations, colors, typography, spacing, radius, shadows, or visual polish. Use when work touches DesignSystem, visual implementation, component styling, buttons, chips, cards, fields, badges, state views, or animation behavior."
---

# SuperApp Design System

## Source Paths

```
SuperApp_PQ/DesignSystem/Foundation/   ← AppColor, AppFont, AppSpacing, AppRadius, AppShadow, AppAnimation
SuperApp_PQ/DesignSystem/Components/   ← AppButton, AppCardView, AppChip, AppBadgeView, AppTextField,
                                          AppIconButton, AppDivider, StateView, ToastView,
                                          PrimaryButton, SecondaryButton
```

## Workflow

1. Confirm available token names — see `AppColor`, `AppFont`, `AppSpacing`, `AppRadius` in Foundation.
2. Check existing components before creating new ones.
3. Define component states: normal, highlighted, disabled, loading, selected, error.
4. Build using tokens — never raw hex, pt, or string literals.
5. Place reusable components in `DesignSystem/Components/`; feature-local variants in `Features/<Name>/Components/`.

## Quick Rules

| ✅ Do | ❌ Don't |
|---|---|
| `AppColor.accent` | `UIColor.systemBlue` or `#0A84FF` |
| `AppFont.headline` | `UIFont.systemFont(ofSize: 17, weight: .semibold)` |
| `AppSpacing.xLarge` | `20` |
| `AppRadius.card` | `layer.cornerRadius = 20` (magic) |
| `AppButton(style: .primary)` | Custom button duplicating AppButton |
| `AppColor.textInverse` on accent fill | `UIColor.white` hardcoded |
| `AppAnimation.spring(...)` | Raw `UIView.animate(...)` for interactive controls |

## Token Quick Reference

**AppColor**: `.background` `.groupedBackground` `.surface` `.elevatedSurface` `.textPrimary` `.textSecondary` `.textInverse` `.accent` `.accentSecondary` `.border` `.success` `.warning` `.error`

**AppFont**: `.largeTitle`(28B) `.title`(22B) `.headline`(17SB) `.subheadline`(15SB) `.body`(15R) `.bodyMedium`(15M) `.caption`(13R) `.captionMedium`(13M) `.metric`(32 monospaced)

**AppSpacing**: `.xSmall`(4) `.small`(8) `.medium`(12) `.large`(16) `.xLarge`(20) `.xxLarge`(24) `.section`(32)

**AppRadius**: `.small`(8) `.medium`(12) `.large`(16) `.card`(20)

**AppButton styles**: `.primary` `.secondary` `.tonal` `.ghost` `.destructive` `.destructiveSecondary`
**AppButton sizes**: `.small`(36h) `.medium`(44h) `.large`(52h)

## Design Direction

Use the Luma profile from `AGENTS.md`:
- Native mobile clean. Shared dark shell with app accents.
- Balanced density. Modern rounded shapes (14–20 px radius).
- Inter typography. Rounded line icons. Springy mobile motion.
- Filled/elevated dark cards. Visible borders only for hierarchy.

## Component States Checklist

For every interactive component:
- [ ] Normal · Highlighted/Pressed · Disabled · Loading · Selected · Error

## Motion

- Use `AppAnimation.spring(...)` for cards, buttons, tabs, CTAs.
- Use `AppAnimation.haptic(.light)` for tap feedback.
- Disabled/loading controls must not animate as active.
- Respects `UIAccessibility.isReduceMotionEnabled` automatically.
