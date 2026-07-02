//
//  SplashLauncherHeaderCell.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import SnapKit
import UIKit

final class SplashLauncherHeaderCell: BaseCollectionCell {

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textColor = AppColor.textTertiary
        return label
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textAlignment = .right
        label.textColor = AppColor.textTertiary
        return label
    }()

    // MARK: - API

    func configure(title: String, count: String) {
        titleLabel.text = title
        countLabel.text = count
    }

    // MARK: - Setup

    override func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
    }

    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(170)
        }

        countLabel.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(170)
        }
    }
}
