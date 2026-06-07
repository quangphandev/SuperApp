//
//  AppLanguage.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 04/06/26.
//

import Foundation

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case vietnamese = "vi"

    static let fallback: AppLanguage = .english

    var locale: Locale {
        Locale(identifier: rawValue)
    }

    var displayName: String {
        switch self {
        case .english:
            return L10n.Language.english
        case .vietnamese:
            return L10n.Language.vietnamese
        }
    }

    var nativeName: String {
        switch self {
        case .english:
            return "English"
        case .vietnamese:
            return "Tiếng Việt"
        }
    }

    static func preferred(from locale: Locale = .current) -> AppLanguage {
        let languageCode = (locale as NSLocale).object(forKey: .languageCode) as? String
        return languageCode.flatMap(AppLanguage.init(rawValue:)) ?? fallback
    }
}
