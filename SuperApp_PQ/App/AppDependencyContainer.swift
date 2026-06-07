//
//  AppDependencyContainer.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import UIKit

final class AppDependencyContainer {

    // MARK: - Shared Dependencies

    private let tokenStorage: TokenStorageProtocol
    private let userDefaultsStorage: UserDefaultsStorageProtocol

    private lazy var tokenRefreshHandler: TokenRefreshHandlerProtocol = {
        TokenRefreshHandler(tokenStorage: tokenStorage)
    }()

    private lazy var authInterceptor: AuthInterceptor = {
        AuthInterceptor(
            tokenStorage: tokenStorage,
            tokenRefreshHandler: tokenRefreshHandler
        )
    }()

    private lazy var apiClient: APIClientProtocol = {
        APIClient(
            interceptor: authInterceptor,
            logger: NetworkLogger()
        )
    }()

    private lazy var sessionManager: SessionManaging = {
        SessionManager(tokenStorage: tokenStorage)
    }()

    // MARK: - Lifecycle

    init(
        tokenStorage: TokenStorageProtocol = KeychainTokenStorage(),
        userDefaultsStorage: UserDefaultsStorageProtocol = UserDefaultsStorage()
    ) {
        self.tokenStorage = tokenStorage
        self.userDefaultsStorage = userDefaultsStorage
    }

    // MARK: - App

    func makeAppCoordinator(navigationController: UINavigationController) -> AppCoordinator {
        AppCoordinator(
            navigationController: navigationController,
            dependencyContainer: self
        )
    }

    // MARK: - Home

    func makeHomeCoordinator(navigationController: UINavigationController) -> HomeCoordinator {
        HomeCoordinator(
            navigationController: navigationController,
            dependencyContainer: self
        )
    }

    func makeHomeVM() -> HomeVM {
        HomeVM(
            contentProvider: LocalizedHomeContentProvider(),
            stateContentProvider: LocalizedHomeStateContentProvider()
        )
    }

    func makeHomeDetailVM() -> HomeDetailVM {
        HomeDetailVM()
    }

    // MARK: - Debug Info

    func makeDebugInfoVM() -> DebugInfoVM {
        DebugInfoVM()
    }

    // MARK: - Shared Accessors

    func makeAPIClient() -> APIClientProtocol {
        apiClient
    }

    func makeTokenStorage() -> TokenStorageProtocol {
        tokenStorage
    }

    func makeUserDefaultsStorage() -> UserDefaultsStorageProtocol {
        userDefaultsStorage
    }

    func makeSessionManager() -> SessionManaging {
        sessionManager
    }
}
