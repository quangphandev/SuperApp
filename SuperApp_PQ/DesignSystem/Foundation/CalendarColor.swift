//
//  CalendarColor.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 12/06/26.
//

import UIKit

enum CalendarColor {
    static let background = asset("color.bg.base", fallback: "#080812")
    static let navigation = asset("color.bg.nav", fallback: "#0B0B13")
    static let surface = asset("color.surface.base", fallback: "#11111C")
    static let elevatedSurface = asset("color.surface.raised", fallback: "#15131D")
    static let accentSurface = asset("color.surface.accent", fallback: "#1D1A33")
    static let border = asset("color.border.default", fallback: "#2A2A3A")
    static let textPrimary = asset("color.text.primary", fallback: "#F6F2FF")
    static let textSecondary = asset("color.text.secondary", fallback: "#C9C7D8")
    static let textMuted = asset("color.text.muted", fallback: "#8E8CA0")
    static let textInverse = asset("color.text.inverse", fallback: "#101018")
    static let accent = asset("color.info.default", fallback: "#7DB3FF") // Blue/Cyan
    static let accentStrong = asset("color.accent.strong", fallback: "#8A7CFF")
    static let danger = asset("color.danger.default", fallback: "#FF6F98")
    static let warning = asset("color.warning.default", fallback: "#FFC544")
    static let success = asset("color.success.default", fallback: "#36E3A1")

    private static func asset(_ name: String, fallback: String) -> UIColor {
        UIColor(named: name) ?? UIColor(hex: fallback)
    }
}
