//
//  CalculatorColor.swift
//  SuperApp_PQ
//
//  Created by Codex on 12/06/26.
//

import UIKit

enum CalculatorColor {
    static let background = asset("color.bg.base", fallback: "#080812")
    static let navigation = asset("color.bg.nav", fallback: "#0B0B13")
    static let surface = asset("color.surface.base", fallback: "#11111C")
    static let elevatedSurface = asset("color.surface.raised", fallback: "#15131D")
    static let border = asset("color.border.default", fallback: "#2A2A3A")
    static let textPrimary = asset("color.text.primary", fallback: "#F6F2FF")
    static let textSecondary = asset("color.text.secondary", fallback: "#C9C7D8")
    static let textMuted = asset("color.text.muted", fallback: "#8E8CA0")
    static let textInverse = asset("color.text.inverse", fallback: "#101018")
    
    // Calculator Specific (Amber Accent Theme)
    static let accent = asset("color.warning.default", fallback: "#FFC544")
    static let accentStrong = asset("color.calculator.accent.strong", fallback: "#FFA000")
    static let accentSurface = asset("color.calculator.surface.accent", fallback: "#251E13")
    static let accentBorder = asset("color.calculator.border.accent", fallback: "#E09F00")
    
    static let error = asset("color.danger.default", fallback: "#FF6F98")

    private static func asset(_ name: String, fallback: String) -> UIColor {
        UIColor(named: name) ?? UIColor(hex: fallback)
    }
}
