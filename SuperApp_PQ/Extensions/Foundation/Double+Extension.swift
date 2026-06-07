//
//  Double+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import Foundation

// MARK: - Rounding

extension Double {

    /// Returns the value rounded to `places` decimal places.
    ///
    /// Usage: `3.14159.rounded(places: 2)` → `3.14`
    func rounded(places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
}

// MARK: - String Formatting

extension Double {

    /// Removes trailing `.0` — e.g. `1.0` → `"1"`, `1.5` → `"1.5"`.
    var clean: String {
        truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", self)
            : String(format: "%.1f", self)
    }

    /// Returns the value as a percentage string.
    /// e.g. `0.75` → `"75%"` | `1.0` → `"100%"` | `0.333` → `"33%"`
    var percentString: String {
        "\(Int((self * 100).rounded()))%"
    }

    /// Returns the value as a percentage string with one decimal place.
    /// e.g. `0.756` → `"75.6%"`
    var percentStringDecimal: String {
        String(format: "%.1f%%", self * 100)
    }
}

// MARK: - Vietnamese Currency

extension Double {

    /// Formats as Vietnamese Dong.
    /// e.g. `150000.0` → `"150.000 ₫"`
    var toVND: String {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .decimal
        formatter.groupingSeparator     = "."
        formatter.decimalSeparator      = ","
        formatter.maximumFractionDigits = 0
        formatter.locale                = Locale(identifier: "vi_VN")
        return "\(formatter.string(from: NSNumber(value: self)) ?? "\(Int(self))") ₫"
    }

    /// Short format: `1500000.0` → `"1,5 triệu ₫"`
    var toVNDShort: String {
        switch self {
        case 1_000_000_000...:
            return "\((self / 1_000_000_000).rounded(places: 1).clean) tỷ ₫"
        case 1_000_000...:
            return "\((self / 1_000_000).rounded(places: 1).clean) triệu ₫"
        case 1_000...:
            return "\((self / 1_000).rounded(places: 1).clean) nghìn ₫"
        default:
            return "\(Int(self)) ₫"
        }
    }
}

// MARK: - Range Clamping

extension Double {

    /// Clamps the value between `min` and `max` (inclusive).
    ///
    /// Usage: `alpha.clamped(to: 0...1)`
    func clamped(to range: ClosedRange<Double>) -> Double {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}

// MARK: - Abbreviation

extension Double {

    /// Returns an abbreviated display string.
    /// e.g. `1200.0` → `"1.2K"` | `3_500_000.0` → `"3.5M"`
    var abbreviated: String {
        switch self {
        case 1_000_000_000...:
            return "\((self / 1_000_000_000).rounded(places: 1).clean)B"
        case 1_000_000...:
            return "\((self / 1_000_000).rounded(places: 1).clean)M"
        case 1_000...:
            return "\((self / 1_000).rounded(places: 1).clean)K"
        default:
            return clean
        }
    }
}

// MARK: - Convenience

extension Double {

    /// `true` if the value is positive (> 0).
    var isPositive: Bool { self > 0 }

    /// `true` if the value is negative (< 0).
    var isNegative: Bool { self < 0 }

    /// Converts to `CGFloat`.
    var cgFloat: CGFloat { CGFloat(self) }

    /// Converts to `Int` by truncating decimal part.
    var toInt: Int { Int(self) }
}
