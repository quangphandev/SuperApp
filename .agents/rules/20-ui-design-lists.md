---
description: DesignSystem, list UI, TableView, CollectionView, and visual implementation rules.
globs:
  - "SuperApp_PQ/DesignSystem/**/*.swift"
  - "SuperApp_PQ/Features/**/View/**/*.swift"
  - "SuperApp_PQ/Features/**/Components/**/*.swift"
  - "SuperApp_PQ/Core/Base/Base*ViewController.swift"
alwaysApply: false
---

# UI, DesignSystem, And Lists

Analyze the design before coding. Choose the right base class before writing any layout code.

## Visual Direction

Use the Luma profile from `AGENTS.md`:
- Native mobile clean, shared dark shell, app accents.
- Balanced density — modern rounded shapes (14–20 px radius).
- Inter typography, rounded line icons, springy mobile motion.
- Filled/elevated dark cards; visible borders only for hierarchy/accessibility.

## Base Class Decision Tree

```
Does the screen need:
├── A keyboard-aware form?            → BaseFormViewController
├── Horizontal paged tabs?            → BasePagingViewController
├── An in-app web page?               → BaseWebViewController
├── A sheet/modal presentation?       → BaseBottomSheet
├── Simple vertical rows / settings?  → BaseTableViewController
├── Grids, carousels, mixed sections? → BaseCollectionViewController
└── None of the above (custom layout) → BaseViewController
```

### When to use each

| Base | Use for |
|---|---|
| `BaseTableViewController` | Settings, forms, menus, simple vertical feeds, uniform rows |
| `BaseCollectionViewController` | Grids, banners, carousels, dashboards, mixed sections, adaptive sizes |
| `BaseFormViewController` | Login, registration, search, any screen with keyboard inputs |
| `BasePagingViewController` | Feature tabs (English/Fit mini-app tabs, paged onboarding) |
| `BaseBottomSheet` | Action sheets, filter panels, pickers, quick confirmations |
| `BaseWebViewController` | Terms, help articles, OAuth, lightweight web content |
| `BaseViewController` | Custom scrollable or static screens that don't fit above |

## DesignSystem — Always Use Tokens

**Never** hardcode colors, fonts, spacing, or radii when a token exists.

### Foundations
```swift
// Colors
AppColor.background          // UIColor.systemBackground
AppColor.groupedBackground   // UIColor.systemGroupedBackground
AppColor.surface             // UIColor.secondarySystemGroupedBackground
AppColor.elevatedSurface     // UIColor.tertiarySystemGroupedBackground
AppColor.textPrimary         // UIColor.label
AppColor.textSecondary       // UIColor.secondaryLabel
AppColor.textInverse         // UIColor.white  (use on solid accent fills)
AppColor.accent              // UIColor.systemBlue
AppColor.accentSecondary     // UIColor.systemIndigo
AppColor.border              // UIColor.separator
AppColor.success / .warning / .error

// Typography
AppFont.largeTitle    // Inter Bold 28
AppFont.title         // Inter Bold 22
AppFont.headline      // Inter SemiBold 17
AppFont.subheadline   // Inter SemiBold 15
AppFont.body          // Inter Regular 15
AppFont.bodyMedium    // Inter Medium 15
AppFont.caption       // Inter Regular 13
AppFont.captionMedium // Inter Medium 13
AppFont.metric        // Monospaced Bold 32 (for numbers, timers)

// Spacing
AppSpacing.xSmall(4) .small(8) .medium(12) .large(16) .xLarge(20) .xxLarge(24) .section(32)

// Shape
AppRadius.small / .medium / .large / .xLarge / .full
AppShadow.card / .elevated / .none
```

### Components
```swift
AppButton(style: .primary)       // Primary CTA
AppButton(style: .secondary)     // Secondary action
AppButton(style: .ghost)         // Borderless
AppButton(style: .destructive)   // Delete/remove
AppIconButton(icon: UIImage?)    // Icon-only tap
AppCardView()                    // Dark rounded card surface
AppChip(title: "Filter")         // Label or filter chip
AppBadgeView()                   // Count or status badge
AppTextField()                   // Styled text field with states
AppDivider()                     // Horizontal/vertical divider
StateView(state: .empty / .loading / .error(retry:))
ToastView.show(message:)
```

## TableView (BaseTableViewController)

```swift
override func setupTableView() {
    tableView.register(MyCell.self)  // Uses Reusable protocol
    tableView.dataSource = dataSource
}
// Use state helpers:
showContent()       // show tableView, hide states
showEmptyState()    // show empty view, hide tableView
showErrorState()    // show error view with retry, hide tableView
// Pagination:
// loadMoreTrigger emits when user scrolls to bottom
// refreshTrigger emits on pull-to-refresh
```

## CollectionView (BaseCollectionViewController)

```swift
override func configureCollectionLayout() -> UICollectionViewLayout {
    // Return compositional layout
    let layout = UICollectionViewCompositionalLayout { sectionIndex, env in
        // return NSCollectionLayoutSection
    }
    return layout
}
// Prefer DiffableDataSource + CellRegistration for dynamic content
// Avoid reloadData() — use apply(snapshot:) instead
```

## Cells

- Subclass `BaseTableCell` or `BaseCollectionCell`.
- Configure display data only — no business logic, no network calls.
- Reset all visual state in `prepareForReuse()`.
- Reset `DisposeBag` in `prepareForReuse()` for Rx-bound cells.
- Avoid expensive work (image decode, layout recalc) in reuse path.

## Animation

- Use `AppAnimation` helpers and `UIView+Animation` extensions.
- Apply subtle scale/spring for taps, cards, tabs, CTAs.
- Disabled or loading controls must not animate as active.
- Use spring for state transitions, fade for visibility changes.
