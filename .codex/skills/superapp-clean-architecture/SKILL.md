---
name: superapp-clean-architecture
description: "Design, scaffold, or refactor SuperApp_PQ features toward Clean Architecture on top of MVViewModel-C: Presentation, Domain, Data, UseCase, RepositoryProtocol, Repository implementation, DTO, Mapper, API Service, dependency inversion, and RxSwift boundaries. Use when creating a new feature, adding business logic, adding repositories/use cases, or correcting architecture that currently goes directly ViewModel to Service."
---

# SuperApp Clean Architecture

## Target Layer Flow

```
Presentation
  ViewController → ViewModel
       ↓ depends on
Domain
  UseCase → RepositoryProtocol → Entity
       ↑ implemented by
Data
  Repository → Remote/Local Service → DTO → Mapper → Entity
```

Coordinator remains outside the business layers and owns navigation only.

## Feature Folder Standard

For new non-trivial features, use:

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

For small existing features, avoid disruptive folder churn unless the task explicitly asks for refactor.

## Dependency Rule

- Presentation may depend on Domain.
- Domain must not depend on Presentation, Data, UIKit, Alamofire, or storage frameworks.
- Data may depend on Domain protocols/entities and Core network/storage abstractions.
- ViewModel depends on UseCase protocols, not concrete services/repositories.
- RepositoryProtocol lives in Domain; concrete Repository lives in Data.
- DTOs stay in Data and never escape to ViewModel/ViewController.

## Type Responsibilities

| Type | Layer | Responsibility |
|---|---|---|
| `ViewController` | Presentation | Render UI, bind outputs, forward actions |
| `ViewModel` | Presentation | Transform input to output, call use cases |
| `Coordinator` | Presentation | Navigation only |
| `UseCase` | Domain | Business action/orchestration |
| `RepositoryProtocol` | Domain | Abstract data contract |
| `Entity` | Domain | Business model |
| `Repository` | Data | Compose remote/local data and map errors |
| `Service` | Data | API/storage call wrapper |
| `DTO` | Data | API/storage response/request shape |
| `Mapper` | Data | DTO ↔ Entity conversion |

## Rx Boundary

- Use cases return `Observable<Entity>` / `Single`-like `Observable` or `Observable<Result<Entity, NetworkError>>` depending on existing local pattern.
- ViewModel maps use case output to `Driver` and `Signal`.
- Errors are typed in Domain/Data, then converted to display strings in ViewModel.

## Workflow

1. Define Domain entity and repository protocol.
2. Define UseCase protocol and implementation.
3. Define Data DTO, mapper, remote/local service, and repository implementation.
4. Inject repository into use case, use case into ViewModel through `AppDependencyContainer`.
5. Keep ViewController and Coordinator unchanged except for DI and routing.
6. Build Staging.

For skeleton examples, read `references/clean-feature-template.md`.
