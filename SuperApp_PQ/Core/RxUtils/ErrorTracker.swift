//
//  ErrorTracker.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 27/5/26.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - ErrorTracker

/// Captures errors from Observable streams and exposes them as `Driver<Error>`.
/// Errors do NOT terminate the tracker — it stays alive for new subscriptions.
///
/// Usage in ViewModel:
/// ```swift
/// private let errorTracker = ErrorTracker()
///
/// func transform(input: Input) -> Output {
///     let users = input.fetchTrigger
///         .flatMapLatest { [weak self] _ -> Driver<[User]> in
///             guard let self else { return .empty() }
///             return self.apiClient.request(UserEndpoint.list)
///                 .trackError(self.errorTracker)  // ← inject here
///                 .asDriverOnErrorJustComplete()
///         }
///
///     return Output(
///         users: users,
///         error: errorTracker.asDriver()          // ← bind to UI
///     )
/// }
/// ```
final class ErrorTracker: SharedSequenceConvertibleType {

    typealias SharingStrategy = DriverSharingStrategy
    typealias Element         = Error

    // MARK: - Private

    private let subject = PublishSubject<Error>()

    // MARK: - Lifecycle

    deinit { subject.onCompleted() }

    // MARK: - SharedSequenceConvertibleType

    func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        subject.asObservable().asDriverOnErrorJustComplete()
    }

    func asDriver() -> Driver<Error> {
        asSharedSequence()
    }

    /// Convenience: map Error to a human-readable message string.
    func asMessageDriver() -> Driver<String> {
        asDriver().map { error in
            if let net = error as? NetworkError  { return net.message }
            if let base = error as? BaseError    { return base.message }
            return error.localizedDescription
        }
    }

    // MARK: - Internal

    fileprivate func onError(_ error: Error) {
        subject.onNext(error)
    }
}

// MARK: - Observable Extension

extension ObservableConvertibleType {
    func trackError(_ tracker: ErrorTracker) -> Observable<Element> {
        self.asObservable().do(onError: tracker.onError)
    }
}
