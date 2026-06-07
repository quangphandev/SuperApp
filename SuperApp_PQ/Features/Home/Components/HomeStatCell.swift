//
//  HomeStatCell.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import SnapKit
import UIKit

final class HomeStatCell: BaseCollectionCell {

    // MARK: - UI Components

    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.surface
        view.layer.cornerRadius = AppRadius.large
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColor.border.cgColor
        return view
    }()

    private let dotView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 1
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(size: 22, weight: .bold)
        label.textColor = AppColor.textPrimary
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 1
        return label
    }()

    // MARK: - API

    func configure(with stat: HomeDashboardStat) {
        dotView.backgroundColor = stat.accent.color
        titleLabel.text = stat.title
        valueLabel.text = stat.value
        subtitleLabel.text = stat.subtitle
    }

    // MARK: - Setup

    override func setupViews() {
        contentView.addSubview(cardView)
        cardView.addSubview(dotView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(valueLabel)
        cardView.addSubview(subtitleLabel)
    }

    override func setupConstraints() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(92)
        }

        dotView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(AppSpacing.medium)
            make.size.equalTo(10)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dotView)
            make.leading.equalTo(dotView.snp.trailing).offset(AppSpacing.xSmall)
            make.trailing.equalToSuperview().inset(AppSpacing.medium)
        }

        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(AppSpacing.small)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.medium)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(AppSpacing.xSmall)
            make.leading.trailing.bottom.equalToSuperview().inset(AppSpacing.medium)
        }
    }
}
