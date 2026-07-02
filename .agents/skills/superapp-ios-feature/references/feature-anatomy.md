# Feature Anatomy Reference

Use this shape for new non-trivial SuperApp_PQ features.

## Folder Structure

```text
Features/Foo/
  Presentation/
    View/FooViewController.swift
    ViewModel/FooViewModel.swift
    Coordinator/FooCoordinator.swift
    Components/FooCardView.swift
  Domain/
    Entity/FooItem.swift
    UseCase/FetchFooItemsUseCase.swift
    Repository/FooRepositoryProtocol.swift
  Data/
    DTO/FooItemDTO.swift
    Mapper/FooItemMapper.swift
    Repository/FooRepository.swift
    Service/FooRemoteService.swift
    Service/FooEndpoint.swift
```

## Dependencies

```text
FooViewController → FooViewModel → FetchFooItemsUseCaseProtocol
FetchFooItemsUseCase → FooRepositoryProtocol
FooRepository → FooRemoteServiceProtocol → APIClientProtocol
FooItemDTO → FooItemMapper → FooItem
```

## ViewModel Shape

```swift
final class FooViewModel: BaseViewModel {
    private let fetchItemsUseCase: FetchFooItemsUseCaseProtocol

    init(fetchItemsUseCase: FetchFooItemsUseCaseProtocol) {
        self.fetchItemsUseCase = fetchItemsUseCase
        super.init()
    }

    struct Input {
        let refreshTrigger: Signal<Void>
        let itemTap: Signal<FooItem>
    }

    struct Output {
        let items: Driver<[FooItem]>
        let error: Signal<String>
        let routeToDetail: Signal<FooItem>
    }

    func transform(input: Input) -> Output {
        let result = input.refreshTrigger.asObservable()
            .flatMapLatest { [fetchItemsUseCase] in fetchItemsUseCase.execute() }
            .share(replay: 1)

        let items = result
            .compactMap { try? $0.get() }
            .asDriverOnErrorJustComplete()

        let error = result
            .compactMap { result -> String? in
                guard case .failure(let error) = result else { return nil }
                return error.message
            }
            .asSignal(onErrorSignalWith: .empty())

        return Output(
            items: items,
            error: error,
            routeToDetail: input.itemTap
        )
    }
}
```
