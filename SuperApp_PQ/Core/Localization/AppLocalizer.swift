//
//  AppLocalizer.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import Foundation

enum AppLocalizer {

    // MARK: - Properties

    private enum StorageKey {
        static let selectedLanguage = "app.selectedLanguage"
    }

    static var supportedLanguages: [AppLanguage] {
        AppLanguage.allCases
    }

    static var currentLanguage: AppLanguage {
        if let rawValue = UserDefaults.standard.string(forKey: StorageKey.selectedLanguage),
           let language = AppLanguage(rawValue: rawValue) {
            return language
        }
        return AppLanguage.preferred()
    }

    // MARK: - API

    static func setLanguage(_ language: AppLanguage) {
        guard language != currentLanguage else { return }
        UserDefaults.standard.set(language.rawValue, forKey: StorageKey.selectedLanguage)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: .appLanguageDidChange, object: language)
    }

    static func resetLanguage() {
        UserDefaults.standard.removeObject(forKey: StorageKey.selectedLanguage)
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: .appLanguageDidChange, object: currentLanguage)
    }

    static func text(_ key: String, tableName: String? = nil) -> String {
        localizedString(
            forKey: key,
            table: tableName ?? "Localizable",
            fallbackValue: key
        )
    }

    static func localizedString(
        forKey key: String,
        table: String,
        fallbackValue: String
    ) -> String {
        let localized = bundle(for: currentLanguage)
            .localizedString(forKey: key, value: fallbackValue, table: table)

        guard localized != key || fallbackValue == key else {
            return bundle(for: AppLanguage.fallback)
                .localizedString(forKey: key, value: fallbackValue, table: table)
        }

        return localized
    }

    // MARK: - Helpers

    private static func bundle(for language: AppLanguage) -> Bundle {
        guard
            let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            return .main
        }

        return bundle
    }
}

extension Notification.Name {
    static let appLanguageDidChange = Notification.Name("AppLocalizer.appLanguageDidChange")
}
