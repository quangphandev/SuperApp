//
//  FitViewControllers.swift
//  SuperApp_PQ
//
//  Created by Codex on 08/06/26.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

private enum FitLayout {
    static func full(
        height: CGFloat,
        top: CGFloat = 0,
        bottom: CGFloat = AppSpacing.large,
        interGroupSpacing: CGFloat = 0
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(height)
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = interGroupSpacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: top,
            leading: AppSpacing.xLarge,
            bottom: bottom,
            trailing: AppSpacing.xLarge
        )
        return section
    }

    static func grid(
        columns: Int,
        height: CGFloat,
        spacing: CGFloat = AppSpacing.small,
        top: CGFloat = 0,
        bottom: CGFloat = AppSpacing.large
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(height)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(
            top: top,
            leading: AppSpacing.xLarge,
            bottom: bottom,
            trailing: AppSpacing.xLarge
        )
        return section
    }

    static func fixedGrid(
        columns: Int,
        itemWidth: CGFloat,
        height: CGFloat,
        spacing: CGFloat,
        top: CGFloat = 0,
        bottom: CGFloat = AppSpacing.large
    ) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(itemWidth),
            heightDimension: .absolute(height)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let totalWidth = CGFloat(columns) * itemWidth + CGFloat(columns - 1) * spacing
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(totalWidth),
            heightDimension: .absolute(height)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: top,
            leading: AppSpacing.xLarge,
            bottom: bottom,
            trailing: 0
        )
        return section
    }

    static func title(bottom: CGFloat = 0) -> NSCollectionLayoutSection {
        full(height: AppSpacing.large, bottom: bottom)
    }
}

private enum FitItemKey {
    static func index(from item: String, prefix: String) -> Int? {
        guard item.hasPrefix(prefix) else { return nil }
        return Int(item.dropFirst(prefix.count))
    }
}

private extension FitRunningState {
    var usesFullWidthActionRows: Bool {
        switch self {
        case .ready, .active, .paused, .confirmStop, .summary:
            return false
        case .locationPermission, .gpsWeak, .backgroundBlocked, .musicPermission, .playlistPicker, .goalSetup, .history, .historyDetail:
            return true
        }
    }
}

private enum FitHomeSection: String, CaseIterable {
    case today
    case quickStats
    case workout
    case activeExercise
    case runningAction
    case healthTitle
    case health
    case habitsTitle
    case habits

    var layout: NSCollectionLayoutSection {
        switch self {
        case .today:
            return FitLayout.full(height: 88, top: AppSpacing.medium, bottom: AppSpacing.medium)
        case .quickStats:
            return FitLayout.fixedGrid(columns: 3, itemWidth: 106, height: 88, spacing: AppSpacing.small, bottom: AppSpacing.small)
        case .workout:
            return FitLayout.full(height: 92, bottom: AppSpacing.small)
        case .activeExercise:
            return FitLayout.full(height: 44, bottom: AppSpacing.small)
        case .runningAction:
            return FitLayout.full(height: 44, bottom: 10)
        case .healthTitle, .habitsTitle:
            return FitLayout.title()
        case .health:
            return FitLayout.fixedGrid(columns: 2, itemWidth: 164, height: 90, spacing: AppSpacing.medium, bottom: 10)
        case .habits:
            return FitLayout.full(height: 42, bottom: AppSpacing.small, interGroupSpacing: 6)
        }
    }
}

private enum FitWorkoutSection: String, CaseIterable {
    case banner
    case weekTitle
    case days
    case exercisesTitle
    case exercises
    case summary

    var layout: NSCollectionLayoutSection {
        switch self {
        case .banner:
            return FitLayout.full(height: 74)
        case .weekTitle, .exercisesTitle:
            return FitLayout.title()
        case .days:
            return FitLayout.grid(columns: 7, height: 54, spacing: 6)
        case .exercises:
            return FitLayout.full(height: 68, bottom: AppSpacing.small)
        case .summary:
            return FitLayout.full(height: 54)
        }
    }
}

private enum FitNutritionSection: String, CaseIterable {
    case hero
    case macros
    case mealsTitle
    case meals
    case tip

    var layout: NSCollectionLayoutSection {
        switch self {
        case .hero:
            return FitLayout.full(height: 154)
        case .macros:
            return FitLayout.grid(columns: 3, height: 94)
        case .mealsTitle:
            return FitLayout.title()
        case .meals:
            return FitLayout.full(height: 64, bottom: AppSpacing.small)
        case .tip:
            return FitLayout.full(height: 58)
        }
    }
}

private enum FitProfileSection: String, CaseIterable {
    case hero
    case stats
    case bodyTitle
    case bodyMetrics
    case goalTitle
    case goals
    case settingsTitle
    case settings

    var layout: NSCollectionLayoutSection {
        switch self {
        case .hero:
            return FitLayout.full(height: 112)
        case .stats:
            return FitLayout.grid(columns: 4, height: 80, spacing: 0)
        case .bodyTitle, .goalTitle, .settingsTitle:
            return FitLayout.title()
        case .bodyMetrics:
            return FitLayout.grid(columns: 2, height: 112)
        case .goals, .settings:
            return FitLayout.full(height: 64, bottom: AppSpacing.small)
        }
    }
}

private enum FitRunningSection: String, CaseIterable {
    case panel

    func layout(for state: FitRunningState) -> NSCollectionLayoutSection {
        FitLayout.full(height: panelHeight(for: state), bottom: AppSpacing.medium)
    }

    private func panelHeight(for state: FitRunningState) -> CGFloat {
        switch state {
        case .ready:
            return 344
        case .active, .paused:
            return 312
        case .confirmStop:
            return 260
        case .summary, .historyDetail:
            return 366
        case .locationPermission, .gpsWeak, .backgroundBlocked, .musicPermission, .playlistPicker, .goalSetup, .history:
            return 382
        }
    }
}

private enum FitRunningSheetDetent: CaseIterable {
    case collapsed
    case middle
    case expanded
}

final class FitHomeViewController: BaseCollectionViewController<FitHomeViewModel> {

    private weak var coordinator: FitCoordinating?
    private var dataSource: UICollectionViewDiffableDataSource<String, String>!
    private let homeHeaderView = FitHomeHeaderView()
    private let bottomNavView = FitBottomNavView()
    private var currentContent: FitHomeContent?

    init(viewModel: FitHomeViewModel, coordinator: FitCoordinating?) {
        self.coordinator = coordinator
        super.init(viewModel: viewModel)
    }

    override func configureCollectionLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard sectionIndex < FitHomeSection.allCases.count else { return nil }
            return FitHomeSection.allCases[sectionIndex].layout
        }
    }

    override func setupViews() {
        overrideUserInterfaceStyle = .dark
        super.setupViews()
        view.backgroundColor = FitColor.background
        homeHeaderView.overrideUserInterfaceStyle = .dark
        bottomNavView.overrideUserInterfaceStyle = .dark
        view.addSubview(homeHeaderView)
        view.addSubview(bottomNavView)
        homeHeaderView.onStreakTap = { [weak self] in
            self?.coordinator?.showError()
        }
    }

    override func setupConstraints() {
        super.setupConstraints()
        homeHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(88)
        }

        bottomNavView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(64)
        }

        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(homeHeaderView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomNavView.snp.top)
        }
    }

    override func registerCollectionCells() {
        collectionView.registerCells(
            FitHomeTodayCell.self,
            FitQuickStatCell.self,
            FitWorkoutPreviewCell.self,
            FitActiveExerciseCell.self,
            FitRunningQuickActionCell.self,
            FitSectionTitleCell.self,
            FitHealthCardCell.self,
            FitHabitCell.self
        )
    }

    override func setupCollectionView() {
        collectionView.backgroundColor = FitColor.background
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset.bottom = 0
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self, let content = self.currentContent else { return nil }
            switch item {
            case "today":
                let cell = collectionView.dequeue(FitHomeTodayCell.self, for: indexPath)
                cell.configure(with: content)
                return cell
            case let id where id.hasPrefix("quickStat-"):
                guard let index = FitItemKey.index(from: id, prefix: "quickStat-"),
                      content.quickStats.indices.contains(index)
                else { return nil }
                let cell = collectionView.dequeue(FitQuickStatCell.self, for: indexPath)
                cell.configure(with: content.quickStats[index])
                return cell
            case "workoutPreview":
                let cell = collectionView.dequeue(FitWorkoutPreviewCell.self, for: indexPath)
                cell.configure(
                    title: content.workoutTitle,
                    subtitle: content.workoutSubtitle,
                    progress: content.workoutProgress
                )
                return cell
            case "activeExercise":
                let cell = collectionView.dequeue(FitActiveExerciseCell.self, for: indexPath)
                cell.configure(title: content.activeExerciseTitle, subtitle: content.activeExerciseSubtitle)
                return cell
            case "runningAction":
                let cell = collectionView.dequeue(FitRunningQuickActionCell.self, for: indexPath)
                cell.configure(title: "Bắt đầu chạy bộ")
                return cell
            case "healthTitle":
                let cell = collectionView.dequeue(FitSectionTitleCell.self, for: indexPath)
                cell.configure(title: "Tổng quan sức khoẻ")
                return cell
            case "habitsTitle":
                let cell = collectionView.dequeue(FitSectionTitleCell.self, for: indexPath)
                cell.configure(title: content.habitsTitle)
                return cell
            case let id where id.hasPrefix("health-"):
                guard let index = FitItemKey.index(from: id, prefix: "health-"),
                      content.healthCards.indices.contains(index)
                else { return nil }
                let cell = collectionView.dequeue(FitHealthCardCell.self, for: indexPath)
                cell.configure(with: content.healthCards[index])
                return cell
            case let id where id.hasPrefix("habit-"):
                guard let index = FitItemKey.index(from: id, prefix: "habit-"),
                      content.habits.indices.contains(index)
                else { return nil }
                let cell = collectionView.dequeue(FitHabitCell.self, for: indexPath)
                cell.configure(with: content.habits[index])
                return cell
            default:
                return nil
            }
        }
    }

    override func setupBindings() {
        super.setupBindings()
        let output = viewModel.transform(input: FitHomeViewModel.Input())
        output.content
            .drive(onNext: { [weak self] content in
                self?.render(content)
            })
            .disposed(by: disposeBag)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case "today":
            coordinator?.showNutrition()
        case let id where id.hasPrefix("quickStat-"):
            guard let content = currentContent,
                  let index = FitItemKey.index(from: id, prefix: "quickStat-"),
                  content.quickStats.indices.contains(index)
            else { return }
            route(from: content.quickStats[index])
        case "workoutPreview", "activeExercise":
            coordinator?.showWorkout()
        case "runningAction":
            coordinator?.showRunning(state: .ready)
        case let id where id.hasPrefix("health-"):
            guard let content = currentContent,
                  let index = FitItemKey.index(from: id, prefix: "health-"),
                  content.healthCards.indices.contains(index)
            else { return }
            let card = content.healthCards[index]
            if card.title.contains("Giấc ngủ") {
                Toast.show("Giấc ngủ đang được cập nhật", type: .info)
            } else if card.title.contains("Cân nặng") {
                coordinator?.showProfile()
            }
        case let id where id.hasPrefix("habit-"):
            guard let content = currentContent,
                  let index = FitItemKey.index(from: id, prefix: "habit-"),
                  content.habits.indices.contains(index)
            else { return }
            route(from: content.habits[index])
        default:
            break
        }
    }

    private func render(_ content: FitHomeContent) {
        currentContent = content
        homeHeaderView.configure(greeting: content.greeting, name: content.name, energyBadge: content.energyBadge)
        bottomNavView.configure(with: content.navItems) { [weak self] item in
            self?.route(to: item.kind)
        }

        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(FitHomeSection.allCases.map(\.rawValue))
        snapshot.appendItems(["today"], toSection: FitHomeSection.today.rawValue)
        snapshot.appendItems(content.quickStats.indices.map { "quickStat-\($0)" }, toSection: FitHomeSection.quickStats.rawValue)
        snapshot.appendItems(["workoutPreview"], toSection: FitHomeSection.workout.rawValue)
        if content.activeWorkoutId != nil {
            snapshot.appendItems(["activeExercise"], toSection: FitHomeSection.activeExercise.rawValue)
        }
        snapshot.appendItems(["runningAction"], toSection: FitHomeSection.runningAction.rawValue)
        snapshot.appendItems(["healthTitle"], toSection: FitHomeSection.healthTitle.rawValue)
        snapshot.appendItems(content.healthCards.indices.map { "health-\($0)" }, toSection: FitHomeSection.health.rawValue)
        snapshot.appendItems(["habitsTitle"], toSection: FitHomeSection.habitsTitle.rawValue)
        snapshot.appendItems(content.habits.indices.map { "habit-\($0)" }, toSection: FitHomeSection.habits.rawValue)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func route(to kind: FitNavKind) {
        switch kind {
        case .home:
            coordinator?.showHome()
        case .workout:
            coordinator?.showWorkout()
        case .nutrition:
            coordinator?.showNutrition()
        case .sleep:
            Toast.show("Sleep đang được cập nhật", type: .info)
        case .profile:
            coordinator?.showProfile()
        }
    }

    private func route(from stat: FitQuickStat) {
        switch stat.subtitle {
        case "bước":
            coordinator?.showRunning(state: .history)
        case "kcal", "nước":
            coordinator?.showNutrition()
        default:
            Toast.show("Tính năng đang được cập nhật", type: .info)
        }
    }

    private func route(from habit: FitHabitItem) {
        if habit.title.contains("Tập") {
            coordinator?.showWorkout()
        } else if habit.title.contains("nước") {
            coordinator?.showNutrition()
        } else if habit.title.contains("Ngủ") {
            Toast.show("Giấc ngủ đang được cập nhật", type: .info)
        } else {
            Toast.show("Tính năng đang được cập nhật", type: .info)
        }
    }
}

final class FitWorkoutViewController: BaseCollectionViewController<FitWorkoutViewModel> {

    private weak var coordinator: FitCoordinating?
    private var dataSource: UICollectionViewDiffableDataSource<String, String>!
    private let topBarView = FitTopBarView()
    private let bottomNavView = FitBottomNavView()
    private var currentContent: FitWorkoutContent?
    private var hasShownWorkoutDoneToast = false

    init(viewModel: FitWorkoutViewModel, coordinator: FitCoordinating?) {
        self.coordinator = coordinator
        super.init(viewModel: viewModel)
    }

    override func configureCollectionLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard sectionIndex < FitWorkoutSection.allCases.count else { return nil }
            return FitWorkoutSection.allCases[sectionIndex].layout
        }
    }

    override func setupViews() {
        overrideUserInterfaceStyle = .dark
        super.setupViews()
        view.backgroundColor = FitColor.background
        topBarView.overrideUserInterfaceStyle = .dark
        bottomNavView.overrideUserInterfaceStyle = .dark
        view.addSubview(topBarView)
        view.addSubview(bottomNavView)
    }

    override func setupConstraints() {
        super.setupConstraints()
        topBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(90)
        }

        bottomNavView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(64)
        }

        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomNavView.snp.top)
        }
    }

    override func registerCollectionCells() {
        collectionView.registerCells(
            FitWorkoutBannerCell.self,
            FitSectionTitleCell.self,
            FitWorkoutDayCell.self,
            FitWorkoutExerciseCell.self,
            FitSummaryCell.self
        )
    }

    override func setupCollectionView() {
        collectionView.backgroundColor = FitColor.background
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset.bottom = AppSpacing.large
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self, let content = self.currentContent else { return nil }
            switch item {
            case "banner":
                let cell = collectionView.dequeue(FitWorkoutBannerCell.self, for: indexPath)
                cell.configure(title: content.activeTitle, subtitle: content.activeSubtitle)
                return cell
            case "weekTitle":
                let cell = collectionView.dequeue(FitSectionTitleCell.self, for: indexPath)
                cell.configure(title: "TUẦN NÀY", trailing: "xem lịch")
                return cell
            case "exercisesTitle":
                let cell = collectionView.dequeue(FitSectionTitleCell.self, for: indexPath)
                cell.configure(title: "BÀI TẬP HÔM NAY", trailing: content.todayLabel, trailingColor: FitColor.textSecondary)
                return cell
            case let id where id.hasPrefix("day-"):
                guard let index = FitItemKey.index(from: id, prefix: "day-"),
                      content.weekDays.indices.contains(index)
                else { return nil }
                let cell = collectionView.dequeue(FitWorkoutDayCell.self, for: indexPath)
                cell.configure(with: content.weekDays[index])
                return cell
            case let id where id.hasPrefix("exercise-"):
                guard let index = FitItemKey.index(from: id, prefix: "exercise-"),
                      content.exercises.indices.contains(index)
                else { return nil }
                let cell = collectionView.dequeue(FitWorkoutExerciseCell.self, for: indexPath)
                cell.configure(with: content.exercises[index])
                return cell
            case "summary":
                let cell = collectionView.dequeue(FitSummaryCell.self, for: indexPath)
                cell.configure(left: content.summary, right: "🔥 ~320 kcal")
                return cell
            default:
                return nil
            }
        }
    }

    override func setupBindings() {
        super.setupBindings()
        let output = viewModel.transform(input: FitWorkoutViewModel.Input())
        output.content
            .drive(onNext: { [weak self] content in
                self?.render(content)
            })
            .disposed(by: disposeBag)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case "banner":
            if viewModel.repository.activeWorkoutId.value == nil {
                viewModel.repository.startWorkout()
                Toast.show("Đã bắt đầu buổi tập!", type: .success)
            } else {
                viewModel.repository.nextExerciseStep()
            }
        case "weekTitle":
            Toast.show("Lịch tập đang được cập nhật", type: .info)
        case let id where id.hasPrefix("exercise-"):
            guard let index = FitItemKey.index(from: id, prefix: "exercise-") else { return }
            
            if viewModel.repository.activeWorkoutId.value == nil {
                viewModel.repository.startWorkout()
                Toast.show("Đã bắt đầu buổi tập!", type: .success)
            } else {
                let activeIndex = viewModel.repository.currentExerciseIndex.value
                if index == activeIndex {
                    viewModel.repository.nextExerciseStep()
                } else {
                    Toast.show("Vui lòng thực hiện bài tập hiện tại", type: .info)
                }
            }
        case let id where id.hasPrefix("day-"):
            Toast.show("Tính năng đang được cập nhật", type: .info)
        case "summary":
            coordinator?.showRunning(state: .history)
        default:
            break
        }
    }

    private func render(_ content: FitWorkoutContent) {
        currentContent = content
        if content.isWorkoutDone && !hasShownWorkoutDoneToast {
            hasShownWorkoutDoneToast = true
            Toast.show("Đã hoàn thành bài tập: +320 kcal, +1 ngày streak 🔥", type: .success)
        } else if !content.isWorkoutDone {
            hasShownWorkoutDoneToast = false
        }
        topBarView.configure(backTitle: "< Fit", title: content.title, rightTitle: content.dayLabel)
        topBarView.onBackTap = { [weak self] in self?.coordinator?.showHome() }
        topBarView.onRightTap = { [weak self] in self?.coordinator?.showRunning(state: .ready) }
        bottomNavView.configure(with: content.navItems) { [weak self] item in
            self?.route(to: item.kind)
        }
        applySnapshot(content)
    }

    private func route(to kind: FitNavKind) {
        switch kind {
        case .home: coordinator?.showHome()
        case .workout: coordinator?.showWorkout()
        case .nutrition: coordinator?.showNutrition()
        case .sleep: Toast.show("Giấc ngủ đang được cập nhật", type: .info)
        case .profile: coordinator?.showProfile()
        }
    }

    private func applySnapshot(_ content: FitWorkoutContent) {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(FitWorkoutSection.allCases.map(\.rawValue))
        snapshot.appendItems(["banner"], toSection: FitWorkoutSection.banner.rawValue)
        snapshot.appendItems(["weekTitle"], toSection: FitWorkoutSection.weekTitle.rawValue)
        snapshot.appendItems(content.weekDays.indices.map { "day-\($0)" }, toSection: FitWorkoutSection.days.rawValue)
        snapshot.appendItems(["exercisesTitle"], toSection: FitWorkoutSection.exercisesTitle.rawValue)
        snapshot.appendItems(content.exercises.indices.map { "exercise-\($0)" }, toSection: FitWorkoutSection.exercises.rawValue)
        snapshot.appendItems(["summary"], toSection: FitWorkoutSection.summary.rawValue)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

final class FitNutritionViewController: BaseCollectionViewController<FitNutritionViewModel> {

    private weak var coordinator: FitCoordinating?
    private var dataSource: UICollectionViewDiffableDataSource<String, String>!
    private let topBarView = FitTopBarView()
    private let bottomNavView = FitBottomNavView()
    private var currentContent: FitNutritionContent?

    init(viewModel: FitNutritionViewModel, coordinator: FitCoordinating?) {
        self.coordinator = coordinator
        super.init(viewModel: viewModel)
    }

    override func configureCollectionLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard sectionIndex < FitNutritionSection.allCases.count else { return nil }
            return FitNutritionSection.allCases[sectionIndex].layout
        }
    }

    override func setupViews() {
        overrideUserInterfaceStyle = .dark
        super.setupViews()
        view.backgroundColor = FitColor.background
        topBarView.overrideUserInterfaceStyle = .dark
        bottomNavView.overrideUserInterfaceStyle = .dark
        view.addSubview(topBarView)
        view.addSubview(bottomNavView)
    }

    override func setupConstraints() {
        super.setupConstraints()
        topBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(90)
        }

        bottomNavView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(64)
        }

        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomNavView.snp.top)
        }
    }

    override func registerCollectionCells() {
        collectionView.registerCells(
            FitNutritionHeroCell.self,
            FitMacroCell.self,
            FitSectionTitleCell.self,
            FitMealCell.self,
            FitTipCell.self
        )
    }

    override func setupCollectionView() {
        collectionView.backgroundColor = FitColor.background
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset.bottom = AppSpacing.large
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self, let content = self.currentContent else { return nil }
            switch item {
            case "hero":
                let cell = collectionView.dequeue(FitNutritionHeroCell.self, for: indexPath)
                cell.configure(with: content)
                return cell
            case let id where id.hasPrefix("macro-"):
                guard let index = FitItemKey.index(from: id, prefix: "macro-"),
                      content.macros.indices.contains(index)
                else { return nil }
                let cell = collectionView.dequeue(FitMacroCell.self, for: indexPath)
                cell.configure(with: content.macros[index])
                return cell
            case "mealsTitle":
                let cell = collectionView.dequeue(FitSectionTitleCell.self, for: indexPath)
                cell.configure(title: content.mealsTitle, trailing: content.addText)
                return cell
            case let id where id.hasPrefix("meal-"):
                guard let index = FitItemKey.index(from: id, prefix: "meal-"),
                      content.meals.indices.contains(index)
                else { return nil }
                let cell = collectionView.dequeue(FitMealCell.self, for: indexPath)
                cell.configure(with: content.meals[index])
                return cell
            case "tip":
                let cell = collectionView.dequeue(FitTipCell.self, for: indexPath)
                cell.configure(title: content.tipTitle, subtitle: content.tipSubtitle)
                return cell
            default:
                return nil
            }
        }
    }

    override func setupBindings() {
        super.setupBindings()
        let output = viewModel.transform(input: FitNutritionViewModel.Input())
        output.content
            .drive(onNext: { [weak self] content in
                self?.render(content)
            })
            .disposed(by: disposeBag)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case "mealsTitle":
            Toast.show("Thêm bữa ăn đang được cập nhật", type: .info)
        case let id where id.hasPrefix("macro-"):
            Toast.show("Chi tiết macro đang được cập nhật", type: .info)
        case let id where id.hasPrefix("meal-"):
            Toast.show("Tính năng đang được cập nhật", type: .info)
        case "tip":
            Toast.show("Tính năng đang được cập nhật", type: .info)
        default:
            break
        }
    }

    private func render(_ content: FitNutritionContent) {
        currentContent = content
        topBarView.configure(backTitle: "< Fit", title: content.title, rightTitle: content.topPill)
        topBarView.onBackTap = { [weak self] in self?.coordinator?.showHome() }
        topBarView.onRightTap = { Toast.show("Lọc ngày đang được cập nhật", type: .info) }
        bottomNavView.configure(with: content.navItems) { [weak self] item in
            self?.route(to: item.kind)
        }
        applySnapshot(content)
    }

    private func route(to kind: FitNavKind) {
        switch kind {
        case .home: coordinator?.showHome()
        case .workout: coordinator?.showWorkout()
        case .nutrition: coordinator?.showNutrition()
        case .sleep: Toast.show("Giấc ngủ đang được cập nhật", type: .info)
        case .profile: coordinator?.showProfile()
        }
    }

    private func applySnapshot(_ content: FitNutritionContent) {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(FitNutritionSection.allCases.map(\.rawValue))
        snapshot.appendItems(["hero"], toSection: FitNutritionSection.hero.rawValue)
        snapshot.appendItems(content.macros.indices.map { "macro-\($0)" }, toSection: FitNutritionSection.macros.rawValue)
        snapshot.appendItems(["mealsTitle"], toSection: FitNutritionSection.mealsTitle.rawValue)
        snapshot.appendItems(content.meals.indices.map { "meal-\($0)" }, toSection: FitNutritionSection.meals.rawValue)
        snapshot.appendItems(["tip"], toSection: FitNutritionSection.tip.rawValue)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

final class FitProfileViewController: BaseCollectionViewController<FitProfileViewModel> {

    private weak var coordinator: FitCoordinating?
    private var dataSource: UICollectionViewDiffableDataSource<String, String>!
    private let topBarView = FitTopBarView()
    private let bottomNavView = FitBottomNavView()
    private var currentContent: FitProfileContent?

    init(viewModel: FitProfileViewModel, coordinator: FitCoordinating?) {
        self.coordinator = coordinator
        super.init(viewModel: viewModel)
    }

    override func configureCollectionLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard sectionIndex < FitProfileSection.allCases.count else { return nil }
            return FitProfileSection.allCases[sectionIndex].layout
        }
    }

    override func setupViews() {
        overrideUserInterfaceStyle = .dark
        super.setupViews()
        view.backgroundColor = FitColor.background
        topBarView.overrideUserInterfaceStyle = .dark
        bottomNavView.overrideUserInterfaceStyle = .dark
        view.addSubview(topBarView)
        view.addSubview(bottomNavView)
    }

    override func setupConstraints() {
        super.setupConstraints()
        topBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(90)
        }

        bottomNavView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(64)
        }

        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomNavView.snp.top)
        }
    }

    override func registerCollectionCells() {
        collectionView.registerCells(
            FitProfileHeroCell.self,
            FitProfileStatCell.self,
            FitSectionTitleCell.self,
            FitBodyMetricCell.self,
            FitGoalCell.self,
            FitSettingCell.self
        )
    }

    override func setupCollectionView() {
        collectionView.backgroundColor = FitColor.background
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset.bottom = AppSpacing.large
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self, let content = self.currentContent else { return nil }
            switch item {
            case "hero":
                let cell = collectionView.dequeue(FitProfileHeroCell.self, for: indexPath)
                cell.configure(with: content)
                return cell
            case let id where id.hasPrefix("stat-"):
                guard let index = FitItemKey.index(from: id, prefix: "stat-"),
                      content.stats.indices.contains(index)
                else { return nil }
                let cell = collectionView.dequeue(FitProfileStatCell.self, for: indexPath)
                cell.configure(with: content.stats[index])
                return cell
            case "bodyTitle":
                let cell = collectionView.dequeue(FitSectionTitleCell.self, for: indexPath)
                cell.configure(title: content.bodyTitle)
                return cell
            case "goalTitle":
                let cell = collectionView.dequeue(FitSectionTitleCell.self, for: indexPath)
                cell.configure(title: content.goalTitle)
                return cell
            case "settingsTitle":
                let cell = collectionView.dequeue(FitSectionTitleCell.self, for: indexPath)
                cell.configure(title: content.settingsTitle)
                return cell
            case let id where id.hasPrefix("bodyMetric-"):
                guard let index = FitItemKey.index(from: id, prefix: "bodyMetric-"),
                      content.bodyMetrics.indices.contains(index)
                else { return nil }
                let cell = collectionView.dequeue(FitBodyMetricCell.self, for: indexPath)
                cell.configure(with: content.bodyMetrics[index])
                return cell
            case let id where id.hasPrefix("goal-"):
                guard let index = FitItemKey.index(from: id, prefix: "goal-"),
                      content.goals.indices.contains(index)
                else { return nil }
                let cell = collectionView.dequeue(FitGoalCell.self, for: indexPath)
                cell.configure(with: content.goals[index])
                return cell
            case let id where id.hasPrefix("setting-"):
                guard let index = FitItemKey.index(from: id, prefix: "setting-"),
                      content.settings.indices.contains(index)
                else { return nil }
                let cell = collectionView.dequeue(FitSettingCell.self, for: indexPath)
                cell.configure(with: content.settings[index])
                return cell
            default:
                return nil
            }
        }
    }

    override func setupBindings() {
        super.setupBindings()
        let output = viewModel.transform(input: FitProfileViewModel.Input())
        output.content
            .drive(onNext: { [weak self] content in
                self?.render(content)
            })
            .disposed(by: disposeBag)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case let id where id.hasPrefix("stat-"):
            guard let content = currentContent,
                  let index = FitItemKey.index(from: id, prefix: "stat-"),
                  content.stats.indices.contains(index)
            else { return }
            route(from: content.stats[index])
        case let id where id.hasPrefix("goal-"):
            guard let content = currentContent,
                  let index = FitItemKey.index(from: id, prefix: "goal-"),
                  content.goals.indices.contains(index)
            else { return }
            route(from: content.goals[index])
        case let id where id.hasPrefix("setting-"):
            Toast.show("Tính năng đang được cập nhật", type: .info)
        case let id where id.hasPrefix("bodyMetric-"):
            Toast.show("Tính năng đang được cập nhật", type: .info)
        default:
            break
        }
    }

    private func render(_ content: FitProfileContent) {
        currentContent = content
        topBarView.configure(backTitle: "< Fit", title: content.title, rightTitle: content.editTitle)
        topBarView.onBackTap = { [weak self] in self?.coordinator?.showHome() }
        topBarView.onRightTap = { Toast.show("Chỉnh sửa hồ sơ đang được cập nhật", type: .info) }
        bottomNavView.configure(with: content.navItems) { [weak self] item in
            self?.route(to: item.kind)
        }
        applySnapshot(content)
    }

    private func route(to kind: FitNavKind) {
        switch kind {
        case .home: coordinator?.showHome()
        case .workout: coordinator?.showWorkout()
        case .nutrition: coordinator?.showNutrition()
        case .sleep: Toast.show("Giấc ngủ đang được cập nhật", type: .info)
        case .profile: coordinator?.showProfile()
        }
    }

    private func route(from stat: FitProfileStat) {
        if stat.subtitle.contains("ngày tập") {
            coordinator?.showWorkout()
        } else if stat.subtitle.contains("kcal") {
            coordinator?.showNutrition()
        } else if stat.subtitle.contains("sleep") {
            Toast.show("Giấc ngủ đang được cập nhật", type: .info)
        } else if stat.subtitle.contains("bước") {
            coordinator?.showRunning(state: .history)
        } else {
            Toast.show("Tính năng đang được cập nhật", type: .info)
        }
    }

    private func route(from goal: FitGoalItem) {
        if goal.title.contains("Giảm cân") {
            coordinator?.showNutrition()
        } else if goal.title.contains("Tăng cơ") {
            coordinator?.showWorkout()
        } else if goal.title.contains("tim mạch") {
            coordinator?.showRunning(state: .goalSetup)
        } else {
            Toast.show("Tính năng đang được cập nhật", type: .info)
        }
    }

    private func applySnapshot(_ content: FitProfileContent) {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(FitProfileSection.allCases.map(\.rawValue))
        snapshot.appendItems(["hero"], toSection: FitProfileSection.hero.rawValue)
        snapshot.appendItems(content.stats.indices.map { "stat-\($0)" }, toSection: FitProfileSection.stats.rawValue)
        snapshot.appendItems(["bodyTitle"], toSection: FitProfileSection.bodyTitle.rawValue)
        snapshot.appendItems(content.bodyMetrics.indices.map { "bodyMetric-\($0)" }, toSection: FitProfileSection.bodyMetrics.rawValue)
        snapshot.appendItems(["goalTitle"], toSection: FitProfileSection.goalTitle.rawValue)
        snapshot.appendItems(content.goals.indices.map { "goal-\($0)" }, toSection: FitProfileSection.goals.rawValue)
        snapshot.appendItems(["settingsTitle"], toSection: FitProfileSection.settingsTitle.rawValue)
        snapshot.appendItems(content.settings.indices.map { "setting-\($0)" }, toSection: FitProfileSection.settings.rawValue)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

final class FitRunningViewController: BaseCollectionViewController<FitRunningViewModel> {

    private weak var coordinator: FitCoordinating?
    private var dataSource: UICollectionViewDiffableDataSource<String, String>!
    private let mapView = FitRoutePreviewView()
    private let sheetView = UIView()
    private let sheetHandleView = UIView()
    private let topBarView = FitTopBarView()
    private let bottomNavView = FitBottomNavView()
    private var currentContent: FitRunningContent?
    private let state: FitRunningState
    private var sheetHeightConstraint: Constraint?
    private var currentSheetDetent: FitRunningSheetDetent = .middle
    private var currentSheetHeight: CGFloat = 0
    private var sheetPanStartHeight: CGFloat = 0
    private var isDraggingSheet = false

    private enum Metric {
        static let topBarHeight: CGFloat = 90
        static let bottomNavHeight: CGFloat = 64
        static let collapsedSheetHeight: CGFloat = 196
        static let middleSheetMinHeight: CGFloat = 360
        static let expandedTopGap: CGFloat = 12
        static let snapVelocity: CGFloat = 650
    }

    init(viewModel: FitRunningViewModel, coordinator: FitCoordinating?, state: FitRunningState) {
        self.coordinator = coordinator
        self.state = state
        super.init(viewModel: viewModel)
    }

    override func configureCollectionLayout() -> UICollectionViewLayout {
        let runningState = state
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard sectionIndex < FitRunningSection.allCases.count else { return nil }
            return FitRunningSection.allCases[sectionIndex].layout(for: runningState)
        }
    }

    override func setupViews() {
        overrideUserInterfaceStyle = .dark
        super.setupViews()
        view.backgroundColor = FitColor.background
        collectionView.removeFromSuperview()
        mapView.overrideUserInterfaceStyle = .dark
        mapView.layer.cornerRadius = 0
        mapView.layer.borderWidth = 0
        sheetView.backgroundColor = FitColor.surface.withAlphaComponent(0.96)
        sheetView.layer.cornerRadius = AppRadius.card
        sheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        sheetView.layer.borderWidth = 1
        sheetView.layer.borderColor = FitColor.border.cgColor
        sheetView.clipsToBounds = true
        sheetHandleView.backgroundColor = FitColor.textMuted.withAlphaComponent(0.42)
        sheetHandleView.layer.cornerRadius = 2
        topBarView.overrideUserInterfaceStyle = .dark
        bottomNavView.overrideUserInterfaceStyle = .dark
        view.insertSubview(mapView, at: 0)
        view.addSubview(sheetView)
        sheetView.addSubview(sheetHandleView)
        sheetView.addSubview(collectionView)
        view.addSubview(topBarView)
        view.addSubview(bottomNavView)
    }

    override func setupConstraints() {
        super.setupConstraints()
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        topBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(90)
        }

        bottomNavView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(64)
        }

        sheetView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomNavView.snp.top)
            sheetHeightConstraint = make.height.equalTo(sheetHeight(for: currentSheetDetent)).constraint
        }

        sheetHandleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppSpacing.small)
            make.centerX.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(4)
        }

        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(sheetHandleView.snp.bottom).offset(AppSpacing.small)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func registerCollectionCells() {
        collectionView.registerCells(
            FitRunningPanelCell.self,
            FitChipCell.self
        )
    }

    override func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        collectionView.isScrollEnabled = false
        collectionView.refreshControl = nil
        collectionView.contentInset.bottom = 0
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self, let content = self.currentContent else { return nil }
            switch item {
            case "panel":
                let cell = collectionView.dequeue(FitRunningPanelCell.self, for: indexPath)
                cell.configure(
                    with: content,
                    state: self.state,
                    onAction: { [weak self] action in
                        self?.handle(action)
                    },
                    onMusicTap: { [weak self] in
                        self?.handleMusicTap()
                    }
                )
                return cell
            case let id where id.hasPrefix("chip-"):
                guard let index = FitItemKey.index(from: id, prefix: "chip-"),
                      content.chips.indices.contains(index)
                else { return nil }
                let cell = collectionView.dequeue(FitChipCell.self, for: indexPath)
                cell.configure(text: content.chips[index])
                return cell
            default:
                return nil
            }
        }
    }

    override func setupActions() {
        super.setupActions()
        let sheetPan = UIPanGestureRecognizer(target: self, action: #selector(handleSheetPan(_:)))
        sheetView.addGestureRecognizer(sheetPan)

        let mapTap = UITapGestureRecognizer(target: self, action: #selector(didTapMap))
        mapView.addGestureRecognizer(mapTap)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard !isDraggingSheet else { return }
        updateSheetHeight(animated: false)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        guard scrollView === collectionView else { return }
        if currentSheetDetent == .expanded && scrollView.contentOffset.y <= 0 {
            if scrollView.panGestureRecognizer.translation(in: view).y > 0 {
                scrollView.contentOffset = .zero
                setSheetDetent(.middle, animated: true)
            }
        }
    }

    override func setupBindings() {
        super.setupBindings()
        let output = viewModel.transform(input: FitRunningViewModel.Input())
        output.content
            .drive(onNext: { [weak self] content in
                self?.render(content)
            })
            .disposed(by: disposeBag)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case "panel":
            break
        case "state":
            if state == .ready {
                coordinator?.showRunning(state: .locationPermission)
            }
        case "music":
            if state == .ready {
                coordinator?.showRunning(state: .musicPermission)
            } else {
                coordinator?.showRunning(state: .playlistPicker)
            }
        case let id where id.hasPrefix("chip-"):
            guard let content = currentContent,
                  let index = FitItemKey.index(from: id, prefix: "chip-"),
                  content.chips.indices.contains(index)
            else { return }
            if content.chips[index].contains("Mục tiêu") {
                coordinator?.showRunning(state: .goalSetup)
            } else if content.chips[index].contains("Outdoor") {
                coordinator?.showRunning(state: .locationPermission)
            } else if content.chips[index].contains("Auto pause") {
                coordinator?.showRunning(state: .backgroundBlocked)
            } else {
                Toast.show("Tính năng đang được cập nhật", type: .info)
            }
        case let id where id.hasPrefix("action-"):
            guard let content = currentContent,
                  let index = FitItemKey.index(from: id, prefix: "action-"),
                  content.actions.indices.contains(index)
            else { return }
            handle(content.actions[index])
        default:
            break
        }
    }

    private func render(_ content: FitRunningContent) {
        currentContent = content
        topBarView.configure(backTitle: "< Fit", title: content.title, rightTitle: content.topPill)
        topBarView.onBackTap = { [weak self] in self?.handleBackTap() }
        topBarView.onRightTap = { [weak self] in self?.handleTopPillTap() }
        bottomNavView.configure(with: content.navItems) { [weak self] item in
            self?.route(to: item.kind)
        }
        mapView.configure(labelText: content.mapLabelLeft, trailingText: content.mapLabelRight)
        applySnapshot()
        FitRunningLiveActivityController.shared.sync(state: state, content: content)
    }

    private func route(to kind: FitNavKind) {
        switch kind {
        case .home: coordinator?.showHome()
        case .workout: coordinator?.showWorkout()
        case .nutrition: coordinator?.showNutrition()
        case .sleep: Toast.show("Giấc ngủ đang được cập nhật", type: .info)
        case .profile: coordinator?.showProfile()
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections(FitRunningSection.allCases.map(\.rawValue))
        snapshot.appendItems(["panel"], toSection: FitRunningSection.panel.rawValue)

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func sheetHeight(for detent: FitRunningSheetDetent) -> CGFloat {
        let expandedHeight = max(
            Metric.collapsedSheetHeight,
            view.bounds.height
                - view.safeAreaInsets.top
                - view.safeAreaInsets.bottom
                - Metric.topBarHeight
                - Metric.bottomNavHeight
                - Metric.expandedTopGap
        )
        let collapsedHeight = min(Metric.collapsedSheetHeight, expandedHeight)
        let middleHeight = min(max(Metric.middleSheetMinHeight, expandedHeight * 0.58), expandedHeight)

        switch detent {
        case .collapsed:
            return collapsedHeight
        case .middle:
            return middleHeight
        case .expanded:
            return expandedHeight
        }
    }

    private func updateSheetHeight(animated: Bool) {
        setSheetHeight(sheetHeight(for: currentSheetDetent), animated: animated)
    }

    private func setSheetDetent(_ detent: FitRunningSheetDetent, animated: Bool) {
        currentSheetDetent = detent
        updateSheetHeight(animated: animated)
        collectionView.isScrollEnabled = (detent == .expanded)
    }

    private func setSheetHeight(_ height: CGFloat, animated: Bool) {
        currentSheetHeight = height
        sheetHeightConstraint?.update(offset: height)

        guard animated else { return }
        UIView.animate(
            withDuration: 0.28,
            delay: 0,
            usingSpringWithDamping: 0.86,
            initialSpringVelocity: 0.7,
            options: [.allowUserInteraction, .beginFromCurrentState]
        ) {
            self.view.layoutIfNeeded()
        }
    }

    private func clampedSheetHeight(_ height: CGFloat) -> CGFloat {
        min(max(height, sheetHeight(for: .collapsed)), sheetHeight(for: .expanded))
    }

    private func targetDetent(for height: CGFloat, velocityY: CGFloat) -> FitRunningSheetDetent {
        let detents = FitRunningSheetDetent.allCases
        if abs(velocityY) > Metric.snapVelocity,
           let currentIndex = detents.firstIndex(of: currentSheetDetent) {
            let nextIndex = velocityY < 0 ? currentIndex + 1 : currentIndex - 1
            return detents[min(max(nextIndex, 0), detents.count - 1)]
        }

        return detents.min {
            abs(sheetHeight(for: $0) - height) < abs(sheetHeight(for: $1) - height)
        } ?? .middle
    }

    @objc private func handleSheetPan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            isDraggingSheet = true
            sheetPanStartHeight = currentSheetHeight == 0 ? sheetHeight(for: currentSheetDetent) : currentSheetHeight
        case .changed:
            let translationY = gesture.translation(in: view).y
            let nextHeight = clampedSheetHeight(sheetPanStartHeight - translationY)
            currentSheetHeight = nextHeight
            sheetHeightConstraint?.update(offset: nextHeight)
            view.layoutIfNeeded()
        case .ended, .cancelled, .failed:
            let detent = targetDetent(for: currentSheetHeight, velocityY: gesture.velocity(in: view).y)
            isDraggingSheet = false
            AppAnimation.haptic(.light)
            setSheetDetent(detent, animated: true)
        default:
            break
        }
    }

    @objc private func didTapMap() {
        if state == .ready {
            coordinator?.showRunning(state: .locationPermission)
        } else if state == .active {
            coordinator?.showRunning(state: .gpsWeak)
        }
    }

    private func handleMusicTap() {
        if state == .ready {
            coordinator?.showRunning(state: .musicPermission)
        } else if state == .active || state == .paused || state == .confirmStop {
            coordinator?.showRunning(state: .playlistPicker)
        }
    }

    private func handleTopPillTap() {
        switch state {
        case .ready:
            coordinator?.showRunning(state: .locationPermission)
        case .active:
            coordinator?.showRunning(state: .paused)
        case .paused:
            coordinator?.showRunning(state: .active)
        case .confirmStop:
            coordinator?.showRunning(state: .summary)
        case .summary:
            coordinator?.showRunning(state: .history)
        case .locationPermission:
            coordinator?.showRunning(state: .active)
        case .gpsWeak:
            coordinator?.showRunning(state: .active)
        case .backgroundBlocked:
            openSystemSettings()
        case .musicPermission:
            coordinator?.showRunning(state: .playlistPicker)
        case .playlistPicker, .goalSetup:
            coordinator?.showRunning(state: .ready)
        case .history:
            coordinator?.showRunning(state: .ready)
        case .historyDetail:
            coordinator?.showRunning(state: .history)
        }
    }

    private func handleBackTap() {
        switch state {
        case .historyDetail:
            coordinator?.showRunning(state: .history)
        case .ready, .active, .paused, .confirmStop, .summary:
            coordinator?.showWorkout()
        case .locationPermission, .gpsWeak, .backgroundBlocked, .musicPermission, .playlistPicker, .goalSetup, .history:
            coordinator?.showRunning(state: .ready)
        }
    }

    private func handle(_ action: FitRunningAction) {
        switch action.title {
        case "Bắt đầu chạy":
            coordinator?.showRunning(state: .locationPermission)
        case "Lịch sử":
            coordinator?.showRunning(state: .history)
        case "Tạm dừng":
            coordinator?.showRunning(state: .paused)
        case "Kết thúc":
            coordinator?.showRunning(state: .confirmStop)
        case "Tiếp tục", "Tiếp tục chạy", "Chạy ngay khi mở app":
            coordinator?.showRunning(state: .active)
        case "Kết thúc và lưu":
            coordinator?.showRunning(state: .summary)
        case "Chạy lại":
            coordinator?.showRunning(state: .ready)
        case "Xong":
            handleDoneAction()
        case "Để sau":
            coordinator?.showWorkout()
        case "Cho phép":
            Toast.show("Đã cấp quyền vị trí", type: .success)
            coordinator?.showRunning(state: .active)
        case "Thử lại GPS":
            Toast.show("GPS đã ổn định hơn", type: .success)
            coordinator?.showRunning(state: .active)
        case "Mở cài đặt":
            openSystemSettings()
        case "Cho phép điều khiển nhạc":
            Toast.show("Đã bật quyền nhạc", type: .success)
            coordinator?.showRunning(state: .playlistPicker)
        case "Chạy không nhạc":
            Toast.show("Đã tắt nhạc cho buổi chạy này", type: .info)
            coordinator?.showRunning(state: .ready)
        case "Chưa có playlist", "Tạo playlist mới":
            Toast.show("Playlist đang được tạo", type: .info)
            coordinator?.showRunning(state: .playlistPicker)
        case "Run Boost Mix", "High Cadence Mix":
            Toast.show("Đã chọn playlist", type: .success)
            coordinator?.showRunning(state: .ready)
        case "5 km", "30 phút", "Không mục tiêu":
            Toast.show("Đã chọn \(action.title)", type: .success)
        case "Lưu mục tiêu":
            Toast.show("Đã lưu mục tiêu chạy", type: .success)
            coordinator?.showRunning(state: .ready)
        case let title where title.contains("km ·"):
            coordinator?.showRunning(state: .historyDetail)
        default:
            Toast.show("Tính năng đang được cập nhật", type: .info)
        }
    }

    private func handleDoneAction() {
        switch state {
        case .playlistPicker, .goalSetup:
            coordinator?.showRunning(state: .ready)
        case .historyDetail:
            coordinator?.showRunning(state: .history)
        default:
            coordinator?.showWorkout()
        }
    }

    private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url)
        else {
            Toast.show("Không mở được cài đặt hệ thống", type: .error)
            return
        }
        UIApplication.shared.open(url)
    }
}

private final class FitHomeHeaderView: UIView {

    private let greetingLabel = UILabel()
    private let nameLabel = UILabel()
    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    private let streakView = UIView()
    private let streakLabel = UILabel()
    private let dividerView = UIView()

    var onStreakTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = FitColor.navigation
        greetingLabel.font = AppFont.font(size: 12, weight: .regular)
        greetingLabel.textColor = FitColor.textMuted
        nameLabel.font = AppFont.font(size: 20, weight: .bold)
        nameLabel.textColor = FitColor.textPrimary
        avatarView.backgroundColor = FitColor.accent
        avatarView.layer.cornerRadius = 10
        avatarLabel.font = AppFont.font(size: 13, weight: .bold)
        avatarLabel.textColor = FitColor.textInverse
        avatarLabel.textAlignment = .center
        avatarView.addSubview(avatarLabel)
        avatarLabel.snp.makeConstraints { make in make.center.equalToSuperview() }
        streakView.backgroundColor = FitColor.warning
        streakView.layer.cornerRadius = 4
        streakLabel.font = AppFont.font(size: 10, weight: .medium)
        streakLabel.textColor = UIColor(hex: "#3B2800")
        streakView.addSubview(streakLabel)
        dividerView.backgroundColor = FitColor.border
        addSubview(greetingLabel)
        addSubview(nameLabel)
        addSubview(avatarView)
        addSubview(streakView)
        addSubview(dividerView)
        greetingLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.xLarge)
            make.top.equalToSuperview().offset(AppSpacing.xLarge)
            make.width.equalTo(200)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(greetingLabel)
            make.top.equalTo(greetingLabel.snp.bottom).offset(1)
            make.width.equalTo(200)
        }
        avatarView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.top.equalToSuperview().offset(18)
            make.size.equalTo(40)
        }
        streakView.snp.makeConstraints { make in
            make.trailing.equalTo(avatarView)
            make.top.equalTo(avatarView.snp.bottom).offset(4)
            make.width.equalTo(44)
            make.height.equalTo(18)
        }
        streakLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        dividerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }

        let streakTap = UITapGestureRecognizer(target: self, action: #selector(didTapStreak))
        streakView.isUserInteractionEnabled = true
        streakView.addGestureRecognizer(streakTap)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(greeting: String, name: String, energyBadge: String) {
        greetingLabel.text = greeting
        nameLabel.text = name
        avatarLabel.text = String(name.prefix(2)).uppercased()
        streakLabel.text = energyBadge
    }

    @objc private func didTapStreak() {
        AppAnimation.haptic(.light)
        onStreakTap?()
    }
}

final class FitErrorViewController: UIViewController {

    private weak var coordinator: FitCoordinating?

    private let errorImageView = UIImageView()
    private let errorLabel = UILabel()
    private let codeLabel = UILabel()
    private let timeLabel = UILabel()
    private let retryButton = UIButton()
    private let manualButton = UIButton()

    init(coordinator: FitCoordinating?) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = FitColor.background
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        errorImageView.image = UIImage(named: "fit_error_sync")
        errorImageView.contentMode = .scaleAspectFit

        errorLabel.text = "Đã xảy ra lỗi đồng bộ dữ liệu"
        errorLabel.font = AppFont.headline
        errorLabel.textColor = FitColor.textPrimary
        errorLabel.textAlignment = .center

        codeLabel.text = "Mã lỗi: FIT_SYNC_409"
        codeLabel.font = AppFont.bodyMedium
        codeLabel.textColor = FitColor.danger
        codeLabel.textAlignment = .center

        timeLabel.text = "Lần đồng bộ cuối: Hôm nay · 08:15"
        timeLabel.font = AppFont.caption
        timeLabel.textColor = FitColor.textSecondary
        timeLabel.textAlignment = .center

        retryButton.setTitle("Thử lại", for: .normal)
        retryButton.setTitleColor(FitColor.textInverse, for: .normal)
        retryButton.backgroundColor = FitColor.accent
        retryButton.layer.cornerRadius = 28
        retryButton.titleLabel?.font = AppFont.font(size: 15, weight: .bold)
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)

        manualButton.setTitle("Ghi thủ công", for: .normal)
        manualButton.setTitleColor(FitColor.textPrimary, for: .normal)
        manualButton.layer.borderColor = FitColor.accent.cgColor
        manualButton.layer.borderWidth = 1
        manualButton.layer.cornerRadius = 28
        manualButton.titleLabel?.font = AppFont.font(size: 15, weight: .bold)
        manualButton.addTarget(self, action: #selector(didTapManual), for: .touchUpInside)

        view.addSubview(errorImageView)
        view.addSubview(errorLabel)
        view.addSubview(codeLabel)
        view.addSubview(timeLabel)
        view.addSubview(retryButton)
        view.addSubview(manualButton)
    }

    private func setupConstraints() {
        errorImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-130)
            make.centerX.equalToSuperview()
            make.size.equalTo(120)
        }

        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(errorImageView.snp.bottom).offset(AppSpacing.xLarge)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
        }

        codeLabel.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(AppSpacing.medium)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(codeLabel.snp.bottom).offset(AppSpacing.small)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
        }

        retryButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(AppSpacing.xLarge * 2)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge * 2)
            make.height.equalTo(56)
        }

        manualButton.snp.makeConstraints { make in
            make.top.equalTo(retryButton.snp.bottom).offset(AppSpacing.medium)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge * 2)
            make.height.equalTo(56)
        }
    }

    @objc private func didTapRetry() {
        AppAnimation.haptic(.light)
        coordinator?.showHome()
    }

    @objc private func didTapManual() {
        AppAnimation.haptic(.light)
        coordinator?.showWorkout()
    }
}
