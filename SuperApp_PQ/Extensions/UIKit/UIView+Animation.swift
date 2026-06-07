//
//  UIView+Animation.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 04/06/26.
//

import UIKit

enum AppEntranceAnimation {
    case fade
    case scale
    case slideFromTop
    case slideFromBottom
    case slideFromLeft
    case slideFromRight
}

extension UIView {

    func animateEntrance(
        _ animation: AppEntranceAnimation = .fade,
        distance: CGFloat = 16,
        delay: TimeInterval = 0,
        duration: TimeInterval = AppAnimation.Duration.normal,
        completion: (() -> Void)? = nil
    ) {
        alpha = 0
        transform = entranceTransform(for: animation, distance: distance)

        AppAnimation.spring(
            duration: duration,
            delay: delay,
            animations: {
                self.alpha = 1
                self.transform = .identity
            },
            completion: { _ in completion?() }
        )
    }

    func animateExit(
        _ animation: AppEntranceAnimation = .fade,
        distance: CGFloat = 12,
        duration: TimeInterval = AppAnimation.Duration.fast,
        completion: (() -> Void)? = nil
    ) {
        let targetTransform = entranceTransform(for: animation, distance: distance)

        AppAnimation.animate(
            duration: duration,
            options: [.curveEaseIn, .allowUserInteraction],
            animations: {
                self.alpha = 0
                self.transform = targetTransform
            },
            completion: { _ in completion?() }
        )
    }

    func animatePress(
        isPressed: Bool,
        scale: CGFloat = 0.97,
        pressedAlpha: CGFloat = 0.86,
        duration: TimeInterval = AppAnimation.Duration.fast
    ) {
        AppAnimation.spring(duration: duration) {
            self.transform = isPressed ? CGAffineTransform(scaleX: scale, y: scale) : .identity
            self.alpha = isPressed ? pressedAlpha : 1
        }
    }

    func animateSelectionBounce(
        scale: CGFloat = 1.04,
        duration: TimeInterval = AppAnimation.Duration.fast
    ) {
        AppAnimation.spring(duration: duration) {
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
        } completion: { _ in
            AppAnimation.spring(duration: duration) {
                self.transform = .identity
            }
        }
    }

    func animateCrossDissolve(
        duration: TimeInterval = AppAnimation.Duration.normal,
        changes: @escaping () -> Void,
        completion: (() -> Void)? = nil
    ) {
        guard !AppAnimation.isReduceMotionEnabled else {
            changes()
            completion?()
            return
        }

        UIView.transition(
            with: self,
            duration: duration,
            options: [.transitionCrossDissolve, .allowUserInteraction],
            animations: changes,
            completion: { _ in completion?() }
        )
    }

    private func entranceTransform(
        for animation: AppEntranceAnimation,
        distance: CGFloat
    ) -> CGAffineTransform {
        switch animation {
        case .fade:
            return .identity
        case .scale:
            return CGAffineTransform(scaleX: 0.94, y: 0.94)
        case .slideFromTop:
            return CGAffineTransform(translationX: 0, y: -distance)
        case .slideFromBottom:
            return CGAffineTransform(translationX: 0, y: distance)
        case .slideFromLeft:
            return CGAffineTransform(translationX: -distance, y: 0)
        case .slideFromRight:
            return CGAffineTransform(translationX: distance, y: 0)
        }
    }
}
