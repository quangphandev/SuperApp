//
//  UITextField+Rx.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import RxCocoa
import RxSwift
import UIKit

// MARK: - Reactive TextField Extensions

extension Reactive where Base: UITextField {

    /// A `Driver` that emits the trimmed, non-empty text on every keystroke.
    /// Returns `nil` if the text is nil, empty, or whitespace-only.
    ///
    /// Usage (in ViewModel binding):
    /// ```swift
    /// let email = input.emailTextField.rx.textNotEmpty
    /// ```
    var textNotEmpty: Driver<String> {
        base.rx.text
            .orEmpty
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .asDriver(onErrorDriveWith: .empty())
    }

    /// A `Driver` that emits the whitespace-trimmed text on every keystroke.
    /// Emits empty string `""` when the field is cleared.
    ///
    /// Usage: bind to ViewModel for form validation that allows empty input.
    var textTrimmed: Driver<String> {
        base.rx.text
            .orEmpty
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .asDriver(onErrorJustReturn: "")
    }

    /// A `Signal` that fires when the user taps the Return / Done key.
    ///
    /// Usage:
    /// ```swift
    /// input.passwordField.rx.returnTap
    ///     .emit(onNext: { [weak self] in self?.didTapLogin() })
    ///     .disposed(by: disposeBag)
    /// ```
    var returnTap: Signal<Void> {
        base.rx.controlEvent(.editingDidEndOnExit)
            .asSignal()
    }

    /// A `Driver<Bool>` that emits `true` when the field has non-empty text.
    /// Useful for driving the enabled state of submit buttons.
    ///
    /// Usage: `loginButton.rx.isEnabled ← emailField.rx.hasContent`
    var hasContent: Driver<Bool> {
        base.rx.text
            .orEmpty
            .map { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
    }

    /// A `Driver<String?>` bound to `text`, emitting on every change.
    var textDriver: Driver<String?> {
        base.rx.text.asDriver(onErrorJustReturn: nil)
    }

    /// Fires when the text field begins editing (focus gained).
    var didBeginEditing: Signal<Void> {
        base.rx.controlEvent(.editingDidBegin).asSignal()
    }

    /// Fires when the text field ends editing (focus lost).
    var didEndEditing: Signal<Void> {
        base.rx.controlEvent(.editingDidEnd).asSignal()
    }
}
