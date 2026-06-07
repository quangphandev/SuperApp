//
//  HomeVC.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class HomeVC: BaseCollectionVC<HomeVM> {

    // MARK: - Properties

    private weak var coordinator: HomeCoordinating?
    private var dataSource: UICollectionViewDiffableDataSource<String, String>!
    private var currentContent: HomeContent?
    private var contentRevision = 0
    private let exploreTrigger = PublishRelay<Void>()
    private let stateActionRelay = PublishRelay<HomeStateActionKind>()
    private let debugTrigger = PublishRelay<Void>()
    private let debugButton = UIBarButtonItem(title: "Config", style: .plain, target: nil, action: nil)

    private let headerRegistration = UICollectionView.CellRegistration<HomeHeaderCell, HomeContent> { cell, _, content in
        cell.configure(with: content)
    }

    private let heroRegistration = UICollectionView.CellRegistration<HomeHeroCell, HomeContent> { cell, _, content in
        cell.configure(with: content)
    }

    private let statRegistration = UICollectionView.CellRegistration<HomeStatCell, HomeDashboardStat> { cell, _, stat in
        cell.configure(with: stat)
    }

    private let focusRegistration = UICollectionView.CellRegistration<HomeFocusCell, HomeDashboardFocusItem> { cell, _, item in
        cell.configure(with: item)
    }

    // MARK: - UI Components

    private let stateView = HomeStateView()
    private let bottomNavView = HomeBottomNavView()

    // MARK: - Lifecycle

    init(viewModel: HomeVM, coordinator: HomeCoordinating?) {
        self.coordinator = coordinator
        super.init(viewModel: viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Layout

    override func configureCollectionLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let section = HomeDashboardSection(rawValue: sectionIndex) else { return nil }
            return self?.makeLayoutSection(for: section, environment: environment)
        }
    }

    // MARK: - Setup

    override func setupViews() {
        overrideUserInterfaceStyle = .dark
        super.setupViews()

        view.backgroundColor = AppColor.background
        stateView.overrideUserInterfaceStyle = .dark
        bottomNavView.overrideUserInterfaceStyle = .dark

        view.addSubview(bottomNavView)
        view.addSubview(stateView)
    }

    override func setupConstraints() {
        super.setupConstraints()

        bottomNavView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(74)
        }

        collectionView.snp.remakeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomNavView.snp.top)
        }

        stateView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func setupCollectionView() {
        collectionView.backgroundColor = AppColor.background
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset.bottom = AppSpacing.large
        collectionView.verticalScrollIndicatorInsets.bottom = AppSpacing.large

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, itemID in
            guard let self else { return nil }

            if itemID.hasPrefix("header") {
                guard let content = self.currentContent else { return nil }
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.headerRegistration,
                    for: indexPath,
                    item: content
                )
            }

            if itemID.hasPrefix("hero") {
                guard let content = self.currentContent else { return nil }
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.heroRegistration,
                    for: indexPath,
                    item: content
                )
            }

            if let index = itemID.dashboardIndex(prefix: "stat") {
                guard let stat = self.currentContent?.stats[safe: index] else { return nil }
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.statRegistration,
                    for: indexPath,
                    item: stat
                )
            }

            if let index = itemID.dashboardIndex(prefix: "focus") {
                guard let focusItem = self.currentContent?.focusItems[safe: index] else { return nil }
                return collectionView.dequeueConfiguredReusableCell(
                    using: self.focusRegistration,
                    for: indexPath,
                    item: focusItem
                )
            }

            return nil
        }
    }

    override func setupNavigation() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = debugButton
    }

    override func setupBindings() {
        super.setupBindings()

        let input = HomeVM.Input(
            exploreTap: exploreTrigger.asSignal(),
            debugTap: Signal.merge(debugButton.rx.tap.asSignal(), debugTrigger.asSignal()),
            stateAction: stateActionRelay.asSignal()
        )
        let output = viewModel.transform(input: input)

        output.screenState
            .drive(onNext: { [weak self] state in
                self?.renderScreenState(state)
            })
            .disposed(by: disposeBag)

        output.title
            .drive(rx.title)
            .disposed(by: disposeBag)

        output.routeToDetail
            .emit(onNext: { [weak self] in
                self?.coordinator?.showDetail()
            })
            .disposed(by: disposeBag)

        output.routeToDebugInfo
            .emit(onNext: { [weak self] in
                self?.coordinator?.showDebugInfo()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Helpers

    private func renderScreenState(_ state: HomeScreenState) {
        switch state {
        case .ready(let content):
            applySnapshot(content)
            bottomNavView.configure(with: content.navigationItems) { [weak self] item in
                self?.didSelectNavigationItem(item)
            }
            setReadyContentVisible(true)
            stateView.setVisible(false, animated: true)
        case .loading(let content),
             .empty(let content),
             .error(let content),
             .offline(let content),
             .syncConflict(let content):
            setReadyContentVisible(false)
            stateView.configure(with: content) { [weak self] action in
                self?.stateActionRelay.accept(action)
            }
            stateView.setVisible(true, animated: true)
        }
    }

    private func applySnapshot(_ content: HomeContent) {
        currentContent = content
        contentRevision += 1

        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        let sections = HomeDashboardSection.allCases.map(\.identifier)
        snapshot.appendSections(sections)
        snapshot.appendItems(["header-\(contentRevision)"], toSection: HomeDashboardSection.header.identifier)
        snapshot.appendItems(["hero-\(contentRevision)"], toSection: HomeDashboardSection.hero.identifier)
        snapshot.appendItems(
            content.stats.indices.map { "stat-\($0)-\(contentRevision)" },
            toSection: HomeDashboardSection.stats.identifier
        )
        snapshot.appendItems(
            content.focusItems.indices.map { "focus-\($0)-\(contentRevision)" },
            toSection: HomeDashboardSection.focus.identifier
        )

        dataSource.apply(
            snapshot,
            animatingDifferences: collectionView.window != nil
        )
    }

    private func setReadyContentVisible(_ isVisible: Bool) {
        collectionView.isHidden = !isVisible
        bottomNavView.isHidden = !isVisible
        collectionView.alpha = isVisible ? 1 : 0
        bottomNavView.alpha = isVisible ? 1 : 0
    }

    private func didSelectNavigationItem(_ item: HomeDashboardNavItem) {
        guard item.kind == .more else { return }
        debugTrigger.accept(())
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemID = dataSource.itemIdentifier(for: indexPath) else { return }
        if itemID.hasPrefix("hero") || itemID.hasPrefix("stat") || itemID.hasPrefix("focus") {
            exploreTrigger.accept(())
        }
    }

    private func makeLayoutSection(
        for section: HomeDashboardSection,
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        switch section {
        case .header:
            return makeEstimatedSection(height: 92, top: AppSpacing.large, bottom: AppSpacing.large)
        case .hero:
            return makeEstimatedSection(height: 276, top: 0, bottom: AppSpacing.large)
        case .stats:
            return makeStatsSection(environment: environment)
        case .focus:
            return makeFocusSection()
        }
    }

    private func makeEstimatedSection(
        height: CGFloat,
        top: CGFloat,
        bottom: CGFloat
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(height)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(height)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: top,
            leading: AppSpacing.xLarge,
            bottom: bottom,
            trailing: AppSpacing.xLarge
        )
        return section
    }

    private func makeStatsSection(
        environment: NSCollectionLayoutEnvironment
    ) -> NSCollectionLayoutSection {
        let availableWidth = environment.container.effectiveContentSize.width - (AppSpacing.xLarge * 2)
        let compactColumnCount = availableWidth < 340 ? 1 : 3

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / CGFloat(compactColumnCount)),
            heightDimension: .absolute(92)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: AppSpacing.xSmall,
            bottom: 0,
            trailing: AppSpacing.xSmall
        )

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(92)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: compactColumnCount
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = AppSpacing.medium
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: AppSpacing.xLarge - AppSpacing.xSmall,
            bottom: AppSpacing.section,
            trailing: AppSpacing.xLarge - AppSpacing.xSmall
        )
        return section
    }

    private func makeFocusSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(68)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(68)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = AppSpacing.medium
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: AppSpacing.xLarge,
            bottom: AppSpacing.section,
            trailing: AppSpacing.xLarge
        )
        return section
    }
}

private extension String {

    func dashboardIndex(prefix: String) -> Int? {
        let parts = split(separator: "-")
        guard parts.count >= 3, parts.first == Substring(prefix) else { return nil }
        return Int(parts[1])
    }
}
