//
//  SplashContent.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import Foundation

struct SplashContent: Hashable, Sendable {
    let brandName: String
    let tagline: String
    let chooseTitle: String
    let selectedTitle: String
    let appCountTitle: String
    let emptySummaryTitle: String
    let emptySummarySubtitle: String
    let selectedSummaryPrefix: String
    let selectedSummarySuffix: String
    let emptyActionTitle: String
    let selectedActionPrefix: String
    let selectedActionSuffix: String
    let footerText: String
    let emptyHint: String
    let selectedHint: String
    let apps: [SplashAppItem]

    func app(for kind: SplashAppKind) -> SplashAppItem? {
        apps.first { $0.kind == kind }
    }
}

protocol SplashContentProviding {
    func makeContent() -> SplashContent
}

struct LocalizedSplashContentProvider: SplashContentProviding {

    func makeContent() -> SplashContent {
        SplashContent(
            brandName: L10n.Splash.Brand.name,
            tagline: L10n.Splash.tagline,
            chooseTitle: L10n.Splash.Launcher.choose,
            selectedTitle: L10n.Splash.Launcher.selected,
            appCountTitle: L10n.Splash.Launcher.count,
            emptySummaryTitle: L10n.Splash.Summary.Empty.title,
            emptySummarySubtitle: L10n.Splash.Summary.Empty.subtitle,
            selectedSummaryPrefix: L10n.Splash.Summary.Selected.prefix,
            selectedSummarySuffix: L10n.Splash.Summary.Selected.suffix,
            emptyActionTitle: L10n.Splash.Action.empty,
            selectedActionPrefix: L10n.Splash.Action.Selected.prefix,
            selectedActionSuffix: L10n.Splash.Action.Selected.suffix,
            footerText: L10n.Splash.footer,
            emptyHint: L10n.Splash.Hint.empty,
            selectedHint: L10n.Splash.Hint.selected,
            apps: [
                SplashAppItem(kind: .english, initials: "EN", title: L10n.Splash.App.english, accent: .rose),
                SplashAppItem(kind: .fit, initials: "FT", title: L10n.Splash.App.fit, accent: .green),
                SplashAppItem(kind: .timer, initials: "TM", title: L10n.Splash.App.timer, accent: .blue),
                SplashAppItem(kind: .todo, initials: "TD", title: L10n.Splash.App.todo, accent: .cyan),
                SplashAppItem(kind: .notes, initials: "NT", title: L10n.Splash.App.notes, accent: .purple),
                SplashAppItem(kind: .money, initials: "MO", title: L10n.Splash.App.money, accent: .teal),
                SplashAppItem(kind: .split, initials: "SP", title: L10n.Splash.App.split, accent: .magenta),
                SplashAppItem(kind: .calculator, initials: "CA", title: L10n.Splash.App.calculator, accent: .amber),
                SplashAppItem(kind: .calendar, initials: "CL", title: L10n.Splash.App.calendar, accent: .blue),
                SplashAppItem(kind: .habit, initials: "HB", title: L10n.Splash.App.habit, accent: .green),
                SplashAppItem(kind: .goals, initials: "GO", title: L10n.Splash.App.goals, accent: .amber),
                SplashAppItem(kind: .coach, initials: "CO", title: L10n.Splash.App.coach, accent: .violet),
                SplashAppItem(kind: .search, initials: "SE", title: L10n.Splash.App.search, accent: .blue),
                SplashAppItem(kind: .inbox, initials: "IN", title: L10n.Splash.App.inbox, accent: .orange),
                SplashAppItem(kind: .account, initials: "AC", title: L10n.Splash.App.account, accent: .purple),
                SplashAppItem(kind: .settings, initials: "ST", title: L10n.Splash.App.settings, accent: .violet),
                SplashAppItem(kind: .weather, initials: "WE", title: L10n.Splash.App.weather, accent: .cyan),
                SplashAppItem(kind: .meals, initials: "ME", title: L10n.Splash.App.meals, accent: .teal),
                SplashAppItem(kind: .play, initials: "PL", title: L10n.Splash.App.play, accent: .rose),
                SplashAppItem(kind: .arcade, initials: "AR", title: L10n.Splash.App.arcade, accent: .lime),
                SplashAppItem(kind: .music, initials: "MU", title: L10n.Splash.App.music, accent: .cyan),
                SplashAppItem(kind: .watch, initials: "WT", title: L10n.Splash.App.watch, accent: .violet)
            ]
        )
    }
}
