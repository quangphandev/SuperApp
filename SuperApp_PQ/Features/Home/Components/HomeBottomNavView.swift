//
//  HomeBottomNavView.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import SnapKit
import UIKit

final class HomeBottomNavView: UIView {

    // MARK: - UI Components

    private let topIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.accent
        view.layer.cornerRadius = 1.5
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - API

    func configure(
        with items: [HomeDashboardNavItem],
        onSelect: ((HomeDashboardNavItem) -> Void)? = nil
    ) {
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        items.forEach { item in
            let itemView = HomeBottomNavItemView()
            itemView.configure(with: item)
            itemView.onTap = {
                onSelect?(item)
            }
            stackView.addArrangedSubview(itemView)
        }
    }

    // MARK: - Setup

    private func setupViews() {
        backgroundColor = AppColor.background
        layer.borderWidth = 1
        layer.borderColor = AppColor.border.cgColor
        addSubview(topIndicatorView)
        addSubview(stackView)
    }

    private func setupConstraints() {
        topIndicatorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(AppSpacing.xLarge)
            make.width.equalTo(42)
            make.height.equalTo(3)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppSpacing.small)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.small)
            make.bottom.equalToSuperview().inset(AppSpacing.small)
        }
    }
}

private final class HomeBottomNavItemView: UIControl {

    // MARK: - Properties

    var onTap: (() -> Void)?

    // MARK: - UI Components

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(
            pointSize: 18,
            weight: .semibold
        )
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        addTarget(self, action: #selector(didTapItem), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - API

    func configure(with item: HomeDashboardNavItem) {
        let tintColor = item.isSelected ? item.accent.color : AppColor.textSecondary
        iconImageView.image = UIImage(systemName: item.systemImageName)
        iconImageView.tintColor = tintColor
        titleLabel.text = item.title
        titleLabel.textColor = tintColor
    }

    // MARK: - Setup

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

    // MARK: - Actions

    @objc private func didTapItem() {
        AppAnimation.haptic(.light)
        onTap?()
    }
}
