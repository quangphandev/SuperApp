//
//  Int+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 31/05/26.
//

import Foundation

// MARK: - Vietnamese Currency

extension Int {

    /// Formats the integer as Vietnamese Dong.
    /// e.g. `150000` → `"150.000 ₫"`
    var toVND: String {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .decimal
        formatter.groupingSeparator     = "."
        formatter.decimalSeparator      = ","
        formatter.locale                = Locale(identifier: "vi_VN")
        let number                      = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "\(number) ₫"
    }

    /// Formats the integer as Vietnamese Dong with full word suffix.
    /// e.g. `1_500_000` → `"1,5 triệu ₫"`  |  `2_000_000_000` → `"2 tỷ ₫"`
    var toVNDShort: String {
        switch self {
        case 1_000_000_000...:
            let value = Double(self) / 1_000_000_000
            return "\(value.clean) tỷ ₫"
        case 1_000_000...:
            let value = Double(self) / 1_000_000
            return "\(value.clean) triệu ₫"
        case 1_000...:
            let value = Double(self) / 1_000
            return "\(value.clean) nghìn ₫"
        default:
            return "\(self) ₫"
        }
    }
}

// MARK: - Abbreviated (Social / Metric)

extension Int {

    /// Returns an abbreviated string for large counts.
    /// e.g. `1200` → `"1.2K"` | `3_500_000` → `"3.5M"`
    var abbreviated: String {
        switch self {
        case 1_000_000_000...:
            return "\((Double(self) / 1_000_000_000).rounded(places: 1).clean)B"
        case 1_000_000...:
            return "\((Double(self) / 1_000_000).rounded(places: 1).clean)M"
        case 1_000...:
            return "\((Double(self) / 1_000).rounded(places: 1).clean)K"
        default:
            return "\(self)"
        }
    }
}

// MARK: - Ordinal

extension Int {

    /// Returns the ordinal string.
    /// e.g. `1` → `"1st"` | `3` → `"3rd"` | `21` → `"21st"`
    var ordinal: String {
        let formatter        = NumberFormatter()
        formatter.numberStyle = .ordinal
        formatter.locale     = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}

// MARK: - Time Conversion

extension Int {

    /// Formats seconds into `mm:ss` string. e.g. `90` → `"01:30"`
    var toMMSS: String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    /// Formats seconds into `hh:mm:ss` when >= 1 hour. e.g. `3661` → `"01:01:01"`
    var toHHMMSS: String {
        let hours   = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = self % 60
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
