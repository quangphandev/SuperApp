//
//  FitRunningLiveActivityAttributes.swift
//  SuperApp_PQ
//
//  Created by Codex on 08/06/26.
//

import Foundation

#if canImport(ActivityKit)
import ActivityKit

struct FitRunningLiveActivityAttributes: ActivityAttributes {

    struct ContentState: Codable, Hashable {
        let status: String
        let distance: String
        let elapsedTime: String
        let pace: String
        let calories: String
        let isPaused: Bool
        let updatedAt: Date
    }

    let runId: String
    let title: String
}
#endif
