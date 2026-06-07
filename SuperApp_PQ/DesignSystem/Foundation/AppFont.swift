//
//  AppFont.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import UIKit

enum AppFont {

    // MARK: - Presets

    static let largeTitle = font(size: 28, weight: .bold)
    static let title = font(size: 22, weight: .bold)
    static let headline = font(size: 17, weight: .semibold)
    static let subheadline = font(size: 15, weight: .semibold)
    static let body = font(size: 15, weight: .regular)
    static let bodyMedium = font(size: 15, weight: .medium)
    static let caption = font(size: 13, weight: .regular)
    static let captionMedium = font(size: 13, weight: .medium)
    static let metric = UIFont.monospacedDigitSystemFont(ofSize: 32, weight: .bold)

    // MARK: - Helpers

    /// Returns Inter font if bundled, otherwise falls back to system font.
    static func font(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let interName = interFontName(for: weight)
        if let inter = UIFont(name: interName, size: size) {
            return inter
        }
        return UIFont.systemFont(ofSize: size, weight: weight)
    }

    private static func interFontName(for weight: UIFont.Weight) -> String {
        switch weight {
        case .regular:  return "Inter-Regular"
        case .medium:   return "Inter-Medium"
        case .semibold: return "Inter-SemiBold"
        case .bold:     return "Inter-Bold"
        case .heavy:    return "Inter-ExtraBold"
        case .black:    return "Inter-Black"
        case .light:    return "Inter-Light"
        case .thin:     return "Inter-Thin"
        case .ultraLight: return "Inter-ExtraLight"
        default:        return "Inter-Regular"
        }
    }
}
