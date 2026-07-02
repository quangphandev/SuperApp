//
//  FitCoordinator.swift
//  SuperApp_PQ
//
//  Created by Codex on 08/06/26.
//

import UIKit

protocol FitCoordinating: AnyObject {
    func showHome()
    func showWorkout()
    func showNutrition()
    func showProfile()
    func showRunning(state: FitRunningState)
    func showError()
}

final class FitCoordinator: BaseCoordinator, FitCoordinating {

    private let dependencyContainer: AppDependencyContainer

    init(
        navigationController: UINavigationController,
        dependencyContainer: AppDependencyContainer
    ) {
        self.dependencyContainer = dependencyContainer
        super.init(navigationController: navigationController)
    }

    override func start() {
        showHome()
    }

    func showHome() {
        let viewController = dependencyContainer.makeFitHomeVC(coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showWorkout() {
        let viewController = dependencyContainer.makeFitWorkoutVC(coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showNutrition() {
        let viewController = dependencyContainer.makeFitNutritionVC(coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showProfile() {
        let viewController = dependencyContainer.makeFitProfileVC(coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showRunning(state: FitRunningState = .ready) {
        let viewController = dependencyContainer.makeFitRunningVC(coordinator: self, state: state)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func showError() {
        let viewController = dependencyContainer.makeFitErrorVC(coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
    }
}
