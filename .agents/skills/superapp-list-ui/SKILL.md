---
name: superapp-list-ui
description: "Build and maintain list-based UIKit screens in SuperApp_PQ using the rule: analyze design first, use TableView for simple views, and use CollectionView for more complex views. Use for UITableView, UICollectionView, cells, sections, feeds, grids, carousels, compositional layouts, diffable data sources, and pagination."
---

# SuperApp List UI Skill

Read `references/list-patterns.md` in this skill folder for concrete code skeletons.

## Decision Tree

Analyze the design first — then pick:

```
Screen has keyboard inputs?              → BaseFormViewController (not a list base)
Screen is horizontal paged tabs?         → BasePagingViewController (not a list base)
Screen needs a bottom sheet?             → BaseBottomSheet (not a list base)

List-based screens:
├── One vertical column, uniform rows?   → BaseTableViewController
│   ├── Settings / menus
│   ├── Forms / input rows
│   └── Simple feeds (mostly uniform)
│
└── Anything more complex?               → BaseCollectionViewController
    ├── 2+ column grids
    ├── Horizontal carousels
    ├── Mixed section layouts
    ├── Banners + rows + grids together
    ├── Adaptive item sizes
    └── Compositional / dashboard layouts
```

## BaseTableViewController

```swift
final class FooViewController: BaseTableViewController<FooViewModel> {

    // 1. Register cells and set dataSource here
    override func setupTableView() {
        tableView.register(FooCell.self)
        tableView.dataSource = dataSource
    }

    // 2. Bind ViewModel output to tableView and state helpers
    override func setupBindings() {
        super.setupBindings()
        let input = FooViewModel.Input(
            refreshTrigger: refreshTrigger.asSignal(),
            loadMoreTrigger: loadMoreTrigger.asSignal()
        )
        let output = viewModel.transform(input: input)

        output.items
            .drive(onNext: { [weak self] items in
                self?.applySnapshot(items)
                items.isEmpty ? self?.showEmptyState() : self?.showContent()
            })
            .disposed(by: disposeBag)

        output.isLoading
            .drive(onNext: { [weak self] isLoading in
                if !isLoading { self?.endRefreshing(); self?.finishLoadingMore() }
            })
            .disposed(by: disposeBag)
    }
}
```

**Available state helpers:**
- `showContent()` — show table, hide empty/error
- `showEmptyState()` — show empty view, hide table
- `showErrorState()` — show error + retry, hide table
- `endRefreshing()` — stop pull-to-refresh spinner
- `finishLoadingMore()` — reset load-more guard

## BaseCollectionViewController

```swift
final class FooViewController: BaseCollectionViewController<FooViewModel> {

    // Override to provide the compositional layout
    override func configureCollectionLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            self?.layoutSection(for: sectionIndex, env: env)
        }
    }

    private func layoutSection(for index: Int, env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        // Build and return NSCollectionLayoutSection
    }
}
```

**Prefer:**
- `UICollectionViewDiffableDataSource` + `NSDiffableDataSourceSnapshot` for dynamic content
- `UICollectionView.CellRegistration` over `register(_:forCellWithReuseIdentifier:)`
- `apply(snapshot:)` over `reloadData()` for large/dynamic datasets

## Cells

```swift
// TableView cell
final class FooCell: BaseTableCell {
    override func setupViews() { ... }
    override func setupConstraints() { ... }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()  // reset Rx subscriptions
        imageView?.image = nil     // reset async-loaded images
    }
    func configure(with item: FooItem) { ... }
}

// CollectionView cell
final class FooCell: BaseCollectionCell {
    override func setupViews() { ... }
    override func setupConstraints() { ... }
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    func configure(with item: FooItem) { ... }
}
```

**Cell rules:**
- Configure display data only — no business logic, no network calls.
- Reset all visual state in `prepareForReuse()`.
- Keep cells lightweight — avoid expensive operations during reuse.

## Pagination

```swift
// In ViewModel:
struct Input {
    let refreshTrigger: Signal<Void>
    let loadMoreTrigger: Signal<Void>
}

// BaseTableViewController / BaseCollectionViewController already provide:
// refreshTrigger: PublishRelay<Void>  (pull-to-refresh)
// loadMoreTrigger: PublishRelay<Void> (scroll-to-bottom)
```
