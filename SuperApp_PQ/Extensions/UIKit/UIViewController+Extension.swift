//
//  UIViewController+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 31/05/26.
//

import UIKit

// MARK: - Child ViewController Embedding

extension UIViewController {

    /// Embeds a child view controller into the given container view.
    /// Handles the full addChild / didMove lifecycle correctly.
    ///
    /// Usage:
    /// ```swift
    /// embed(childVC, in: containerView)
    /// ```
    func embed(_ child: UIViewController, in container: UIView) {
        addChild(child)
        container.addSubview(child.view)
        child.view.frame = container.bounds
        child.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        child.didMove(toParent: self)
    }

    /// Removes a previously embedded child view controller.
    func removeEmbedded(_ child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}

// MARK: - Keyboard Dismissal

extension UIViewController {

    /// Adds a tap gesture to the root view that dismisses the keyboard.
    /// Call once in `setupViews()` or `viewDidLoad()`.
    func hideKeyboardOnTap(cancelsTouchesInView: Bool = false) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(_dismissKeyboard))
        tap.cancelsTouchesInView = cancelsTouchesInView
        view.addGestureRecognizer(tap)
    }

    @objc private func _dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - Safe Area

extension UIViewController {

    /// The height of the top safe area inset (status bar + notch).
    var topSafeAreaHeight: CGFloat {
        view.safeAreaInsets.top
    }

    /// The height of the bottom safe area inset (home indicator).
    var bottomSafeAreaHeight: CGFloat {
        view.safeAreaInsets.bottom
    }
}

// MARK: - Alert Shortcuts

extension UIViewController {

    /// Presents a simple one-button alert.
    func presentAlert(
        title: String,
        message: String,
        buttonTitle: String = "OK",
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default) { _ in completion?() })
        present(alert, animated: true)
    }

    /// Presents a confirm / cancel alert.
    func presentConfirm(
        title: String,
        message: String,
        confirmTitle: String = "Xác nhận",
        cancelTitle: String  = "Huỷ",
        onConfirm: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancelTitle,  style: .cancel))
        alert.addAction(UIAlertAction(title: confirmTitle, style: .destructive) { _ in onConfirm() })
        present(alert, animated: true)
    }
}

// MARK: - Navigation Helpers

extension UIViewController {

    /// Pops the current view controller from the navigation stack.
    func popSelf(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    /// Dismisses the current modal presentation.
    func dismissSelf(animated: Bool = true, completion: (() -> Void)? = nil) {
        dismiss(animated: animated, completion: completion)
    }

    /// Sets a custom back button with only the chevron icon (no title).
    func setBackButtonTitleHidden() {
        navigationItem.backButtonDisplayMode = .minimal
    }
}
