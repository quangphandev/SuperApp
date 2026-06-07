//
//  AppCardView.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import UIKit

class AppCardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = AppColor.surface
        layer.cornerRadius = AppRadius.card
        layer.masksToBounds = false
        AppShadow.applyCardShadow(to: self)
    }
}
