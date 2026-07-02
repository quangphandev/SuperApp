---
name: superapp-network
description: "Add or update network calls in SuperApp_PQ using Clean Architecture: APIEndpoint, Data Service, DTO, Mapper, Data Repository, Domain RepositoryProtocol, UseCase, NetworkError mapping, and RxSwift Observable wiring into ViewModels. Use when adding a new API endpoint, repository, service, use case, or handling auth/error cases."
---

# SuperApp Network

## Layer Flow

```
ViewModel → UseCase → RepositoryProtocol ← Repository → Service → APIClient → APIEndpoint
                                      Data DTO → Mapper → Domain Entity
```

## Step 1 — Define APIEndpoint

Source: `SuperApp_PQ/Core/Network/APIEndpoint.swift`

```swift
enum FooEndpoint: APIEndpoint {
    case list
    case detail(id: String)
    case create(body: [String: Any])

    var path: String {
        switch self {
        case .list:            return "/foo"
        case .detail(let id): return "/foo/\(id)"
        case .create:          return "/foo"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list, .detail: return .get
        case .create:         return .post
        }
    }

    var parameters: Parameters? {
        if case .create(let body) = self { return body }
        return nil
    }
    // requiresAuth defaults to true. Set false for public endpoints.
}
```

## Step 2 — Create DTO + Service

```swift
struct FooItemDTO: Decodable {
    let id: String
    let title: String
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

## Step 3 — Create Domain Contract + UseCase + Repository

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

final class FooRepository: FooRepositoryProtocol {
    private let remoteService: FooRemoteServiceProtocol
    init(remoteService: FooRemoteServiceProtocol) { self.remoteService = remoteService }
    func fetchList() -> Observable<Result<[FooItem], NetworkError>> {
        remoteService.fetchList()
            .map { $0.map { $0.map(FooItemMapper.map) } }
    }
}
```

## Step 4 — Wire DI

```swift
// AppDependencyContainer.swift
func makeFooVM() -> FooViewModel { FooViewModel(fetchItemsUseCase: makeFetchFooItemsUseCase()) }
func makeFetchFooItemsUseCase() -> FetchFooItemsUseCaseProtocol { FetchFooItemsUseCase(repository: makeFooRepository()) }
func makeFooRepository() -> FooRepositoryProtocol { FooRepository(remoteService: makeFooRemoteService()) }
func makeFooRemoteService() -> FooRemoteServiceProtocol { FooRemoteService(apiClient: apiClient) }
```

## NetworkError Cases

| Case | HTTP | `.message` |
|---|---|---|
| `.noInternet` | No connection | "Không có kết nối mạng..." |
| `.unauthorized` | 401 | "Phiên đăng nhập hết hạn..." |
| `.forbidden` | 403 | "Bạn không có quyền..." |
| `.notFound` | 404 | "Không tìm thấy tài nguyên..." |
| `.badRequest` | 400 | "Yêu cầu không hợp lệ." |
| `.internalServerError` | 500 | "Lỗi máy chủ..." |
| `.apiError(response)` | Server error body | `response.displayMessage` |

Use `.message` for display. Use specific cases for logic (e.g. `.unauthorized` → redirect to login).

## Commands

```bash
rtk rg "APIEndpoint\|APIClient" SuperApp_PQ/Core/Network
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace \
  -scheme "SuperApp_PQ Staging" \
  -destination "generic/platform=iOS Simulator" -quiet build
```
