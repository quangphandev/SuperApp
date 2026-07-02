//
//  HomeDetailViewModel.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 26/05/26.
//

import Foundation
import RxCocoa
import RxSwift

final class HomeDetailViewModel: BaseViewModel {

    // MARK: - Properties

    struct Output {
        let title: Driver<String>
        let message: Driver<String>
        let navigationTitle: Driver<String>
    }

    // MARK: - Transform

    func transform() -> Output {
        let languageChanged = Observable.merge(
            Observable.just(()),
            NotificationCenter.default.rx
                .notification(.appLanguageDidChange)
                .mapToVoid()
        )
        .share(replay: 1)

        return Output(
            title: languageChanged
                .map { L10n.Home.Detail.title }
                .asDriverOnErrorJustComplete(),
            message: languageChanged
                .map { L10n.Home.Detail.message }
                .asDriverOnErrorJustComplete(),
            navigationTitle: languageChanged
                .map { L10n.Home.Detail.Navigation.title }
                .asDriverOnErrorJustComplete()
        )
    }
}
