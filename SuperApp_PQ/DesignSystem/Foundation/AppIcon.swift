//
//  AppIcon.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 08/06/26.
//

import UIKit

enum AppIcon: String {
    case homeFill = "house.fill"
    case home = "house"
    case book = "book"
    case figureRun = "figure.run"
    case figureWalk = "figure.walk"
    case checklist = "checklist"
    case ellipsis = "ellipsis"
    case checkmarkSeal = "checkmark.seal"
    case activity = "arrow.triangle.2.circlepath"
    case sparkles = "sparkles"
    case tray = "tray"
    case moon = "moon"
    case moonFill = "moon.fill"
    case personCircle = "person.crop.circle"
    case personCircleFill = "person.crop.circle.fill"
    case forkKnife = "fork.knife"
    case plus = "plus"
    case minus = "minus"
    case playFill = "play.fill"
    case pauseFill = "pause.fill"
    case xmark = "xmark"
    case chevronLeft = "chevron.left"
    case chevronRight = "chevron.right"
    case arrowRight = "arrow.right"
    case arrowUpRight = "arrow.up.right"
    case target = "scope"
    case location = "location.circle"
    case locationFill = "location.fill"
    case music = "music.note"
    case timer = "timer"
    case chartBar = "chart.bar.fill"
    case flame = "flame.fill"
    case drop = "drop.fill"
    case heart = "heart.fill"
    case weight = "scalemass"
    case height = "ruler"
    case bell = "bell"
    case gear = "gearshape"
    case wallet = "wallet.pass"
    case wifi = "wifi"
    case warningTriangle = "exclamationmark.triangle"
    case exclamation = "exclamationmark"
    case wifiSlash = "wifi.slash"
    case checkmarkCircleFill = "checkmark.circle.fill"
    case warningCircleFill = "exclamationmark.triangle.fill"
    case xmarkCircleFill = "xmark.circle.fill"
    case infoCircleFill = "info.circle.fill"
    case calendar = "calendar"
    case info = "info.circle"
}

extension AppIcon {

    var systemName: String {
        rawValue
    }

    var image: UIImage? {
        UIImage(named: rawValue) ?? UIImage(systemName: rawValue)
    }

    var templateImage: UIImage? {
        image?.withRenderingMode(.alwaysTemplate)
    }
}
