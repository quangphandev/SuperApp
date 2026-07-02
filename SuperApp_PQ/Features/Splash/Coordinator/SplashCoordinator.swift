//
//  SplashCoordinator.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import UIKit

protocol SplashCoordinating: AnyObject {
    func openApp(_ kind: SplashAppKind)
}

final class SplashCoordinator: BaseCoordinator, SplashCoordinating {

    // MARK: - Properties

    var onFinish: (() -> Void)?
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
        let viewController = dependencyContainer.makeSplashVC(coordinator: self)
        navigationController.setViewControllers([viewController], animated: false)
    }

    // MARK: - SplashCoordinating

    func openApp(_ kind: SplashAppKind) {
        switch kind {
        case .english:
            removeAllChildren()
            let englishCoordinator = dependencyContainer.makeEnglishCoordinator(navigationController: navigationController)
            addChild(englishCoordinator)
            englishCoordinator.start()
        case .fit:
            removeAllChildren()
            let fitCoordinator = dependencyContainer.makeFitCoordinator(navigationController: navigationController)
            addChild(fitCoordinator)
            fitCoordinator.start()
        case .timer:
            removeAllChildren()
            let timerCoordinator = dependencyContainer.makeTimerCoordinator(navigationController: navigationController)
            addChild(timerCoordinator)
            timerCoordinator.start()
        case .todo:
            removeAllChildren()
            let todoCoordinator = dependencyContainer.makeTodoCoordinator(navigationController: navigationController)
            addChild(todoCoordinator)
            todoCoordinator.start()
        case .notes:
            removeAllChildren()
            let notesCoordinator = dependencyContainer.makeNotesCoordinator(navigationController: navigationController)
            addChild(notesCoordinator)
            notesCoordinator.start()
        case .calculator:
            removeAllChildren()
            let calculatorCoordinator = dependencyContainer.makeCalculatorCoordinator(navigationController: navigationController)
            addChild(calculatorCoordinator)
            calculatorCoordinator.start()
        case .goals:
            removeAllChildren()
            let goalsCoordinator = dependencyContainer.makeGoalsCoordinator(navigationController: navigationController)
            addChild(goalsCoordinator)
            goalsCoordinator.start()
        case .calendar:
            removeAllChildren()
            let calendarCoordinator = dependencyContainer.makeCalendarCoordinator(navigationController: navigationController)
            addChild(calendarCoordinator)
            calendarCoordinator.start()
        default:
            Toast.show(L10n.Splash.Toast.updating, type: .info)
        }
    }
}
