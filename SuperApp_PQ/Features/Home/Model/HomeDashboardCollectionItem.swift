//
//  HomeDashboardCollectionItem.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import Foundation

enum HomeDashboardSection: Int, CaseIterable, Sendable {
    case header
    case hero
    case stats
    case focus

    var identifier: String {
        switch self {
        case .header:
            return "header"
        case .hero:
            return "hero"
        case .stats:
            return "stats"
        case .focus:
            return "focus"
        }
    }
}
