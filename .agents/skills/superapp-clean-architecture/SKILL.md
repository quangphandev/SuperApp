---
name: superapp-clean-architecture
description: "Design, scaffold, or refactor SuperApp_PQ features toward Clean Architecture on top of MVViewModel-C: Presentation, Domain, Data, UseCase, RepositoryProtocol, Repository implementation, DTO, Mapper, API Service, dependency inversion, and RxSwift boundaries."
---

# SuperApp Clean Architecture

## Target Flow

```text
ViewController → ViewModel → UseCase → RepositoryProtocol
                  ↑
             Repository → Service → DTO
```

## Feature Structure

```text
Features/<Feature>/
  Presentation/View/
  Presentation/ViewModel/
  Presentation/Coordinator/
  Presentation/Components/
  Domain/Entity/
  Domain/UseCase/
  Domain/Repository/
  Data/DTO/
  Data/Mapper/
  Data/Repository/
  Data/Service/
```

## Rules

- Presentation depends on Domain.
- Domain does not depend on Presentation or Data.
- Data implements Domain repository protocols.
- ViewModels depend on UseCase protocols.
- Services are data-source wrappers, not business logic owners.
- DTOs never escape Data.
- Coordinators own navigation only.

Read `references/clean-feature-template.md` for skeletons.
