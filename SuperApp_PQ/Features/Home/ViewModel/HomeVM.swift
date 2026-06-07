//
//  HomeVM.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import Foundation
import RxCocoa
import RxSwift

final class HomeVM: BaseVM {

    // MARK: - Properties

    private let contentProvider: HomeContentProviding
    private let stateContentProvider: HomeStateContentProviding
    private let stateKindRelay: BehaviorRelay<HomeScreenStateKind>

    struct Input {
        let exploreTap: Signal<Void>
        let debugTap: Signal<Void>
        let stateAction: Signal<HomeStateActionKind>
    }

    struct Output {
        let screenState: Driver<HomeScreenState>
        let title: Driver<String>
        let welcomeText: Driver<String>
        let subtitleText: Driver<String>
        let balanceTitle: Driver<String>
        let balanceValue: Driver<String>
        let balanceSubtitle: Driver<String>
        let exploreButtonTitle: Driver<String>
        let featuresTitle: Driver<String>
        let features: Driver<[HomeFeatureItem]>
        let routeToDetail: Signal<Void>
        let routeToDebugInfo: Signal<Void>
    }

    // MARK: - Lifecycle

    init(
        contentProvider: HomeContentProviding,
        stateContentProvider: HomeStateContentProviding,
        initialState: HomeScreenStateKind = .ready
    ) {
        self.contentProvider = contentProvider
        self.stateContentProvider = stateContentProvider
        self.stateKindRelay = BehaviorRelay(value: initialState)
        super.init()
    }

    func transform(input: Input) -> Output {
        input.stateAction
            .emit(onNext: { [weak self] action in
                self?.handleStateAction(action)
            })
            .disposed(by: disposeBag)

        let content = Observable.merge(
            Observable.just(()),
            NotificationCenter.default.rx
                .notification(.appLanguageDidChange)
                .mapToVoid()
        )
        .map { [contentProvider] in contentProvider.makeContent() }
        .share(replay: 1, scope: .whileConnected)

        let screenState = Observable.combineLatest(
            content,
            stateKindRelay.asObservable()
        )
        .map { [stateContentProvider] content, kind -> HomeScreenState in
            switch kind {
            case .ready:
                return .ready(content)
            case .loading:
                return .loading(stateContentProvider.makeStateContent(for: kind))
            case .empty:
                return .empty(stateContentProvider.makeStateContent(for: kind))
            case .error:
                return .error(stateContentProvider.makeStateContent(for: kind))
            case .offline:
                return .offline(stateContentProvider.makeStateContent(for: kind))
            case .syncConflict:
                return .syncConflict(stateContentProvider.makeStateContent(for: kind))
            }
        }
        .asDriverOnErrorJustComplete()

        let contentDriver = content.asDriverOnErrorJustComplete()

        return Output(
            screenState: screenState,
            title: contentDriver.map { $0.title },
            welcomeText: contentDriver.map { $0.welcomeText },
            subtitleText: contentDriver.map { $0.subtitleText },
            balanceTitle: contentDriver.map { $0.balanceTitle },
            balanceValue: contentDriver.map { $0.balanceValue },
            balanceSubtitle: contentDriver.map { $0.balanceSubtitle },
            exploreButtonTitle: contentDriver.map { $0.exploreButtonTitle },
            featuresTitle: contentDriver.map { $0.featuresTitle },
            features: contentDriver.map { $0.features },
            routeToDetail: input.exploreTap,
            routeToDebugInfo: input.debugTap
        )
    }

    // MARK: - Helpers

    private func handleStateAction(_ action: HomeStateActionKind) {
        switch action {
        case .retry:
            stateKindRelay.accept(.loading)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { [weak self] in
                self?.stateKindRelay.accept(.ready)
            }
        case .compareChanges:
            stateKindRelay.accept(.syncConflict)
        case .selectStarterApp,
             .openCachedHome,
             .continueOffline,
             .useLatestVersion:
            stateKindRelay.accept(.ready)
        }
    }
}
