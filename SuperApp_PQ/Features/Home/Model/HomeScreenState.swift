//
//  HomeScreenState.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import Foundation

enum HomeScreenState: Equatable {
    case ready(HomeContent)
    case loading(HomeStateContent)
    case empty(HomeStateContent)
    case error(HomeStateContent)
    case offline(HomeStateContent)
    case syncConflict(HomeStateContent)
}

enum HomeScreenStateKind: Equatable {
    case ready
    case loading
    case empty
    case error
    case offline
    case syncConflict
}

struct HomeStateContent: Equatable {
    let kind: HomeScreenStateKind
    let eyebrow: String
    let title: String
    let message: String
    let icon: AppIcon
    let accent: HomeStateAccent
    let cardTitle: String
    let cardMessage: String
    let rows: [HomeStateRow]
    let primaryAction: HomeStateAction?
    let secondaryAction: HomeStateAction?
}

struct HomeStateRow: Equatable {
    let title: String
    let subtitle: String
    let actionTitle: String?
    let accent: HomeStateAccent
}

struct HomeStateAction: Equatable {
    let kind: HomeStateActionKind
    let title: String
    let style: HomeStateActionStyle
}

enum HomeStateActionKind: Equatable {
    case retry
    case selectStarterApp
    case openCachedHome
    case continueOffline
    case useLatestVersion
    case compareChanges
}

enum HomeStateActionStyle: Equatable {
    case primary
    case secondary
    case destructive
    case ghost
}

enum HomeStateAccent: Equatable {
    case home
    case english
    case fit
    case todo
    case warning
    case error
    case conflict
    case muted
}
