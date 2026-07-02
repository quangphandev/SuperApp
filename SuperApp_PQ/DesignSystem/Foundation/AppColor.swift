//
//  AppColor.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import UIKit

enum AppColor {
    static let background = asset("color.bg.base", fallback: "#080812")
    static let groupedBackground = asset("color.bg.nav", fallback: "#0B0B13")
    static let surface = asset("color.surface.base", fallback: "#11111C")
    static let elevatedSurface = asset("color.surface.raised", fallback: "#15131D")
    static let accentSurface = asset("color.surface.accent", fallback: "#1D1A33")
    static let disabledSurface = asset("color.surface.disabled", fallback: "#18182A")
    static let textPrimary = asset("color.text.primary", fallback: "#F6F2FF")
    static let textSecondary = asset("color.text.secondary", fallback: "#C9C7D8")
    static let textTertiary = asset("color.text.subtle", fallback: "#6F6C7D")
    static let textInverse = asset("color.text.inverse", fallback: "#101018")
    static let border = asset("color.border.default", fallback: "#2A2A3A")
    static let accent = asset("color.accent.primary", fallback: "#B69CFF")
    static let accentSecondary = asset("color.accent.secondary", fallback: "#45E2A1")
    static let brandOrbit = asset("color.brand.orbit", fallback: "#6A5DAB")
    static let brandCore = asset("color.brand.core", fallback: "#A99BFF")
    static let brandSpark = asset("color.brand.spark", fallback: "#FF7A90")
    static let success = asset("color.success.default", fallback: "#36E3A1")
    static let warning = asset("color.warning.default", fallback: "#FFC544")
    static let error = asset("color.danger.default", fallback: "#FF6F98")
    static let info = asset("color.info.default", fallback: "#7DB3FF")

    private static func asset(_ name: String, fallback: String) -> UIColor {
        UIColor(named: name) ?? UIColor(hex: fallback)
    }
}
