---
name: superapp-network
description: "Add or update network calls in SuperApp_PQ using Clean Architecture: APIEndpoint, Data Service, DTO, Mapper, Data Repository, Domain RepositoryProtocol, UseCase, NetworkError mapping, and RxSwift Observable wiring into ViewModels."
---

# SuperApp Network Skill

## Layer Overview

```text
ViewModel → UseCase → RepositoryProtocol ← Repository → RemoteService → APIClient → APIEndpoint
                                      DTO → Mapper → Entity
```

## Steps

1. Define endpoint in `Data/Service`.
2. Define DTO in `Data/DTO`.
3. Define mapper in `Data/Mapper`.
4. Define Domain entity and `RepositoryProtocol`.
5. Define UseCase protocol and implementation.
6. Implement Data repository.
7. Wire DI in `AppDependencyContainer`.
8. ViewModel calls UseCase and maps result to `Driver`/`Signal`.

## Endpoint + Service

```swift
enum FooEndpoint: APIEndpoint {
    case list
    var path: String { "/foo" }
    var method: HTTPMethod { .get }
}

protocol FooRemoteServiceProtocol {
    func fetchList() -> Observable<Result<[FooItemDTO], NetworkError>>
}

final class FooRemoteService: FooRemoteServiceProtocol {
    private let apiClient: APIClientProtocol
    init(apiClient: APIClientProtocol) { self.apiClient = apiClient }

    func fetchList() -> Observable<Result<[FooItemDTO], NetworkError>> {
        apiClient.request(FooEndpoint.list)
            .map { Result.success($0) }
            .catch { error in .just(.failure(NetworkError.map(error))) }
    }
}
```

## Repository + UseCase

```swift
protocol FooRepositoryProtocol {
    func fetchList() -> Observable<Result<[FooItem], NetworkError>>
}

final class FooRepository: FooRepositoryProtocol {
    private let remoteService: FooRemoteServiceProtocol
    init(remoteService: FooRemoteServiceProtocol) { self.remoteService = remoteService }

    func fetchList() -> Observable<Result<[FooItem], NetworkError>> {
        remoteService.fetchList()
            .map { $0.map { $0.map(FooItemMapper.map) } }
    }
}

protocol FetchFooItemsUseCaseProtocol {
    func execute() -> Observable<Result<[FooItem], NetworkError>>
}

final class FetchFooItemsUseCase: FetchFooItemsUseCaseProtocol {
    private let repository: FooRepositoryProtocol
    init(repository: FooRepositoryProtocol) { self.repository = repository }
    func execute() -> Observable<Result<[FooItem], NetworkError>> { repository.fetchList() }
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
