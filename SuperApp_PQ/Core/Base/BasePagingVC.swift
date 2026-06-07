//
//  BasePagingVC.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

/// Base ViewController for horizontally-paging tab screens (e.g. mini-app Home tabs).
///
/// Provides:
/// - A custom tab strip (horizontally scrolling tab buttons)
/// - Horizontal UIScrollView paging synced with the tab strip
/// - Lazy loading: child VCs are only initialized when their tab is first selected
///
/// Usage:
/// ```swift
/// class EnglishHomeVC: BasePagingVC<EnglishHomeVM> {
///     override var pages: [PageItem] {
///         [
///             PageItem(title: "Từ vựng",   viewController: { VocabVC(viewModel: ...) }),
///             PageItem(title: "Ngữ pháp",  viewController: { GrammarVC(viewModel: ...) }),
///             PageItem(title: "Phát âm",   viewController: { PronounVC(viewModel: ...) }),
///         ]
///     }
/// }
/// ```
class BasePagingVC<VM: BaseVM>: BaseVC<VM>, UIScrollViewDelegate {

    // MARK: - Page Item

    struct PageItem {
        let title: String
        let viewController: () -> UIViewController   // lazy factory
    }

    // MARK: - Properties

    private var loadedVCs: [Int: UIViewController] = [:]
    private var currentIndex: Int = 0

    private let selectedIndexRelay = BehaviorRelay<Int>(value: 0)

    /// A `Driver` that emits the selected tab index whenever it changes.
    var selectedIndex: Driver<Int> { selectedIndexRelay.asDriver() }

    /// Override in subclass to provide the page definitions.
    var pages: [PageItem] { [] }

    // MARK: - UI

    private lazy var tabScrollView: UIScrollView = {
        let sv                            = UIScrollView()
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator   = false
        sv.bounces                        = true
        return sv
    }()

    private lazy var tabStackView: UIStackView = {
        let sv    = UIStackView()
        sv.axis   = .horizontal
        sv.spacing = 0
        return sv
    }()

    private lazy var tabIndicator: UIView = {
        let v              = UIView()
        v.backgroundColor  = AppColor.accent
        v.layer.cornerRadius = 1.5
        return v
    }()

    private lazy var pageScrollView: UIScrollView = {
        let sv              = UIScrollView()
        sv.isPagingEnabled  = true
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator   = false
        sv.bounces          = false
        sv.delegate         = self
        return sv
    }()

    private lazy var pageContainer = UIView()

    private enum Metric {
        static var tabHeight: CGFloat { 44 }
        static var indicatorH: CGFloat { 3 }
    }

    // MARK: - Setup

    override func setupViews() {
        super.setupViews()

        view.addSubview(tabScrollView)
        tabScrollView.addSubview(tabStackView)
        tabScrollView.addSubview(tabIndicator)

        view.addSubview(pageScrollView)
        pageScrollView.addSubview(pageContainer)

        buildTabButtons()
    }

    override func setupConstraints() {
        super.setupConstraints()

        tabScrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Metric.tabHeight)
        }
        tabStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(Metric.tabHeight)
        }
        pageScrollView.snp.makeConstraints { make in
            make.top.equalTo(tabScrollView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        pageContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(pageScrollView.snp.height)
            make.width.equalTo(pageScrollView.snp.width).multipliedBy(pages.count > 0 ? pages.count : 1)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutChildPages()
        updateTabIndicator(animated: false)
    }

    // MARK: - Tab Construction

    private func buildTabButtons() {
        pages.enumerated().forEach { index, page in
            let button         = UIButton(type: .system)
            button.tag         = index
            button.setTitle(page.title, for: .normal)
            button.titleLabel?.font     = AppFont.body
            button.setTitleColor(AppColor.textSecondary, for: .normal)
            button.setTitleColor(AppColor.accent, for: .selected)
            button.addTarget(self, action: #selector(_tabTapped(_:)), for: .touchUpInside)
            tabStackView.addArrangedSubview(button)

            let minWidth: CGFloat = UIScreen.main.bounds.width / CGFloat(min(pages.count, 4))
            button.snp.makeConstraints { make in
                make.width.greaterThanOrEqualTo(minWidth)
                make.height.equalTo(Metric.tabHeight)
            }
        }
        updateTabSelection(index: 0, animated: false)
    }

    @objc private func _tabTapped(_ sender: UIButton) {
        selectPage(at: sender.tag, animated: true)
    }

    // MARK: - Page Navigation

    /// Programmatically select a tab/page.
    func selectPage(at index: Int, animated: Bool = true) {
        guard index >= 0, index < pages.count, index != currentIndex else { return }

        let previous = currentIndex
        currentIndex = index
        selectedIndexRelay.accept(index)

        loadPageIfNeeded(at: index)
        updateTabSelection(index: index, animated: animated)

        let offsetX = CGFloat(index) * pageScrollView.bounds.width
        pageScrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: animated)

        _ = previous  // suppress unused warning; useful for analytics hooks
    }

    // MARK: - Lazy Loading

    private func loadPageIfNeeded(at index: Int) {
        guard loadedVCs[index] == nil, index < pages.count else { return }

        let childVC = pages[index].viewController()
        addChild(childVC)
        pageContainer.addSubview(childVC.view)
        childVC.didMove(toParent: self)

        childVC.view.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(CGFloat(index) * pageScrollView.bounds.width)
            make.width.equalTo(pageScrollView.snp.width)
        }

        loadedVCs[index] = childVC
    }

    private func layoutChildPages() {
        loadedVCs.forEach { index, childVC in
            childVC.view.snp.updateConstraints { make in
                make.leading.equalToSuperview().offset(CGFloat(index) * pageScrollView.bounds.width)
                make.width.equalTo(pageScrollView.snp.width)
            }
        }
    }

    // MARK: - Tab Indicator

    private func updateTabSelection(index: Int, animated: Bool) {
        tabStackView.arrangedSubviews.enumerated().forEach { i, view in
            (view as? UIButton)?.isSelected = (i == index)
        }
        updateTabIndicator(animated: animated)
        scrollTabToVisible(index: index)
    }

    private func updateTabIndicator(animated: Bool) {
        guard currentIndex < tabStackView.arrangedSubviews.count else { return }
        let tabButton = tabStackView.arrangedSubviews[currentIndex]

        let x      = tabButton.frame.origin.x
        let width  = tabButton.frame.width
        let y      = Metric.tabHeight - Metric.indicatorH

        let updateBlock = {
            self.tabIndicator.frame = CGRect(x: x, y: y, width: width, height: Metric.indicatorH)
        }

        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
                updateBlock()
            }
        } else {
            updateBlock()
        }
    }

    private func scrollTabToVisible(index: Int) {
        guard index < tabStackView.arrangedSubviews.count else { return }
        let tabButton = tabStackView.arrangedSubviews[index]
        tabScrollView.scrollRectToVisible(tabButton.frame, animated: true)
    }

    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView === pageScrollView else { return }
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        guard index != currentIndex else { return }

        currentIndex = index
        selectedIndexRelay.accept(index)
        loadPageIfNeeded(at: index)
        updateTabSelection(index: index, animated: true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Allows smooth tab indicator interpolation during drag if needed
    }
}
