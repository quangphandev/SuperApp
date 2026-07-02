---
description: Create a SuperApp_PQ feature with Clean Architecture layers.
---

# Clean Feature

1. Analyze design and choose the UI base:
   - `BaseTableViewController` for simple rows/forms/menus.
   - `BaseCollectionViewController` for grids/carousels/mixed layouts.
   - `BaseViewController` for custom non-list layouts.
2. Create only needed folders:

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

3. Write in order:
   `Entity → RepositoryProtocol → UseCase → DTO → Mapper → Service → Repository → ViewModel → ViewController → Coordinator`.
4. Wire DI:
   `ViewModel ← UseCase ← RepositoryProtocol ← Repository ← Service`.
5. Localize UI copy with SwiftGen.
6. Build Staging.
