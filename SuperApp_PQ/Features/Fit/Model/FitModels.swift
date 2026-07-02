//
//  FitModels.swift
//  SuperApp_PQ
//
//  Created by Codex on 08/06/26.
//

import UIKit

enum FitScreenKind: Hashable {
    case home
    case workout
    case nutrition
    case profile
    case running(FitRunningState)
}

enum FitNavKind: Hashable {
    case home
    case workout
    case nutrition
    case sleep
    case profile
}

struct FitNavItem: Hashable {
    let kind: FitNavKind
    let title: String
    let icon: AppIcon
    let isSelected: Bool
}

struct FitQuickStat: Hashable {
    let value: String
    let subtitle: String
    let icon: String
    let progress: CGFloat
}

struct FitHabitItem: Hashable {
    let title: String
    let subtitle: String
    let icon: String
    let progress: CGFloat
}

struct FitWorkoutItem: Hashable {
    let title: String
    let subtitle: String
    let trailingText: String?
    let icon: String
    let progress: CGFloat
}

struct FitMealItem: Hashable {
    let title: String
    let subtitle: String
    let kcal: String
}

struct FitGoalItem: Hashable {
    let title: String
    let subtitle: String
    let progress: CGFloat
    let icon: String
}

struct FitProfileStat: Hashable {
    let value: String
    let subtitle: String
    let isPrimary: Bool
}

enum FitRunningState: Hashable {
    case ready
    case active
    case paused
    case confirmStop
    case summary
    case locationPermission
    case gpsWeak
    case backgroundBlocked
    case musicPermission
    case playlistPicker
    case goalSetup
    case history
    case historyDetail
}
