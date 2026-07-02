//
//  SplashViewController.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class SplashViewController: BaseCollectionViewController<SplashViewModel> {

    // MARK: - Properties

    private weak var coordinator: SplashCoordinating?
    private var dataSource: UICollectionViewDiffableDataSource<String, String>!
    private var currentContent: SplashContent?
    private var currentSelectedKind: SplashAppKind?
    private var launcherTitle = ""
    private var summaryTitle = ""
    private var summarySubtitle = ""
    private var actionTitle = ""
    private var hintText = ""
    private var canContinue = false
    private var revision = 0

    private let selectAppRelay = PublishRelay<SplashAppKind>()
    private let continueRelay = PublishRelay<Void>()

    // MARK: - Lifecycle

    init(viewModel: SplashViewModel, coordinator: SplashCoordinating?) {
        self.coordinator = coordinator
        super.init(viewModel: viewModel)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: - Layout

    override func configureCollectionLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = SplashSection(rawValue: sectionIndex) else { return nil }
            return Self.makeLayoutSection(for: section)
        }
    }

    // MARK: - Setup

    override func setupViews() {
        overrideUserInterfaceStyle = .dark
        super.setupViews()
        view.backgroundColor = AppColor.background
    }

    override func registerCollectionCells() {
        collectionView.registerCells(
            SplashBrandCell.self,
            SplashLauncherHeaderCell.self,
            SplashAppCell.self,
            SplashSummaryCell.self,
            SplashActionCell.self,
            SplashFooterCell.self
        )
    }

    override func setupCollectionView() {
        collectionView.backgroundColor = AppColor.background
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset.bottom = AppSpacing.xxLarge

        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, itemID in
            guard let self, let content = self.currentContent else { return nil }

            if itemID.hasPrefix("brand") {
                let cell = collectionView.dequeue(SplashBrandCell.self, for: indexPath)
                cell.configure(with: content)
                return cell
            }

            if itemID.hasPrefix("launcherHeader") {
                let cell = collectionView.dequeue(SplashLauncherHeaderCell.self, for: indexPath)
                cell.configure(
                    title: self.launcherTitle,
                    count: content.appCountTitle
                )
                return cell
            }

            if let index = itemID.splashIndex(prefix: "app") {
                guard content.apps.indices.contains(index) else { return nil }
                let item = content.apps[index]
                let cell = collectionView.dequeue(SplashAppCell.self, for: indexPath)
                cell.configure(
                    with: item,
                    isSelected: item.kind == self.currentSelectedKind,
                    onTap: { [weak self] kind in
                        self?.selectAppRelay.accept(kind)
                    }
                )
                return cell
            }

            if itemID.hasPrefix("summary") {
                let cell = collectionView.dequeue(SplashSummaryCell.self, for: indexPath)
                cell.configure(
                    title: self.summaryTitle,
                    subtitle: self.summarySubtitle
                )
                return cell
            }

            if itemID.hasPrefix("action") {
                let cell = collectionView.dequeue(SplashActionCell.self, for: indexPath)
                cell.configure(
                    title: self.actionTitle,
                    isEnabled: self.canContinue,
                    accentColor: self.selectedAccentColor()
                )
                cell.onTap = { [weak self] in
                    self?.continueRelay.accept(())
                }
                return cell
            }

            if itemID.hasPrefix("footer") {
                let cell = collectionView.dequeue(SplashFooterCell.self, for: indexPath)
                cell.configure(
                    footer: content.footerText,
                    hint: self.hintText
                )
                return cell
            }

            return nil
        }
    }

    override func setupNavigation() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func setupBindings() {
        super.setupBindings()

        let input = SplashViewModel.Input(
            selectApp: selectAppRelay.asSignal(),
            continueTap: continueRelay.asSignal()
        )
        let output = viewModel.transform(input: input)

        Driver.combineLatest(
            output.content,
            output.selectedKind,
            output.launcherTitle,
            output.summaryTitle,
            output.summarySubtitle,
            output.actionTitle,
            output.hintText,
            output.canContinue
        )
        .drive(onNext: { [weak self] content, selectedKind, launcherTitle, summaryTitle, summarySubtitle, actionTitle, hintText, canContinue in
            self?.render(
                content: content,
                selectedKind: selectedKind,
                launcherTitle: launcherTitle,
                summaryTitle: summaryTitle,
                summarySubtitle: summarySubtitle,
                actionTitle: actionTitle,
                hintText: hintText,
                canContinue: canContinue
            )
        })
        .disposed(by: disposeBag)

        output.routeToApp
            .emit(onNext: { [weak self] kind in
                self?.coordinator?.openApp(kind)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemID = dataSource.itemIdentifier(for: indexPath) else { return }
        guard let index = itemID.splashIndex(prefix: "app") else { return }
        guard let app = currentContent?.apps[safe: index] else { return }
        selectAppRelay.accept(app.kind)
    }

    // MARK: - Rendering

    private func render(
        content: SplashContent,
        selectedKind: SplashAppKind?,
        launcherTitle: String,
        summaryTitle: String,
        summarySubtitle: String,
        actionTitle: String,
        hintText: String,
        canContinue: Bool
    ) {
        currentContent = content
        currentSelectedKind = selectedKind
        self.launcherTitle = launcherTitle
        self.summaryTitle = summaryTitle
        self.summarySubtitle = summarySubtitle
        self.actionTitle = actionTitle
        self.hintText = hintText
        self.canContinue = canContinue
        applySnapshot(content: content, selectedKind: selectedKind)
    }

    private func applySnapshot(content: SplashContent, selectedKind: SplashAppKind?) {
        revision += 1

        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        SplashSection.allCases.forEach { section in
            snapshot.appendSections([section.identifier])
        }

        snapshot.appendItems(
            ["brand-\(revision)"],
            toSection: SplashSection.brand.identifier
        )
        snapshot.appendItems(
            ["launcherHeader-\(revision)"],
            toSection: SplashSection.launcherHeader.identifier
        )
        snapshot.appendItems(
            content.apps.indices.map { index in
                let isSelected = content.apps[index].kind == selectedKind
                return "app-\(index)-\(isSelected ? 1 : 0)-\(revision)"
            },
            toSection: SplashSection.apps.identifier
        )
        snapshot.appendItems(
            ["summary-\(revision)"],
            toSection: SplashSection.summary.identifier
        )
        snapshot.appendItems(
            ["action-\(revision)"],
            toSection: SplashSection.action.identifier
        )
        snapshot.appendItems(
            ["footer-\(revision)"],
            toSection: SplashSection.footer.identifier
        )

        dataSource.apply(snapshot, animatingDifferences: collectionView.window != nil)
    }

    private func selectedAccentColor() -> UIColor {
        guard
            let currentContent,
            let currentSelectedKind,
            let selectedApp = currentContent.app(for: currentSelectedKind)
        else {
            return AppColor.accent
        }
        return selectedApp.accent.color
    }

    private static func makeLayoutSection(for section: SplashSection) -> NSCollectionLayoutSection {
        switch section {
        case .brand:
            return makeFullWidthSection(height: 226, leading: 0, trailing: 0)
        case .launcherHeader:
            return makeFullWidthSection(height: 16, leading: AppSpacing.xLarge, trailing: AppSpacing.xLarge)
        case .apps:
            return makeAppsSection()
        case .summary:
            return makeFullWidthSection(height: 84, leading: AppSpacing.xLarge, trailing: AppSpacing.xLarge)
        case .action:
            return makeFullWidthSection(height: 75, leading: 0, trailing: 0)
        case .footer:
            return makeFullWidthSection(height: 84, leading: AppSpacing.xLarge, trailing: AppSpacing.xLarge)
        }
    }

    private static func makeFullWidthSection(
        height: CGFloat,
        leading: CGFloat,
        trailing: CGFloat
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(height)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: leading,
            bottom: 0,
            trailing: trailing
        )
        return section
    }

    private static func makeAppsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(Metric.appPillWidth),
            heightDimension: .absolute(Metric.appPillHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(Metric.appPillHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: Metric.columnCount
        )
        group.interItemSpacing = .fixed(Metric.appPillSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 6
        section.contentInsets = NSDirectionalEdgeInsets(
            top: AppSpacing.xSmall,
            leading: 14,
            bottom: 0,
            trailing: 14
        )
        return section
    }
}

private extension String {

    func splashIndex(prefix: String) -> Int? {
        let parts = split(separator: "-")
        guard parts.count >= 2, parts[0] == prefix else { return nil }
        return Int(parts[1])
    }
}

private extension SplashViewController {

    enum Metric {
        static let columnCount = 5
        static let appPillWidth: CGFloat = 66
        static let appPillHeight: CGFloat = 58
        static let appPillSpacing: CGFloat = 8
    }
}
