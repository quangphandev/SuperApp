//
//  ViewState.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import Foundation

enum ViewState<T> {
    case idle
    case loading
    case success(T)
    case empty
    case failure(Error)
}

// MARK: - Helpers

extension ViewState {

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var isIdle: Bool {
        if case .idle = self { return true }
        return false
    }

    var isEmpty: Bool {
        if case .empty = self { return true }
        return false
    }

    var value: T? {
        if case .success(let value) = self { return value }
        return nil
    }

    var error: Error? {
        if case .failure(let error) = self { return error }
        return nil
    }

    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
}
