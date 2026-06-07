//
//  Optional+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import Foundation

// MARK: - Unwrap with Default

extension Optional {

    /// Returns the wrapped value, or the given default if `nil`.
    /// Equivalent to `?? defaultValue` but reads more naturally in chains.
    ///
    /// Usage: `user.name.or("Ẩn danh")`
    func or(_ defaultValue: Wrapped) -> Wrapped {
        self ?? defaultValue
    }

    /// Returns the wrapped value, or the result of the closure if `nil`.
    func or(_ fallback: () -> Wrapped) -> Wrapped {
        self ?? fallback()
    }
}

// MARK: - Presence Checks

extension Optional {

    /// `true` if this optional is `nil`.
    var isNil: Bool { self == nil }

    /// `true` if this optional holds a value.
    var isNotNil: Bool { self != nil }
}

extension Optional where Wrapped: Collection {

    /// `true` if the optional is `nil` OR the wrapped collection is empty.
    var isNilOrEmpty: Bool {
        switch self {
        case .none:           return true
        case .some(let value): return value.isEmpty
        }
    }

    /// `true` if the optional holds a non-empty collection.
    var hasValue: Bool { !isNilOrEmpty }
}

// MARK: - Conditional Execution

extension Optional {

    /// Executes the closure with the wrapped value if non-nil.
    /// Returns `self` to allow chaining.
    ///
    /// Usage:
    /// ```swift
    /// user.avatarURL.ifLet { url in
    ///     avatarImageView.setImage(url: url)
    /// }
    /// ```
    @discardableResult
    func ifLet(_ action: (Wrapped) -> Void) -> Optional {
        if let value = self { action(value) }
        return self
    }

    /// Executes `ifNone` if the optional is nil.
    @discardableResult
    func ifNil(_ action: () -> Void) -> Optional {
        if self == nil { action() }
        return self
    }
}

// MARK: - Transform with Fallback

extension Optional {

    /// Maps the wrapped value, or returns `defaultValue` if nil.
    ///
    /// Usage: `user.score.map(or: 0) { $0 * 2 }` → `0` if score is nil
    func map<T>(or defaultValue: T, _ transform: (Wrapped) -> T) -> T {
        switch self {
        case .some(let value): return transform(value)
        case .none:            return defaultValue
        }
    }
}

// MARK: - Optional String

extension Optional where Wrapped == String {

    /// Returns the string if non-nil and non-empty, otherwise `nil`.
    var nonEmpty: String? {
        flatMap { $0.isEmpty ? nil : $0 }
    }

    /// Returns the string, or empty string `""` if nil.
    var orEmpty: String { self ?? "" }
}
