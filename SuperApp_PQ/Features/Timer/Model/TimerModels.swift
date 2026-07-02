//
//  TimerModels.swift
//  SuperApp_PQ
//
//  Created by Codex on 12/06/26.
//

import UIKit

enum TimerScreenState: Hashable {
    case home
    case focusSetup
    case focusRunning
    case focusPaused
    case focusDone
    case presets
    case stopwatch
    case settings
    case tracking
    case targetDetail
    case targetForm
    case alertRules
    case pipSetup
    case pipFloating
    case trackingEmpty
    case trackingLoading
    case trackingError
    case targetMissed
    case deviceTimeDrift
    case notificationPermission
    case exactAlarmPermission
    case pipUnsupported
    case pipSuspended
    case alarmRinging
    case deleteTargetConfirm
    case targetSyncConflict
}

enum TimerNavKind: Hashable {
    case timer
    case focus
    case stopwatch
    case presets
    case settings
}

enum TimerTone: Hashable {
    case accent
    case danger
    case warning
    case success
    case muted
}

enum TimerButtonStyle: Hashable {
    case primary
    case secondary
    case danger
}

enum TimerBlock: Hashable {
    case hero(TimerHeroContent)
    case stats([TimerStatItem])
    case sectionTitle(String)
    case rows([TimerRowItem])
    case durationPicker([TimerDurationItem])
    case timerRing(TimerRingContent)
    case controls([TimerButtonItem])
    case progress(TimerProgressContent)
    case state(TimerStateContent)
    case buttons([TimerButtonItem])
    case segmented(TimerSegmentedContent)
    case pipPreview(TimerPIPPreviewContent)
}

struct TimerScreenContent: Hashable {
    let state: TimerScreenState
    let backTitle: String
    let title: String
    let topPill: String
    let navItems: [TimerNavItem]
    let blocks: [TimerBlock]
}

struct TimerNavItem: Hashable {
    let kind: TimerNavKind
    let title: String
    let icon: String
    let isSelected: Bool
}

struct TimerHeroContent: Hashable {
    let eyebrow: String
    let title: String
    let subtitle: String
    let time: String?
    let actionTitle: String?
    let progress: CGFloat
    let tone: TimerTone
}

struct TimerStatItem: Hashable {
    let title: String
    let value: String
}

struct TimerRowItem: Hashable {
    let title: String
    let subtitle: String
    let actionTitle: String?
    let tone: TimerTone
}

struct TimerDurationItem: Hashable {
    let value: String
    let subtitle: String
    let isSelected: Bool
}

struct TimerRingContent: Hashable {
    let eyebrow: String
    let time: String
    let subtitle: String
    let progress: CGFloat
    let tone: TimerTone
}

struct TimerButtonItem: Hashable {
    let title: String
    let style: TimerButtonStyle
}

struct TimerProgressContent: Hashable {
    let title: String
    let subtitle: String
    let progress: CGFloat
    let tone: TimerTone
}

struct TimerStateContent: Hashable {
    let icon: String
    let title: String
    let message: String
    let tone: TimerTone
}

struct TimerSegmentedContent: Hashable {
    let title: String
    let options: [String]
    let selectedIndex: Int
}

struct TimerPIPPreviewContent: Hashable {
    let title: String
    let subtitle: String
    let time: String
    let badge: String
    let tone: TimerTone
}
