//
//  BaseRepository.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 27/5/26.
//

import Foundation
import RxSwift

// MARK: - BaseRepository

/// Base class for all repository / service layer classes.
/// Provides `apiClient`, `disposeBag`, and common helper operators.
///
/// Usage:
/// ```swift
/// final class UserRepository: BaseRepository {
///
///     func fetchProfile() -> Observable<UserModel> {
///         apiClient
///             .request(UserEndpoint.profile)
///             .mapNetworkError()       // ← converts AFError to NetworkError
///     }
///
///     func deleteAccount() -> Observable<Void> {
///         apiClient.requestVoid(UserEndpoint.deleteAccount)
///     }
/// }
/// ```
class BaseRepository {

    // MARK: - Properties

    let apiClient:  APIClientProtocol
    let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    deinit {
        Logger.debug("\(String(describing: type(of: self))) deallocated", category: .app)
    }
}

// MARK: - Observable Helpers

extension Observable {

    /// Re-tries the observable up to `count` times on network connectivity errors only.
    func retryOnNoInternet(count: Int = 2) -> Observable<Element> {
        retry { errors in
            errors.enumerated().flatMap { index, error -> Observable<Int64> in
                guard
                    let netError = error as? NetworkError,
                    netError.isNoInternet,
                    index < count
                else {
                    return .error(error)
                }
                return Observable<Int64>.timer(.seconds(2), scheduler: MainScheduler.instance)
            }
        }
    }
}
