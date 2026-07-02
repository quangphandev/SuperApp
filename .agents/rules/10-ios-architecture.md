---
description: Swift UIKit MVViewModel-C and Clean Architecture rules for SuperApp_PQ.
globs:
  - "SuperApp_PQ/**/*.swift"
alwaysApply: false
---

# iOS Architecture

Apply this when editing Swift source files.

## App Entry Flow

```
SceneDelegate
  → AppEnvironment.configure()
  → UIWindow + BaseNavigationController
  → AppDependencyContainer
  → AppCoordinator.start()
    → HomeCoordinator.start()
      → HomeViewController(viewModel: container.makeHomeVM(), coordinator: self)
```

## Layer Boundaries

| Layer | Responsibility | Must NOT |
|---|---|---|
| `ViewController` | Render UI, bind ViewModel outputs, forward user actions | Business logic, API calls, navigate directly |
| `ViewModel` | Transform Input→Output, own presentation state | Import UIKit, reference ViewController, navigate |
| `Coordinator` | Own navigation + child lifecycle | UI logic, business logic |
| `UseCase` | Business action/orchestration | UIKit, Alamofire, storage details |
| `RepositoryProtocol` | Domain data contract | Concrete API/storage dependencies |
| `Repository` | Data access, DTO mapping, typed errors | UI logic, business rules |
| `Service` | Remote/local data-source wrapper | Business rules |
| `View` | Reusable UI rendering | Business logic |

## ViewModel Pattern

Always use `struct Input`, `struct Output`, `func transform(input:) -> Output`.

```swift
// Inputs: Signal<Void> for taps, Driver<T> for text/values
// Outputs: Driver<T> for UI, Signal<Void> for navigation/one-shot events

struct Input {
    let refreshTrigger: Signal<Void>
    let itemTap: Signal<IndexPath>
}

struct Output {
    let items: Driver<[ItemModel]>
    let isLoading: Driver<Bool>
    let error: Signal<String>
    let routeToDetail: Signal<ItemModel>
}

func transform(input: Input) -> Output { ... }
```

- Expose `Driver` for state, `Signal` for one-shot events and navigation.
- Never expose raw `Observable` or `Error` to ViewController.
- Never nest subscriptions — use `flatMap`, `withLatestFrom`, `combineLatest`, `switchLatest`.

## ViewController Pattern

```swift
final class FooViewController: BaseViewController<FooViewModel> {
    private weak var coordinator: FooCoordinating?

    init(viewModel: FooViewModel, coordinator: FooCoordinating?) {
        self.coordinator = coordinator
        super.init(viewModel: viewModel)
    }

    override func setupViews() { ... }
    override func setupConstraints() { ... }
    override func setupNavigation() { ... }

    override func setupBindings() {
        super.setupBindings()
        let input = FooViewModel.Input(...)
        let output = viewModel.transform(input: input)
        output.items.drive(...).disposed(by: disposeBag)
        output.routeToDetail.emit(onNext: { [weak self] item in
            self?.coordinator?.showDetail(item)
        }).disposed(by: disposeBag)
    }
}
```

- Subclass the right base: `BaseViewController`, `BaseTableViewController`, `BaseCollectionViewController`, `BaseFormViewController`, `BasePagingViewController`.
- Do not instantiate dependencies inside ViewController — inject via `init`.
- Do not navigate directly — route through coordinator.

## Coordinator Pattern

```swift
protocol FooCoordinating: AnyObject {
    func showDetail(_ item: ItemModel)
}

final class FooCoordinator: BaseCoordinator, FooCoordinating {
    private let container: AppDependencyContainer

    override func start() {
        let vc = FooViewController(viewModel: container.makeFooVM(), coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }

    func showDetail(_ item: ItemModel) {
        let vc = DetailViewController(viewModel: container.makeDetailVM(item: item))
        navigationController.pushViewController(vc, animated: true)
    }
}
```

## Dependency Injection

All VMs, UseCases, Repositories, and Services are created in `AppDependencyContainer`:

```swift
// In AppDependencyContainer:
func makeFooVM() -> FooViewModel {
    FooViewModel(fetchItemsUseCase: makeFetchFooItemsUseCase())
}
func makeFetchFooItemsUseCase() -> FetchFooItemsUseCaseProtocol {
    FetchFooItemsUseCase(repository: makeFooRepository())
}
func makeFooRepository() -> FooRepositoryProtocol {
    FooRepository(remoteService: makeFooRemoteService())
}
func makeFooRemoteService() -> FooRemoteServiceProtocol {
    FooRemoteService(apiClient: apiClient)
}
```

Never call `FooService()` or `FooRepository()` directly inside a ViewController or ViewModel.

## Networking Pattern

```swift
// 1. Define endpoint
struct FooEndpoint: APIEndpoint {
    var method: HTTPMethod { .get }
    var path: String { "/foo/list" }
    var parameters: [String: Any]? { nil }
}

// 2. Data Service calls apiClient
final class FooRemoteService: FooRemoteServiceProtocol {
    private let apiClient: APIClientProtocol
    init(apiClient: APIClientProtocol) { self.apiClient = apiClient }

    func fetchItems() -> Observable<Result<[FooItemDTO], NetworkError>> {
        apiClient.request(FooEndpoint())
            .map { Result.success($0) }
            .catch { error in .just(.failure(NetworkError.map(error))) }
    }
}

// 3. ViewModel calls Domain UseCase, Data Repository maps DTO -> Entity
func transform(input: Input) -> Output {
    let result = fetchItemsUseCase.execute().share(replay: 1)
    let items = result.compactMap { try? $0.get() }.asDriverOnErrorJustComplete()
    let error = result.compactMap { if case .failure(let e) = $0 { return e.message } else { return nil } }
                      .asSignal(onErrorSignalWith: .empty())
    return Output(items: items, error: error)
}
```

## RxSwift Rules

- Every lifecycle owner has its own `DisposeBag`.
- Cells reset `DisposeBag` in `prepareForReuse`.
- Use `catchAndReturn` / `.catch { }` to prevent stream termination.
- Never expose raw `Error` to the UI layer.
- Map all errors through `handleError(_:)` on `BaseViewModel` or map to typed display strings.

## Error Handling

```swift
// Service returns typed errors:
func fetchItems() -> Observable<Result<[Item], NetworkError>>

// ViewModel maps to Signal<String> for display:
let error: Signal<String>

// BaseViewModel.handleError maps any Error to BaseError → errorRelay → ViewController alert
```
