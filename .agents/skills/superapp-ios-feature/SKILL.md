---
name: superapp-ios-feature
description: "Build or modify SuperApp_PQ iOS features using UIKit-only programmatic UI, MVViewModel-C, Clean Architecture, Coordinator navigation, dependency injection, RxSwift/RxCocoa, SnapKit, and modular feature architecture. Use when adding a feature/module, editing Presentation/Domain/Data files, wiring navigation, or preparing feature code."
---

# SuperApp iOS Feature Skill

Read `references/feature-anatomy.md` and `$superapp-clean-architecture` before writing non-trivial feature code.

## Pre-Task Checklist

1. Run `rtk rg "FeatureName" SuperApp_PQ/Features`.
2. Read `AppDependencyContainer` for current factory methods.
3. Analyze design and choose the right base class.
4. Identify Coordinator-owned navigation routes.
5. Decide whether the feature needs full Clean Architecture. New business/data features should use it.

## Workflow

1. Create only needed folders:

```text
Features/<FeatureName>/
  Presentation/
    View/
    ViewModel/
    Coordinator/
    Components/
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

2. Write in order:
   `Entity → RepositoryProtocol → UseCase → DTO → Mapper → Service → Repository → ViewModel → ViewController → Coordinator`.
3. Wire DI:
   `ViewModel ← UseCase ← RepositoryProtocol ← Repository ← Service`.
4. Register route in parent Coordinator.
5. Localize copy with SwiftGen.
6. Build Staging.

## MVViewModel-C + Clean Flow

```text
ViewController --input--> ViewModel --calls--> UseCase --depends on--> RepositoryProtocol
                                      ↑ implemented by
                                  Repository --calls--> Service --uses--> APIClient
```

## Commands

```bash
rtk rg "FeatureName" SuperApp_PQ/Features
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace -scheme SuperApp_PQ\ Staging -destination generic/platform=iOS\ Simulator -quiet build
```
