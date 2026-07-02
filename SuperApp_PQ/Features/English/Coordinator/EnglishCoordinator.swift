//
//  EnglishCoordinator.swift
//  SuperApp_PQ
//
//  Created by Codex on 12/06/26.
//

import UIKit

protocol EnglishCoordinating: AnyObject {
    func showEnglish(state: EnglishScreenState)
    func closeEnglish()
}

final class EnglishCoordinator: BaseCoordinator, EnglishCoordinating {

    private let dependencyContainer: AppDependencyContainer

    init(
        navigationController: UINavigationController,
        dependencyContainer: AppDependencyContainer
    ) {
        self.dependencyContainer = dependencyContainer
        super.init(navigationController: navigationController)
    }

    override func start() {
        showEnglish(state: .home)
    }

    func showEnglish(state: EnglishScreenState = .home) {
        let viewController = dependencyContainer.makeEnglishVC(coordinator: self, state: state)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func closeEnglish() {
        let homeCoordinator = dependencyContainer.makeHomeCoordinator(navigationController: navigationController)
        addChild(homeCoordinator)
        homeCoordinator.start()
    }
}
