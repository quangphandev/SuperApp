//
//  BaseTabBarController.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 27/5/26.
//

import UIKit

// MARK: - BaseTabBarController

class BaseTabBarController: UITabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }

    // MARK: - Status Bar — delegate to selected child

    override var preferredStatusBarStyle: UIStatusBarStyle {
        selectedViewController?.preferredStatusBarStyle ?? .default
    }

    override var childForStatusBarStyle: UIViewController? {
        selectedViewController
    }

    // MARK: - Setup

    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColor.surface
        appearance.shadowColor     = .clear

        // Normal state
        let normalAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: AppColor.textSecondary,
            .font:            AppFont.caption
        ]
        // Selected state
        let selectedAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: AppColor.accent,
            .font:            AppFont.captionMedium
        ]

        [appearance.inlineLayoutAppearance,
         appearance.stackedLayoutAppearance,
         appearance.compactInlineLayoutAppearance].forEach {
            $0.normal.titleTextAttributes   = normalAttrs
            $0.selected.titleTextAttributes = selectedAttrs
            $0.normal.iconColor             = AppColor.textSecondary
            $0.selected.iconColor           = AppColor.accent
        }

        tabBar.standardAppearance   = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor            = AppColor.accent
    }
}
