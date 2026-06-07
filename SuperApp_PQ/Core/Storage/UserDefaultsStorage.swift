//
//  UserDefaultsStorage.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import Foundation

protocol UserDefaultsStorageProtocol: AnyObject {
    func string(for key: String) -> String?
    func bool(for key: String) -> Bool
    func set(_ value: Any?, for key: String)
    func removeValue(for key: String)
}

final class UserDefaultsStorage: UserDefaultsStorageProtocol {

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func string(for key: String) -> String? {
        userDefaults.string(forKey: key)
    }

    func bool(for key: String) -> Bool {
        userDefaults.bool(forKey: key)
    }

    func set(_ value: Any?, for key: String) {
        userDefaults.set(value, forKey: key)
    }

    func removeValue(for key: String) {
        userDefaults.removeObject(forKey: key)
    }
}

