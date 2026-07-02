//
//  TimerViewModel.swift
//  SuperApp_PQ
//
//  Created by Codex on 12/06/26.
//

import RxCocoa
import RxSwift

final class TimerViewModel: BaseViewModel {

    private let contentProvider: TimerContentProviding
    private let state: TimerScreenState

    init(contentProvider: TimerContentProviding, state: TimerScreenState) {
        self.contentProvider = contentProvider
        self.state = state
        super.init()
    }

    struct Input {}

    struct Output {
        let content: Driver<TimerScreenContent>
    }

    func transform(input _: Input) -> Output {
        Output(content: Driver.just(contentProvider.makeContent(for: state)))
    }
}
