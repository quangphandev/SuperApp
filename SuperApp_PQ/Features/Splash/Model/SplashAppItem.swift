//
//  SplashAppItem.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import Foundation

enum SplashAppKind: CaseIterable, Hashable, Sendable {
    case english
    case fit
    case timer
    case todo
    case notes
    case money
    case split
    case calculator
    case calendar
    case habit
    case goals
    case coach
    case search
    case inbox
    case account
    case settings
    case weather
    case meals
    case play
    case arcade
    case music
    case watch
}

enum SplashAppAccent: Hashable, Sendable {
    case rose
    case green
    case blue
    case cyan
    case purple
    case teal
    case magenta
    case amber
    case violet
    case orange
    case lime
}

struct SplashAppItem: Hashable, Sendable {
    let kind: SplashAppKind
    let initials: String
    let title: String
    let accent: SplashAppAccent
}
