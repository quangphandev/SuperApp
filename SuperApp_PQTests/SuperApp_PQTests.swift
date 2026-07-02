//
//  SuperApp_PQTests.swift
//  SuperApp_PQTests
//
//  Created by Phan Quang on 22/5/26.
//

import Alamofire
import RxBlocking
import RxCocoa
import RxSwift
import UIKit
import XCTest
@testable import SuperApp_PQ

final class SuperApp_PQTests: XCTestCase {

    func testViewStateHelpersExposeExpectedValues() {
        let loadingState = ViewState<String>.loading
        XCTAssertTrue(loadingState.isLoading)
        XCTAssertNil(loadingState.value)

        let successState = ViewState.success("Done")
        XCTAssertTrue(successState.isSuccess)
        XCTAssertEqual(successState.value, "Done")
    }

    func testBaseErrorMessageUsesUserFacingText() {
        XCTAssertEqual(BaseError.message("Custom error").message, "Custom error")
        XCTAssertFalse(BaseError.unauthorized.message.isEmpty)
    }

    func testReusableIdentifierDefaultsToTypeName() {
        XCTAssertEqual(TestCell.reuseIdentifier, "TestCell")
    }

    func testNetworkErrorMapsUnauthorizedStatusCode() {
        let error = AFError.responseValidationFailed(
            reason: .unacceptableStatusCode(code: 401)
        )
        let mappedError = NetworkError.map(from: error, statusCode: 401)
        XCTAssertTrue(mappedError.isUnauthorized)
    }

    func testSessionManagerStoresAndClearsTokens() {
        let storage = MockTokenStorage()
        let sessionManager = SessionManager(tokenStorage: storage)

        XCTAssertFalse(sessionManager.isAuthenticated)

        sessionManager.updateTokens(accessToken: "access", refreshToken: "refresh")
        XCTAssertTrue(sessionManager.isAuthenticated)
        XCTAssertEqual(storage.accessToken, "access")
        XCTAssertEqual(storage.refreshToken, "refresh")

        sessionManager.clearSession()
        XCTAssertFalse(sessionManager.isAuthenticated)
        XCTAssertNil(storage.accessToken)
        XCTAssertNil(storage.refreshToken)
    }

    func testNetworkConfigBuildsRefreshURLFromConfiguredPath() {
        let originalBaseURL = NetworkConfig.baseURL
        let originalRefreshPath = NetworkConfig.authRefreshPath

        NetworkConfig.baseURL = URL(string: "https://example.com/api")!
        NetworkConfig.authRefreshPath = "/auth/refresh"

        XCTAssertEqual(
            NetworkConfig.authRefreshURL.absoluteString,
            "https://example.com/api/auth/refresh"
        )

        NetworkConfig.baseURL = originalBaseURL
        NetworkConfig.authRefreshPath = originalRefreshPath
    }

    func testHomeStateProviderBuildsExpectedStates() {
        let provider = LocalizedHomeStateContentProvider()
        let kinds: [HomeScreenStateKind] = [
            .loading,
            .empty,
            .error,
            .offline,
            .syncConflict
        ]

        kinds.forEach { kind in
            let content = provider.makeStateContent(for: kind)
            XCTAssertEqual(content.kind, kind)
            XCTAssertFalse(content.title.isEmpty)
            XCTAssertFalse(content.cardTitle.isEmpty)
        }
    }

    func testHomeVMEmitsConfiguredInitialState() throws {
        let viewModel = HomeViewModel(
            contentProvider: LocalizedHomeContentProvider(),
            stateContentProvider: LocalizedHomeStateContentProvider(),
            initialState: .empty
        )
        let input = HomeViewModel.Input(
            exploreTap: .empty(),
            debugTap: .empty(),
            stateAction: .empty()
        )

        let state = try viewModel
            .transform(input: input)
            .screenState
            .asObservable()
            .take(1)
            .toBlocking(timeout: 1)
            .first()

        guard case .empty(let content) = state else {
            return XCTFail("Expected Home empty state")
        }

        XCTAssertEqual(content.kind, .empty)
    }
}

private final class TestCell: UITableViewCell, Reusable {}

private final class MockTokenStorage: TokenStorageProtocol {
    var accessToken: String?
    var refreshToken: String?
}
