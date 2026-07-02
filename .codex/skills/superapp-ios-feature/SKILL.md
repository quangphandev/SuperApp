---
name: superapp-ios-feature
description: "Build or modify SuperApp_PQ iOS features using UIKit-only programmatic UI, MVViewModel-C, Clean Architecture, Coordinator navigation, dependency injection, RxSwift/RxCocoa, SnapKit, and modular feature architecture. Use when adding a feature/module, editing Presentation/Domain/Data files, wiring navigation, or preparing feature code."
---

# SuperApp iOS Feature

## Pre-Task Checklist

Before writing code:
1. `rtk rg "FeatureName" SuperApp_PQ/Features` — check if a similar feature already exists.
2. Read `AppDependencyContainer` to see current `make*` factory methods.
3. Analyze design: determine the right base class.
4. Identify all navigation routes the Coordinator will own.
5. For non-trivial business/data work, use `$superapp-clean-architecture`.

## Base Class Selection

```
Keyboard-aware form?              → BaseFormViewController
Horizontal paged tabs?            → BasePagingViewController
In-app web page?                  → BaseWebViewController
Sheet/modal presentation?         → BaseBottomSheet
Simple vertical rows/settings?    → BaseTableViewController
Grids, carousels, mixed sections? → BaseCollectionViewController
None of the above (custom layout) → BaseViewController
```

## Workflow

1. **Create folder structure** (only what's needed):
   ```
   Features/<Name>/
     Presentation/ · Domain/ · Data/
   ```
2. **Write in order**: Entity → RepositoryProtocol → UseCase → DTO → Mapper → Service → Repository → ViewModel → ViewController → Coordinator.
3. **Wire DI**: `ViewModel ← UseCase ← RepositoryProtocol ← Repository ← Service`.
4. **Register route**: Call new Coordinator from parent Coordinator.
5. **Localize copy**: Add keys to both `.strings` files, run SwiftGen.
6. **Verify**: Build Staging.

## MVViewModel-C Pattern

```swift
// ViewModel — Input/Output transform, depends on UseCase protocol
struct Input { let refreshTrigger: Signal<Void> }
struct Output { let items: Driver<[Item]>; let error: Signal<String> }
func transform(input: Input) -> Output { ... }

// ViewController — bind only
override func setupBindings() {
    super.setupBindings()
    let output = viewModel.transform(input: .init(refreshTrigger: ...))
    output.items.drive(...).disposed(by: disposeBag)
    output.error.emit(onNext: { [weak self] in self?.showError($0) }).disposed(by: disposeBag)
}

// Coordinator — route only
func showDetail(_ item: Item) {
    let vc = DetailViewController(viewModel: container.makeDetailVM(item: item))
    navigationController.pushViewController(vc, animated: true)
}
```

## DI Wiring

```swift
// AppDependencyContainer.swift
func makeFooVM() -> FooViewModel { FooViewModel(fetchItemsUseCase: makeFetchFooItemsUseCase()) }
func makeFetchFooItemsUseCase() -> FetchFooItemsUseCaseProtocol { FetchFooItemsUseCase(repository: makeFooRepository()) }
func makeFooRepository() -> FooRepositoryProtocol { FooRepository(remoteService: makeFooRemoteService()) }
func makeFooRemoteService() -> FooRemoteServiceProtocol { FooRemoteService(apiClient: apiClient) }
```

## File Rules

- One primary type per Swift file.
- Header: author `Phan Quang`, date `dd/MM/yy`.
- Suffixes: `ViewController`, `ViewModel`, `Coordinator`, `Service`, `Cell`.
- Prefer `private`. Use `Metric`, `Text`, `Constants` enums for literals.
- Override points: `setupViews()` `setupConstraints()` `setupNavigation()` `setupBindings()` `setupActions()`.
- Cells: reset `DisposeBag` in `prepareForReuse()`.

## Commands

```bash
rtk rg "FeatureName" SuperApp_PQ/Features
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace \
  -scheme "SuperApp_PQ Staging" \
  -destination "generic/platform=iOS Simulator" -quiet build
```
