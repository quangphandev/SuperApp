//
//  GoalsColor.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 12/06/26.
//

import UIKit

enum GoalsColor {
    static let background = asset("color.bg.base", fallback: "#080812")
    static let navigation = asset("color.bg.nav", fallback: "#0B0B13")
    static let surface = asset("color.goals.surface", fallback: "#11111C")
    static let elevatedSurface = asset("color.goals.surface.elevated", fallback: "#15131D")
    static let accentSurface = asset("color.goals.surface.accent", fallback: "#2C2514") // Dark amber tint
    static let border = asset("color.goals.border", fallback: "#2A2A3A")
    static let accentBorder = asset("color.goals.border.accent", fallback: "#FFC544")
    static let textPrimary = asset("color.text.primary", fallback: "#F6F2FF")
    static let textSecondary = asset("color.text.secondary", fallback: "#C9C7D8")
    static let textMuted = asset("color.text.muted", fallback: "#8E8CA0")
    static let textInverse = asset("color.text.inverse", fallback: "#101018")
    static let accent = asset("color.goals.accent", fallback: "#FFC544") // Amber/Yellow
    static let accentStrong = asset("color.goals.accent.strong", fallback: "#FFB000")
    static let danger = asset("color.goals.danger", fallback: "#FF6F98")
    static let warning = asset("color.goals.warning", fallback: "#FFC544")
    static let success = asset("color.goals.success", fallback: "#36E3A1")

    private static func asset(_ name: String, fallback: String) -> UIColor {
        UIColor(named: name) ?? UIColor(hex: fallback)
    }
}
