//
//  BaseCoordinator.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import UIKit

class BaseCoordinator: CoordinatorType {

    // MARK: - Properties

    let navigationController: UINavigationController
    var childCoordinators: [CoordinatorType] = []

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    deinit {
        #if DEBUG
        Logger.debug("\(String(describing: type(of: self))) deallocated", category: .app)
        #endif
    }

    // MARK: - CoordinatorType

    func start() {
        // Override in subclass
    }

    // MARK: - Child Management

    func addChild(_ coordinator: CoordinatorType) {
        childCoordinators.append(coordinator)
    }

    func removeChild(_ coordinator: CoordinatorType) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }

    func removeAllChildren() {
        childCoordinators.removeAll()
    }

    // MARK: - Navigation

    func pop(animated: Bool = true) {
        navigationController.popViewController(animated: animated)
    }

    func popToRoot(animated: Bool = true) {
        navigationController.popToRootViewController(animated: animated)
    }

    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
}
