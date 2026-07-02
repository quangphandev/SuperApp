---
description: Create or modify a SuperApp_PQ feature using MVViewModel-C, Clean Architecture, DI, RxSwift, and programmatic UIKit.
---

# New Feature

## Pre-Task

```bash
# 1. Check if similar feature exists
rtk rg "FeatureName" SuperApp_PQ/Features --files-with-matches

# 2. Read current DI wiring to understand existing make* factories
rtk rg "func make" SuperApp_PQ/App/AppDependencyContainer.swift
```

## Build Steps

1. **Analyze design** — determine content complexity and scrolling behavior.
   Choose base class:
   - `BaseTableViewController` → simple rows, settings, forms, simple feeds
   - `BaseCollectionViewController` → grids, carousels, mixed sections, dashboards
   - `BaseFormViewController` → keyboard-aware input screens
   - `BasePagingViewController` → horizontal paged tabs
   - `BaseViewController` → custom non-list layouts

2. **Create folder structure** — only folders you need:
   ```
   Features/<FeatureName>/
     Presentation/ · Domain/ · Data/
   ```
   See `.agents/skills/superapp-ios-feature/references/feature-anatomy.md` for full skeletons.
   See `.agents/skills/superapp-clean-architecture/references/clean-feature-template.md` for Clean Architecture skeletons.

3. **Write in order**: Entity → RepositoryProtocol → UseCase → DTO → Mapper → Service → Repository → ViewModel (Input/Output) → ViewController → Coordinator.

4. **Wire DI** — `ViewModel ← UseCase ← RepositoryProtocol ← Repository ← Service`.
   Register navigation route in the parent Coordinator.

5. **Localize copy** — add keys to both `.strings` files then run SwiftGen:
   ```bash
   rtk Pods/SwiftGen/bin/swiftgen config run --config swiftgen.yml
   ```

6. **Verify** — Staging build must pass:
   ```bash
   rtk xcodebuild -workspace SuperApp_PQ.xcworkspace -scheme "SuperApp_PQ Staging" -destination "generic/platform=iOS Simulator" -quiet build
   ```
