//
//  EnglishViewModel.swift
//  SuperApp_PQ
//
//  Created by Codex on 12/06/26.
//

import RxCocoa
import RxSwift

final class EnglishViewModel: BaseViewModel {

    private let contentProvider: EnglishContentProviding
    private let state: EnglishScreenState

    init(contentProvider: EnglishContentProviding, state: EnglishScreenState) {
        self.contentProvider = contentProvider
        self.state = state
        super.init()
    }

    struct Input {}

    struct Output {
        let content: Driver<EnglishScreenContent>
    }

    func transform(input _: Input) -> Output {
        Output(content: Driver.just(contentProvider.makeContent(for: state)))
    }
}
