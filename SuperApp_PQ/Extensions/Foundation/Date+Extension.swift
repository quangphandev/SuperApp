//
//  Date+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 31/05/26.
//

import Foundation

// MARK: - Formatting

extension Date {

    /// Shared formatter — reused to avoid expensive re-creation.
    private static let sharedFormatter = DateFormatter()

    /// Returns a date string using the given format and locale.
    /// - Parameters:
    ///   - format: e.g. `"dd/MM/yyyy"`, `"HH:mm"`, `"dd MMM yyyy"`
    ///   - locale: defaults to `vi_VN`
    func toString(format: String, locale: Locale = Locale(identifier: "vi_VN")) -> String {
        Self.sharedFormatter.locale     = locale
        Self.sharedFormatter.dateFormat = format
        return Self.sharedFormatter.string(from: self)
    }

    /// `dd/MM/yyyy` — e.g. "31/05/2026"
    var ddMMyyyy: String { toString(format: "dd/MM/yyyy") }

    /// `dd MMM yyyy` — e.g. "31 thg 5 2026"
    var ddMMMMyyyy: String { toString(format: "dd MMMM yyyy") }

    /// `HH:mm` — e.g. "18:45"
    var HHmm: String { toString(format: "HH:mm") }

    /// `dd/MM/yyyy HH:mm`
    var ddMMyyyyHHmm: String { toString(format: "dd/MM/yyyy HH:mm") }

    /// ISO 8601 string — e.g. "2026-05-31T18:45:00+07:00"
    var iso8601: String { toString(format: "yyyy-MM-dd'T'HH:mm:ssZ", locale: Locale(identifier: "en_US_POSIX")) }
}

// MARK: - Relative Time

extension Date {

    /// Returns a human-readable relative string.
    /// e.g. "Vừa xong", "3 phút trước", "2 giờ trước", "Hôm qua", "31/05/2026"
    var relativeString: String {
        let now = Date()
        let seconds = now.timeIntervalSince(self)

        switch seconds {
        case ..<0:
            // Future date — fallback to formatted string
            return ddMMyyyy

        case 0..<60:
            return "Vừa xong"

        case 60..<3600:
            let minutes = Int(seconds / 60)
            return "\(minutes) phút trước"

        case 3600..<86400:
            let hours = Int(seconds / 3600)
            return "\(hours) giờ trước"

        case 86400..<172800:
            return "Hôm qua"

        case 172800..<604800:
            let days = Int(seconds / 86400)
            return "\(days) ngày trước"

        case 604800..<2_592_000:
            let weeks = Int(seconds / 604800)
            return "\(weeks) tuần trước"

        case 2_592_000..<31_536_000:
            let months = Int(seconds / 2_592_000)
            return "\(months) tháng trước"

        default:
            return ddMMyyyy
        }
    }
}

// MARK: - Calendar Helpers

extension Date {

    private static let calendar = Calendar.current

    /// `true` if the date falls on today.
    var isToday: Bool { Self.calendar.isDateInToday(self) }

    /// `true` if the date falls on yesterday.
    var isYesterday: Bool { Self.calendar.isDateInYesterday(self) }

    /// `true` if the date falls in the current week.
    var isThisWeek: Bool { Self.calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear) }

    /// `true` if the date falls in the current year.
    var isThisYear: Bool { Self.calendar.isDate(self, equalTo: Date(), toGranularity: .year) }

    /// Start of the day (00:00:00).
    var startOfDay: Date { Self.calendar.startOfDay(for: self) }

    /// Returns `true` if `self` and `other` fall on the same calendar day.
    func isSameDay(as other: Date) -> Bool {
        Self.calendar.isDate(self, inSameDayAs: other)
    }

    /// Adds the given number of days and returns a new `Date`.
    func adding(days: Int) -> Date {
        Self.calendar.date(byAdding: .day, value: days, to: self) ?? self
    }

    /// Adds the given number of months and returns a new `Date`.
    func adding(months: Int) -> Date {
        Self.calendar.date(byAdding: .month, value: months, to: self) ?? self
    }
}

// MARK: - Parsing

extension String {

    /// Parses the string into a `Date` using the given format.
    func toDate(format: String, locale: Locale = Locale(identifier: "vi_VN")) -> Date? {
        let formatter        = DateFormatter()
        formatter.locale     = locale
        formatter.dateFormat = format
        return formatter.date(from: self)
    }

    /// Parses an ISO 8601 string to a `Date`.
    var toDateISO8601: Date? {
        toDate(format: "yyyy-MM-dd'T'HH:mm:ssZ", locale: Locale(identifier: "en_US_POSIX"))
    }
}
