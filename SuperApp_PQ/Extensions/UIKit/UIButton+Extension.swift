//
//  UIButton+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import UIKit

// MARK: - Title Styling

extension UIButton {

    /// Sets the title with a specific font and color for a given state.
    ///
    /// Usage: `button.setTitle("Đăng nhập", font: AppFont.headline, color: AppColor.accent)`
    func setTitle(
        _ title: String,
        font: UIFont,
        color: UIColor = .label,
        for state: UIControl.State = .normal
    ) {
        let attrs: [NSAttributedString.Key: Any] = [
            .font:            font,
            .foregroundColor: color
        ]
        setAttributedTitle(NSAttributedString(string: title, attributes: attrs), for: state)
    }
}

// MARK: - Loading State

extension UIButton {

    private static var loadingTagKey: UInt8 = 0
    private static let loadingTag = 9_999_001

    /// Shows or hides an inline spinner replacing the button title.
    /// Automatically disables/enables the button.
    ///
    /// Usage:
    /// ```swift
    /// submitButton.setLoadingState(true)   // show spinner
    /// submitButton.setLoadingState(false)  // restore title
    /// ```
    func setLoadingState(_ isLoading: Bool, spinnerColor: UIColor = .white) {
        isEnabled = !isLoading

        if isLoading {
            // Save current title and hide it
            objc_setAssociatedObject(
                self, &Self.loadingTagKey,
                currentAttributedTitle ?? currentTitle.map { NSAttributedString(string: $0) },
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
            setAttributedTitle(nil, for: .normal)
            setTitle("", for: .normal)

            // Add spinner if not already present
            if viewWithTag(Self.loadingTag) == nil {
                let spinner = UIActivityIndicatorView(style: .medium)
                spinner.color    = spinnerColor
                spinner.tag      = Self.loadingTag
                spinner.translatesAutoresizingMaskIntoConstraints = false
                addSubview(spinner)
                NSLayoutConstraint.activate([
                    spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
                    spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])
                spinner.startAnimating()
            }
        } else {
            // Remove spinner
            viewWithTag(Self.loadingTag)?.removeFromSuperview()

            // Restore saved attributed title
            let saved = objc_getAssociatedObject(self, &Self.loadingTagKey) as? NSAttributedString
            if let saved {
                setAttributedTitle(saved, for: .normal)
            }
        }
    }
}

// MARK: - Image Position

extension UIButton {

    enum ImagePosition {
        case left, right, top, bottom
    }

    /// Sets button image relative to the title.
    /// Only works with `UIButton.Configuration`-based buttons (iOS 15+).
    ///
    /// Usage: `button.setImage(UIImage(systemName: "arrow.right"), position: .right, spacing: 8)`
    func setImage(
        _ image: UIImage?,
        position: ImagePosition = .left,
        spacing: CGFloat = 6
    ) {
        var config = configuration ?? UIButton.Configuration.plain()
        if configuration == nil {
            config.title = currentTitle
        }
        config.image = image
        config.imagePadding = spacing
        switch position {
        case .left:   config.imagePlacement = .leading
        case .right:  config.imagePlacement = .trailing
        case .top:    config.imagePlacement = .top
        case .bottom: config.imagePlacement = .bottom
        }
        configuration = config
    }
}

// MARK: - Hit Area Expansion

extension UIButton {

    /// Expands the tap hit area by the given inset (negative = expand outward).
    ///
    /// Usage: call in `override func point(inside:with:)` or use `contentEdgeInsets`.
    /// For quick 44pt minimum target: `button.expandHitArea(by: 10)`
    func expandHitArea(by padding: CGFloat) {
        var config = configuration ?? UIButton.Configuration.plain()
        if configuration == nil {
            config.title = currentTitle
            config.image = currentImage
        }
        config.contentInsets = NSDirectionalEdgeInsets(
            top: padding,
            leading: padding,
            bottom: padding,
            trailing: padding
        )
        configuration = config
    }
}
