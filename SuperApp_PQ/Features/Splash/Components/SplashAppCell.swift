//
//  SplashAppCell.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import SnapKit
import UIKit

final class SplashAppCell: BaseCollectionCell {

    // MARK: - UI Components

    private let pillView = SplashAppPillView()

    // MARK: - API

    func configure(
        with item: SplashAppItem,
        isSelected: Bool,
        onTap: ((SplashAppKind) -> Void)? = nil
    ) {
        pillView.onTap = onTap
        pillView.isUserInteractionEnabled = true
        pillView.configure(with: item, isSelected: isSelected)
    }

    // MARK: - Setup

    override func setupViews() {
        contentView.addSubview(pillView)
    }

    override func setupConstraints() {
        pillView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
