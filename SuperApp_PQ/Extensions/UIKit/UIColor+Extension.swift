//
//  UIColor+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 27/5/26.
//

import UIKit

// MARK: - Hex Initializer

extension UIColor {

    /// Creates a `UIColor` from a hex string (with or without `#`).
    /// - Parameters:
    ///   - hex: e.g. `"#FF3B7F"` or `"FF3B7F"`
    ///   - alpha: Opacity from 0.0 to 1.0 (default 1.0)
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var sanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if sanitized.hasPrefix("#") { sanitized = String(sanitized.dropFirst()) }

        var rgb: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8)  / 255
        let b = CGFloat(rgb & 0x0000FF)          / 255

        self.init(red: r, green: g, blue: b, alpha: alpha)
    }

    /// Returns the color as a `#RRGGBB` hex string.
    var hexString: String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    }
}

// MARK: - Dynamic Dark/Light

extension UIColor {

    /// Returns a color that adapts to light/dark mode.
    static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
        UIColor { $0.userInterfaceStyle == .dark ? dark : light }
    }
}

// MARK: - Alpha Adjustment

extension UIColor {

    func withAlpha(_ alpha: CGFloat) -> UIColor {
        withAlphaComponent(alpha)
    }
}
