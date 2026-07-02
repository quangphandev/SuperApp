# Clean Feature Template

Use the same structure for new non-trivial features:

```text
Presentation → Domain → Data
ViewModel → UseCase → RepositoryProtocol ← Repository → Service → DTO
```

## Minimal DI Shape

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

## Dependency Direction

- ViewModel knows UseCase protocol.
- UseCase knows RepositoryProtocol.
- Repository implementation knows Service and Mapper.
- Service knows APIClientProtocol and endpoint.
