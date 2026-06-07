//
//  PrimaryButton.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import UIKit

final class PrimaryButton: AppButton {

    init(title: String) {
        super.init(title: title, style: .primary, size: .large)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
