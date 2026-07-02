//
//  TimerCoordinator.swift
//  SuperApp_PQ
//
//  Created by Codex on 12/06/26.
//

import UIKit

protocol TimerCoordinating: AnyObject {
    func showTimer(state: TimerScreenState)
    func closeTimer()
    func startFloatingPIP()
    func dismissFloatingPIP()
}

final class TimerCoordinator: BaseCoordinator, TimerCoordinating {

    private let dependencyContainer: AppDependencyContainer

    init(
        navigationController: UINavigationController,
        dependencyContainer: AppDependencyContainer
    ) {
        self.dependencyContainer = dependencyContainer
        super.init(navigationController: navigationController)
    }

    override func start() {
        showTimer(state: .home)
    }

    func showTimer(state: TimerScreenState = .home) {
        let viewController = dependencyContainer.makeTimerVC(coordinator: self, state: state)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func closeTimer() {
        let homeCoordinator = dependencyContainer.makeHomeCoordinator(navigationController: navigationController)
        addChild(homeCoordinator)
        homeCoordinator.start()
    }

    func startFloatingPIP() {
        FloatingPIPManager.shared.showPIP(
            navigationController: navigationController,
            dependencyContainer: dependencyContainer
        )
    }

    func dismissFloatingPIP() {
        FloatingPIPManager.shared.dismissPIP()
    }
}
