//
//  FitViewModels.swift
//  SuperApp_PQ
//
//  Created by Codex on 08/06/26.
//

import RxCocoa
import RxSwift

final class FitHomeViewModel: BaseViewModel {

    private let contentProvider: FitContentProviding
    let repository: FitRepositoryProtocol

    init(contentProvider: FitContentProviding, repository: FitRepositoryProtocol) {
        self.contentProvider = contentProvider
        self.repository = repository
        super.init()
    }

    struct Input {}

    struct Output {
        let content: Driver<FitHomeContent>
    }

    func transform(input _: Input) -> Output {
        let trigger = Observable.combineLatest(
            repository.stepsToday.asObservable(),
            repository.kcalBurned.asObservable(),
            repository.waterMl.asObservable(),
            repository.streakDays.asObservable(),
            repository.activeWorkoutId.asObservable()
        )
        
        let content = trigger
            .map { [weak self] _ -> FitHomeContent in
                guard let self else {
                    return LocalizedFitContentProvider(repository: FitRepository()).makeHomeContent()
                }
                return self.contentProvider.makeHomeContent()
            }
            .asDriver(onErrorDriveWith: Driver.empty())
            
        return Output(content: content)
    }
}

final class FitWorkoutViewModel: BaseViewModel {

    private let contentProvider: FitContentProviding
    let repository: FitRepositoryProtocol

    init(contentProvider: FitContentProviding, repository: FitRepositoryProtocol) {
        self.contentProvider = contentProvider
        self.repository = repository
        super.init()
    }

    struct Input {}

    struct Output {
        let content: Driver<FitWorkoutContent>
    }

    func transform(input _: Input) -> Output {
        let trigger = Observable.combineLatest(
            repository.exercises.asObservable(),
            repository.activeWorkoutId.asObservable(),
            repository.currentExerciseIndex.asObservable(),
            repository.restSecondsRemaining.asObservable(),
            repository.isResting.asObservable(),
            repository.isWorkoutDone.asObservable()
        )
        
        let content = trigger
            .map { [weak self] _ -> FitWorkoutContent in
                guard let self else {
                    return LocalizedFitContentProvider(repository: FitRepository()).makeWorkoutContent()
                }
                return self.contentProvider.makeWorkoutContent()
            }
            .asDriver(onErrorDriveWith: Driver.empty())
            
        return Output(content: content)
    }
}

final class FitNutritionViewModel: BaseViewModel {

    private let contentProvider: FitContentProviding
    let repository: FitRepositoryProtocol

    init(contentProvider: FitContentProviding, repository: FitRepositoryProtocol) {
        self.contentProvider = contentProvider
        self.repository = repository
        super.init()
    }

    struct Input {}

    struct Output {
        let content: Driver<FitNutritionContent>
    }

    func transform(input _: Input) -> Output {
        let trigger = Observable.combineLatest(
            repository.kcalBurned.asObservable(),
            repository.waterMl.asObservable()
        )
        
        let content = trigger
            .map { [weak self] _ -> FitNutritionContent in
                guard let self else {
                    return LocalizedFitContentProvider(repository: FitRepository()).makeNutritionContent()
                }
                return self.contentProvider.makeNutritionContent()
            }
            .asDriver(onErrorDriveWith: Driver.empty())
            
        return Output(content: content)
    }
}

final class FitProfileViewModel: BaseViewModel {

    private let contentProvider: FitContentProviding
    let repository: FitRepositoryProtocol

    init(contentProvider: FitContentProviding, repository: FitRepositoryProtocol) {
        self.contentProvider = contentProvider
        self.repository = repository
        super.init()
    }

    struct Input {}

    struct Output {
        let content: Driver<FitProfileContent>
    }

    func transform(input _: Input) -> Output {
        let trigger = Observable.combineLatest(
            repository.streakDays.asObservable(),
            repository.kcalBurned.asObservable(),
            repository.stepsToday.asObservable(),
            repository.weightKg.asObservable(),
            repository.heightCm.asObservable()
        )
        
        let content = trigger
            .map { [weak self] _ -> FitProfileContent in
                guard let self else {
                    return LocalizedFitContentProvider(repository: FitRepository()).makeProfileContent()
                }
                return self.contentProvider.makeProfileContent()
            }
            .asDriver(onErrorDriveWith: Driver.empty())
            
        return Output(content: content)
    }
}

final class FitRunningViewModel: BaseViewModel {

    private let contentProvider: FitContentProviding
    let repository: FitRepositoryProtocol
    private let state: FitRunningState

    init(contentProvider: FitContentProviding, repository: FitRepositoryProtocol, state: FitRunningState) {
        self.contentProvider = contentProvider
        self.repository = repository
        self.state = state
        super.init()
    }

    struct Input {}

    struct Output {
        let content: Driver<FitRunningContent>
    }

    func transform(input _: Input) -> Output {
        Output(content: Driver.just(contentProvider.makeRunningContent(for: state)))
    }
}
