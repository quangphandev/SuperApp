//
//  ToastView.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import SnapKit
import UIKit

/// Global toast notification system.
///
/// Shows a brief, non-blocking message from the top of the screen.
/// Auto-dismisses after a configurable duration.
///
/// Usage (from anywhere):
/// ```swift
/// Toast.show("Lưu thành công!", type: .success)
/// Toast.show("Không có kết nối mạng", type: .error, duration: 4)
/// Toast.show("Đang xử lý...", type: .warning)
/// ```
enum Toast {

    enum ToastType {
        case success
        case warning
        case error
        case info

        var icon: UIImage? {
            switch self {
            case .success: return UIImage(systemName: "checkmark.circle.fill")
            case .warning: return UIImage(systemName: "exclamationmark.triangle.fill")
            case .error:   return UIImage(systemName: "xmark.circle.fill")
            case .info:    return UIImage(systemName: "info.circle.fill")
            }
        }

        var color: UIColor {
            switch self {
            case .success: return AppColor.success
            case .warning: return AppColor.warning
            case .error:   return AppColor.error
            case .info:    return AppColor.accent
            }
        }
    }

    /// Shows a toast message from the top of the key window.
    ///
    /// - Parameters:
    ///   - message:  The text to display.
    ///   - type:     Visual style — success, warning, error, or info.
    ///   - duration: Seconds before auto-dismiss. Default: 2.5s.
    static func show(
        _ message: String,
        type: ToastType = .info,
        duration: TimeInterval = 2.5
    ) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
                  let window = windowScene.windows.first(where: { $0.isKeyWindow })
            else { return }

            // Dismiss any existing toast first
            window.subviews
                .compactMap { $0 as? ToastView }
                .forEach { $0.dismissToast(animated: false) }

            let toast = ToastView(message: message, type: type)
            window.addSubview(toast)

            let topInset = window.safeAreaInsets.top + 8
            toast.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(AppSpacing.large)
                make.top.equalToSuperview().offset(topInset)
            }

            toast.presentToast(autoDismiss: duration)
        }
    }
}

// MARK: - ToastView (internal)

final class ToastView: UIView {

    // MARK: - UI

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let messageLabel: UILabel = {
        let l = UILabel()
        l.font = AppFont.subheadline
        l.textColor = AppColor.textInverse
        l.numberOfLines = 3
        return l
    }()

    // MARK: - Init

    init(message: String, type: Toast.ToastType) {
        super.init(frame: .zero)
        iconView.image     = type.icon?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = AppColor.textInverse
        messageLabel.text  = message
        backgroundColor    = type.color
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setupViews() {
        layer.cornerRadius    = AppRadius.medium
        layer.shadowColor     = UIColor.black.cgColor
        layer.shadowOpacity   = 0.15
        layer.shadowRadius    = 8
        layer.shadowOffset    = CGSize(width: 0, height: 4)

        let stack             = UIStackView(arrangedSubviews: [iconView, messageLabel])
        stack.axis            = .horizontal
        stack.spacing         = AppSpacing.small
        stack.alignment       = .center

        addSubview(stack)

        iconView.snp.makeConstraints { make in make.size.equalTo(20) }
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(
                top: AppSpacing.medium,
                left: AppSpacing.large,
                bottom: AppSpacing.medium,
                right: AppSpacing.large
            ))
        }

        // Tap to dismiss early
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(_tapped)))
    }

    // MARK: - Animation

    func presentToast(autoDismiss duration: TimeInterval) {
        alpha = 0
        transform = CGAffineTransform(translationX: 0, y: -20)

        UIView.animate(
            withDuration: 0.35,
            delay: 0,
            usingSpringWithDamping: 0.72,
            initialSpringVelocity: 0.5
        ) {
            self.alpha = 1
            self.transform = .identity
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                self?.dismissToast(animated: true)
            }
        }
    }

    func dismissToast(animated: Bool) {
        guard superview != nil else { return }

        let dismissBlock = {
            self.alpha = 0
            self.transform = CGAffineTransform(translationX: 0, y: -12)
        }
        let removeBlock = { self.removeFromSuperview() }

        if animated {
            UIView.animate(withDuration: 0.2, animations: dismissBlock) { _ in removeBlock() }
        } else {
            dismissBlock()
            removeBlock()
        }
    }

    @objc private func _tapped() {
        dismissToast(animated: true)
    }
}
