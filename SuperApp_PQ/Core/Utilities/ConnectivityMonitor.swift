//
//  ConnectivityMonitor.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import Network
import RxCocoa
import RxSwift

/// Real-time network connectivity monitor using NWPathMonitor.
///
/// Exposes an `isConnected: Driver<Bool>` stream that emits whenever
/// the network state changes. Designed as a singleton for app-wide use.
///
/// Usage (in AppCoordinator or BaseVM):
/// ```swift
/// ConnectivityMonitor.shared.isConnected
///     .drive(onNext: { isConnected in
///         if isConnected { viewModel.retryPendingRequests() }
///     })
///     .disposed(by: disposeBag)
/// ```
final class ConnectivityMonitor {

    // MARK: - Singleton

    static let shared = ConnectivityMonitor()

    // MARK: - Public

    /// Emits `true` when the device is connected to any network.
    /// Always replays the latest value to new subscribers.
    var isConnected: Driver<Bool> {
        _isConnectedRelay.asDriver()
    }

    /// The current connection status (synchronous read).
    var currentStatus: Bool { _isConnectedRelay.value }

    // MARK: - Private

    private let _isConnectedRelay = BehaviorRelay<Bool>(value: true)
    private let monitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "com.superapp.connectivity", qos: .background)

    // MARK: - Init

    private init() {
        startMonitoring()
    }

    deinit {
        stopMonitoring()
    }

    // MARK: - Monitoring

    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            DispatchQueue.main.async {
                self?._isConnectedRelay.accept(isConnected)
                Logger.debug(
                    "Network: \(isConnected ? "connected" : "disconnected")",
                    category: .network
                )
            }
        }
        monitor.start(queue: monitorQueue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}

// MARK: - BaseVM Integration

extension ConnectivityMonitor {

    /// Returns an Observable that fires only when connectivity is restored
    /// (transitions from false → true).
    var onReconnect: Observable<Void> {
        isConnected
            .asObservable()
            .distinctUntilChanged()
            .skip(1)
            .filter { $0 }
            .map { _ in () }
    }
}
