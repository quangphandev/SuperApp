# Clean Feature Template

Use this as a compact template. Rename `Foo` to the feature name.

## Domain

```swift
// Features/Foo/Domain/Entity/FooItem.swift
struct FooItem: Hashable {
    let id: String
    let title: String
}

// Features/Foo/Domain/Repository/FooRepositoryProtocol.swift
protocol FooRepositoryProtocol {
    func fetchItems() -> Observable<Result<[FooItem], NetworkError>>
}

// Features/Foo/Domain/UseCase/FetchFooItemsUseCase.swift
protocol FetchFooItemsUseCaseProtocol {
    func execute() -> Observable<Result<[FooItem], NetworkError>>
}

final class FetchFooItemsUseCase: FetchFooItemsUseCaseProtocol {
    private let repository: FooRepositoryProtocol

    init(repository: FooRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> Observable<Result<[FooItem], NetworkError>> {
        repository.fetchItems()
    }
}
```

## Data

```swift
// Features/Foo/Data/DTO/FooItemDTO.swift
struct FooItemDTO: Decodable {
    let id: String
    let title: String
}

// Features/Foo/Data/Mapper/FooItemMapper.swift
enum FooItemMapper {
    static func map(_ dto: FooItemDTO) -> FooItem {
        FooItem(id: dto.id, title: dto.title)
    }
}

// Features/Foo/Data/Service/FooRemoteService.swift
protocol FooRemoteServiceProtocol {
    func fetchItems() -> Observable<Result<[FooItemDTO], NetworkError>>
}

final class FooRemoteService: FooRemoteServiceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchItems() -> Observable<Result<[FooItemDTO], NetworkError>> {
        apiClient.request(FooEndpoint.list)
            .map { Result.success($0) }
            .catch { error in .just(.failure(NetworkError.map(error))) }
    }
}

// Features/Foo/Data/Repository/FooRepository.swift
final class FooRepository: FooRepositoryProtocol {
    private let remoteService: FooRemoteServiceProtocol

    init(remoteService: FooRemoteServiceProtocol) {
        self.remoteService = remoteService
    }

    func fetchItems() -> Observable<Result<[FooItem], NetworkError>> {
        remoteService.fetchItems()
            .map { result in
                result.map { $0.map(FooItemMapper.map) }
            }
    }
}
```

## Presentation

```swift
final class FooViewModel: BaseViewModel {
    private let fetchItemsUseCase: FetchFooItemsUseCaseProtocol

    init(fetchItemsUseCase: FetchFooItemsUseCaseProtocol) {
        self.fetchItemsUseCase = fetchItemsUseCase
        super.init()
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

        return Output(items: items, error: error)
    }
}
```

## DI

```swift
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
