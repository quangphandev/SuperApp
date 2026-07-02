# Design System Token Reference

This file documents all available tokens from `SuperApp_PQ/DesignSystem/Foundation/`.
Always use these tokens — never hardcode raw values.

---

## AppColor

Source: `SuperApp_PQ/DesignSystem/Foundation/AppColor.swift`

### Backgrounds & Surfaces

| Token | System Color | Use |
|---|---|---|
| `AppColor.background` | `UIColor.systemBackground` | Main screen background |
| `AppColor.groupedBackground` | `UIColor.systemGroupedBackground` | Grouped/inset screen background |
| `AppColor.surface` | `UIColor.secondarySystemGroupedBackground` | Card/row surface |
| `AppColor.elevatedSurface` | `UIColor.tertiarySystemGroupedBackground` | Elevated card surface |

### Text

| Token | System Color | Use |
|---|---|---|
| `AppColor.textPrimary` | `UIColor.label` | Primary body/headline text |
| `AppColor.textSecondary` | `UIColor.secondaryLabel` | Supporting/caption text |
| `AppColor.textInverse` | `UIColor.white` | Text on solid accent fills (e.g. primary button) |

### Accents & Status

| Token | System Color | Use |
|---|---|---|
| `AppColor.accent` | `UIColor.systemBlue` | Primary interactive, CTAs |
| `AppColor.accentSecondary` | `UIColor.systemIndigo` | Secondary brand accent |
| `AppColor.border` | `UIColor.separator` | Dividers, card borders |
| `AppColor.success` | `UIColor.systemGreen` | Positive status |
| `AppColor.warning` | `UIColor.systemOrange` | Warning status |
| `AppColor.error` | `UIColor.systemRed` | Error / destructive status |

> Bright solid accent fills (`.accent`, `.error`) require `AppColor.textInverse` for text on top.

---

## AppFont

Source: `SuperApp_PQ/DesignSystem/Foundation/AppFont.swift`

Uses Inter font when bundled; falls back to system font automatically.

| Token | Size | Weight | Use |
|---|---|---|---|
| `AppFont.largeTitle` | 28 | Bold | Hero/splash headlines |
| `AppFont.title` | 22 | Bold | Screen titles, section heroes |
| `AppFont.headline` | 17 | SemiBold | Card titles, section headers |
| `AppFont.subheadline` | 15 | SemiBold | Row titles, strong labels |
| `AppFont.body` | 15 | Regular | Body copy, descriptions |
| `AppFont.bodyMedium` | 15 | Medium | Emphasized body |
| `AppFont.caption` | 13 | Regular | Meta, timestamps, supporting |
| `AppFont.captionMedium` | 13 | Medium | Small labels, badges |
| `AppFont.metric` | 32 | Bold (Monospaced) | Numbers, balances, timers |

Custom sizes: use `AppFont.font(size:weight:)`.

---

## AppSpacing

Source: `SuperApp_PQ/DesignSystem/Foundation/AppSpacing.swift`

| Token | Value | Use |
|---|---|---|
| `AppSpacing.xSmall` | 4 pt | Tight internal gaps |
| `AppSpacing.small` | 8 pt | Small padding, icon gaps |
| `AppSpacing.medium` | 12 pt | Standard row padding, stack gaps |
| `AppSpacing.large` | 16 pt | Card internal padding |
| `AppSpacing.xLarge` | 20 pt | Screen horizontal margins |
| `AppSpacing.xxLarge` | 24 pt | Section padding |
| `AppSpacing.section` | 32 pt | Between major screen sections |

---

## AppRadius

Source: `SuperApp_PQ/DesignSystem/Foundation/AppRadius.swift`

| Token | Value | Use |
|---|---|---|
| `AppRadius.small` | 8 pt | Chips, small tags |
| `AppRadius.medium` | 12 pt | Input fields, small cards |
| `AppRadius.large` | 16 pt | Buttons, medium cards |
| `AppRadius.card` | 20 pt | Feature cards, main content cards |

---

## AppShadow

Source: `SuperApp_PQ/DesignSystem/Foundation/AppShadow.swift`

```swift
// Apply card shadow to any UIView:
AppShadow.applyCardShadow(to: view)
// → shadowOpacity: 0.06, offset: (0, 6), radius: 14
```

Use only on `AppCardView` or elevated surfaces. Avoid on flat/inline elements.

---

## AppAnimation

Source: `SuperApp_PQ/DesignSystem/Foundation/AppAnimation.swift`

Respects `UIAccessibility.isReduceMotionEnabled` automatically.

### Duration Constants

| Token | Value | Use |
|---|---|---|
| `AppAnimation.Duration.instant` | 0.08 s | Micro-feedback |
| `AppAnimation.Duration.fast` | 0.14 s | Quick transitions |
| `AppAnimation.Duration.normal` | 0.22 s | Standard transitions |
| `AppAnimation.Duration.slow` | 0.35 s | Page/modal transitions |

### Usage

```swift
// Standard animation
AppAnimation.animate(duration: .normal) {
    view.alpha = 1
}

// Spring animation (for cards, buttons, interactive elements)
AppAnimation.spring {
    card.transform = .identity
}

// Haptic feedback (light = tap, medium = selection, heavy = error)
AppAnimation.haptic(.light)
```

---

## AppButton — Style Reference

Source: `SuperApp_PQ/DesignSystem/Components/AppButton.swift`

```swift
AppButton(title: "Pay Now", style: .primary, size: .large)
AppButton(title: "Cancel", style: .secondary, size: .medium)
AppButton(title: "Learn More", style: .tonal, size: .medium)
AppButton(title: "Skip", style: .ghost, size: .small)
AppButton(title: "Delete", style: .destructive, size: .large)
AppButton(title: "Remove", style: .destructiveSecondary, size: .medium)
```

| Style | Background | Foreground | Border |
|---|---|---|---|
| `.primary` | accent | textInverse | none |
| `.secondary` | clear | accent | accent 1.5pt |
| `.tonal` | accent @ 14% | accent | none |
| `.ghost` | clear | accent | none |
| `.destructive` | error | textInverse | none |
| `.destructiveSecondary` | clear | error | error 1.5pt |

Button sizes: `.small` (36h), `.medium` (44h), `.large` (52h).

Buttons auto-handle: loading state, disabled (α=0.45), haptic, scale-press animation.
