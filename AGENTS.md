# SuperApp_PQ — Agent Instructions

**Project**: iOS Super App (UIKit · MVVM-C · Clean Architecture · RxSwift · SnapKit · CocoaPods)
**Author**: Phan Quang
**Working Directory**: `/Users/admin/Desktop/DemoPQ/SuperApp_PQ`

---

# 1. Behavioral Core

These four principles apply to every task, every file, every change.
They bias toward caution over speed. For trivial one-line fixes, use judgment.

## Think Before Coding

Don't assume. Don't hide confusion. Surface tradeoffs.

- State your assumptions explicitly before implementing. If uncertain, ask.
- If a request has multiple plausible meanings, present the interpretations — don't pick silently.
- If a simpler approach exists, say so and push back when warranted.
- If missing context makes a correct change unlikely, stop. Name what's confusing. Ask one concise question.

## Simplicity First

Minimum code that solves the problem. Nothing speculative.

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.
- Ask: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## Surgical Changes

Touch only what you must. Clean up only your own mess.

- Don't improve adjacent code, comments, or formatting that isn't part of the request.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.
- Remove imports/variables/functions that **your** changes made unused.
- Every changed line must trace directly to the user's request.

## Goal-Driven Execution

Define success criteria. Loop until verified.

Transform tasks into verifiable goals before coding:
- "Add validation" → write tests for invalid inputs, then make them pass.
- "Fix the bug" → reproduce it first, then fix it and verify the same path.
- "Refactor X" → ensure behavior is unchanged before and after.

For multi-step tasks, state a brief plan with verification checkpoints:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

---

# 2. Shell & Environment

Always prefix shell commands with `rtk`.

```bash
rtk git status
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace -scheme "SuperApp_PQ Staging" \
  -destination "generic/platform=iOS Simulator" -quiet build
rtk pod install
rtk rg "HomeVC"
rtk rg --files SuperApp_PQ/Features
```

- Prefer `rg` / `rg --files` for searching. Avoid slow recursive commands.
- Use `rtk proxy <cmd>` only when the wrapped command needs raw system behavior.
- Do not run destructive commands (`git reset --hard`, file deletion) without explicit approval.

## Schemes

- `SuperApp_PQ Staging` — use for most builds
- `SuperApp_PQ Production` — use when task affects shared config, resources, or pods

---

# 3. Skills (Codex)

Use a skill when the user names it or when the task clearly matches the skill's purpose.

| Skill | Trigger |
|---|---|
| `superapp-design-system` | UIKit UI, colors, typography, components, animations |
| `superapp-clean-architecture` | Domain/Data/Presentation, UseCase, Repository boundaries |
| `superapp-ios-feature` | New feature, MVVM-C, Clean Architecture feature files |
| `superapp-list-ui` | TableView, CollectionView, cells, compositional layout |
| `superapp-localization` | L10n keys, SwiftGen, runtime language switching |
| `superapp-network` | APIEndpoint, Repository, UseCase, networking, RxSwift wiring |
| `superapp-figma` | Figma design, components, tokens, screenshot validation |
| `superapp-preflight` | Readiness check, build, validation before/after coding |
| `superapp-swiftgen-assets` | Adding colors, images/icons, localized text, and running SwiftGen via Xcode Build (Cmd+B) |


Rules:
- Read the relevant `SKILL.md` before applying.
- Announce the skill in one short sentence.
- If a skill is unavailable, say so briefly and continue with the best fallback.

## Sub-Agent Usage

Only use sub-agents when the user explicitly asks for delegation, parallel work, or sub-agents.
- Assign concrete file/module ownership per agent.
- Use disjoint write scopes for multiple agents.
- Review all returned changes before integrating.

---

# 4. iOS Stack

## Tech

- UIKit only · Programmatic UI only · No Storyboard · No XIB
- MVVM-C · Clean Architecture · Coordinator navigation · Dependency Injection
- RxSwift / RxCocoa · SnapKit · iOS 15+ · Swift (latest stable)
- Alamofire · CocoaPods

## Source Paths

| Layer | Path |
|---|---|
| Features | `SuperApp_PQ/Features/<Name>/` |
| Presentation | `SuperApp_PQ/Features/<Name>/Presentation/` |
| Domain | `SuperApp_PQ/Features/<Name>/Domain/` |
| Data | `SuperApp_PQ/Features/<Name>/Data/` |
| DesignSystem | `SuperApp_PQ/DesignSystem/Foundation/` + `Components/` |
| Base classes | `SuperApp_PQ/Core/Base/` |
| Network | `SuperApp_PQ/Core/Network/` |
| Localization | `SuperApp_PQ/Core/Localization/` |
| Generated | `SuperApp_PQ/Resources/Generated/` |

## Base Classes

`BaseViewController<ViewModel>` · `BaseTableViewController<ViewModel>` · `BaseCollectionViewController<ViewModel>` · `BaseFormViewController<ViewModel>` · `BasePagingViewController<ViewModel>`
`BaseBottomSheet` · `BaseWebViewController<ViewModel>` · `BaseNavigationController` · `BaseTabBarController`
`BaseTableCell` · `BaseCollectionCell` · `BaseHeaderView` · `BaseViewModel` · `BaseCoordinator`
`BaseView` · `BaseRepository` · `BaseError` · `ViewState<T>` · `CoordinatorType`
`Loadable` · `Bindable` · `Reusable`

## DesignSystem Foundations

`AppColor` · `AppFont` · `AppSpacing` · `AppRadius` · `AppShadow` · `AppAnimation`

## DesignSystem Components

`AppButton` (primary/secondary/tonal/ghost/destructive) · `AppIconButton` · `AppCardView`
`AppChip` · `AppBadgeView` · `AppTextField` · `AppDivider` · `StateView` · `ToastView`
`PrimaryButton` · `SecondaryButton`

## Network Layer

`APIClientProtocol` / `APIClient` · `APIEndpoint` · `NetworkConfig` · `AuthInterceptor`
`TokenRefreshHandler` · `NetworkError` · `KeychainTokenStorage` · `SessionManager`

---

# 5. Coding Rules

## File Header

```swift
//
//  HomeViewController.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on dd/MM/yy.
//
```

## Naming Suffixes

`ViewController` · `ViewModel` · `Coordinator` · `Service` · `TableViewCell` · `CollectionViewCell` · `Repository` · `Config`

## UI Component Property Suffix

Required for all UIKit properties in ViewController, View, and Cell:

| UIKit Class | Suffix | Example |
|---|---|---|
| `UILabel` | `Label` | `titleLabel`, `priceLabel` |
| `UITextField` | `TextField` | `emailTextField`, `passwordTextField` |
| `UITextView` | `TextView` | `descriptionTextView`, `notesTextView` |
| `UIImageView` | `ImageView` | `avatarImageView`, `bannerImageView` |
| `UIStackView` | `StackView` | `mainStackView`, `actionsStackView` |
| `UITableView` | `TableView` | `feedTableView`, `ordersTableView` |
| `UICollectionView` | `CollectionView` | `bannersCollectionView`, `gridCollectionView` |
| `UIButton` | `Button` | `submitButton`, `loginButton` |
| `UIView` (container) | `View` | `headerView`, `cardView` |
| `UIScrollView` | `ScrollView` | `contentScrollView` |
| `UISwitch` | `Switch` | `notificationSwitch` |
| `UISlider` | `Slider` | `volumeSlider` |
| `UIActivityIndicatorView` | `ActivityIndicator` | `loadingActivityIndicator` |
| `UIPageControl` | `PageControl` | `bannerPageControl` |

Rules: always append context (`titleLabel` not `title`). camelCase. Never abbreviated names (`lblTitle` → `titleLabel`).

## MVVM-C Layer Rules

- **ViewController**: render UI, bind ViewModel outputs, forward user actions. No business logic, no navigation.
- **ViewModel**: `struct Input` + `struct Output` + `func transform(input:) -> Output`. No UIKit import.
- **Coordinator**: owns navigation + child lifecycle. No UI/business logic.
- **UseCase**: owns business action/orchestration. No UIKit, no Alamofire, no storage details.
- **RepositoryProtocol**: lives in Domain and defines data contract.
- **Repository**: lives in Data, implements Domain protocol, maps DTOs/entities, handles data source composition.
- **Service**: lives in Data and wraps remote/local data source calls. No business rules.

## Clean Architecture Feature Structure

For new non-trivial features, use this structure:

```text
Features/<Name>/
  Presentation/
    View/
    ViewModel/
    Components/
    Coordinator/
  Domain/
    Entity/
    UseCase/
    Repository/
  Data/
    DTO/
    Mapper/
    Repository/
    Service/
```

Dependency direction:

```text
Presentation → Domain ← Data
ViewController → ViewModel → UseCase → RepositoryProtocol ← Repository → Service → DTO
```

Rules:
- Domain must not import UIKit, Alamofire, concrete storage, or concrete API clients.
- ViewModel depends on UseCase protocols, not concrete services/repositories.
- Data DTOs never escape Data; map to Domain entities before returning.
- Existing small features may keep the older folder layout until a requested refactor touches them.

## RxSwift

- Input/Output transform pattern. Expose `Driver` for state, `Signal` for one-shot/navigation.
- Never expose raw `Observable` or `Error` to UI. Map via `NetworkError.message`.
- Avoid nested subscriptions — use `flatMap`, `withLatestFrom`, `combineLatest`, `switchLatest`.
- Every lifecycle owner has its own `DisposeBag`. Cells reset in `prepareForReuse`.

## Access & Style

- Prefer `private` by default.
- Use `Metric`, `Text`, `Constants` enums for literals. No magic numbers. No hardcoded strings.
- Use `Logger.*` — never `print()`.
- Never force unwrap without justification. Never expose raw `Error` to UI layer.

## BaseViewController Lifecycle & Override Points

`viewDidLoad()` calls these in order — **override only what you need**:

```swift
func setupViews()        // add subviews, configure appearance
func setupConstraints()  // SnapKit constraints
func setupNavigation()   // title, bar buttons
func setupBindings()     // bind VM Output → UI (always call super)
func setupActions()      // gesture recognizers, target-action
func reloadData()        // initial data trigger (called once on load)
```

**Auto-bound by `BaseViewController` — do NOT rebind in subclass:**
- `viewModel.isLoadingRelay` → `showLoading()` / `hideLoading()` (via `Loadable`)
- `viewModel.errorRelay` → `showError(_:)` alert

**`BaseListViewController`** — deprecated alias for `BaseCollectionViewController`. New screens must choose `BaseTableViewController` or `BaseCollectionViewController` explicitly.

---

# 6. Forbidden Practices

- Storyboard / XIB / Massive ViewController
- API calls directly inside ViewController
- Hardcoded colors, fonts, strings, spacing
- `import UIKit` inside ViewModel
- Nested subscriptions
- Direct dependency creation inside feature layer (`let service = FooService()` in ViewController)
- Global mutable state / Singleton abuse
- Mixing `async/await` inside RxSwift chains without bridging
- `print()` for logging
- Raw `Error` exposed to UI layer
- Retain cycles

---

# 7. Codex Workflows

Step-by-step instructions for common tasks. Read the relevant section before coding.

## Clean Feature

1. Analyze design and choose `BaseViewController`, `BaseTableViewController`, `BaseCollectionViewController`, `BaseFormViewController`, or `BasePagingViewController`.
2. Create Clean Architecture folders: `Presentation/ Domain/ Data/`.
3. Keep dependency direction: `Presentation → Domain ← Data`.
4. Write in order: **Entity → RepositoryProtocol → UseCase → DTO → Mapper → Service → Repository → ViewModel → ViewController → Coordinator**.
5. Wire DI: `ViewModel ← UseCase ← RepositoryProtocol ← Repository ← Service`.
6. Add L10n keys and run SwiftGen.
7. Build Staging.

## New Feature (MVVM-C)

1. Identify the right base class (see Base Classes in section 4).
2. For non-trivial features, create Clean Architecture folders: `Presentation/ Domain/ Data/`.
3. Write in order: **Entity → RepositoryProtocol → UseCase → DTO → Mapper → Service → Repository → ViewModel → ViewController → Coordinator**.
4. Wire DI: `ViewModel ← UseCase ← RepositoryProtocol ← Repository ← Service`.
5. Register in parent Coordinator.
6. Add L10n keys to both `.strings` files, run SwiftGen.
7. Build Staging → report pass/fail.

## Add API Endpoint + Repository

1. Add endpoint in `Data/Service`.
2. Create DTO in `Data/DTO` and mapper in `Data/Mapper`.
3. Create `RepositoryProtocol` in `Domain/Repository`.
4. Create UseCase in `Domain/UseCase`.
5. Implement Repository in `Data/Repository`; it calls Service and maps DTO → Entity.
6. Wire into VM via `AppDependencyContainer`: `ViewModel ← UseCase ← Repository ← Service`.
7. In ViewModel: call UseCase, map to `Driver`/`Signal`, handle typed errors.
8. Build Staging.

## Add Localization Key

1. Add key to **both** `en.lproj/Localizable.strings` and `vi.lproj/Localizable.strings`.
2. `rtk Pods/SwiftGen/bin/swiftgen config run --config swiftgen.yml`
3. `rtk Pods/SwiftGen/bin/swiftgen config lint --config swiftgen.yml`
4. Replace hardcoded string with `L10n.<Key>` in Swift code.
5. Build Staging.

## Preflight Check

1. `rtk git status --short` — note dirty files.
2. `rtk rg --files SuperApp_PQ/Resources/Generated` — confirm generated files exist.
3. `rtk xcodebuild -list -workspace SuperApp_PQ.xcworkspace` — confirm schemes.
4. Build Staging. Report errors with file + line.

## Build Both Schemes

```bash
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace \
  -scheme "SuperApp_PQ Staging" \
  -destination "generic/platform=iOS Simulator" -quiet build

rtk xcodebuild -workspace SuperApp_PQ.xcworkspace \
  -scheme "SuperApp_PQ Production" \
  -destination "generic/platform=iOS Simulator" -quiet build
```

---


# 8. Figma Design Profile

Use this profile for all visual / Figma work. Active selection:

```
visual_direction:    D. Native Mobile Clean
theme_strategy:      A. Shared Dark Shell + App Accents
density:             B. Balanced
shape_language:      B. Modern Rounded (14–20 px radius)
color_intensity:     B. Balanced Accent
typography:          B. Inter
icon_style:          B. Rounded Line
motion_style:        B. Springy Mobile
component_style:     B/C. Filled Cards + light Elevated Cards
handoff_strictness:  C/D. Component Discipline + Production Validation
```

**Brand**: Luma · orbit ring + cyan core + rose spark mark.
Do not use "Dev Lab" or the old 3×3 dot-grid logo.

### Figma Required Flow

1. Create or modify design.
2. Capture screenshot.
3. Audit: alignment, spacing, colors, typography.
4. Iterate until visually correct.
5. Final screenshot to confirm.

Never report a Figma change as done without screenshot validation.

### Figma Refactor Order (for broad work)

1. Define theme variables.
2. Normalize shell: page root, top bars, bottom nav.
3. Normalize base components: button, chip, card, row, tab, stat card.
4. Rebuild high-risk screens from components.
5. Validate by screenshot and audit.

Related file: `/Users/admin/figma-assets/design.md`

---

# 9. Verification

Run the smallest meaningful check for the changed behavior.

```bash
# Default: build Staging
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace \
  -scheme "SuperApp_PQ Staging" \
  -destination "generic/platform=iOS Simulator" \
  -quiet build

# Include Production when task affects shared config, resources, or pods
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace \
  -scheme "SuperApp_PQ Production" \
  -destination "generic/platform=iOS Simulator" \
  -quiet build
```

Report: pass/fail. If fail, cite the first project-source error (file + line). Ignore Pod/framework errors unless directly caused by your changes.

---

# 10. Before Broad Changes

Read these files first:
- `AGENTS.md` (this file)
- `NAMING_CONVENTION.md`
- `SKILLS_SCRIPTS_RULES.md`
- Source files in the target feature

For Antigravity: also read `.agents/rules/00-superapp-project.md` and related rules.
