//
//  SplashSummaryCell.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import SnapKit
import UIKit

final class SplashSummaryCell: BaseCollectionCell {

    // MARK: - UI Components

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.surface
        view.layer.cornerRadius = 18
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColor.border.cgColor
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.bodyMedium
        label.textColor = AppColor.textPrimary
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textColor = AppColor.textTertiary
        return label
    }()

    // MARK: - API

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

    // MARK: - Setup

    override func setupViews() {
        contentView.addSubview(cardView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
    }

    override func setupConstraints() {
        cardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(26)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(58)
            make.bottom.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppSpacing.medium)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.large)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(AppSpacing.xSmall)
            make.leading.trailing.equalTo(titleLabel)
        }
    }
}
