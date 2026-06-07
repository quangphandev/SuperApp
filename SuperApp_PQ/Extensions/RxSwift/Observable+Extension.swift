//
//  Observable+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 27/5/26.
//

import RxSwift
import RxCocoa

// MARK: - Error handling

extension ObservableType {

    /// Converts to Driver, completing silently on error (safe for UI).
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        asDriver(onErrorDriveWith: .empty())
    }

    /// Converts to Signal, completing silently on error (safe for UI).
    func asSignalOnErrorJustComplete() -> Signal<Element> {
        asSignal(onErrorSignalWith: .empty())
    }
}

// MARK: - Void

extension Observable where Element == Void {
    static func just() -> Observable<Void> { .just(()) }
}

extension ObservableType {
    /// Discards emitted values, maps stream to Void.
    func mapToVoid() -> Observable<Void> { map { _ in } }
}

// MARK: - Optional unwrap

extension ObservableType {
    /// Filters out `nil` values and unwraps optionals.
    func unwrap<T>() -> Observable<T> where Element == T? {
        compactMap { $0 }
    }
}

// MARK: - Combine with previous

extension ObservableType {
    /// Emits `(previous, current)` pairs. Previous is `nil` on the first emission.
    func withPrevious() -> Observable<(Element?, Element)> {
        scan((nil as Element?, nil as Element?)) { ($0.1, $1) }
            .compactMap { prev, current in
                guard let current else { return nil }
                return (prev, current)
            }
    }
}

// MARK: - Debug helpers

extension ObservableType {
    /// Prints every event to the console in DEBUG builds.
    func debugLog(_ tag: String = "") -> Observable<Element> {
        #if DEBUG
        return self.do(
            onNext:      { Logger.debug("\(tag) → onNext: \($0)", category: .app) },
            onError:     { Logger.error("\(tag) → onError: \($0)", category: .app) },
            onCompleted: { Logger.debug("\(tag) → onCompleted", category: .app) }
        )
        #else
        return self.asObservable()
        #endif
    }
}
