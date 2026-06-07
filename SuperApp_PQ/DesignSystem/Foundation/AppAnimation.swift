//
//  AppAnimation.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 04/06/26.
//

import UIKit

enum AppAnimation {

    enum Duration {
        static let instant: TimeInterval = 0.08
        static let fast: TimeInterval = 0.14
        static let normal: TimeInterval = 0.22
        static let slow: TimeInterval = 0.35
    }

    enum Spring {
        static let damping: CGFloat = 0.82
        static let velocity: CGFloat = 0.55
    }

    static var isReduceMotionEnabled: Bool {
        UIAccessibility.isReduceMotionEnabled
    }

    static func animate(
        duration: TimeInterval = Duration.normal,
        delay: TimeInterval = 0,
        options: UIView.AnimationOptions = [.curveEaseInOut],
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        guard !isReduceMotionEnabled else {
            UIView.performWithoutAnimation {
                animations()
            }
            completion?(true)
            return
        }

        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: options,
            animations: animations,
            completion: completion
        )
    }

    static func spring(
        duration: TimeInterval = Duration.normal,
        delay: TimeInterval = 0,
        damping: CGFloat = Spring.damping,
        velocity: CGFloat = Spring.velocity,
        options: UIView.AnimationOptions = [.curveEaseOut, .allowUserInteraction],
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        guard !isReduceMotionEnabled else {
            UIView.performWithoutAnimation {
                animations()
            }
            completion?(true)
            return
        }

        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: damping,
            initialSpringVelocity: velocity,
            options: options,
            animations: animations,
            completion: completion
        )
    }

    static func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        guard !isReduceMotionEnabled else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}
