//
//  EnglishColor.swift
//  SuperApp_PQ
//
//  Created by Codex on 12/06/26.
//

import UIKit

enum EnglishColor {
    static let background = asset("color.bg.base", fallback: "#080812")
    static let navigation = asset("color.bg.nav", fallback: "#0B0B13")
    static let surface = asset("color.english.surface", fallback: "#15131D")
    static let elevatedSurface = asset("color.english.surface.elevated", fallback: "#1B1825")
    static let accentSurface = asset("color.english.surface.accent", fallback: "#2D244B")
    static let border = asset("color.border.default", fallback: "#2A2A3A")
    static let accentBorder = asset("color.english.border.accent", fallback: "#9E7CFD")
    static let textPrimary = asset("color.text.primary", fallback: "#F6F2FF")
    static let textSecondary = asset("color.text.secondary", fallback: "#C9C7D8")
    static let textMuted = asset("color.text.muted", fallback: "#8E8CA0")
    static let textInverse = asset("color.text.inverse", fallback: "#101018")
    static let accent = asset("color.english.accent", fallback: "#B195FF")
    static let accentStrong = asset("color.english.accent.strong", fallback: "#8B7CFF")
    static let danger = asset("color.danger.default", fallback: "#FF6F98")
    static let warning = asset("color.warning.default", fallback: "#FFC544")
    static let success = asset("color.success.default", fallback: "#39E6A3")

    private static func asset(_ name: String, fallback: String) -> UIColor {
        UIColor(named: name) ?? UIColor(hex: fallback)
    }
}
