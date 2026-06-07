//
//  AppButton.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 04/06/26.
//

import UIKit

class AppButton: UIButton {

    // MARK: - Types

    enum Style {
        case primary
        case secondary
        case tonal
        case ghost
        case destructive
        case destructiveSecondary
    }

    enum Size {
        case small
        case medium
        case large

        var height: CGFloat {
            switch self {
            case .small: return 36
            case .medium: return 44
            case .large: return 52
            }
        }

        var font: UIFont {
            switch self {
            case .small: return AppFont.captionMedium
            case .medium: return AppFont.bodyMedium
            case .large: return AppFont.headline
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .small: return AppRadius.medium
            case .medium, .large: return AppRadius.large
            }
        }

        var contentInsets: NSDirectionalEdgeInsets {
            switch self {
            case .small:
                return NSDirectionalEdgeInsets(
                    top: AppSpacing.small,
                    leading: AppSpacing.medium,
                    bottom: AppSpacing.small,
                    trailing: AppSpacing.medium
                )
            case .medium:
                return NSDirectionalEdgeInsets(
                    top: AppSpacing.medium,
                    leading: AppSpacing.large,
                    bottom: AppSpacing.medium,
                    trailing: AppSpacing.large
                )
            case .large:
                return NSDirectionalEdgeInsets(
                    top: AppSpacing.medium,
                    leading: AppSpacing.xLarge,
                    bottom: AppSpacing.medium,
                    trailing: AppSpacing.xLarge
                )
            }
        }
    }

    // MARK: - Properties

    private(set) var style: Style
    private(set) var buttonSize: Size

    private var titleText: String
    private var iconImage: UIImage?
    private var iconPlacement: NSDirectionalRectEdge
    private var isLoading = false
    private let performsHaptic: Bool

    override var isHighlighted: Bool {
        didSet {
            guard isEnabled, !isLoading else { return }
            if isHighlighted, performsHaptic {
                AppAnimation.haptic(.light)
            }
            animatePress(
                isPressed: isHighlighted,
                scale: 0.97,
                pressedAlpha: style.pressedAlpha
            )
        }
    }

    override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1 : 0.45
        }
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width, height: max(size.height, buttonSize.height))
    }

    // MARK: - Init

    init(
        title: String,
        style: Style = .primary,
        size: Size = .large,
        image: UIImage? = nil,
        imagePlacement: NSDirectionalRectEdge = .leading,
        performsHaptic: Bool = true
    ) {
        self.titleText = title
        self.style = style
        self.buttonSize = size
        self.iconImage = image
        self.iconPlacement = imagePlacement
        self.performsHaptic = performsHaptic
        super.init(frame: .zero)
        applyConfiguration()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - API

    func configure(
        title: String? = nil,
        style: Style? = nil,
        size: Size? = nil,
        image: UIImage? = nil,
        imagePlacement: NSDirectionalRectEdge? = nil
    ) {
        if let title { titleText = title }
        if let style { self.style = style }
        if let size { buttonSize = size }
        if let image { iconImage = image }
        if let imagePlacement { self.iconPlacement = imagePlacement }
        applyConfiguration()
    }

    func setTitleText(_ title: String) {
        titleText = title
        applyConfiguration()
    }

    func setIcon(_ image: UIImage?, placement: NSDirectionalRectEdge = .leading) {
        iconImage = image
        iconPlacement = placement
        applyConfiguration()
    }

    func setLoading(_ isLoading: Bool) {
        self.isLoading = isLoading
        isUserInteractionEnabled = !isLoading
        applyConfiguration()
    }

    // MARK: - Helpers

    private func applyConfiguration() {
        let appearance = style.appearance
        var config: UIButton.Configuration = style.usesFilledConfiguration ? .filled() : .plain()

        config.title = isLoading ? nil : titleText
        config.image = isLoading ? nil : iconImage
        config.imagePlacement = iconPlacement
        config.imagePadding = AppSpacing.small
        config.showsActivityIndicator = isLoading
        config.baseForegroundColor = appearance.foregroundColor
        config.baseBackgroundColor = appearance.backgroundColor
        config.background.backgroundColor = appearance.backgroundColor
        config.background.cornerRadius = buttonSize.cornerRadius
        config.contentInsets = buttonSize.contentInsets
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { [buttonSize] attrs in
            var output = attrs
            output.font = buttonSize.font
            return output
        }

        configuration = config
        layer.cornerRadius = buttonSize.cornerRadius
        layer.borderWidth = appearance.borderWidth
        layer.borderColor = appearance.borderColor?.cgColor
        clipsToBounds = true
        alpha = isEnabled ? 1 : 0.45
        invalidateIntrinsicContentSize()
    }
}

// MARK: - Style

private extension AppButton.Style {

    struct Appearance {
        let backgroundColor: UIColor
        let foregroundColor: UIColor
        let borderColor: UIColor?
        let borderWidth: CGFloat
    }

    var appearance: Appearance {
        switch self {
        case .primary:
            return Appearance(
                backgroundColor: AppColor.accent,
                foregroundColor: AppColor.textInverse,
                borderColor: nil,
                borderWidth: 0
            )
        case .secondary:
            return Appearance(
                backgroundColor: .clear,
                foregroundColor: AppColor.accent,
                borderColor: AppColor.accent,
                borderWidth: 1.5
            )
        case .tonal:
            return Appearance(
                backgroundColor: AppColor.accent.withAlphaComponent(0.14),
                foregroundColor: AppColor.accent,
                borderColor: nil,
                borderWidth: 0
            )
        case .ghost:
            return Appearance(
                backgroundColor: .clear,
                foregroundColor: AppColor.accent,
                borderColor: nil,
                borderWidth: 0
            )
        case .destructive:
            return Appearance(
                backgroundColor: AppColor.error,
                foregroundColor: AppColor.textInverse,
                borderColor: nil,
                borderWidth: 0
            )
        case .destructiveSecondary:
            return Appearance(
                backgroundColor: .clear,
                foregroundColor: AppColor.error,
                borderColor: AppColor.error,
                borderWidth: 1.5
            )
        }
    }

    var pressedAlpha: CGFloat {
        switch self {
        case .ghost:
            return 0.7
        default:
            return 0.86
        }
    }

    var usesFilledConfiguration: Bool {
        switch self {
        case .primary, .tonal, .destructive:
            return true
        case .secondary, .ghost, .destructiveSecondary:
            return false
        }
    }
}
