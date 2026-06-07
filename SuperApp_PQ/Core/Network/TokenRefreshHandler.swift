//
//  TokenRefreshHandler.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import Foundation
import Alamofire
import RxSwift

// MARK: - TokenStorageProtocol

/// Abstraction for reading/writing auth tokens.
/// Implement this with Keychain or UserDefaults in your SessionManager.
protocol TokenStorageProtocol: AnyObject {
    var accessToken: String?  { get set }
    var refreshToken: String? { get set }
}

// MARK: - TokenRefreshHandlerProtocol

protocol TokenRefreshHandlerProtocol: AnyObject {
    /// Refreshes the access token.
    /// Multiple concurrent callers share the same in-flight request.
    func refreshToken() -> Observable<Void>
}

// MARK: - TokenRefreshResponse (private DTO)

private struct TokenRefreshResponse: Sendable {
    let accessToken:  String
    let refreshToken: String
}

extension TokenRefreshResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case accessToken  = "access_token"
        case refreshToken = "refresh_token"
    }

    nonisolated init(from decoder: any Decoder) throws {
        let container    = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken  = try container.decode(String.self, forKey: .accessToken)
        self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
    }
}

// MARK: - TokenRefreshHandler

final class TokenRefreshHandler: TokenRefreshHandlerProtocol {

    // MARK: - Properties

    private let tokenStorage: TokenStorageProtocol
    private let refreshURLProvider: () -> URL
    private let refreshTokenParameterNameProvider: () -> String
    private let lock          = NSLock()
    private var inflightShare: Observable<Void>?

    // MARK: - Lifecycle

    init(
        tokenStorage: TokenStorageProtocol,
        refreshURLProvider: @escaping () -> URL = { NetworkConfig.authRefreshURL },
        refreshTokenParameterNameProvider: @escaping () -> String = { NetworkConfig.refreshTokenParameterName }
    ) {
        self.tokenStorage = tokenStorage
        self.refreshURLProvider = refreshURLProvider
        self.refreshTokenParameterNameProvider = refreshTokenParameterNameProvider
    }

    // MARK: - TokenRefreshHandlerProtocol

    func refreshToken() -> Observable<Void> {
        lock.lock()
        defer { lock.unlock() }

        // Return existing in-flight observable to prevent duplicate refresh calls
        if let existing = inflightShare { return existing }

        let shared = buildRefreshRequest()
            .do(onDispose: { [weak self] in
                self?.lock.lock()
                self?.inflightShare = nil
                self?.lock.unlock()
            })
            .share(replay: 1, scope: .whileConnected)

        inflightShare = shared
        return shared
    }

    // MARK: - Private

    private func buildRefreshRequest() -> Observable<Void> {
        guard let token = tokenStorage.refreshToken else {
            return .error(NetworkError.unauthorized)
        }

        return Observable.create { [weak self] observer in
            guard let self else {
                observer.onCompleted()
                return Disposables.create()
            }

            let task = AF.request(
                refreshURLProvider(),
                method: .post,
                parameters: [refreshTokenParameterNameProvider(): token],
                encoding: JSONEncoding.default
            )
            .validate()
            .responseDecodable(of: TokenRefreshResponse.self) { [weak self] response in
                switch response.result {
                case .success(let dto):
                    self?.tokenStorage.accessToken  = dto.accessToken
                    self?.tokenStorage.refreshToken = dto.refreshToken
                    observer.onNext(())
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(
                        NetworkError.map(from: error, statusCode: response.response?.statusCode)
                    )
                }
            }

            return Disposables.create { task.cancel() }
        }
    }
}
