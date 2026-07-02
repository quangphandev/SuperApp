//
//  SplashBrandCell.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import SnapKit
import UIKit

final class SplashBrandCell: BaseCollectionCell {

    // MARK: - UI Components

    private let markView = SplashLumaMarkView()

    private let brandLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(size: 34, weight: .bold)
        label.textAlignment = .center
        label.textColor = AppColor.textPrimary
        return label
    }()

    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body
        label.textAlignment = .center
        label.textColor = AppColor.textTertiary
        return label
    }()

    // MARK: - API

    func configure(with content: SplashContent) {
        brandLabel.text = content.brandName
        taglineLabel.text = content.tagline
    }

    // MARK: - Setup

    override func setupViews() {
        contentView.addSubview(markView)
        contentView.addSubview(brandLabel)
        contentView.addSubview(taglineLabel)
    }

    override func setupConstraints() {
        markView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(72)
            make.centerX.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(70)
        }

        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(markView.snp.bottom).offset(AppSpacing.medium)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
        }

        taglineLabel.snp.makeConstraints { make in
            make.top.equalTo(brandLabel.snp.bottom).offset(AppSpacing.xSmall)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}
