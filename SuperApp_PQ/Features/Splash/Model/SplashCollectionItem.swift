//
//  SplashCollectionItem.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import Foundation

enum SplashSection: Int, CaseIterable, Sendable {
    case brand
    case launcherHeader
    case apps
    case summary
    case action
    case footer

    var identifier: String {
        switch self {
        case .brand:
            return "brand"
        case .launcherHeader:
            return "launcherHeader"
        case .apps:
            return "apps"
        case .summary:
            return "summary"
        case .action:
            return "action"
        case .footer:
            return "footer"
        }
    }
}
