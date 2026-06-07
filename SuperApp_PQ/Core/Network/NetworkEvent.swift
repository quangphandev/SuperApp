//
//  NetworkEvent.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import Foundation

// MARK: - NetworkEvent

/// Represents intermediate progress and final result of an upload/download task.
enum NetworkEvent<T> {
    /// Transfer progress from 0.0 to 1.0
    case progress(Double)
    /// Final decoded response
    case completed(T)
}

// MARK: - Helpers

extension NetworkEvent {
    var isCompleted: Bool {
        if case .completed = self { return true }
        return false
    }

    var progress: Double? {
        if case .progress(let value) = self { return value }
        return nil
    }

    var value: T? {
        if case .completed(let value) = self { return value }
        return nil
    }
}
