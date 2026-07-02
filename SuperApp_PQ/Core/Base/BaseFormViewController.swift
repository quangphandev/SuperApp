//
//  BaseFormViewController.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

/// Base ViewController for form / data-entry screens.
///
/// Provides:
/// - Automatic keyboard avoidance via `scrollView.observeKeyboard()`
/// - `hideKeyboardOnTap()` pre-configured
/// - A root `scrollView` + `contentView` layout ready for form fields
/// - A sticky `submitButton` pinned above the keyboard
///
/// Usage:
/// ```swift
/// class LoginViewController: BaseFormViewController<LoginViewModel> {
///     private let emailField = UITextField()
///
///     override func setupFormContent(_ contentView: UIView) {
///         contentView.addSubview(emailField)
///         emailField.snp.makeConstraints { ... }
///     }
///
///     override func setupSubmitButton() -> UIButton? {
///         PrimaryButton(title: "Đăng nhập")
///     }
/// }
/// ```
class BaseFormViewController<ViewModel: BaseViewModel>: BaseViewController<ViewModel> {

    // MARK: - UI

    private(set) lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator   = false
        sv.keyboardDismissMode            = .interactive
        sv.alwaysBounceVertical           = true
        return sv
    }()

    private(set) lazy var contentView  = UIView()
    private(set) var submitButton: UIButton?

    private lazy var submitContainer: UIView = {
        let v = UIView()
        v.backgroundColor = AppColor.background
        return v
    }()

    // MARK: - Setup

    override func setupViews() {
        super.setupViews()
        view.backgroundColor = AppColor.background

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Sticky submit area
        if let button = setupSubmitButton() {
            submitButton = button
            view.addSubview(submitContainer)
            submitContainer.addSubview(button)
        }

        setupFormContent(contentView)
        hideKeyboardOnTap()
        scrollView.observeKeyboard()
    }

    override func setupConstraints() {
        super.setupConstraints()

        if let submitContainer = view.subviews.first(where: { $0 === self.submitContainer }) {
            submitContainer.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalTo(view.safeAreaLayoutGuide)
            }
            submitButton?.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(UIEdgeInsets(
                    top: AppSpacing.medium,
                    left: AppSpacing.large,
                    bottom: AppSpacing.medium,
                    right: AppSpacing.large
                ))
                make.height.equalTo(52)
            }

            scrollView.snp.makeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.bottom.equalTo(submitContainer.snp.top)
            }
        } else {
            scrollView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.stopObservingKeyboard()
    }

    // MARK: - Override Points

    /// Add form fields to `contentView` here.
    /// Call `super` is not required.
    func setupFormContent(_ contentView: UIView) {}

    /// Return a submit button to show pinned above the keyboard.
    /// Return `nil` to omit the sticky button area.
    /// Default: returns `nil`.
    func setupSubmitButton() -> UIButton? { nil }

    // MARK: - Validation Helpers

    /// Binds a `Driver<Bool>` to the submit button's enabled state.
    /// Use in `setupBindings()` after calling `super`.
    ///
    /// Usage:
    /// ```swift
    /// bindSubmitEnabled(viewModel.output.isFormValid)
    /// ```
    func bindSubmitEnabled(_ isEnabled: Driver<Bool>) {
        guard let submitButton else { return }
        isEnabled
            .drive(submitButton.rx.isEnabled)
            .disposed(by: disposeBag)

        isEnabled
            .map { $0 ? 1.0 : 0.5 }
            .drive(submitButton.rx.alpha)
            .disposed(by: disposeBag)
    }

    /// Scrolls the scroll view so a specific view is visible.
    /// Call when a field has a validation error to bring it into view.
    func scrollToVisible(_ view: UIView, animated: Bool = true) {
        let rect = view.convert(view.bounds, to: scrollView)
        scrollView.scrollRectToVisible(rect.insetBy(dx: 0, dy: -AppSpacing.large), animated: animated)
    }
}
