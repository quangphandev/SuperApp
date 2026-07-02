//
//  HomeDashboardModels.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import Foundation

struct HomeDashboardStat: Hashable {
    let title: String
    let value: String
    let subtitle: String
    let accent: HomeDashboardAccent
}

struct HomeDashboardFocusItem: Hashable {
    let title: String
    let subtitle: String
    let actionTitle: String
    let accent: HomeDashboardAccent
}

struct HomeDashboardNavItem: Hashable {
    let kind: HomeDashboardNavKind
    let title: String
    let icon: AppIcon
    let accent: HomeDashboardAccent
    let isSelected: Bool
}

enum HomeDashboardNavKind: Hashable {
    case home
    case english
    case fit
    case todo
    case more
}

enum HomeDashboardAccent: Hashable {
    case home
    case english
    case fit
    case todo
    case muted
}
