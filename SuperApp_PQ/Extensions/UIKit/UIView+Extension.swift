//
//  UIView+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 27/5/26.
//

import UIKit

// MARK: - Subviews

extension UIView {

    /// Adds multiple subviews in one call.
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}

// MARK: - Corner Radius

extension UIView {

    func roundCorners(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        layer.masksToBounds = true
    }

    func roundTopCorners(radius: CGFloat) {
        roundCorners([.layerMinXMinYCorner, .layerMaxXMinYCorner], radius: radius)
    }

    func roundBottomCorners(radius: CGFloat) {
        roundCorners([.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: radius)
    }
}

// MARK: - Shadow

extension UIView {

    func addShadow(
        color: UIColor = UIColor.black,
        opacity: Float = 0.12,
        radius: CGFloat = 8,
        offset: CGSize = CGSize(width: 0, height: 2)
    ) {
        layer.shadowColor   = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius  = radius
        layer.shadowOffset  = offset
        layer.masksToBounds = false
    }

    func removeShadow() {
        layer.shadowOpacity = 0
    }
}

// MARK: - Border

extension UIView {

    func setBorder(color: UIColor, width: CGFloat = 1) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }

    func removeBorder() {
        layer.borderWidth = 0
    }
}

// MARK: - Gradient

extension UIView {

    enum GradientDirection {
        case topToBottom, leftToRight, diagonal

        var start: CGPoint {
            switch self {
            case .topToBottom: return CGPoint(x: 0.5, y: 0)
            case .leftToRight: return CGPoint(x: 0,   y: 0.5)
            case .diagonal:    return CGPoint(x: 0,   y: 0)
            }
        }

        var end: CGPoint {
            switch self {
            case .topToBottom: return CGPoint(x: 0.5, y: 1)
            case .leftToRight: return CGPoint(x: 1,   y: 0.5)
            case .diagonal:    return CGPoint(x: 1,   y: 1)
            }
        }
    }

    @discardableResult
    func addGradient(
        colors: [UIColor],
        direction: GradientDirection = .topToBottom,
        cornerRadius: CGFloat = 0
    ) -> CAGradientLayer {
        let gradient        = CAGradientLayer()
        gradient.colors     = colors.map { $0.cgColor }
        gradient.startPoint = direction.start
        gradient.endPoint   = direction.end
        gradient.frame      = bounds
        gradient.cornerRadius = cornerRadius
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}

// MARK: - Visibility

extension UIView {

    func show(animated: Bool = false, duration: TimeInterval = 0.2) {
        guard isHidden else { return }
        if animated {
            isHidden = false
            alpha = 0
            UIView.animate(withDuration: duration) { self.alpha = 1 }
        } else {
            isHidden = false
        }
    }

    func hide(animated: Bool = false, duration: TimeInterval = 0.2) {
        guard !isHidden else { return }
        if animated {
            UIView.animate(withDuration: duration, animations: {
                self.alpha = 0
            }, completion: { _ in
                self.isHidden = true
                self.alpha    = 1
            })
        } else {
            isHidden = true
        }
    }
}

// MARK: - Shake Animation

extension UIView {

    func shake() {
        let animation              = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction   = CAMediaTimingFunction(name: .linear)
        animation.duration         = 0.4
        animation.values           = [-8, 8, -6, 6, -4, 4, 0]
        layer.add(animation, forKey: "shake")
    }
}

// MARK: - Pulse Animation

extension UIView {

    func pulse(scale: CGFloat = 1.06, duration: TimeInterval = 0.15) {
        UIView.animate(
            withDuration: duration,
            animations: { self.transform = CGAffineTransform(scaleX: scale, y: scale) },
            completion: { _ in
                UIView.animate(withDuration: duration) {
                    self.transform = .identity
                }
            }
        )
    }
}
