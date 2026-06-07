//
//  ActivityIndicator.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 27/5/26.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - ActivityIndicator

/// Tracks in-flight Observable operations and exposes a `Driver<Bool>` loading state.
/// Thread-safe — multiple concurrent requests increment/decrement a counter.
///
/// Usage in ViewModel:
/// ```swift
/// private let loading = ActivityIndicator()
///
/// func transform(input: Input) -> Output {
///     let users = input.fetchTrigger
///         .flatMapLatest { [weak self] _ -> Driver<[User]> in
///             guard let self else { return .empty() }
///             return self.apiClient.request(UserEndpoint.list)
///                 .trackActivity(self.loading)    // ← inject here
///                 .asDriverOnErrorJustComplete()
///         }
///
///     return Output(
///         users: users,
///         isLoading: loading.asDriver()           // ← bind to UI
///     )
/// }
/// ```
final class ActivityIndicator: SharedSequenceConvertibleType {

    typealias Element          = Bool
    typealias SharingStrategy  = DriverSharingStrategy

    // MARK: - Private

    private let lock    = NSRecursiveLock()
    private let relay   = BehaviorRelay<Bool>(value: false)
    private let loading: Driver<Bool>

    // MARK: - Lifecycle

    init() {
        loading = relay.asDriver().distinctUntilChanged()
    }

    // MARK: - SharedSequenceConvertibleType

    func asSharedSequence() -> SharedSequence<SharingStrategy, Bool> { loading }
    func asDriver()         -> Driver<Bool>                           { loading }

    // MARK: - Internal

    fileprivate func track<Source: ObservableConvertibleType>(_ source: Source) -> Observable<Source.Element> {
        Observable.using(
            { [weak self] () -> ActivityToken<Source.Element> in
                self?.increment()
                return ActivityToken(source: source.asObservable(), dispose: { [weak self] in self?.decrement() })
            },
            observableFactory: { $0.asObservable() }
        )
    }

    private func increment() {
        lock.lock(); relay.accept(true);  lock.unlock()
    }

    private func decrement() {
        lock.lock(); relay.accept(false); lock.unlock()
    }
}

// MARK: - ActivityToken (private)

private final class ActivityToken<E>: ObservableConvertibleType, Disposable {
    private let source:  Observable<E>
    private let cleanup: () -> Void

    init(source: Observable<E>, dispose: @escaping () -> Void) {
        self.source  = source
        self.cleanup = dispose
    }

    func dispose()              { cleanup() }
    func asObservable()         -> Observable<E> { source }
}

// MARK: - Observable Extension

extension ObservableConvertibleType {
    func trackActivity(_ indicator: ActivityIndicator) -> Observable<Element> {
        indicator.track(self)
    }
}
