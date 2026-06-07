//
//  HomeHeaderCell.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import SnapKit
import UIKit

final class HomeHeaderCell: BaseCollectionCell {

    // MARK: - UI Components

    private let markView = LumaMarkView()

    private let brandLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.captionMedium
        label.textColor = AppColor.textSecondary
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.largeTitle
        label.textColor = AppColor.textPrimary
        return label
    }()

    private let statusBadgeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.captionMedium
        label.textColor = AppColor.accent
        label.textAlignment = .center
        label.backgroundColor = AppColor.elevatedSurface
        label.layer.cornerRadius = AppRadius.medium
        label.layer.borderWidth = 1
        label.layer.borderColor = AppColor.border.cgColor
        label.clipsToBounds = true
        return label
    }()

    // MARK: - API

    func configure(with content: HomeContent) {
        brandLabel.text = content.brandName
        titleLabel.text = content.title
        statusBadgeLabel.text = content.statusTitle
    }

    // MARK: - Setup

    override func setupViews() {
        contentView.addSubview(markView)
        contentView.addSubview(brandLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(statusBadgeLabel)
    }

    override func setupConstraints() {
        markView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(AppSpacing.large)
            make.width.equalTo(36)
            make.height.equalTo(26)
        }

        brandLabel.snp.makeConstraints { make in
            make.leading.equalTo(markView.snp.trailing).offset(AppSpacing.xSmall)
            make.centerY.equalTo(markView.snp.top).offset(AppSpacing.large)
            make.trailing.lessThanOrEqualTo(statusBadgeLabel.snp.leading).offset(-AppSpacing.medium)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(markView.snp.bottom).offset(AppSpacing.xSmall)
            make.leading.equalToSuperview()
            make.trailing.lessThanOrEqualTo(statusBadgeLabel.snp.leading).offset(-AppSpacing.medium)
            make.bottom.equalToSuperview().inset(AppSpacing.medium)
        }

        statusBadgeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(72)
            make.height.equalTo(32)
        }
    }
}
