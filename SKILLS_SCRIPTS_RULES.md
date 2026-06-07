# SuperApp_PQ Skills, Scripts, Rules

Last read: 24/05/26

This file is a quick operating guide for agents working in this repository.

## Project Root

```text
/Users/admin/Desktop/DemoPQ/SuperApp_PQ
```

Always work from this directory unless the user explicitly asks otherwise.

## Sources Read

- `AGENTS.md`
- `NAMING_CONVENTION.md`
- `Podfile`
- `Podfile.lock`
- `SuperApp_PQ.xcodeproj/project.pbxproj`
- `SuperApp_PQ/Info.plist`
- `SuperApp_PQ/AppDelegate.swift`
- `SuperApp_PQ/SceneDelegate.swift`
- `SuperApp_PQ/MainViewController.swift`
- `SuperApp_PQ/SecondViewController.swift`
- `SuperApp_PQ/ViewController.swift`
- `SuperApp_PQ/Core/Base/*`
- `SuperApp_PQ/Core/Environment/*`
- `SuperApp_PQ/Core/Logging/*`
- `SuperApp_PQ/Core/Network/*`
- `SuperApp_PQ/Core/Localization/*`
- `SuperApp_PQ/Core/Session/*`
- `SuperApp_PQ/Core/Storage/*`
- `SuperApp_PQ/Core/Utilities/*`
- `SuperApp_PQ/Resources/en.lproj/Localizable.strings`
- `SuperApp_PQ/DesignSystem/*`
- `SuperApp_PQ/Features/Home/*`
- `SuperApp_PQTests/*`
- `SuperApp_PQUITests/*`

## Skills

Use skills when the user names one or when the task clearly matches the skill's purpose.
Read the relevant `SKILL.md` before applying. Announce the skill in one sentence.

Available skills (both `.agents/skills/` for Antigravity and `.codex/skills/` for Codex):

| Skill | Trigger |
|---|---|
| `superapp-design-system` | UIKit UI, DesignSystem tokens, components, animation |
| `superapp-ios-feature` | New feature, MVVM-C, VC/VM/Coordinator/Service/DI |
| `superapp-list-ui` | TableView, CollectionView, cells, compositional layout |
| `superapp-localization` | L10n keys, SwiftGen, runtime language switching |
| `superapp-network` | APIEndpoint, Service, network wiring into VM |
| `superapp-figma` | Figma design, Luma tokens, screenshot validation |
| `superapp-preflight` | Build readiness, validation before/after changes |

Skill rules:

- Read the relevant `SKILL.md` before applying a skill.
- Prefer skill-provided patterns and templates over reinventing.
- If a skill is unavailable, say so briefly and continue with best fallback.

Sub-agent rules:

- Use sub-agents only when the user explicitly asks for agents, delegation, parallel work, or sub-agent assistance.
- Assign concrete file or module ownership.
- Use disjoint write scopes when multiple agents edit code.
- Tell sub-agents not to revert other edits.
- Review returned changes before integrating.

Figma/design workflow:

- Follow the inlined Figma profile in `AGENTS.md`.
- Use Native Mobile Clean, shared dark shell with app accents, balanced density, modern rounded shapes, Inter, rounded line icons.
- Every Figma visual change requires screenshot validation.
- For broad design work, also check `/Users/admin/figma-assets/design.md`.

## Scripts And Commands

All shell commands must be prefixed with `rtk`.

There are no custom project script files currently found:

- No `Makefile`
- No `Fastfile`
- No `.sh` scripts
- No `Package.swift`
- No XcodeGen `project.yml`

The practical command set is CocoaPods + Xcode.

Install or refresh pods:

```bash
rtk pod install
```

List workspace schemes:

```bash
rtk xcodebuild -list -workspace SuperApp_PQ.xcworkspace
```

Build app:

```bash
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace -scheme SuperApp_PQ -destination generic/platform=iOS\ Simulator build
```

Run unit tests:

```bash
rtk xcodebuild test -workspace SuperApp_PQ.xcworkspace -scheme SuperApp_PQ -destination 'platform=iOS Simulator,name=iPhone 16'
```

Search files and code:

```bash
rtk rg --files
rtk rg "SearchText"
```

Useful workspace schemes found:

- `SuperApp_PQ`
- `Pods-SuperApp_PQ`
- `Pods-SuperApp_PQTests`
- `Alamofire`
- `RxSwift`
- `RxCocoa`
- `RxRelay`
- `RxBlocking`
- `RxTest`
- `SnapKit`

Xcode project shell build phases are CocoaPods-generated only:

- Check Pods Manifest.lock.
- Embed Pods frameworks for app/tests.

## Dependencies

Declared in `Podfile`:

- `Alamofire ~> 5.9`
- `RxSwift ~> 6.7`
- `RxCocoa ~> 6.7`
- `SnapKit ~> 5.7`
- Test target: `Alamofire`, `RxSwift`, `RxCocoa`, `RxTest`, `RxBlocking`, `SnapKit`

Podfile sets:

- `platform :ios, '15.0'`
- `use_frameworks!`
- `inhibit_all_warnings!`
- `ENABLE_USER_SCRIPT_SANDBOXING = NO` in `post_install`
- Pods deployment target forced to `15.0`

## Architecture Rules

Primary direction:

- UIKit only.
- Programmatic UI only.
- No Storyboard for app screens.
- No XIB.
- MVVM-C.
- Coordinator-based navigation.
- Dependency injection.
- Modular feature architecture.
- RxSwift/RxCocoa for reactive flows.
- SnapKit preferred for layout.

Layer rules:

- `ViewController` renders UI, handles user interaction, and binds ViewModel outputs.
- `ViewController` must not contain business logic, direct API calls, navigation flow, or data transformation.
- `ViewModel` handles presentation state and input/output transforms.
- `ViewModel` must not import UIKit, reference UIViewController, or navigate directly.
- `Coordinator` owns navigation flow and child coordinator lifecycle.
- Dependencies must be injected, not instantiated directly inside ViewControllers.

RxSwift rules:

- Prefer Input/Output `transform(input:)`.
- Use `Driver` and `Signal` for UI-safe binding.
- Avoid nested subscriptions.
- Every lifecycle owner must own a `DisposeBag`.
- Cells must reset `DisposeBag` in `prepareForReuse`.
- Do not expose raw `Error` to UI; map errors to typed/domain errors.

Networking rules:

- `APIEndpoint` defines request shape.
- `NetworkConfig` owns `baseURL`, timeout, default headers, and auth refresh endpoint configuration.
- `NetworkConfig.makeURL(baseURL:path:)` normalizes leading/trailing slashes in endpoint paths.
- `APIClientProtocol` supports request, void request, upload, upload progress, download, and download progress.
- `APIClient` wraps Alamofire in RxSwift `Observable`.
- `AuthInterceptor` injects bearer tokens and retries once on HTTP 401.
- `TokenRefreshHandler` shares a single in-flight refresh request and reads its URL/parameter name from `NetworkConfig`.
- `NetworkError` maps Alamofire/HTTP errors to typed cases and user-facing messages.
- `NetworkLogger` is DEBUG-only logging via Alamofire `EventMonitor`.
- `APIEnvironment` and `AppEnvironment` configure the active API base URL before app launch.
- `KeychainTokenStorage` stores access and refresh tokens.
- `SessionManager` owns token session state.

Base layer currently available:

- `BaseVC<VM: BaseVM>`
- `BaseVM`
- `BaseCoordinator`
- `BaseNavigationController`
- `BaseView`
- `BaseTableCell`
- `BaseCollectionCell`
- `Loadable`
- `Bindable`
- `Reusable`
- `CoordinatorType`
- `BaseError`
- `ViewState<T>`
- `AppLocalizer`
- `Logger`
- `APIEnvironment`
- `AppEnvironment`
- `KeychainTokenStorage`
- `UserDefaultsStorage`
- `SessionManager`
- `AppJSONCoder`
- `BundleInfo`
- `DeviceInfo`
- `AppCoordinator`
- `AppDependencyContainer`
- `HomeCoordinator`
- `HomeContent`
- `LocalizedHomeContentProvider`
- `HomeVC`
- `HomeVM`
- `HomeDetailVC`

DesignSystem currently available:

- `AppColor`
- `AppFont`
- `AppSpacing`
- `AppRadius`
- `AppShadow`
- `AppCardView`
- `PrimaryButton`
- `StateView`

## Naming Rules

Follow `NAMING_CONVENTION.md` for all new files and types.

Important suffixes:

- `VC` for ViewController, e.g. `HomeVC`.
- `VM` for ViewModel, e.g. `HomeVM`.
- `Coordinator` for coordinator classes.
- `Service` for services.
- `Repo` for repositories.
- `Cell` for table/collection cells.
- `Config` for configuration.

General naming:

- PascalCase for files, classes, structs, enums, and protocols.
- camelCase for variables, properties, and functions.
- No Objective-C style project prefixes like `PQ` or `SA`.
- Do not abbreviate domain names; only abbreviate file/type roles like `VC`, `VM`, `Repo`.
- Boolean names start with `is`, `has`, `can`, or `should`.
- Array names should be plural.

Swift file header:

```swift
//
//  FileName.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on dd/MM/yy.
//
```

## Editing Rules

- Make surgical changes scoped to the user's request.
- Use `apply_patch` for manual edits.
- Do not revert user changes unless explicitly asked.
- Do not run destructive commands without explicit approval.
- Preserve current formatting and style unless changing it is required.
- Add comments only when they clarify non-obvious behavior.
- Clean up imports, variables, functions, tests, and files made unused by your own changes.
- Every changed line should be explainable from the request or verification.

## Verification Rules

Run the smallest meaningful check for the changed behavior.

Preferred checks:

- Build with `xcodebuild` for source changes.
- Use `build-for-testing` when simulator runtime is unavailable but test targets must still compile.
- Unit test with `xcodebuild test` for logic changes.
- UI test only when UI flow is changed and a simulator destination is available.
- Report checks that pass, fail, or could not be run.

## Current Project Shape

Current app entry:

- `AppDelegate` is default lifecycle setup.
- `AppDelegate` calls `AppEnvironment.configure()`.
- `SceneDelegate` creates `UIWindow`, `BaseNavigationController`, `AppDependencyContainer`, and `AppCoordinator` programmatically.
- `Info.plist` has scene configuration and no main storyboard key.
- `LaunchScreen.storyboard` still exists for launch screen only.

Current screens:

- `HomeVC`: programmatic Home feature screen using `BaseVC<HomeVM>`, Rx binding, SnapKit, and DesignSystem components.
- `HomeVM`: consumes a `HomeContentProviding` dependency so display copy comes from a content/localization provider.
- `HomeDetailVC`: simple programmatic detail route.
- `MainViewController`, `SecondViewController`, and `ViewController` are deprecated compatibility typealiases.

Current tests:

- Unit tests cover `ViewState`, `BaseError`, `Reusable`, `NetworkError`, `SessionManager`, and `NetworkConfig` refresh URL path normalization.
- UI tests are still Xcode templates.

## Known Gaps And Mismatches

- `NetworkConfig.authRefreshPath` defaults to `/auth/refresh`; set the real backend path before auth integration.
- `Main.storyboard` is deleted in git status, but `LaunchScreen.storyboard` remains and is referenced by the Xcode project.
- Runtime `xcodebuild test` depends on CoreSimulatorService; use `build-for-testing` when the service is unavailable.
