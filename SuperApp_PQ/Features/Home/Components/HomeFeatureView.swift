//
//  HomeFeatureView.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import SnapKit
import UIKit

final class HomeFeatureView: AppCardView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.headline
        label.textColor = AppColor.textPrimary
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: HomeFeatureItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }

    private func setupViews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(AppSpacing.large)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(AppSpacing.small)
            make.leading.trailing.bottom.equalToSuperview().inset(AppSpacing.large)
        }
    }
}

