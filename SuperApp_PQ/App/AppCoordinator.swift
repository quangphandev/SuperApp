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
        showSplash()
    }

    func handle(url: URL) -> Bool {
        guard let state = FitRunningLiveActivityController.shared.handle(url: url) else {
            return false
        }

        showFitRunning(state: state)
        return true
    }

    // MARK: - Routing

    private func showSplash() {
        removeAllChildren()
        let splashCoordinator = dependencyContainer.makeSplashCoordinator(
            navigationController: navigationController
        )
        splashCoordinator.onFinish = { [weak self, weak splashCoordinator] in
            if let splashCoordinator {
                self?.removeChild(splashCoordinator)
            }
            self?.showHome()
        }
        addChild(splashCoordinator)
        splashCoordinator.start()
    }

    private func showHome() {
        removeAllChildren()
        let homeCoordinator = dependencyContainer.makeHomeCoordinator(
            navigationController: navigationController
        )
        addChild(homeCoordinator)
        homeCoordinator.start()
    }

    private func showFitRunning(state: FitRunningState) {
        removeAllChildren()
        let fitCoordinator = dependencyContainer.makeFitCoordinator(
            navigationController: navigationController
        )
        addChild(fitCoordinator)
        fitCoordinator.showRunning(state: state)
    }
}
