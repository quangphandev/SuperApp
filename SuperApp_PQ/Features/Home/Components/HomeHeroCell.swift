//
//  HomeHeroCell.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import SnapKit
import UIKit

final class HomeHeroCell: BaseCollectionCell {

    // MARK: - UI Components

    private let stateEyebrowLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.captionMedium
        label.textColor = AppColor.accent
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.title
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 0
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 0
        return label
    }()

    private let progressCardView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.surface
        view.layer.cornerRadius = AppRadius.card
        view.layer.borderWidth = 1.5
        view.layer.borderColor = AppColor.accent.cgColor
        return view
    }()

    private let progressEyebrowLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.captionMedium
        label.textColor = AppColor.accent
        return label
    }()

    private let progressTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.headline
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 0
        return label
    }()

    private let progressSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 0
        return label
    }()

    private let progressTrackView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.elevatedSurface
        view.layer.cornerRadius = 3
        view.clipsToBounds = true
        return view
    }()

    private let progressFillView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.accent
        view.layer.cornerRadius = 3
        return view
    }()

    private let progressValueLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.metric
        label.textColor = AppColor.accent
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()

    // MARK: - API

    func configure(with content: HomeContent) {
        stateEyebrowLabel.text = content.dashboardEyebrow
        titleLabel.text = content.dashboardTitle
        messageLabel.text = content.dashboardMessage
        progressEyebrowLabel.text = content.progressEyebrow
        progressTitleLabel.text = content.progressTitle
        progressSubtitleLabel.text = content.progressSubtitle
        progressValueLabel.text = content.progressText

        let progress = max(0, min(content.progressValue, 1))
        progressFillView.snp.remakeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(progressTrackView).multipliedBy(progress)
        }
    }

    // MARK: - Setup

    override func setupViews() {
        contentView.addSubview(stateEyebrowLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(progressCardView)

        progressCardView.addSubview(progressEyebrowLabel)
        progressCardView.addSubview(progressTitleLabel)
        progressCardView.addSubview(progressSubtitleLabel)
        progressCardView.addSubview(progressTrackView)
        progressTrackView.addSubview(progressFillView)
        progressCardView.addSubview(progressValueLabel)
    }

    override func setupConstraints() {
        stateEyebrowLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(stateEyebrowLabel.snp.bottom).offset(AppSpacing.small)
            make.leading.trailing.equalToSuperview()
        }

        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(AppSpacing.small)
            make.leading.trailing.equalToSuperview()
        }

        progressCardView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(AppSpacing.large)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.greaterThanOrEqualTo(148)
        }

        progressEyebrowLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(AppSpacing.large)
            make.trailing.lessThanOrEqualTo(progressValueLabel.snp.leading).offset(-AppSpacing.medium)
        }

        progressTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressEyebrowLabel.snp.bottom).offset(AppSpacing.small)
            make.leading.equalToSuperview().offset(AppSpacing.large)
            make.trailing.lessThanOrEqualTo(progressValueLabel.snp.leading).offset(-AppSpacing.medium)
        }

        progressSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(progressTitleLabel.snp.bottom).offset(AppSpacing.xSmall)
            make.leading.equalTo(progressTitleLabel)
            make.trailing.lessThanOrEqualTo(progressValueLabel.snp.leading).offset(-AppSpacing.medium)
        }

        progressTrackView.snp.makeConstraints { make in
            make.leading.equalTo(progressTitleLabel)
            make.trailing.equalTo(progressValueLabel.snp.leading).offset(-AppSpacing.large)
            make.bottom.equalToSuperview().inset(AppSpacing.large)
            make.height.equalTo(6)
        }

        progressValueLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(AppSpacing.large)
            make.bottom.equalToSuperview().inset(AppSpacing.medium)
            make.width.equalTo(86)
        }
    }
}
