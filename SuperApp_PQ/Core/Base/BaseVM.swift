//
//  BaseVM.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import Foundation
import RxSwift
import RxCocoa

class BaseVM {

    // MARK: - Properties

    let disposeBag = DisposeBag()

    /// Emit loading state. Use `Driver` in VC for UI binding.
    let isLoadingRelay = BehaviorRelay<Bool>(value: false)

    /// Emit errors to be displayed in UI.
    let errorRelay = PublishRelay<BaseError>()

    // MARK: - Lifecycle

    init() {}

    deinit {
        #if DEBUG
        Logger.debug("\(String(describing: type(of: self))) deallocated", category: .app)
        #endif
    }

    // MARK: - Helpers

    /// Toggle loading state safely.
    func setLoading(_ isLoading: Bool) {
        isLoadingRelay.accept(isLoading)
    }

    /// Map any Error to BaseError and push to errorRelay.
    /// Priority: NetworkError (rich message) → BaseError → generic fallback.
    func handleError(_ error: Error) {
        if let networkError = error as? NetworkError {
            // Preserve rich NetworkError messages (e.g. "Phiên đăng nhập hết hạn")
            errorRelay.accept(.message(networkError.message))
        } else if let baseError = error as? BaseError {
            errorRelay.accept(baseError)
        } else {
            errorRelay.accept(.network(error))
        }
    }
}
