//
//  APIEndpoint.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import Foundation
import Alamofire

// MARK: - NetworkConfig

/// Global configuration for the network layer.
/// Set `baseURL` before app launch (e.g. in SceneDelegate or AppCoordinator).
struct NetworkConfig {
    static var baseURL: URL = URL(string: "https://api.example.com")!
    static var timeoutInterval: TimeInterval = 30
    static var authRefreshPath = "/auth/refresh"
    static var refreshTokenParameterName = "refresh_token"
    static var defaultHeaders: HTTPHeaders = [
        "Content-Type": "application/json",
        "Accept":       "application/json"
    ]

    static var authRefreshURL: URL {
        makeURL(path: authRefreshPath)
    }

    static func makeURL(baseURL: URL = NetworkConfig.baseURL, path: String) -> URL {
        baseURL.appendingPathComponent(path.normalizedAPIPath)
    }
}

// MARK: - APIEndpoint

protocol APIEndpoint {
    /// Base URL, defaults to `NetworkConfig.baseURL`.
    var baseURL: URL { get }

    /// Path appended to baseURL, e.g. `"/users/me"`.
    var path: String { get }

    /// HTTP method: `.get`, `.post`, `.put`, `.delete`, etc.
    var method: HTTPMethod { get }

    /// Extra headers merged on top of `NetworkConfig.defaultHeaders`.
    var headers: HTTPHeaders? { get }

    /// Query params (GET) or body params (POST/PUT).
    var parameters: Parameters? { get }

    /// Encoding strategy. Defaults to `URLEncoding` for GET, `JSONEncoding` otherwise.
    var encoding: ParameterEncoding { get }

    /// Whether the request requires an Authorization header. Defaults to `true`.
    var requiresAuth: Bool { get }
}

// MARK: - Default Implementation

extension APIEndpoint {
    var baseURL: URL          { NetworkConfig.baseURL }
    var headers: HTTPHeaders? { nil }
    var parameters: Parameters? { nil }
    var requiresAuth: Bool    { true }

    var encoding: ParameterEncoding {
        method == .get ? URLEncoding.default : JSONEncoding.default
    }

    /// Full request URL = baseURL + path.
    var url: URL {
        NetworkConfig.makeURL(baseURL: baseURL, path: path)
    }
}

private extension String {
    var normalizedAPIPath: String {
        trimmingCharacters(in: CharacterSet(charactersIn: "/"))
    }
}
