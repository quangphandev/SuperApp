//
//  String+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 27/5/26.
//

import Foundation
import UIKit

// MARK: - Trimming

extension String {

    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isBlank: Bool { trimmed.isEmpty }

    var isNotEmpty: Bool { !isEmpty }
}

// MARK: - Validation

extension String {

    var isValidEmail: Bool {
        let regex = "[A-Z0-9a-z._%+\\-]+@[A-Za-z0-9.\\-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: self)
    }

    /// Vietnamese phone: 0xxxxxxxxx or +84xxxxxxxxx (9–10 digits)
    var isValidPhone: Bool {
        let cleaned = replacingOccurrences(of: " ", with: "")
        let regex   = "^(\\+84|0)[0-9]{9,10}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: cleaned)
    }

    var isValidPassword: Bool { count >= 8 }

    var isValidURL: Bool {
        guard let url = URL(string: self) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
}

// MARK: - Localization

extension String {

    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    func localized(with args: CVarArg...) -> String {
        String(format: localized, arguments: args)
    }
}

// MARK: - Formatting

extension String {

    /// Masks sensitive strings: `"HelloWorld"` → `"He••••••ld"`
    func masked(visibleCount: Int = 2) -> String {
        guard count > visibleCount * 2 else { return String(repeating: "•", count: count) }
        let prefix = String(prefix(visibleCount))
        let suffix = String(suffix(visibleCount))
        let dots   = String(repeating: "•", count: max(0, count - visibleCount * 2))
        return prefix + dots + suffix
    }

    /// Converts snake_case or kebab-case to Title Case.
    var titleCased: String {
        replacingOccurrences(of: "_", with: " ")
            .replacingOccurrences(of: "-", with: " ")
            .capitalized
    }
}

// MARK: - Numeric Parsing

extension String {

    var toInt: Int?    { Int(self) }
    var toDouble: Double? { Double(self) }
}
