---
description: Clean Architecture boundaries for SuperApp_PQ feature code.
globs:
  - "SuperApp_PQ/Features/**/*.swift"
alwaysApply: false
---

# Clean Architecture

Use this for new non-trivial features and when refactoring business/data logic.

## Layer Flow

```text
Presentation: ViewController / ViewModel / Coordinator / Components
       ↓ depends on
Domain: Entity / UseCase / RepositoryProtocol
       ↑ implemented by
Data: DTO / Mapper / Repository / Service
```

## Feature Folder Standard

```text
Features/<Feature>/
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

Do not churn existing small features into this structure unless the task asks for refactor.

## Rules

- Domain imports Foundation/RxSwift only when needed.
- Domain must not import UIKit, Alamofire, storage SDKs, or concrete Core clients.
- ViewModel depends on UseCase protocols, not repositories or services.
- RepositoryProtocol lives in Domain.
- Concrete Repository lives in Data.
- Service in Data wraps remote/local data source calls.
- DTOs stay in Data; map DTOs to Domain entities before returning to Domain/Presentation.
- Coordinator owns navigation only.
- ViewController binds UI only.
