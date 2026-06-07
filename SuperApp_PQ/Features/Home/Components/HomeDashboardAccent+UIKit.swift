//
//  HomeDashboardAccent+UIKit.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import UIKit

extension HomeDashboardAccent {

    var color: UIColor {
        switch self {
        case .home:
            return AppColor.accent
        case .english:
            return AppColor.accentSecondary
        case .fit:
            return AppColor.success
        case .todo:
            return AppColor.warning
        case .muted:
            return AppColor.textSecondary
        }
    }
}
