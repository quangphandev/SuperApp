//
//  AppTextField.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

/// Luma-styled text field component.
///
/// Features:
/// - Border + focus ring animation (accent color when active)
/// - Error state with animated message label below
/// - Optional leading icon
/// - Password toggle support
/// - Reactive `textDriver` and `isValid` output
///
/// Usage:
/// ```swift
/// let emailField = AppTextField(placeholder: "Email")
/// emailField.setLeadingIcon(UIImage(systemName: "envelope"))
///
/// let passwordField = AppTextField(placeholder: "Mật khẩu", isSecure: true)
/// passwordField.enablePasswordToggle()
///
/// // Bind error from ViewModel:
/// viewModel.emailError
///     .drive(emailField.rx.errorMessage)
///     .disposed(by: disposeBag)
/// ```
final class AppTextField: UIView {

    // MARK: - Public

    /// The raw text value. Setting this updates the internal UITextField.
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    /// Show or hide an error message below the field.
    var errorMessage: String? {
        get { _errorMessage }
        set { setError(newValue) }
    }

    // MARK: - UI

    private(set) lazy var textField: UITextField = {
        let tf = UITextField()
        tf.font = AppFont.body
        tf.textColor = AppColor.textPrimary
        tf.autocorrectionType = .no
        tf.spellCheckingType = .no
        tf.delegate = self
        return tf
    }()

    private lazy var containerView: UIView = {
        let v = UIView()
        v.backgroundColor = AppColor.surface
        v.layer.cornerRadius = AppRadius.medium
        v.layer.borderWidth = 1
        v.layer.borderColor = borderColor.cgColor
        v.clipsToBounds = true
        return v
    }()

    private lazy var iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = AppColor.textSecondary
        return iv
    }()

    private lazy var errorLabel: UILabel = {
        let l = UILabel()
        l.font = AppFont.caption
        l.textColor = AppColor.error
        l.numberOfLines = 0
        l.alpha = 0
        return l
    }()

    // MARK: - Private State

    private var _errorMessage: String?
    private var hasIcon = false

    private var borderColor: UIColor {
        if _errorMessage != nil { return AppColor.error }
        return UIColor.separator
    }

    // MARK: - Init

    init(placeholder: String = "", isSecure: Bool = false) {
        super.init(frame: .zero)
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecure
        if isSecure { textField.addPasswordToggle() }
        setupViews()
        setupConstraints()
        textField.setPlaceholderColor(AppColor.textSecondary)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Configuration

    /// Adds a leading icon inside the field.
    func setLeadingIcon(_ image: UIImage?, tintColor: UIColor = AppColor.textSecondary) {
        iconImageView.image     = image?.withRenderingMode(.alwaysTemplate)
        iconImageView.tintColor = tintColor
        hasIcon = image != nil
        iconImageView.isHidden = !hasIcon
        updateTextFieldPadding()
    }

    /// Forwards to the internal UITextField for keyboard / return key type.
    func configure(
        keyboardType: UIKeyboardType = .default,
        returnKeyType: UIReturnKeyType = .default,
        autocapitalization: UITextAutocapitalizationType = .none
    ) {
        textField.keyboardType = keyboardType
        textField.returnKeyType = returnKeyType
        textField.autocapitalizationType = autocapitalization
    }

    // MARK: - Error State

    private func setError(_ message: String?) {
        _errorMessage = message
        errorLabel.text = message

        let hasError = message != nil
        UIView.animate(withDuration: 0.2) {
            self.errorLabel.alpha = hasError ? 1 : 0
            self.containerView.layer.borderColor = self.borderColor.cgColor
        }
    }

    // MARK: - Setup

    private func setupViews() {
        addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(textField)
        addSubview(errorLabel)

        iconImageView.isHidden = true
    }

    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.large)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.large)
            make.trailing.equalToSuperview().inset(AppSpacing.large)
            make.top.bottom.equalToSuperview()
        }
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(AppSpacing.xSmall)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xSmall)
            make.bottom.equalToSuperview()
        }
    }

    private func updateTextFieldPadding() {
        textField.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(hasIcon ? 44 : AppSpacing.large)
        }
    }

    // MARK: - Focus Animation

    private func animateFocus(_ isFocused: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.containerView.layer.borderColor = (isFocused
                ? AppColor.accent
                : self.borderColor).cgColor
            self.containerView.layer.borderWidth = isFocused ? 1.5 : 1
        }
    }
}

// MARK: - UITextFieldDelegate

extension AppTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateFocus(true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateFocus(false)
    }
}

// MARK: - Reactive Extension

extension Reactive where Base: AppTextField {

    /// Emits the current text on every keystroke.
    var text: Driver<String?> {
        base.textField.rx.text.asDriver(onErrorJustReturn: nil)
    }

    /// Emits non-empty, trimmed text.
    var textNotEmpty: Driver<String> {
        base.textField.rx.textNotEmpty
    }

    /// Sets the error message from a Driver.
    var errorMessage: Binder<String?> {
        Binder(base) { field, message in
            field.errorMessage = message
        }
    }
}
