# List UI Patterns Reference

Concrete code patterns for `BaseTableViewController` and `BaseCollectionViewController` screens in SuperApp_PQ.

---

## BaseTableViewController — DiffableDataSource Pattern

This is the recommended pattern for TableView screens with dynamic data.

```swift
//
//  SettingsViewController.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on dd/MM/yy.
//

import UIKit
import RxSwift
import RxCocoa

final class SettingsViewController: BaseTableViewController<SettingsViewModel> {

    // MARK: - Types

    enum Section: Int, CaseIterable { case main }

    // MARK: - Properties

    private weak var coordinator: SettingsCoordinating?
    private var dataSource: UITableViewDiffableDataSource<Section, SettingsItem>!

    // MARK: - Lifecycle

    init(viewModel: SettingsViewModel, coordinator: SettingsCoordinating?) {
        self.coordinator = coordinator
        super.init(viewModel: viewModel)
    }

    // MARK: - Setup

    override func setupTableView() {
        tableView.register(SettingsCell.self)

        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeue(SettingsCell.self, for: indexPath)
            cell.configure(with: item)
            return cell
        }
    }

    override func setupNavigation() {
        title = L10n.Settings.title
    }

    override func setupBindings() {
        super.setupBindings()

        let input = SettingsViewModel.Input(
            refreshTrigger: refreshTrigger.asSignal()
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
                if !isLoading { self?.endRefreshing() }
            })
            .disposed(by: disposeBag)

        output.error
            .emit(onNext: { [weak self] message in
                self?.showError(message)
                self?.showErrorState()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - UITableViewDelegate

    override func didSelectRow(at indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        coordinator?.showDetail(item)
    }

    // MARK: - Helpers

    private func applySnapshot(_ items: [SettingsItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SettingsItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
```

---

## BaseCollectionViewController — Compositional Layout (Mixed Sections)

Pattern for dashboard/feed screens with multiple section types.

```swift
//
//  DashboardViewController.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on dd/MM/yy.
//

import UIKit
import RxSwift

final class DashboardViewController: BaseCollectionViewController<DashboardViewModel> {

    // MARK: - Types

    enum Section: Int, CaseIterable {
        case banner
        case quickActions
        case feed
    }

    // MARK: - Properties

    private weak var coordinator: DashboardCoordinating?
    private var dataSource: UICollectionViewDiffableDataSource<Section, DashboardItem>!

    private let bannerRegistration = UICollectionView.CellRegistration<BannerCell, DashboardItem> { cell, _, item in
        cell.configure(with: item)
    }

    private let actionRegistration = UICollectionView.CellRegistration<ActionCell, DashboardItem> { cell, _, item in
        cell.configure(with: item)
    }

    private let feedRegistration = UICollectionView.CellRegistration<FeedCell, DashboardItem> { cell, _, item in
        cell.configure(with: item)
    }

    // MARK: - Lifecycle

    init(viewModel: DashboardViewModel, coordinator: DashboardCoordinating?) {
        self.coordinator = coordinator
        super.init(viewModel: viewModel)
    }

    // MARK: - Layout

    override func configureCollectionLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, env in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            return self?.layoutSection(for: section, env: env)
        }
    }

    private func layoutSection(for section: Section, env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch section {
        case .banner:
            return makeBannerSection()
        case .quickActions:
            return makeGridSection(columns: 4, height: 80)
        case .feed:
            return makeListSection()
        }
    }

    // MARK: - Section Layouts

    private func makeBannerSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(180))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = AppSpacing.medium
        section.contentInsets = NSDirectionalEdgeInsets(
            top: AppSpacing.xLarge, leading: AppSpacing.xLarge,
            bottom: AppSpacing.section, trailing: AppSpacing.xLarge
        )
        return section
    }

    private func makeGridSection(columns: Int, height: CGFloat) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / CGFloat(columns)), heightDimension: .absolute(height))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: AppSpacing.small, bottom: 0, trailing: AppSpacing.small)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(height))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: AppSpacing.xLarge, bottom: AppSpacing.section, trailing: AppSpacing.xLarge)
        return section
    }

    private func makeListSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = AppSpacing.medium
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: AppSpacing.xLarge, bottom: AppSpacing.section, trailing: AppSpacing.xLarge)
        return section
    }

    // MARK: - DataSource

    override func setupCollectionView() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self, let section = Section(rawValue: indexPath.section) else { return nil }
            switch section {
            case .banner: return collectionView.dequeueConfiguredReusableCell(using: self.bannerRegistration, for: indexPath, item: item)
            case .quickActions: return collectionView.dequeueConfiguredReusableCell(using: self.actionRegistration, for: indexPath, item: item)
            case .feed: return collectionView.dequeueConfiguredReusableCell(using: self.feedRegistration, for: indexPath, item: item)
            }
        }
    }

    override func setupBindings() {
        super.setupBindings()

        let input = DashboardViewModel.Input(
            refreshTrigger: refreshTrigger.asSignal()
        )
        let output = viewModel.transform(input: input)

        output.sections
            .drive(onNext: { [weak self] in self?.applySnapshot($0) })
            .disposed(by: disposeBag)
    }

    private func applySnapshot(_ sections: DashboardSections) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, DashboardItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(sections.banners, toSection: .banner)
        snapshot.appendItems(sections.actions, toSection: .quickActions)
        snapshot.appendItems(sections.feed, toSection: .feed)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
```

---

## BaseTableCell — Standard Pattern

```swift
final class SettingsCell: BaseTableCell {

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = AppColor.accent
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body
        label.textColor = AppColor.textPrimary
        return label
    }()

    private let chevronView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.tintColor = AppColor.textSecondary
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    override func setupViews() {
        backgroundColor = AppColor.surface
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(chevronView)
    }

    override func setupConstraints() {
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(AppSpacing.xLarge)
            make.centerY.equalToSuperview()
            make.size.equalTo(22)
        }
        chevronView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(AppSpacing.medium)
            make.trailing.equalTo(chevronView.snp.leading).offset(-AppSpacing.small)
            make.top.bottom.equalToSuperview().inset(AppSpacing.large)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        titleLabel.text = nil
        iconView.image = nil
    }

    func configure(with item: SettingsItem) {
        titleLabel.text = item.title
        iconView.image = UIImage(systemName: item.iconName)
    }
}
```

---

## Pagination Pattern

```swift
// In ViewModel:
func transform(input: Input) -> Output {
    let currentPage = BehaviorRelay<Int>(value: 1)

    let refresh = input.refreshTrigger
        .do(onNext: { currentPage.accept(1) })

    let loadMore = input.loadMoreTrigger
        .withLatestFrom(currentPage)
        .map { $0 + 1 }
        .do(onNext: { currentPage.accept($0) })
        .mapToVoid()

    let trigger = Signal.merge(refresh, loadMore)
    // ... fetch with currentPage.value
}
```
