//
//  KeychainTokenStorage.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import Foundation
import Security

final class KeychainTokenStorage: TokenStorageProtocol {

    // MARK: - Properties

    private let service: String

    var accessToken: String? {
        get { readValue(for: Key.accessToken) }
        set { saveValue(newValue, for: Key.accessToken) }
    }

    var refreshToken: String? {
        get { readValue(for: Key.refreshToken) }
        set { saveValue(newValue, for: Key.refreshToken) }
    }

    // MARK: - Lifecycle

    init(service: String = Bundle.main.bundleIdentifier ?? "SuperApp_PQ") {
        self.service = service
    }

    // MARK: - Helpers

    func clear() {
        deleteValue(for: Key.accessToken)
        deleteValue(for: Key.refreshToken)
    }

    private func readValue(for key: String) -> String? {
        var query = baseQuery(for: key)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess,
              let data = item as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }

        return value
    }

    private func saveValue(_ value: String?, for key: String) {
        guard let value else {
            deleteValue(for: key)
            return
        }

        let data = Data(value.utf8)
        let query = baseQuery(for: key)
        let attributes = [kSecValueData as String: data]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status == errSecItemNotFound {
            var newItem = query
            newItem[kSecValueData as String] = data
            SecItemAdd(newItem as CFDictionary, nil)
        }
    }

    private func deleteValue(for key: String) {
        SecItemDelete(baseQuery(for: key) as CFDictionary)
    }

    private func baseQuery(for key: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
    }
}

private enum Key {
    static let accessToken = "accessToken"
    static let refreshToken = "refreshToken"
}

