//
//  SplashFooterCell.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import SnapKit
import UIKit

final class SplashFooterCell: BaseCollectionCell {

    // MARK: - UI Components

    private let footerLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textAlignment = .center
        label.textColor = AppColor.textTertiary
        return label
    }()

    private let hintLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textAlignment = .center
        label.textColor = AppColor.textTertiary
        return label
    }()

    // MARK: - API

    func configure(footer: String, hint: String) {
        footerLabel.text = footer
        hintLabel.text = hint
    }

    // MARK: - Setup

    override func setupViews() {
        contentView.addSubview(footerLabel)
        contentView.addSubview(hintLabel)
    }

    override func setupConstraints() {
        footerLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.trailing.equalToSuperview()
        }

        hintLabel.snp.makeConstraints { make in
            make.top.equalTo(footerLabel.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
