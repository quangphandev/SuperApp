//
//  BaseCollectionVC.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 03/06/26.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

/// Base view controller for complex collection-based screens.
///
/// Use this when the design needs grids, mixed sections, horizontal carousels,
/// compositional layouts, or adaptive item sizing. For simple vertical rows,
/// prefer `BaseTableVC`.
class BaseCollectionVC<VM: BaseVM>: BaseVC<VM>, UICollectionViewDelegate {

    // MARK: - Properties

    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: configureCollectionLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = AppColor.accent
        return refreshControl
    }()

    private lazy var emptyStateView: UIView = buildEmptyStateView()
    private lazy var errorStateView: UIView = buildErrorStateView()

    /// Emits when the user pulls to refresh.
    let refreshTrigger = PublishRelay<Void>()

    /// Emits when the user scrolls near the bottom.
    let loadMoreTrigger = PublishRelay<Void>()

    private var isLoadingMore = false

    // MARK: - Setup

    override func setupViews() {
        super.setupViews()
        view.addSubview(collectionView)
        collectionView.refreshControl = refreshControl
        collectionView.delegate = self

        emptyStateView.isHidden = true
        errorStateView.isHidden = true
        view.addSubview(emptyStateView)
        view.addSubview(errorStateView)

        setupCollectionView()
    }

    override func setupConstraints() {
        super.setupConstraints()

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        emptyStateView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
        }

        errorStateView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
        }
    }

    override func setupBindings() {
        super.setupBindings()
        bindRefreshControl()
    }

    // MARK: - Override Points

    /// Preferred override point for new code.
    func configureCollectionLayout() -> UICollectionViewLayout {
        configureLayout()
    }

    /// Compatibility override point used by older `BaseListVC` subclasses.
    func configureLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }

    /// Preferred override point for cell/supplementary registration.
    func setupCollectionView() {
        setupSections()
    }

    /// Compatibility override point used by older `BaseListVC` subclasses.
    func setupSections() {}

    /// Override to customize empty copy.
    var emptyMessage: String { "Không có dữ liệu" }

    /// Override to customize error copy.
    var errorMessage: String { "Đã xảy ra lỗi" }

    /// Override to customize retry button title.
    var retryTitle: String { "Thử lại" }

    /// Called when pull-to-refresh begins.
    func didPullToRefresh() {
        refreshTrigger.accept(())
    }

    /// Called when the collection view scrolls near the bottom.
    func didReachBottom() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        loadMoreTrigger.accept(())
    }

    // MARK: - State

    func showEmptyState() {
        emptyStateView.isHidden = false
        errorStateView.isHidden = true
        collectionView.isHidden = true
    }

    func showErrorState() {
        errorStateView.isHidden = false
        emptyStateView.isHidden = true
        collectionView.isHidden = true
    }

    func showContent() {
        emptyStateView.isHidden = true
        errorStateView.isHidden = true
        collectionView.isHidden = false
    }

    func finishLoadingMore() {
        isLoadingMore = false
    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }

    // MARK: - UICollectionViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === collectionView else { return }
        guard shouldTriggerLoadMore(for: scrollView) else { return }
        didReachBottom()
    }

    func shouldTriggerLoadMore(for scrollView: UIScrollView) -> Bool {
        scrollView.contentSize.height > scrollView.bounds.height && scrollView.isAtBottom
    }

    // MARK: - Private

    private func bindRefreshControl() {
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                self?.didPullToRefresh()
            })
            .disposed(by: disposeBag)
    }

    private func buildEmptyStateView() -> UIView {
        let label = UILabel()
        label.text = emptyMessage
        label.font = AppFont.body
        label.textColor = AppColor.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }

    private func buildErrorStateView() -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = AppSpacing.medium
        stack.alignment = .center

        let label = UILabel()
        label.text = errorMessage
        label.font = AppFont.body
        label.textColor = AppColor.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0

        let retryButton = UIButton(type: .system)
        retryButton.setTitle(retryTitle, for: .normal)
        retryButton.setTitleColor(AppColor.accent, for: .normal)
        retryButton.titleLabel?.font = AppFont.headline
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)

        stack.addArrangedSubview(label)
        stack.addArrangedSubview(retryButton)
        return stack
    }

    @objc private func didTapRetry() {
        showContent()
        refreshTrigger.accept(())
    }
}
