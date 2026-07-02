//
//  UIScrollView+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import UIKit

// MARK: - Scroll Position Checks

extension UIScrollView {

    /// `true` if the scroll view is scrolled to (or past) the bottom.
    /// Use to trigger load-more in feeds.
    ///
    /// Usage:
    /// ```swift
    /// func scrollViewDidScroll(_ scrollView: UIScrollView) {
    ///     if scrollView.isAtBottom { viewModel.loadMore() }
    /// }
    /// ```
    var isAtBottom: Bool {
        let threshold: CGFloat = 80   // trigger 80pt before exact bottom
        return contentOffset.y + frame.height >= contentSize.height - threshold
    }

    /// `true` if the scroll view is scrolled to (or before) the top.
    var isAtTop: Bool {
        contentOffset.y <= -contentInset.top
    }

    /// The fraction scrolled from top (0.0) to bottom (1.0).
    var scrollProgress: CGFloat {
        let scrollable = contentSize.height - frame.height
        guard scrollable > 0 else { return 0 }
        return (contentOffset.y / scrollable).clamped(to: 0...1)
    }
}

// MARK: - Scroll To

extension UIScrollView {

    /// Scrolls to the top of the content.
    func scrollToTop(animated: Bool = true) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    /// Scrolls to the bottom of the content.
    func scrollToBottom(animated: Bool = true) {
        let bottomOffset = CGPoint(
            x: 0,
            y: max(contentSize.height - frame.height + contentInset.bottom, -contentInset.top)
        )
        setContentOffset(bottomOffset, animated: animated)
    }

    /// Scrolls to make the given rect visible.
    func scrollToVisible(_ rect: CGRect, animated: Bool = true) {
        scrollRectToVisible(rect, animated: animated)
    }
}

// MARK: - Keyboard Avoidance (UIScrollView)

extension UIScrollView {

    /// Adjusts the bottom content inset when the keyboard appears/disappears.
    /// Call `stopObservingKeyboard()` in `deinit` or `viewDidDisappear`.
    ///
    /// Usage in `BaseFormViewController`:
    /// ```swift
    /// scrollView.observeKeyboard()
    /// ```
    func observeKeyboard() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(_keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(_keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    func stopObservingKeyboard() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func _keyboardWillShow(_ notification: Notification) {
        guard
            let info     = notification.userInfo,
            let keyFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }

        let keyboardHeight = keyFrame.height
        UIView.animate(withDuration: duration) {
            self.contentInset.bottom        = keyboardHeight
            self.verticalScrollIndicatorInsets.bottom = keyboardHeight
        }
    }

    @objc private func _keyboardWillHide(_ notification: Notification) {
        guard
            let info     = notification.userInfo,
            let duration = info[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        else { return }

        UIView.animate(withDuration: duration) {
            self.contentInset.bottom        = 0
            self.verticalScrollIndicatorInsets.bottom = 0
        }
    }
}

// MARK: - Private helpers

private extension CGFloat {
    func clamped(to range: ClosedRange<CGFloat>) -> CGFloat {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
