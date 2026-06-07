//
//  AppIconButton.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 04/06/26.
//

import UIKit

final class AppIconButton: UIButton {

    // MARK: - Types

    enum Style {
        case plain
        case filled
        case tonal
        case destructive
    }

    enum Size {
        case small
        case medium
        case large

        var dimension: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 40
            case .large: return 48
            }
        }

        var symbolPointSize: CGFloat {
            switch self {
            case .small: return 14
            case .medium: return 17
            case .large: return 20
            }
        }
    }

    // MARK: - Properties

    private let style: Style
    private let buttonSize: Size
    private var iconImage: UIImage?

    override var isHighlighted: Bool {
        didSet {
            guard isEnabled else { return }
            if isHighlighted {
                AppAnimation.haptic(.light)
            }
            animatePress(isPressed: isHighlighted, scale: 0.92, pressedAlpha: 0.75)
        }
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.45
        }
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: buttonSize.dimension, height: buttonSize.dimension)
    }

    // MARK: - Init

    init(
        image: UIImage?,
        style: Style = .tonal,
        size: Size = .medium
    ) {
        self.iconImage = image
        self.style = style
        self.buttonSize = size
        super.init(frame: .zero)
        applyConfiguration()
    }

    convenience init(
        systemName: String,
        style: Style = .tonal,
        size: Size = .medium
    ) {
        self.init(image: UIImage(systemName: systemName), style: style, size: size)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - API

    func setIcon(_ image: UIImage?) {
        iconImage = image
        applyConfiguration()
    }

    // MARK: - Helpers

    private func applyConfiguration() {
        let appearance = style.appearance
        var config: UIButton.Configuration = style.usesFilledConfiguration ? .filled() : .plain()
        config.image = iconImage?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: buttonSize.symbolPointSize, weight: .semibold)
        )
        config.baseForegroundColor = appearance.foregroundColor
        config.baseBackgroundColor = appearance.backgroundColor
        config.background.backgroundColor = appearance.backgroundColor
        config.background.cornerRadius = buttonSize.dimension / 2
        config.contentInsets = .zero

        configuration = config
        layer.cornerRadius = buttonSize.dimension / 2
        layer.borderWidth = appearance.borderWidth
        layer.borderColor = appearance.borderColor?.cgColor
        clipsToBounds = true
        alpha = isEnabled ? 1 : 0.45
        invalidateIntrinsicContentSize()
    }
}

// MARK: - Style

private extension AppIconButton.Style {

    struct Appearance {
        let backgroundColor: UIColor
        let foregroundColor: UIColor
        let borderColor: UIColor?
        let borderWidth: CGFloat
    }

    var appearance: Appearance {
        switch self {
        case .plain:
            return Appearance(
                backgroundColor: .clear,
                foregroundColor: AppColor.textPrimary,
                borderColor: nil,
                borderWidth: 0
            )
        case .filled:
            return Appearance(
                backgroundColor: AppColor.accent,
                foregroundColor: AppColor.textInverse,
                borderColor: nil,
                borderWidth: 0
            )
        case .tonal:
            return Appearance(
                backgroundColor: AppColor.surface,
                foregroundColor: AppColor.accent,
                borderColor: AppColor.border,
                borderWidth: 0.5
            )
        case .destructive:
            return Appearance(
                backgroundColor: AppColor.error.withAlphaComponent(0.14),
                foregroundColor: AppColor.error,
                borderColor: nil,
                borderWidth: 0
            )
        }
    }

    var usesFilledConfiguration: Bool {
        switch self {
        case .filled, .tonal, .destructive:
            return true
        case .plain:
            return false
        }
    }
}
