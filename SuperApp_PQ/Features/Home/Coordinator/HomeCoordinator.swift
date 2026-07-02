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
    func showEnglish()
    func showFit()
    func showTodo()
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
        let viewController = dependencyContainer.makeHomeVC(
            coordinator: self
        )
        navigationController.setViewControllers([viewController], animated: false)
    }

    // MARK: - HomeCoordinating

    func showDetail() {
        let viewController = HomeDetailViewController(
            viewModel: dependencyContainer.makeHomeDetailVM()
        )
        navigationController.pushViewController(viewController, animated: true)
    }

    func showDebugInfo() {
        let viewController = DebugInfoViewController(
            viewModel: dependencyContainer.makeDebugInfoVM()
        )
        let navController = UINavigationController(rootViewController: viewController)
        navigationController.present(navController, animated: true)
    }

    func showEnglish() {
        removeAllChildren()
        let englishCoordinator = dependencyContainer.makeEnglishCoordinator(navigationController: navigationController)
        addChild(englishCoordinator)
        englishCoordinator.start()
    }

    func showFit() {
        removeAllChildren()
        let fitCoordinator = dependencyContainer.makeFitCoordinator(navigationController: navigationController)
        addChild(fitCoordinator)
        fitCoordinator.start()
    }

    func showTodo() {
        removeAllChildren()
        let todoCoordinator = dependencyContainer.makeTodoCoordinator(navigationController: navigationController)
        addChild(todoCoordinator)
        todoCoordinator.start()
    }
}
