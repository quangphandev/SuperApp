//
//  NotesBottomNavView.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 12/06/26.
//

import UIKit
import SnapKit

enum NotesTab: Int, CaseIterable {
    case home
    case search
    case new
    case folders
    case settings

    var title: String {
        switch self {
        case .home: return L10n.Notes.Nav.home
        case .search: return L10n.Notes.Nav.search
        case .new: return L10n.Notes.Nav.new
        case .folders: return L10n.Notes.Nav.folders
        case .settings: return L10n.Notes.Nav.settings
        }
    }

    var icon: UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "note.text")
        case .search:
            return UIImage(systemName: "magnifyingglass")
        case .new:
            return UIImage(systemName: "plus")
        case .folders:
            return UIImage(systemName: "folder")
        case .settings:
            return UIImage(systemName: "slider.horizontal.3")
        }
    }
}

final class NotesBottomNavView: UIView {

    // MARK: - Properties

    var onTabSelect: ((NotesTab) -> Void)?
    private(set) var activeTab: NotesTab = .home

    // MARK: - UI Components

    private let topIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.accent
        view.layer.cornerRadius = 1.5
        return view
    } ()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    } ()

    private var tabViews: [NotesTab: NotesBottomNavItemView] = [:]

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - API

    func selectTab(_ tab: NotesTab) {
        activeTab = tab
        for (itemTab, tabView) in tabViews {
            tabView.isSelected = (itemTab == tab)
        }
        updateIndicatorPosition()
    }

    // MARK: - Setup

    private func setupViews() {
        backgroundColor = AppColor.groupedBackground
        layer.borderWidth = 1
        layer.borderColor = AppColor.border.cgColor

        addSubview(topIndicatorView)
        addSubview(stackView)

        for tab in NotesTab.allCases {
            let itemView = NotesBottomNavItemView(tab: tab)
            itemView.onTap = { [weak self] selectedTab in
                self?.selectTab(selectedTab)
                self?.onTabSelect?(selectedTab)
            }
            tabViews[tab] = itemView
            stackView.addArrangedSubview(itemView)
        }

        selectTab(.home)
    }

    private func setupConstraints() {
        topIndicatorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(3)
            make.width.equalTo(40)
            make.centerX.equalTo(self.snp.leading).offset(0) // Will be updated dynamically
        }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppSpacing.small)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.small)
            make.bottom.equalToSuperview().inset(AppSpacing.small)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateIndicatorPosition()
    }

    private func updateIndicatorPosition() {
        guard bounds.width > 0 else { return }
        let tabWidth = bounds.width / CGFloat(NotesTab.allCases.count)
        let targetX = tabWidth * CGFloat(activeTab.rawValue) + (tabWidth / 2)

        topIndicatorView.snp.updateConstraints { make in
            make.centerX.equalTo(self.snp.leading).offset(targetX)
        }

        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.layoutIfNeeded()
        }
    }
}

private final class NotesBottomNavItemView: UIControl {

    let tab: NotesTab

    var onTap: ((NotesTab) -> Void)?

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(
            pointSize: 18,
            weight: .semibold
        )
        return imageView
    } ()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    } ()

    init(tab: NotesTab) {
        self.tab = tab
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        updateAppearance()
        addTarget(self, action: #selector(didTapItem), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(iconImageView)
        addSubview(titleLabel)
    }

    private func setupConstraints() {
        iconImageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(22)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(AppSpacing.xSmall)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    private func updateAppearance() {
        let tintColor = isSelected ? AppColor.accent : AppColor.textTertiary
        iconImageView.image = tab.icon
        iconImageView.tintColor = tintColor
        titleLabel.text = tab.title
        titleLabel.textColor = tintColor
    }

    @objc private func didTapItem() {
        AppAnimation.haptic(.light)
        onTap?(tab)
    }
}
