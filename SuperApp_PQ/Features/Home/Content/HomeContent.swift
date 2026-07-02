//
//  HomeContent.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import Foundation

struct HomeContent: Hashable {
    let title: String
    let brandName: String
    let statusTitle: String
    let welcomeText: String
    let subtitleText: String
    let balanceTitle: String
    let balanceValue: String
    let balanceSubtitle: String
    let dashboardEyebrow: String
    let dashboardTitle: String
    let dashboardMessage: String
    let progressEyebrow: String
    let progressTitle: String
    let progressSubtitle: String
    let progressValue: Double
    let progressText: String
    let exploreButtonTitle: String
    let featuresTitle: String
    let features: [HomeFeatureItem]
    let stats: [HomeDashboardStat]
    let focusItems: [HomeDashboardFocusItem]
    let navigationItems: [HomeDashboardNavItem]
}

protocol HomeContentProviding {
    func makeContent() -> HomeContent
}

protocol HomeStateContentProviding {
    func makeStateContent(for kind: HomeScreenStateKind) -> HomeStateContent
}

struct LocalizedHomeContentProvider: HomeContentProviding {

    func makeContent() -> HomeContent {
        HomeContent(
            title: L10n.Home.title,
            brandName: L10n.Home.Brand.name,
            statusTitle: L10n.Home.Status.ready,
            welcomeText: L10n.Home.welcome,
            subtitleText: L10n.Home.subtitle,
            balanceTitle: L10n.Home.Balance.title,
            balanceValue: L10n.Home.Balance.value,
            balanceSubtitle: L10n.Home.Balance.subtitle,
            dashboardEyebrow: L10n.Home.Dashboard.eyebrow,
            dashboardTitle: L10n.Home.Dashboard.title,
            dashboardMessage: L10n.Home.Dashboard.message,
            progressEyebrow: L10n.Home.Dashboard.Progress.eyebrow,
            progressTitle: L10n.Home.Dashboard.Progress.title,
            progressSubtitle: L10n.Home.Dashboard.Progress.subtitle,
            progressValue: 0.68,
            progressText: L10n.Home.Dashboard.Progress.value,
            exploreButtonTitle: L10n.Home.Explore.button,
            featuresTitle: L10n.Home.Features.title,
            features: [
                HomeFeatureItem(
                    title: L10n.Home.Feature.Programmatic.title,
                    subtitle: L10n.Home.Feature.Programmatic.subtitle
                ),
                HomeFeatureItem(
                    title: L10n.Home.Feature.Architecture.title,
                    subtitle: L10n.Home.Feature.Architecture.subtitle
                ),
                HomeFeatureItem(
                    title: L10n.Home.Feature.Core.title,
                    subtitle: L10n.Home.Feature.Core.subtitle
                )
            ],
            stats: [
                HomeDashboardStat(
                    title: L10n.Home.Dashboard.Stat.English.title,
                    value: L10n.Home.Dashboard.Stat.English.value,
                    subtitle: L10n.Home.Dashboard.Stat.English.subtitle,
                    accent: .english
                ),
                HomeDashboardStat(
                    title: L10n.Home.Dashboard.Stat.Fit.title,
                    value: L10n.Home.Dashboard.Stat.Fit.value,
                    subtitle: L10n.Home.Dashboard.Stat.Fit.subtitle,
                    accent: .fit
                ),
                HomeDashboardStat(
                    title: L10n.Home.Dashboard.Stat.Todo.title,
                    value: L10n.Home.Dashboard.Stat.Todo.value,
                    subtitle: L10n.Home.Dashboard.Stat.Todo.subtitle,
                    accent: .todo
                )
            ],
            focusItems: [
                HomeDashboardFocusItem(
                    title: L10n.Home.Dashboard.Focus.Next.title,
                    subtitle: L10n.Home.Dashboard.Focus.Next.subtitle,
                    actionTitle: L10n.Home.Dashboard.Focus.Next.action,
                    accent: .fit
                ),
                HomeDashboardFocusItem(
                    title: L10n.Home.Dashboard.Focus.Todo.title,
                    subtitle: L10n.Home.Dashboard.Focus.Todo.subtitle,
                    actionTitle: L10n.Home.Dashboard.Focus.Todo.action,
                    accent: .todo
                ),
                HomeDashboardFocusItem(
                    title: L10n.Home.Dashboard.Focus.Workout.title,
                    subtitle: L10n.Home.Dashboard.Focus.Workout.subtitle,
                    actionTitle: L10n.Home.Dashboard.Focus.Workout.action,
                    accent: .english
                )
            ],
            navigationItems: [
                HomeDashboardNavItem(
                    kind: .home,
                    title: L10n.Home.Nav.home,
                    icon: .homeFill,
                    accent: .home,
                    isSelected: true
                ),
                HomeDashboardNavItem(
                    kind: .english,
                    title: L10n.Home.Nav.english,
                    icon: .book,
                    accent: .muted,
                    isSelected: false
                ),
                HomeDashboardNavItem(
                    kind: .fit,
                    title: L10n.Home.Nav.fit,
                    icon: .figureRun,
                    accent: .muted,
                    isSelected: false
                ),
                HomeDashboardNavItem(
                    kind: .todo,
                    title: L10n.Home.Nav.todo,
                    icon: .checklist,
                    accent: .muted,
                    isSelected: false
                ),
                HomeDashboardNavItem(
                    kind: .more,
                    title: L10n.Home.Nav.more,
                    icon: .ellipsis,
                    accent: .muted,
                    isSelected: false
                )
            ]
        )
    }
}

struct LocalizedHomeStateContentProvider: HomeStateContentProviding {

    func makeStateContent(for kind: HomeScreenStateKind) -> HomeStateContent {
        switch kind {
        case .ready:
            return makeReadyContent()
        case .loading:
            return makeLoadingContent()
        case .empty:
            return makeEmptyContent()
        case .error:
            return makeErrorContent()
        case .offline:
            return makeOfflineContent()
        case .syncConflict:
            return makeSyncConflictContent()
        }
    }

    private func makeReadyContent() -> HomeStateContent {
        HomeStateContent(
            kind: .ready,
            eyebrow: L10n.Home.State.Ready.eyebrow,
            title: L10n.Home.State.Ready.title,
            message: L10n.Home.State.Ready.message,
            icon: .checkmarkSeal,
            accent: .home,
            cardTitle: L10n.Home.State.Ready.cardTitle,
            cardMessage: L10n.Home.State.Ready.cardMessage,
            rows: [],
            primaryAction: nil,
            secondaryAction: nil
        )
    }

    private func makeLoadingContent() -> HomeStateContent {
        HomeStateContent(
            kind: .loading,
            eyebrow: L10n.Home.State.Loading.eyebrow,
            title: L10n.Home.State.Loading.title,
            message: L10n.Home.State.Loading.message,
            icon: .activity,
            accent: .home,
            cardTitle: L10n.Home.State.Loading.cardTitle,
            cardMessage: L10n.Home.State.Loading.cardMessage,
            rows: [
                HomeStateRow(
                    title: L10n.Home.State.Loading.Row.dashboard,
                    subtitle: L10n.Home.State.Loading.Row.dashboardSubtitle,
                    actionTitle: nil,
                    accent: .muted
                ),
                HomeStateRow(
                    title: L10n.Home.State.Loading.Row.modules,
                    subtitle: L10n.Home.State.Loading.Row.modulesSubtitle,
                    actionTitle: nil,
                    accent: .muted
                )
            ],
            primaryAction: nil,
            secondaryAction: nil
        )
    }

    private func makeEmptyContent() -> HomeStateContent {
        HomeStateContent(
            kind: .empty,
            eyebrow: L10n.Home.State.Empty.eyebrow,
            title: L10n.Home.State.Empty.title,
            message: L10n.Home.State.Empty.message,
            icon: .sparkles,
            accent: .todo,
            cardTitle: L10n.Home.State.Empty.cardTitle,
            cardMessage: L10n.Home.State.Empty.cardMessage,
            rows: [
                HomeStateRow(
                    title: L10n.Home.State.Empty.Row.english,
                    subtitle: L10n.Home.State.Empty.Row.englishSubtitle,
                    actionTitle: L10n.Home.State.Action.add,
                    accent: .english
                ),
                HomeStateRow(
                    title: L10n.Home.State.Empty.Row.fit,
                    subtitle: L10n.Home.State.Empty.Row.fitSubtitle,
                    actionTitle: L10n.Home.State.Action.add,
                    accent: .fit
                ),
                HomeStateRow(
                    title: L10n.Home.State.Empty.Row.todo,
                    subtitle: L10n.Home.State.Empty.Row.todoSubtitle,
                    actionTitle: L10n.Home.State.Action.add,
                    accent: .todo
                )
            ],
            primaryAction: HomeStateAction(
                kind: .selectStarterApp,
                title: L10n.Home.State.Action.chooseStarter,
                style: .primary
            ),
            secondaryAction: nil
        )
    }

    private func makeErrorContent() -> HomeStateContent {
        HomeStateContent(
            kind: .error,
            eyebrow: L10n.Home.State.Error.eyebrow,
            title: L10n.Home.State.Error.title,
            message: L10n.Home.State.Error.message,
            icon: .warningTriangle,
            accent: .error,
            cardTitle: L10n.Home.State.Error.cardTitle,
            cardMessage: L10n.Home.State.Error.cardMessage,
            rows: [
                HomeStateRow(
                    title: L10n.Home.State.Error.Row.code,
                    subtitle: L10n.Home.State.Error.Row.codeSubtitle,
                    actionTitle: L10n.Home.State.Action.copy,
                    accent: .error
                ),
                HomeStateRow(
                    title: L10n.Home.State.Error.Row.cached,
                    subtitle: L10n.Home.State.Error.Row.cachedSubtitle,
                    actionTitle: L10n.Home.State.Action.open,
                    accent: .muted
                )
            ],
            primaryAction: HomeStateAction(
                kind: .retry,
                title: L10n.Home.State.Action.retry,
                style: .destructive
            ),
            secondaryAction: HomeStateAction(
                kind: .openCachedHome,
                title: L10n.Home.State.Action.useOffline,
                style: .ghost
            )
        )
    }

    private func makeOfflineContent() -> HomeStateContent {
        HomeStateContent(
            kind: .offline,
            eyebrow: L10n.Home.State.Offline.eyebrow,
            title: L10n.Home.State.Offline.title,
            message: L10n.Home.State.Offline.message,
            icon: .wifiSlash,
            accent: .warning,
            cardTitle: L10n.Home.State.Offline.cardTitle,
            cardMessage: L10n.Home.State.Offline.cardMessage,
            rows: [
                HomeStateRow(
                    title: L10n.Home.State.Offline.Row.english,
                    subtitle: L10n.Home.State.Offline.Row.englishSubtitle,
                    actionTitle: L10n.Home.State.Action.open,
                    accent: .english
                ),
                HomeStateRow(
                    title: L10n.Home.State.Offline.Row.fit,
                    subtitle: L10n.Home.State.Offline.Row.fitSubtitle,
                    actionTitle: L10n.Home.State.Action.open,
                    accent: .fit
                ),
                HomeStateRow(
                    title: L10n.Home.State.Offline.Row.todo,
                    subtitle: L10n.Home.State.Offline.Row.todoSubtitle,
                    actionTitle: L10n.Home.State.Action.view,
                    accent: .todo
                )
            ],
            primaryAction: HomeStateAction(
                kind: .retry,
                title: L10n.Home.State.Action.retryConnection,
                style: .primary
            ),
            secondaryAction: HomeStateAction(
                kind: .continueOffline,
                title: L10n.Home.State.Action.continueOffline,
                style: .ghost
            )
        )
    }

    private func makeSyncConflictContent() -> HomeStateContent {
        HomeStateContent(
            kind: .syncConflict,
            eyebrow: L10n.Home.State.Conflict.eyebrow,
            title: L10n.Home.State.Conflict.title,
            message: L10n.Home.State.Conflict.message,
            icon: .activity,
            accent: .conflict,
            cardTitle: L10n.Home.State.Conflict.cardTitle,
            cardMessage: L10n.Home.State.Conflict.cardMessage,
            rows: [
                HomeStateRow(
                    title: L10n.Home.State.Conflict.Row.local,
                    subtitle: L10n.Home.State.Conflict.Row.localSubtitle,
                    actionTitle: nil,
                    accent: .muted
                ),
                HomeStateRow(
                    title: L10n.Home.State.Conflict.Row.cloud,
                    subtitle: L10n.Home.State.Conflict.Row.cloudSubtitle,
                    actionTitle: nil,
                    accent: .conflict
                )
            ],
            primaryAction: HomeStateAction(
                kind: .useLatestVersion,
                title: L10n.Home.State.Action.useLatest,
                style: .primary
            ),
            secondaryAction: HomeStateAction(
                kind: .compareChanges,
                title: L10n.Home.State.Action.compareChanges,
                style: .ghost
            )
        )
    }
}
