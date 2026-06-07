//
//  CoordinatorType.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import UIKit

protocol CoordinatorType: AnyObject {

    // MARK: - Properties

    var navigationController: UINavigationController { get }
    var childCoordinators: [CoordinatorType] { get set }

    // MARK: - Methods

    func start()
}
