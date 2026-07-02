//
//  TimerColor.swift
//  SuperApp_PQ
//
//  Created by Codex on 12/06/26.
//

import UIKit

enum TimerColor {
    static let background = asset("color.bg.base", fallback: "#080812")
    static let navigation = asset("color.bg.nav", fallback: "#0B0B13")
    static let surface = asset("color.timer.surface", fallback: "#15131D")
    static let elevatedSurface = asset("color.timer.surface.elevated", fallback: "#11111C")
    static let accentSurface = asset("color.timer.surface.accent", fallback: "#10252B")
    static let border = asset("color.timer.border", fallback: "#2A2A3A")
    static let accentBorder = asset("color.timer.border.accent", fallback: "#2E8BA1")
    static let textPrimary = asset("color.text.primary", fallback: "#F6F2FF")
    static let textSecondary = asset("color.text.secondary", fallback: "#C9C7D8")
    static let textMuted = asset("color.text.muted", fallback: "#8E8CA0")
    static let textInverse = asset("color.text.inverse", fallback: "#101018")
    static let accent = asset("color.timer.accent", fallback: "#6DE7FF")
    static let accentStrong = asset("color.timer.accent.strong", fallback: "#28C7E8")
    static let danger = asset("color.timer.danger", fallback: "#FF6F98")
    static let warning = asset("color.timer.warning", fallback: "#FFC544")
    static let success = asset("color.timer.success", fallback: "#39E6A3")

    private static func asset(_ name: String, fallback: String) -> UIColor {
        UIColor(named: name) ?? UIColor(hex: fallback)
    }
}
