//
//  SplashAppAccent+UIKit.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import UIKit

extension SplashAppAccent {

    var color: UIColor {
        switch self {
        case .rose:
            return UIColor(red: 1, green: 0.38, blue: 0.62, alpha: 1)
        case .green:
            return UIColor(red: 0.18, green: 0.91, blue: 0.56, alpha: 1)
        case .blue:
            return UIColor(red: 0.48, green: 0.72, blue: 1, alpha: 1)
        case .cyan:
            return UIColor(red: 0.37, green: 0.87, blue: 0.96, alpha: 1)
        case .purple:
            return UIColor(red: 0.75, green: 0.54, blue: 1, alpha: 1)
        case .teal:
            return UIColor(red: 0.30, green: 0.92, blue: 0.75, alpha: 1)
        case .magenta:
            return UIColor(red: 1, green: 0.48, blue: 0.82, alpha: 1)
        case .amber:
            return UIColor(red: 1, green: 0.76, blue: 0.22, alpha: 1)
        case .violet:
            return UIColor(red: 0.65, green: 0.54, blue: 1, alpha: 1)
        case .orange:
            return UIColor(red: 1, green: 0.70, blue: 0.25, alpha: 1)
        case .lime:
            return UIColor(red: 0.65, green: 0.96, blue: 0.36, alpha: 1)
        }
    }
}
