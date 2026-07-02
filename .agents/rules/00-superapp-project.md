---
description: Always-on SuperApp_PQ project rules for Antigravity agents.
alwaysApply: true
---

# SuperApp_PQ Project Rules

Use these rules for every task in this workspace.

## Workspace

- Work from `/Users/admin/Desktop/DemoPQ/SuperApp_PQ`.
- Read `AGENTS.md`, `NAMING_CONVENTION.md`, and related source files before broad changes.
- Treat the worktree as dirty by default. Do not revert, delete, or overwrite user changes unless explicitly asked.
- Keep edits surgical and scoped to the user request.

## Shell

Always prefix shell commands with `rtk`.

```bash
rtk rg "HomeViewModel"
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace -scheme SuperApp_PQ\ Staging -destination generic/platform=iOS\ Simulator -quiet build
```

Prefer `rg` / `rg --files` for searching.

## Stack

- UIKit only. Programmatic UI only. No Storyboard, no XIB.
- MVViewModel-C + Clean Architecture with Coordinator navigation.
- Dependency injection via `AppDependencyContainer`.
- RxSwift/RxCocoa — Input/Output transform pattern.
- SnapKit preferred for layout. iOS 15+.

## Source Paths

| Layer | Path |
|---|---|
| DesignSystem Foundations | `SuperApp_PQ/DesignSystem/Foundation/` |
| DesignSystem Components | `SuperApp_PQ/DesignSystem/Components/` |
| Base classes | `SuperApp_PQ/Core/Base/` |
| Network layer | `SuperApp_PQ/Core/Network/` |
| Localization | `SuperApp_PQ/Core/Localization/` |
| Features | `SuperApp_PQ/Features/<FeatureName>/` |
| Feature Presentation | `SuperApp_PQ/Features/<FeatureName>/Presentation/` |
| Feature Domain | `SuperApp_PQ/Features/<FeatureName>/Domain/` |
| Feature Data | `SuperApp_PQ/Features/<FeatureName>/Data/` |
| Resources | `SuperApp_PQ/Resources/` |
| Generated | `SuperApp_PQ/Resources/Generated/` |

## Base Classes Available

**ViewControllers**
- `BaseViewController<ViewModel: BaseViewModel>` — generic screen base
- `BaseTableViewController<ViewModel>` — simple vertical row/form/menu/feed screens
- `BaseCollectionViewController<ViewModel>` — grids, carousels, mixed sections, dashboards
- `BaseFormViewController<ViewModel>` — keyboard-aware form screens
- `BasePagingViewController<ViewModel>` — horizontal paged tab screens
- `BaseBottomSheet` — sheet presentations
- `BaseWebViewController<ViewModel>` — in-app WKWebView screens
- `BaseNavigationController` — navigation shell
- `BaseTabBarController` — tab shell

**Cells / Supplementary**
- `BaseTableCell` — table cells
- `BaseCollectionCell` — collection cells
- `BaseHeaderView` — collection header
- `BaseTableHeaderFooterView` — table header/footer

**Other**
- `BaseViewModel` — ViewModel base (isLoadingRelay, errorRelay, handleError)
- `BaseCoordinator` — Coordinator base (addChild, removeChild, pop, dismiss)
- `BaseView` — Reusable UIView base
- `BaseRepository` — Repository base
- `BaseError` — Typed error base
- `ViewState<T>` — idle / loading / success / failure state enum
- `CoordinatorType` — Coordinator protocol
- `Loadable`, `Bindable`, `Reusable` — Utility protocols

## DesignSystem Available

**Foundations**
- `AppColor` — background, surface, text, accent, status colors
- `AppFont` — largeTitle, title, headline, subheadline, body, caption, metric
- `AppSpacing` — xSmall(4), small(8), medium(12), large(16), xLarge(20), xxLarge(24), section(32)
- `AppRadius` — small, medium, large, xLarge, full
- `AppShadow` — card, elevated, none
- `AppAnimation` — spring, scale, fade helpers

**Components**
- `AppButton` — multi-style button (primary, secondary, ghost, destructive)
- `PrimaryButton` — convenience primary button
- `SecondaryButton` — convenience secondary button
- `AppIconButton` — icon-only tappable button
- `AppCardView` — rounded dark card surface
- `AppChip` — label/filter chip
- `AppBadgeView` — count/status badge
- `AppTextField` — styled text field with states
- `AppDivider` — horizontal/vertical divider
- `StateView` — empty/loading/error state view
- `ToastView` — transient toast notification

## Networking Available

- `APIClientProtocol` / `APIClient` — Alamofire RxSwift wrapper
- `APIEndpoint` — request shape (method, path, params, headers)
- `NetworkConfig` — baseURL, timeout, auth refresh config
- `AuthInterceptor` — bearer token injection + 401 retry
- `TokenRefreshHandler` — single in-flight refresh
- `NetworkError` — typed error cases + user-facing messages
- `KeychainTokenStorage` / `UserDefaultsStorage`
- `SessionManager` — token session state

## Clean Architecture

For new non-trivial features use:

```text
Presentation → Domain ← Data
ViewController → ViewModel → UseCase → RepositoryProtocol ← Repository → Service → DTO
```

- `Domain` owns entities, use cases, and repository protocols.
- `Data` owns DTOs, mappers, repository implementations, and remote/local services.
- `Presentation` owns ViewController, ViewModel, Coordinator, and components.
- ViewModel depends on UseCase protocols, not concrete repositories/services.
- DTOs never escape Data.

## Coding

- Use project headers: author `Phan Quang`, date `dd/MM/yy`.
- Suffixes: `ViewController`, `ViewModel`, `Coordinator`, `Service`, `Cell`, `Repo`, `Config`.
- Prefer `private` by default.
- Use scoped `Metric`, `Text`, or `Constants` enums for literals.
- Do not add speculative abstractions or drive-by refactors.
- Do not use `print()`; use `Logger`.

## Verification

```bash
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace -scheme SuperApp_PQ\ Staging -destination generic/platform=iOS\ Simulator -quiet build
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace -scheme SuperApp_PQ\ Production -destination generic/platform=iOS\ Simulator -quiet build
```

Report pass/fail and any blocker clearly.
