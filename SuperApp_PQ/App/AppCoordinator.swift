//
//  AppCoordinator.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import UIKit

final class AppCoordinator: BaseCoordinator {

    // MARK: - Properties

    private let dependencyContainer: AppDependencyContainer

    // MARK: - Lifecycle

    init(
        navigationController: UINavigationController,
        dependencyContainer: AppDependencyContainer
    ) {
        self.dependencyContainer = dependencyContainer
        super.init(navigationController: navigationController)
    }

    // MARK: - CoordinatorType

    override func start() {
        let homeCoordinator = dependencyContainer.makeHomeCoordinator(
            navigationController: navigationController
        )
        addChild(homeCoordinator)
        homeCoordinator.start()
    }
}

