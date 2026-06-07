//
//  AuthInterceptor.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import Foundation
import Alamofire
import RxSwift

// MARK: - AuthInterceptor

/// Conforms to Alamofire's `RequestInterceptor`.
/// Responsibilities:
///   - `adapt` — injects `Authorization: Bearer <token>` header
///   - `retry`  — triggers token refresh on HTTP 401, retries once
final class AuthInterceptor: RequestInterceptor, @unchecked Sendable {

    // MARK: - Properties

    private let tokenStorage:       TokenStorageProtocol
    private let tokenRefreshHandler: TokenRefreshHandlerProtocol
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(
        tokenStorage: TokenStorageProtocol,
        tokenRefreshHandler: TokenRefreshHandlerProtocol
    ) {
        self.tokenStorage        = tokenStorage
        self.tokenRefreshHandler = tokenRefreshHandler
    }

    // MARK: - RequestAdapter

    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest

        if let token = tokenStorage.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        completion(.success(request))
    }

    // MARK: - RequestRetrier

    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        // Only retry once on 401 Unauthorized
        guard
            let response = request.task?.response as? HTTPURLResponse,
            response.statusCode == 401,
            request.retryCount < 1
        else {
            completion(.doNotRetry)
            return
        }

        tokenRefreshHandler
            .refreshToken()
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext:  { completion(.retry) },
                onError: { _ in completion(.doNotRetryWithError(NetworkError.unauthorized)) }
            )
            .disposed(by: disposeBag)
    }
}
