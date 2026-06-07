//
//  HomeCoordinator.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import UIKit

protocol HomeCoordinating: AnyObject {
    func showDetail()
    func showDebugInfo()
}

final class HomeCoordinator: BaseCoordinator, HomeCoordinating {

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
        let viewController = HomeVC(
            viewModel: dependencyContainer.makeHomeVM(),
            coordinator: self
        )
        navigationController.setViewControllers([viewController], animated: false)
    }

    // MARK: - HomeCoordinating

    func showDetail() {
        let viewController = HomeDetailVC(
            viewModel: dependencyContainer.makeHomeDetailVM()
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    func showDebugInfo() {
        let viewController = DebugInfoVC(
            viewModel: dependencyContainer.makeDebugInfoVM()
        )
        let navController = UINavigationController(rootViewController: viewController)
        navigationController.present(navController, animated: true)
    }
}

