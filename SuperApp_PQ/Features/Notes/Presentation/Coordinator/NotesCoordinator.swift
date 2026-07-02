//
//  NotesCoordinator.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 12/06/26.
//

import UIKit

protocol NotesCoordinating: AnyObject {
    func closeNotes()
}

final class NotesCoordinator: BaseCoordinator, NotesCoordinating {

    private let dependencyContainer: AppDependencyContainer

    init(
        navigationController: UINavigationController,
        dependencyContainer: AppDependencyContainer
    ) {
        self.dependencyContainer = dependencyContainer
        super.init(navigationController: navigationController)
    }

    override func start() {
        let viewController = dependencyContainer.makeNotesVC(coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
    }

    func closeNotes() {
        let homeCoordinator = dependencyContainer.makeHomeCoordinator(navigationController: navigationController)
        addChild(homeCoordinator)
        homeCoordinator.start()
    }
}
