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

    private lazy var todoLocalService: TodoLocalServiceProtocol = {
        TodoLocalService()
    }()

    private lazy var todoRepository: TodoRepositoryProtocol = {
        TodoRepository(localService: todoLocalService)
    }()

    private lazy var notesLocalService: NotesLocalServiceProtocol = {
        NotesLocalService()
    }()

    private lazy var notesRepository: NoteRepositoryProtocol = {
        NoteRepository(localService: notesLocalService)
    }()

    private lazy var goalsLocalService: GoalsLocalServiceProtocol = {
        GoalsLocalService()
    }()

    private lazy var goalsRepository: GoalsRepositoryProtocol = {
        GoalsRepository(localService: goalsLocalService)
    }()

    private lazy var calculatorLocalService: CalculatorLocalServiceProtocol = {
        CalculatorLocalService()
    }()

    private lazy var calculatorRemoteService: CalculatorRemoteServiceProtocol = {
        CalculatorRemoteService()
    }()

    private lazy var calculatorRepository: CalculatorRepositoryProtocol = {
        CalculatorRepository(
            localService: calculatorLocalService,
            remoteService: calculatorRemoteService,
            userDefaultsStorage: userDefaultsStorage
        )
    }()

    private lazy var calendarLocalService: CalendarLocalServiceProtocol = {
        CalendarLocalService()
    }()

    private lazy var calendarRepository: CalendarRepositoryProtocol = {
        CalendarRepository(localService: calendarLocalService)
    }()

    private lazy var fitRepository: FitRepositoryProtocol = {
        FitRepository()
    }()

    private lazy var fitContentProvider: FitContentProviding = {
        LocalizedFitContentProvider(repository: fitRepository)
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

    // MARK: - Splash

    func makeSplashCoordinator(navigationController: UINavigationController) -> SplashCoordinator {
        SplashCoordinator(
            navigationController: navigationController,
            dependencyContainer: self
        )
    }

    func makeSplashVC(coordinator: SplashCoordinating?) -> SplashViewController {
        SplashViewController(
            viewModel: makeSplashVM(),
            coordinator: coordinator
        )
    }

    func makeSplashVM() -> SplashViewModel {
        SplashViewModel(contentProvider: LocalizedSplashContentProvider())
    }

    // MARK: - Home

    func makeHomeCoordinator(navigationController: UINavigationController) -> HomeCoordinator {
        HomeCoordinator(
            navigationController: navigationController,
            dependencyContainer: self
        )
    }

    func makeHomeVC(coordinator: HomeCoordinating?) -> HomeViewController {
        HomeViewController(
            viewModel: makeHomeVM(),
            coordinator: coordinator
        )
    }

    func makeHomeVM() -> HomeViewModel {
        HomeViewModel(
            contentProvider: LocalizedHomeContentProvider(),
            stateContentProvider: LocalizedHomeStateContentProvider()
        )
    }

    func makeHomeDetailVM() -> HomeDetailViewModel {
        HomeDetailViewModel()
    }

    // MARK: - English

    func makeEnglishCoordinator(navigationController: UINavigationController) -> EnglishCoordinator {
        EnglishCoordinator(
            navigationController: navigationController,
            dependencyContainer: self
        )
    }

    func makeEnglishVC(coordinator: EnglishCoordinating?, state: EnglishScreenState) -> EnglishViewController {
        EnglishViewController(
            viewModel: makeEnglishVM(state: state),
            coordinator: coordinator,
            state: state
        )
    }

    func makeEnglishVM(state: EnglishScreenState) -> EnglishViewModel {
        EnglishViewModel(contentProvider: LocalizedEnglishContentProvider(), state: state)
    }

    // MARK: - Fit

    func makeFitCoordinator(navigationController: UINavigationController) -> FitCoordinator {
        FitCoordinator(
            navigationController: navigationController,
            dependencyContainer: self
        )
    }

    func makeFitHomeVC(coordinator: FitCoordinating?) -> FitHomeViewController {
        FitHomeViewController(
            viewModel: makeFitHomeVM(),
            coordinator: coordinator
        )
    }

    func makeFitErrorVC(coordinator: FitCoordinating?) -> FitErrorViewController {
        FitErrorViewController(coordinator: coordinator)
    }

    func makeFitWorkoutVC(coordinator: FitCoordinating?) -> FitWorkoutViewController {
        FitWorkoutViewController(
            viewModel: makeFitWorkoutVM(),
            coordinator: coordinator
        )
    }

    func makeFitNutritionVC(coordinator: FitCoordinating?) -> FitNutritionViewController {
        FitNutritionViewController(
            viewModel: makeFitNutritionVM(),
            coordinator: coordinator
        )
    }

    func makeFitProfileVC(coordinator: FitCoordinating?) -> FitProfileViewController {
        FitProfileViewController(
            viewModel: makeFitProfileVM(),
            coordinator: coordinator
        )
    }

    func makeFitRunningVC(coordinator: FitCoordinating?, state: FitRunningState) -> FitRunningViewController {
        FitRunningViewController(
            viewModel: makeFitRunningVM(state: state),
            coordinator: coordinator,
            state: state
        )
    }

    func makeFitHomeVM() -> FitHomeViewModel {
        FitHomeViewModel(contentProvider: fitContentProvider, repository: fitRepository)
    }

    func makeFitWorkoutVM() -> FitWorkoutViewModel {
        FitWorkoutViewModel(contentProvider: fitContentProvider, repository: fitRepository)
    }

    func makeFitNutritionVM() -> FitNutritionViewModel {
        FitNutritionViewModel(contentProvider: fitContentProvider, repository: fitRepository)
    }

    func makeFitProfileVM() -> FitProfileViewModel {
        FitProfileViewModel(contentProvider: fitContentProvider, repository: fitRepository)
    }

    func makeFitRunningVM(state: FitRunningState) -> FitRunningViewModel {
        FitRunningViewModel(contentProvider: fitContentProvider, repository: fitRepository, state: state)
    }

    // MARK: - Timer

    func makeTimerCoordinator(navigationController: UINavigationController) -> TimerCoordinator {
        TimerCoordinator(
            navigationController: navigationController,
            dependencyContainer: self
        )
    }

    func makeTimerVC(coordinator: TimerCoordinating?, state: TimerScreenState) -> TimerViewController {
        TimerViewController(
            viewModel: makeTimerVM(state: state),
            coordinator: coordinator,
            state: state
        )
    }

    func makeTimerVM(state: TimerScreenState) -> TimerViewModel {
        TimerViewModel(contentProvider: LocalizedTimerContentProvider(), state: state)
    }

    // MARK: - Todo

    func makeTodoCoordinator(navigationController: UINavigationController) -> TodoCoordinator {
        TodoCoordinator(
            navigationController: navigationController,
            dependencyContainer: self
        )
    }

    func makeTodoVC(
        coordinator: TodoCoordinating?,
        state: TodoScreenState
    ) -> TodoViewController {
        TodoViewController(
            viewModel: makeTodoVM(state: state),
            coordinator: coordinator,
            state: state
        )
    }

    func makeTodoVM(state: TodoScreenState) -> TodoViewModel {
        TodoViewModel(
            state: state,
            contentProvider: LocalizedTodoContentProvider(),
            observeTasksUseCase: makeObserveTodoTasksUseCase(),
            observeProjectsUseCase: makeObserveTodoProjectsUseCase(),
            toggleTaskUseCase: makeToggleTodoTaskUseCase(),
            deleteTaskUseCase: makeDeleteTodoTaskUseCase(),
            archiveCompletedUseCase: makeArchiveCompletedTodoTasksUseCase()
        )
    }

    func makeTodoTaskFormVC(coordinator: TodoCoordinating?) -> TodoTaskFormViewController {
        TodoTaskFormViewController(
            viewModel: makeTodoTaskFormVM(),
            coordinator: coordinator
        )
    }

    func makeTodoTaskFormVM() -> TodoTaskFormViewModel {
        TodoTaskFormViewModel(addTaskUseCase: makeAddTodoTaskUseCase())
    }

    func makeTodoProjectFormVC(coordinator: TodoCoordinating?) -> TodoProjectFormViewController {
        TodoProjectFormViewController(
            viewModel: makeTodoProjectFormVM(),
            coordinator: coordinator
        )
    }

    func makeTodoProjectFormVM() -> TodoProjectFormViewModel {
        TodoProjectFormViewModel(addProjectUseCase: makeAddTodoProjectUseCase())
    }

    func makeObserveTodoTasksUseCase() -> ObserveTodoTasksUseCaseProtocol {
        ObserveTodoTasksUseCase(repository: todoRepository)
    }

    func makeAddTodoTaskUseCase() -> AddTodoTaskUseCaseProtocol {
        AddTodoTaskUseCase(repository: todoRepository)
    }

    func makeUpdateTodoTaskUseCase() -> UpdateTodoTaskUseCaseProtocol {
        UpdateTodoTaskUseCase(repository: todoRepository)
    }

    func makeToggleTodoTaskUseCase() -> ToggleTodoTaskUseCaseProtocol {
        ToggleTodoTaskUseCase(repository: todoRepository)
    }

    func makeDeleteTodoTaskUseCase() -> DeleteTodoTaskUseCaseProtocol {
        DeleteTodoTaskUseCase(repository: todoRepository)
    }

    func makeArchiveCompletedTodoTasksUseCase() -> ArchiveCompletedTodoTasksUseCaseProtocol {
        ArchiveCompletedTodoTasksUseCase(repository: todoRepository)
    }

    func makeObserveTodoProjectsUseCase() -> ObserveTodoProjectsUseCaseProtocol {
        ObserveTodoProjectsUseCase(repository: todoRepository)
    }

    func makeAddTodoProjectUseCase() -> AddTodoProjectUseCaseProtocol {
        AddTodoProjectUseCase(repository: todoRepository)
    }

    // MARK: - Notes

    func makeNotesCoordinator(navigationController: UINavigationController) -> NotesCoordinator {
        NotesCoordinator(
            navigationController: navigationController,
            dependencyContainer: self
        )
    }

    func makeNotesVC(coordinator: NotesCoordinating?) -> NotesHomeViewController {
        NotesHomeViewController(
            viewModel: makeNotesVM(),
            coordinator: coordinator
        )
    }

    func makeNotesVM() -> NotesHomeViewModel {
        NotesHomeViewModel(
            observeNotesUseCase: makeObserveNotesUseCase(),
            observeFoldersUseCase: makeObserveFoldersUseCase()
        )
    }

    func makeObserveNotesUseCase() -> ObserveNotesUseCaseProtocol {
        ObserveNotesUseCase(repository: notesRepository)
    }

    func makeObserveFoldersUseCase() -> ObserveFoldersUseCaseProtocol {
        ObserveFoldersUseCase(repository: notesRepository)
    }

    // MARK: - Goals

    func makeGoalsCoordinator(navigationController: UINavigationController) -> GoalsCoordinator {
        GoalsCoordinator(
            navigationController: navigationController,
            dependencyContainer: self
        )
    }

    func makeGoalsVC(coordinator: GoalsCoordinator?, state: GoalsScreenState) -> GoalsViewController {
        GoalsViewController(
            viewModel: makeGoalsVM(),
            coordinator: coordinator,
            state: state
        )
    }

    func makeGoalsVM() -> GoalsViewModel {
        GoalsViewModel(
            observeGoalsUseCase: makeObserveGoalsUseCase(),
            saveGoalUseCase: makeSaveGoalUseCase(),
            updateGoalProgressUseCase: makeUpdateGoalProgressUseCase(),
            observeWeeklyPlanUseCase: makeObserveWeeklyPlanUseCase(),
            saveWeeklyPlanUseCase: makeSaveWeeklyPlanUseCase(),
            observeGoalReviewUseCase: makeObserveGoalReviewUseCase(),
            saveGoalReviewUseCase: makeSaveGoalReviewUseCase()
        )
    }

    func makeObserveGoalsUseCase() -> ObserveGoalsUseCaseProtocol {
        ObserveGoalsUseCase(repository: goalsRepository)
    }

    func makeSaveGoalUseCase() -> SaveGoalUseCaseProtocol {
        SaveGoalUseCase(repository: goalsRepository)
    }

    func makeUpdateGoalProgressUseCase() -> UpdateGoalProgressUseCaseProtocol {
        UpdateGoalProgressUseCase(repository: goalsRepository)
    }

    func makeObserveWeeklyPlanUseCase() -> ObserveWeeklyPlanUseCaseProtocol {
        ObserveWeeklyPlanUseCase(repository: goalsRepository)
    }

    func makeSaveWeeklyPlanUseCase() -> SaveWeeklyPlanUseCaseProtocol {
        SaveWeeklyPlanUseCase(repository: goalsRepository)
    }

    func makeObserveGoalReviewUseCase() -> ObserveGoalReviewUseCaseProtocol {
        ObserveGoalReviewUseCase(repository: goalsRepository)
    }

    func makeSaveGoalReviewUseCase() -> SaveGoalReviewUseCaseProtocol {
        SaveGoalReviewUseCase(repository: goalsRepository)
    }

    // MARK: - Calculator

    func makeCalculatorCoordinator(navigationController: UINavigationController) -> CalculatorCoordinator {
        CalculatorCoordinator(
            navigationController: navigationController,
            dependencyContainer: self
        )
    }

    func makeCalculatorVC(coordinator: CalculatorCoordinating?) -> CalculatorViewController {
        CalculatorViewController(
            viewModel: makeCalculatorVM(),
            coordinator: coordinator
        )
    }

    func makeCalculatorVM() -> CalculatorViewModel {
        CalculatorViewModel(
            observeCalculationsUseCase: makeObserveCalculationsUseCase(),
            saveCalculationUseCase: makeSaveCalculationUseCase(),
            deleteCalculationUseCase: makeDeleteCalculationUseCase(),
            clearHistoryUseCase: makeClearHistoryUseCase(),
            pinCalculationUseCase: makePinCalculationUseCase(),
            observeRatesUseCase: makeObserveRatesUseCase(),
            fetchRatesUseCase: makeFetchRatesUseCase(),
            observePreferencesUseCase: makeObservePreferencesUseCase(),
            savePreferencesUseCase: makeSavePreferencesUseCase()
        )
    }

    func makeObserveCalculationsUseCase() -> ObserveCalculationsUseCaseProtocol {
        ObserveCalculationsUseCase(repository: calculatorRepository)
    }

    func makeSaveCalculationUseCase() -> SaveCalculationUseCaseProtocol {
        SaveCalculationUseCase(repository: calculatorRepository)
    }

    func makeDeleteCalculationUseCase() -> DeleteCalculationUseCaseProtocol {
        DeleteCalculationUseCase(repository: calculatorRepository)
    }

    func makeObserveRatesUseCase() -> ObserveRatesUseCaseProtocol {
        ObserveRatesUseCase(repository: calculatorRepository)
    }

    func makeFetchRatesUseCase() -> FetchRatesUseCaseProtocol {
        FetchRatesUseCase(repository: calculatorRepository)
    }

    func makeObservePreferencesUseCase() -> ObservePreferencesUseCaseProtocol {
        ObservePreferencesUseCase(repository: calculatorRepository)
    }

    func makeSavePreferencesUseCase() -> SavePreferencesUseCaseProtocol {
        SavePreferencesUseCase(repository: calculatorRepository)
    }

    func makeClearHistoryUseCase() -> ClearHistoryUseCaseProtocol {
        ClearHistoryUseCase(repository: calculatorRepository)
    }

    func makePinCalculationUseCase() -> PinCalculationUseCaseProtocol {
        PinCalculationUseCase(repository: calculatorRepository)
    }

    // MARK: - Calendar

    func makeCalendarCoordinator(navigationController: UINavigationController) -> CalendarCoordinator {
        CalendarCoordinator(
            navigationController: navigationController,
            dependencyContainer: self
        )
    }

    func makeCalendarVC(coordinator: CalendarCoordinator?, state: CalendarScreenState) -> CalendarViewController {
        CalendarViewController(
            viewModel: makeCalendarVM(),
            coordinator: coordinator,
            state: state
        )
    }

    func makeCalendarVM() -> CalendarViewModel {
        CalendarViewModel(
            observeCalendarEventsUseCase: makeObserveCalendarEventsUseCase(),
            saveCalendarEventUseCase: makeSaveCalendarEventUseCase(),
            deleteCalendarEventUseCase: makeDeleteCalendarEventUseCase(),
            observeCalendarSettingsUseCase: makeObserveCalendarSettingsUseCase(),
            saveCalendarSettingsUseCase: makeSaveCalendarSettingsUseCase(),
            observeConflictsUseCase: makeObserveConflictsUseCase()
        )
    }

    func makeObserveCalendarEventsUseCase() -> ObserveCalendarEventsUseCaseProtocol {
        ObserveCalendarEventsUseCase(repository: calendarRepository)
    }

    func makeSaveCalendarEventUseCase() -> SaveCalendarEventUseCaseProtocol {
        SaveCalendarEventUseCase(repository: calendarRepository)
    }

    func makeDeleteCalendarEventUseCase() -> DeleteCalendarEventUseCaseProtocol {
        DeleteCalendarEventUseCase(repository: calendarRepository)
    }

    func makeObserveCalendarSettingsUseCase() -> ObserveCalendarSettingsUseCaseProtocol {
        ObserveCalendarSettingsUseCase(repository: calendarRepository)
    }

    func makeSaveCalendarSettingsUseCase() -> SaveCalendarSettingsUseCaseProtocol {
        SaveCalendarSettingsUseCase(repository: calendarRepository)
    }

    func makeObserveConflictsUseCase() -> ObserveConflictsUseCaseProtocol {
        ObserveConflictsUseCase(repository: calendarRepository)
    }

    // MARK: - Debug Info

    func makeDebugInfoVM() -> DebugInfoViewModel {
        DebugInfoViewModel()
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
