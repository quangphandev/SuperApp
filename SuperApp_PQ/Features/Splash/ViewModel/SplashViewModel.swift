//
//  SplashViewModel.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import Foundation
import RxCocoa
import RxSwift

final class SplashViewModel: BaseViewModel {

    // MARK: - Properties

    private let contentProvider: SplashContentProviding
    private let selectedKindRelay = BehaviorRelay<SplashAppKind?>(value: nil)

    struct Input {
        let selectApp: Signal<SplashAppKind>
        let continueTap: Signal<Void>
    }

    struct Output {
        let content: Driver<SplashContent>
        let selectedKind: Driver<SplashAppKind?>
        let launcherTitle: Driver<String>
        let summaryTitle: Driver<String>
        let summarySubtitle: Driver<String>
        let actionTitle: Driver<String>
        let hintText: Driver<String>
        let canContinue: Driver<Bool>
        let routeToApp: Signal<SplashAppKind>
    }

    // MARK: - Lifecycle

    init(contentProvider: SplashContentProviding) {
        self.contentProvider = contentProvider
        super.init()
    }

    func transform(input: Input) -> Output {
        input.selectApp
            .emit(onNext: { [weak self] kind in
                self?.selectedKindRelay.accept(kind)
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

        let contentDriver = content.asDriverOnErrorJustComplete()
        let selectedKind = selectedKindRelay.asDriver()
        let selectedItem = Driver.combineLatest(contentDriver, selectedKind) { content, kind in
            kind.flatMap { content.app(for: $0) }
        }

        let launcherTitle = Driver.combineLatest(contentDriver, selectedKind) { content, kind in
            kind == nil ? content.chooseTitle : content.selectedTitle
        }

        let summaryTitle = Driver.combineLatest(contentDriver, selectedItem) { content, item in
            item?.title ?? content.emptySummaryTitle
        }

        let summarySubtitle = Driver.combineLatest(contentDriver, selectedItem) { content, item in
            guard let item else { return content.emptySummarySubtitle }
            return "\(content.selectedSummaryPrefix) \(item.title) \(content.selectedSummarySuffix)"
        }

        let actionTitle = Driver.combineLatest(contentDriver, selectedItem) { content, item in
            guard let item else { return content.emptyActionTitle }
            return "\(content.selectedActionPrefix) \(item.title) \(content.selectedActionSuffix)"
        }

        let hintText = Driver.combineLatest(contentDriver, selectedKind) { content, kind in
            kind == nil ? content.emptyHint : content.selectedHint
        }

        let canContinue = selectedKind.map { $0 != nil }
        let routeToApp = input.continueTap
            .withLatestFrom(selectedKindRelay.asSignal(onErrorSignalWith: .empty()))
            .compactMap { $0 }

        return Output(
            content: contentDriver,
            selectedKind: selectedKind,
            launcherTitle: launcherTitle,
            summaryTitle: summaryTitle,
            summarySubtitle: summarySubtitle,
            actionTitle: actionTitle,
            hintText: hintText,
            canContinue: canContinue,
            routeToApp: routeToApp
        )
    }
}
