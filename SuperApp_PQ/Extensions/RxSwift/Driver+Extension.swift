//
//  Driver+Extension.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 31/05/26.
//

import RxSwift
import RxCocoa

// MARK: - Void Driver

extension SharedSequence where SharingStrategy == DriverSharingStrategy, Element == Void {
    /// Creates a Driver that emits a single Void element immediately.
    static func just() -> Driver<Void> { .just(()) }
}

// MARK: - Optional unwrap

extension SharedSequence where SharingStrategy == DriverSharingStrategy {
    /// Filters out `nil` values and unwraps optionals.
    func unwrap<T>() -> Driver<T> where Element == T? {
        compactMap { $0 }
    }
}

// MARK: - mapToVoid

extension SharedSequence where SharingStrategy == DriverSharingStrategy {
    /// Discards emitted values and maps the stream to `Void`.
    func mapToVoid() -> Driver<Void> { map { _ in } }
}

// MARK: - mapToTrue / mapToFalse

extension SharedSequence where SharingStrategy == DriverSharingStrategy {
    func mapToTrue()  -> Driver<Bool> { map { _ in true  } }
    func mapToFalse() -> Driver<Bool> { map { _ in false } }
}

// MARK: - withPrevious

extension SharedSequence where SharingStrategy == DriverSharingStrategy {
    /// Emits `(previous, current)` pairs. `previous` is `nil` on first emission.
    func withPrevious() -> Driver<(Element?, Element)> {
        scan((nil as Element?, nil as Element?)) { ($0.1, $1) }
            .compactMap { prev, current in
                guard let current else { return nil }
                return (prev, current)
            }
    }
}

// MARK: - startWith (if not already available in your RxCocoa version)

extension SharedSequence where SharingStrategy == DriverSharingStrategy {
    /// Prepends a value at the start of the driver sequence.
    func startWithValue(_ value: Element) -> Driver<Element> {
        Driver<Element>.concat([.just(value), self])
    }
}

// MARK: - Loading / Error convenience

extension ObservableType {
    /// Converts to `Driver<Bool>` emitting `true` while the source is active, `false` when done.
    /// Useful when you want a quick loading Driver without a full ActivityIndicator.
    func toLoadingDriver() -> Driver<Bool> {
        self
            .map { _ in false }
            .startWith(true)
            .asDriverOnErrorJustComplete()
    }
}

// MARK: - Throttled tap (RxCocoa, no RxGesture needed)

extension Reactive where Base: UIControl {
    /// Emits a throttled tap with a 300ms debounce to prevent double-tap bugs.
    var throttledTap: ControlEvent<Void> {
        let source = base.rx.controlEvent(.touchUpInside)
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: UIButton {
    /// Emits a single-fire tap using `throttle` — safe against rapid presses.
    var safeTap: ControlEvent<Void> { throttledTap }
}
