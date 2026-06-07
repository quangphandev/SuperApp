//
//  HomeFocusCell.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import SnapKit
import UIKit

final class HomeFocusCell: BaseCollectionCell {

    // MARK: - UI Components

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.surface
        view.layer.cornerRadius = AppRadius.large
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColor.border.cgColor
        return view
    }()

    private let iconBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.bodyMedium
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 1
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 1
        return label
    }()

    private let actionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.captionMedium
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()

    // MARK: - API

    func configure(with item: HomeDashboardFocusItem) {
        let accentColor = item.accent.color
        iconBackgroundView.backgroundColor = accentColor
        actionLabel.textColor = accentColor
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        actionLabel.text = item.actionTitle
    }

    // MARK: - Setup

    override func setupViews() {
        contentView.addSubview(cardView)
        cardView.addSubview(iconBackgroundView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(actionLabel)
    }

    override func setupConstraints() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(64)
        }

        iconBackgroundView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.large)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }

        actionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(AppSpacing.large)
            make.centerY.equalToSuperview()
            make.width.equalTo(52)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppSpacing.medium)
            make.leading.equalTo(iconBackgroundView.snp.trailing).offset(AppSpacing.medium)
            make.trailing.equalTo(actionLabel.snp.leading).offset(-AppSpacing.medium)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(AppSpacing.xSmall)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.lessThanOrEqualToSuperview().inset(AppSpacing.medium)
        }
    }
}
