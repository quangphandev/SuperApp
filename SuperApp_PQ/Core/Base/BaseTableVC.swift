//
//  BaseTableVC.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 03/06/26.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

/// Base view controller for simple vertical row-based screens.
///
/// Use this for settings, forms, menus, simple feeds, and repeated rows.
/// If the design needs grids, carousels, or mixed section layouts, use
/// `BaseCollectionVC` instead.
class BaseTableVC<VM: BaseVM>: BaseVC<VM>, UITableViewDelegate {

    // MARK: - Properties

    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: configureTableStyle())
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 56
        tableView.tableFooterView = UIView()
        return tableView
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
        view.addSubview(tableView)
        tableView.refreshControl = refreshControl
        tableView.delegate = self

        emptyStateView.isHidden = true
        errorStateView.isHidden = true
        view.addSubview(emptyStateView)
        view.addSubview(errorStateView)

        setupTableView()
    }

    override func setupConstraints() {
        super.setupConstraints()

        tableView.snp.makeConstraints { make in
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

    func configureTableStyle() -> UITableView.Style {
        .plain
    }

    /// Register cells, headers, footers, and set datasource here.
    func setupTableView() {}

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

    /// Called when the table view scrolls near the bottom.
    func didReachBottom() {
        guard !isLoadingMore else { return }
        isLoadingMore = true
        loadMoreTrigger.accept(())
    }

    /// Called after the default deselect behavior.
    func didSelectRow(at indexPath: IndexPath) {}

    // MARK: - State

    func showEmptyState() {
        emptyStateView.isHidden = false
        errorStateView.isHidden = true
        tableView.isHidden = true
    }

    func showErrorState() {
        errorStateView.isHidden = false
        emptyStateView.isHidden = true
        tableView.isHidden = true
    }

    func showContent() {
        emptyStateView.isHidden = true
        errorStateView.isHidden = true
        tableView.isHidden = false
    }

    func finishLoadingMore() {
        isLoadingMore = false
    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        didSelectRow(at: indexPath)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView === tableView else { return }
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
