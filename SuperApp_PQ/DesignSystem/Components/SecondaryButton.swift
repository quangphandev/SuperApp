//
//  SecondaryButton.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import UIKit

final class SecondaryButton: AppButton {

    // MARK: - Variant

    enum Variant {
        case `default`
        case destructive
        case ghost
    }

    // MARK: - Properties

    private let variant: Variant

    // MARK: - Init

    init(title: String, variant: Variant = .default) {
        self.variant = variant
        super.init(title: title, style: variant.buttonStyle, size: .large)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Loading State

    func setLoadingState(_ isLoading: Bool) {
        setLoading(isLoading)
    }
}

private extension SecondaryButton.Variant {

    var buttonStyle: AppButton.Style {
        switch self {
        case .default:
            return .secondary
        case .destructive:
            return .destructiveSecondary
        case .ghost:
            return .ghost
        }
    }
}
