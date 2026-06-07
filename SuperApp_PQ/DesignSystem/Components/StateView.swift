//
//  StateView.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import SnapKit
import UIKit

/// Full-screen state placeholder view.
///
/// Use for empty, error, and no-internet states in list screens.
///
/// Preset factories:
/// ```swift
/// let view = StateView.empty(
///     title: "Chưa có gì ở đây",
///     subtitle: "Hãy thêm mục đầu tiên của bạn"
/// )
///
/// let view = StateView.error {
///     viewModel.retry()
/// }
///
/// let view = StateView.noInternet {
///     viewModel.retry()
/// }
/// ```
final class StateView: UIView {

    // MARK: - UI

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = AppColor.textSecondary
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.headline
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textColor = AppColor.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var ctaButton: UIButton = {
        let b = UIButton(type: .system)
        b.titleLabel?.font = AppFont.headline
        b.setTitleColor(AppColor.accent, for: .normal)
        b.isHidden = true
        b.addTarget(self, action: #selector(_ctaTapped), for: .touchUpInside)
        return b
    }()

    private var ctaAction: (() -> Void)?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration

    /// Configure with title and optional message (backward compatible).
    func configure(title: String, message: String = "") {
        titleLabel.text   = title
        messageLabel.text = message.isEmpty ? nil : message
        messageLabel.isHidden = message.isEmpty
    }

    /// Set an icon image above the title.
    func setIcon(_ image: UIImage?, tintColor: UIColor = AppColor.textSecondary) {
        iconImageView.image     = image?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = tintColor
        iconImageView.isHidden  = image == nil
    }

    /// Set a CTA button below the message.
    func setCTA(title: String, action: @escaping () -> Void) {
        ctaButton.setTitle(title, for: .normal)
        ctaButton.isHidden = false
        ctaAction = action
    }

    // MARK: - Preset Factories

    /// Empty state: icon + title + subtitle.
    static func empty(
        title: String = "Không có dữ liệu",
        subtitle: String = ""
    ) -> StateView {
        let v = StateView()
        v.setIcon(UIImage(systemName: "tray"))
        v.configure(title: title, message: subtitle)
        return v
    }

    /// Error state: warning icon + retry button.
    static func error(onRetry: @escaping () -> Void) -> StateView {
        let v = StateView()
        v.setIcon(UIImage(systemName: "exclamationmark.triangle"), tintColor: AppColor.warning)
        v.configure(title: "Đã xảy ra lỗi", message: "Vui lòng thử lại.")
        v.setCTA(title: "Thử lại", action: onRetry)
        return v
    }

    /// No internet state: wifi-slash icon + retry button.
    static func noInternet(onRetry: @escaping () -> Void) -> StateView {
        let v = StateView()
        v.setIcon(UIImage(systemName: "wifi.slash"), tintColor: AppColor.textSecondary)
        v.configure(title: "Không có kết nối mạng", message: "Kiểm tra kết nối và thử lại.")
        v.setCTA(title: "Thử lại", action: onRetry)
        return v
    }

    // MARK: - Setup

    private func setupViews() {
        iconImageView.isHidden  = true
        messageLabel.isHidden   = false

        let stack = UIStackView(arrangedSubviews: [
            iconImageView,
            titleLabel,
            messageLabel,
            ctaButton
        ])
        stack.axis      = .vertical
        stack.spacing   = AppSpacing.medium
        stack.alignment = .center

        iconImageView.snp.makeConstraints { make in make.size.equalTo(52) }
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(AppSpacing.xLarge)
        }
    }

    private func setupConstraints() {}

    // MARK: - Actions

    @objc private func _ctaTapped() {
        ctaAction?()
    }
}
