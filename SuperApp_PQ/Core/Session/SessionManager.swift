//
//  SessionManager.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import Foundation

protocol SessionManaging: AnyObject {
    var isAuthenticated: Bool { get }
    func updateTokens(accessToken: String, refreshToken: String)
    func clearSession()
}

final class SessionManager: SessionManaging {

    private let tokenStorage: TokenStorageProtocol

    var isAuthenticated: Bool {
        tokenStorage.accessToken?.isEmpty == false
    }

    init(tokenStorage: TokenStorageProtocol) {
        self.tokenStorage = tokenStorage
    }

    func updateTokens(accessToken: String, refreshToken: String) {
        tokenStorage.accessToken = accessToken
        tokenStorage.refreshToken = refreshToken
    }

    func clearSession() {
        tokenStorage.accessToken = nil
        tokenStorage.refreshToken = nil
    }
}

