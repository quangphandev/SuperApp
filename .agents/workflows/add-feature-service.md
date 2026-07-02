---
description: Add a new API endpoint, Data Service, Repository, UseCase, and wire the network call into an existing ViewModel using RxSwift.
---

# Add Feature Repository (Network Call)

Use this workflow when adding a new API call to an existing or new feature.

## Pre-Task

```bash
# Check existing endpoints for this feature
rtk rg "Endpoint\|Service" SuperApp_PQ/Features/<FeatureName> --files-with-matches

# Check current DI wiring
rtk rg "func make<FeatureName>" SuperApp_PQ/App/AppDependencyContainer.swift
```

Read `.agents/skills/superapp-network/SKILL.md` and `.agents/skills/superapp-clean-architecture/SKILL.md` for full patterns.

---

## Step 1 — Define APIEndpoint

Create or update `Features/<Name>/Data/Service/<Name>Endpoint.swift`:

```swift
enum FooEndpoint: APIEndpoint {
    case list
    case detail(id: String)

    var path: String {
        switch self {
        case .list:            return "/foo"
        case .detail(let id): return "/foo/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list, .detail: return .get
        }
    }
}
```

---

## Step 2 — Define DTO + Mapper

Create `Features/<Name>/Data/DTO/<Name>DTO.swift` and `Features/<Name>/Data/Mapper/<Name>Mapper.swift`:

```swift
struct FooItemDTO: Decodable {
    let id: String
    let title: String
}

enum FooItemMapper {
    static func map(_ dto: FooItemDTO) -> FooItem {
        FooItem(id: dto.id, title: dto.title)
    }
}
```

Domain entity lives separately in `Features/<Name>/Domain/Entity/`.

---

## Step 3 — Create Service + Repository + UseCase

Create Domain contract and Data implementation:

```swift
protocol FooRepositoryProtocol {
    func fetchList() -> Observable<Result<[FooItem], NetworkError>>
}

protocol FetchFooItemsUseCaseProtocol {
    func execute() -> Observable<Result<[FooItem], NetworkError>>
}

final class FetchFooItemsUseCase: FetchFooItemsUseCaseProtocol {
    private let repository: FooRepositoryProtocol
    init(repository: FooRepositoryProtocol) { self.repository = repository }
    func execute() -> Observable<Result<[FooItem], NetworkError>> { repository.fetchList() }
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

final class FooRepository: FooRepositoryProtocol {
    private let remoteService: FooRemoteServiceProtocol
    init(remoteService: FooRemoteServiceProtocol) { self.remoteService = remoteService }

    func fetchList() -> Observable<Result<[FooItem], NetworkError>> {
        remoteService.fetchList()
            .map { $0.map { $0.map(FooItemMapper.map) } }
    }
}
```

---

## Step 4 — Wire Into ViewModel

In the ViewModel `transform(input:)`:

```swift
let items = input.refreshTrigger
    .flatMapLatest { [fetchItemsUseCase] in
        fetchItemsUseCase.execute()
    }
    .compactMap { try? $0.get() }
    .asDriverOnErrorJustComplete()
```

---

## Step 5 — Wire DI

In `AppDependencyContainer.swift`:

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

---

## Step 6 — Verify

```bash
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace \
  -scheme "SuperApp_PQ Staging" \
  -destination "generic/platform=iOS Simulator" \
  -quiet build
```

Report: pass/fail. If fail, paste first project-source error (not Pod/framework errors).
