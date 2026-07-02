---
name: superapp-list-ui
description: "Build and maintain list-based UIKit screens in SuperApp_PQ. Analyze design first: use BaseTableViewController for simple vertical row/form/menu screens, BaseCollectionViewController for grids, carousels, mixed sections, dashboards. Use for UITableView, UICollectionView, cells, sections, feeds, compositional layouts, diffable data sources, and pagination."
---

# SuperApp List UI

## Decision Tree

```
Keyboard-aware inputs?           → BaseFormViewController (not a list base)
Horizontal paged tabs?           → BasePagingViewController (not a list base)
Bottom sheet?                    → BaseBottomSheet (not a list base)

List screens:
├── One vertical column?         → BaseTableViewController
│   ├── Settings / menus
│   ├── Forms / input rows
│   └── Simple vertical feeds
└── More complex?                → BaseCollectionViewController
    ├── 2+ column grids
    ├── Horizontal carousels
    ├── Mixed section layouts (banner + rows + grid)
    ├── Adaptive item sizes
    └── Compositional / dashboard layouts
```

## BaseTableViewController

```swift
final class FooViewController: BaseTableViewController<FooViewModel> {
    override func setupTableView() {
        tableView.register(FooCell.self)  // Reusable protocol
        tableView.dataSource = dataSource
    }

    override func setupBindings() {
        super.setupBindings()
        let input = FooViewModel.Input(
            refreshTrigger: refreshTrigger.asSignal(),
            loadMoreTrigger: loadMoreTrigger.asSignal()
        )
        let output = viewModel.transform(input: input)
        output.items.drive(onNext: { [weak self] items in
            items.isEmpty ? self?.showEmptyState() : self?.showContent()
        }).disposed(by: disposeBag)
        output.isLoading.drive(onNext: { [weak self] loading in
            if !loading { self?.endRefreshing(); self?.finishLoadingMore() }
        }).disposed(by: disposeBag)
    }
}
```

**State helpers**: `showContent()` · `showEmptyState()` · `showErrorState()` · `endRefreshing()` · `finishLoadingMore()`
**Triggers**: `refreshTrigger` (pull-to-refresh) · `loadMoreTrigger` (scroll to bottom)

## BaseCollectionViewController

```swift
final class FooViewController: BaseCollectionViewController<FooViewModel> {
    override func configureCollectionLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            self?.layoutSection(for: sectionIndex, env: env)
        }
    }
}
```

- Prefer `UICollectionViewDiffableDataSource` + `NSDiffableDataSourceSnapshot`.
- Prefer `UICollectionView.CellRegistration` over `register(_:forCellWithReuseIdentifier:)`.
- Use `apply(snapshot:)` — avoid `reloadData()` on dynamic data.

## Cells

```swift
final class FooCell: BaseTableCell {          // or BaseCollectionCell
    override func setupViews() { ... }
    override func setupConstraints() { ... }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()   // reset Rx
        titleLabel.text = nil       // reset async-loaded state
    }
    func configure(with item: FooItem) { ... }
}
```

- Configure display data only — no business logic, no network calls.
- Reset all visual state in `prepareForReuse()`.
- Avoid expensive work in reuse path.

## Commands

```bash
rtk rg "BaseTableViewController\|BaseCollectionViewController" SuperApp_PQ/Core/Base
rtk xcodebuild -workspace SuperApp_PQ.xcworkspace \
  -scheme "SuperApp_PQ Staging" \
  -destination "generic/platform=iOS Simulator" -quiet build
```
