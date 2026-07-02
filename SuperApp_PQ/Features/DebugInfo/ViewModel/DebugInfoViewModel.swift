//
//  DebugInfoViewModel.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 28/05/26.
//

import Foundation
import RxCocoa
import RxSwift

final class DebugInfoViewModel: BaseViewModel {

    struct Input {
        let closeTap: Signal<Void>
    }

    struct Output {
        let title: Driver<String>
        let configInfo: Driver<String>
        let appIcon: Driver<UIImage?>
        let routeToClose: Signal<Void>
    }

    func transform(input: Input) -> Output {
        var infoText = ""
        infoText += "APP_ENVIRONMENT: \(AppEnvironment.active)\n\n"
        infoText += "BASE_URL: \(AppEnvironment.baseURL)\n\n"
        infoText += "APP_NAME: \(AppEnvironment.appName)\n\n"
        infoText += "APP_VERSION: \(AppEnvironment.appVersion)\n\n"
        infoText += "BUILD_NUMBER: \(AppEnvironment.buildNumber)\n\n"
        infoText += "Bundle ID: \(AppEnvironment.bundleIdentifier)\n"
        
        let appIcon = AppEnvironment.appIcon
        
        return Output(
            title: Driver.just("Config Info"),
            configInfo: Driver.just(infoText),
            appIcon: Driver.just(appIcon),
            routeToClose: input.closeTap
        )
    }
}
