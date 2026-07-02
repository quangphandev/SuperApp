//
//  GoogleMapsConfig.swift
//  SuperApp_PQ
//
//  Created by Codex on 08/06/26.
//

import Foundation

enum GoogleMapsConfig {

    static var apiKey: String? {
        guard let value = Bundle.main.infoDictionary?["GOOGLE_MAPS_API_KEY"] as? String else {
            return nil
        }

        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !trimmed.hasPrefix("$(") else {
            return nil
        }
        return trimmed
    }

    static var isConfigured: Bool {
        apiKey != nil
    }
}
