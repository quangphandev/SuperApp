//
//  TimerViewController.swift
//  SuperApp_PQ
//
//  Created by Codex on 12/06/26.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class TimerViewController: BaseViewController<TimerViewModel> {

    private weak var coordinator: TimerCoordinating?
    private let state: TimerScreenState
    private let topBarView = TimerTopBarView()
    private let bottomNavView = TimerBottomNavView()
    private let contentScrollView = UIScrollView()
    private let contentStackView = UIStackView()

    init(viewModel: TimerViewModel, coordinator: TimerCoordinating?, state: TimerScreenState) {
        self.coordinator = coordinator
        self.state = state
        super.init(viewModel: viewModel)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func setupViews() {
        overrideUserInterfaceStyle = .dark
        super.setupViews()
        view.backgroundColor = TimerColor.background
        topBarView.overrideUserInterfaceStyle = .dark
        bottomNavView.overrideUserInterfaceStyle = .dark
        contentScrollView.backgroundColor = TimerColor.background
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.alwaysBounceVertical = true
        contentStackView.axis = .vertical
        contentStackView.spacing = AppSpacing.medium
        contentStackView.alignment = .fill
        view.addSubview(topBarView)
        view.addSubview(bottomNavView)
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(contentStackView)
    }

    override func setupConstraints() {
        super.setupConstraints()
        topBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(90)
        }

        bottomNavView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(64)
        }

        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomNavView.snp.top)
        }

        contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(AppSpacing.xLarge)
            make.leading.trailing.equalTo(view).inset(AppSpacing.xLarge)
            make.width.equalTo(view).offset(-AppSpacing.xLarge * 2)
        }
    }

    override func setupBindings() {
        super.setupBindings()
        let output = viewModel.transform(input: TimerViewModel.Input())
        output.content
            .drive(onNext: { [weak self] content in
                self?.render(content)
            })
            .disposed(by: disposeBag)
    }

    private func render(_ content: TimerScreenContent) {
        topBarView.configure(backTitle: content.backTitle, title: content.title, pill: content.topPill)
        topBarView.onBackTap = { [weak self] in self?.handleBackTap() }
        topBarView.onRightTap = { [weak self] in self?.handleTopPillTap() }
        bottomNavView.isHidden = content.navItems.isEmpty
        bottomNavView.configure(with: content.navItems) { [weak self] item in
            self?.route(to: item.kind)
        }
        removeArrangedSubviews()
        content.blocks.forEach { block in
            guard let view = makeView(for: block) else { return }
            contentStackView.addArrangedSubview(view)
        }
    }

    private func makeView(for block: TimerBlock) -> UIView? {
        switch block {
        case .hero(let content):
            let view = TimerHeroView()
            view.configure(with: content)
            view.onActionTap = { [weak self] in
                self?.handleHeroAction(content.actionTitle)
            }
            return view
        case .stats(let items):
            guard !items.isEmpty else { return nil }
            let view = TimerStatGridView(items: items)
            view.snp.makeConstraints { make in
                make.height.equalTo(70)
            }
            return view
        case .sectionTitle(let title):
            let view = TimerSectionTitleView(title: title)
            view.snp.makeConstraints { make in
                make.height.equalTo(20)
            }
            return view
        case .rows(let rows):
            guard !rows.isEmpty else { return nil }
            return TimerRowsView(rows: rows) { [weak self] row in
                self?.handle(row)
            }
        case .durationPicker(let items):
            guard !items.isEmpty else { return nil }
            return TimerDurationPickerView(items: items)
        case .timerRing(let content):
            return TimerRingView(content: content)
        case .controls(let items):
            guard !items.isEmpty else { return nil }
            return TimerControlsView(items: items) { [weak self] item in
                self?.handle(item)
            }
        case .progress(let content):
            return TimerProgressCardView(content: content)
        case .state(let content):
            return TimerStateCardView(content: content)
        case .buttons(let items):
            guard !items.isEmpty else { return nil }
            return TimerButtonsView(items: items) { [weak self] item in
                self?.handle(item)
            }
        case .segmented(let content):
            return TimerSegmentedView(content: content)
        case .pipPreview(let content):
            return TimerPIPPreviewView(content: content)
        }
    }

    private func route(to kind: TimerNavKind) {
        switch kind {
        case .timer:
            coordinator?.showTimer(state: .home)
        case .focus:
            coordinator?.showTimer(state: .focusSetup)
        case .stopwatch:
            coordinator?.showTimer(state: .stopwatch)
        case .presets:
            coordinator?.showTimer(state: .presets)
        case .settings:
            coordinator?.showTimer(state: .settings)
        }
    }

    private func handleHeroAction(_ title: String?) {
        switch title {
        case "Bắt đầu focus":
            coordinator?.showTimer(state: .focusSetup)
        case "Dùng gợi ý":
            coordinator?.showTimer(state: .focusRunning)
        default:
            Toast.show("Tính năng đang được cập nhật", type: .info)
        }
    }

    private func handle(_ row: TimerRowItem) {
        switch row.title {
        case "Tùy chỉnh timer":
            coordinator?.showTimer(state: .focusSetup)
        case "Săn sale flash 20:00", "Flash sale voucher":
            coordinator?.showTimer(state: .targetDetail)
        case "Tracking & PIP", "PIP đang tắt":
            coordinator?.showTimer(state: .tracking)
        case "Checklist săn sale", "T-10 phút", "T-60 giây", "T-10 giây", "Đúng giờ":
            coordinator?.showTimer(state: .alertRules)
        case "Xóa lịch sử timer":
            coordinator?.showTimer(state: .deleteTargetConfirm)
        case "Cloud sync lỗi":
            coordinator?.showTimer(state: .targetSyncConflict)
        default:
            handleRowAction(row.actionTitle)
        }
    }

    private func handleRowAction(_ title: String?) {
        switch title {
        case "Start":
            coordinator?.showTimer(state: .focusRunning)
        case "Sửa", "Tạo", "Set", "Dùng", "Chọn":
            coordinator?.showTimer(state: .targetForm)
        case "Track":
            coordinator?.showTimer(state: .targetDetail)
        case "PIP", "Thiết lập", "Cài":
            coordinator?.showTimer(state: .pipSetup)
        case "ON", "OFF", "Đổi", "Xem", "Log", "Info", "Use", "OK", "Required", "Risk", "Live":
            Toast.show("Đã ghi nhận lựa chọn", type: .info)
        default:
            Toast.show("Tính năng đang được cập nhật", type: .info)
        }
    }

    private func handle(_ item: TimerButtonItem) {
        switch item.title {
        case "Bắt đầu 25:00", "Thử lại", "Dùng local", "Tạo lại ngày mai":
            coordinator?.showTimer(state: .focusRunning)
        case "Ⅱ":
            coordinator?.showTimer(state: .focusPaused)
        case "■", "Kết thúc sớm", "Đánh dấu đã xong":
            coordinator?.showTimer(state: .focusDone)
        case "+5", "Lap", "Reset":
            Toast.show("Đã cập nhật timer", type: .success)
        case "Tiếp tục":
            coordinator?.showTimer(state: .focusRunning)
        case "Bắt đầu nghỉ":
            coordinator?.showTimer(state: .focusRunning)
        case "Về Timer", "Dừng", "Snooze 1 phút":
            coordinator?.showTimer(state: .home)
        case "+ Thêm mốc giờ", "Thêm mốc giờ", "Sửa mốc giờ":
            coordinator?.showTimer(state: .targetForm)
        case "Lưu mốc giờ":
            coordinator?.showTimer(state: .tracking)
        case "Cài cảnh báo":
            coordinator?.showTimer(state: .alertRules)
        case "Lưu cảnh báo":
            coordinator?.showTimer(state: .targetDetail)
        case "Mở PIP", "Bật PIP", "Mở lại PIP":
            coordinator?.showTimer(state: .pipFloating)
            coordinator?.startFloatingPIP()
        case "Mở":
            coordinator?.dismissFloatingPIP()
            coordinator?.showTimer(state: .targetDetail)
        case "Ẩn", "Ghim", "Theo dõi trong app", "Dùng fallback":
            coordinator?.showTimer(state: .tracking)
        case "Mở cài đặt thông báo", "Bật quyền alarm", "Đồng bộ giờ", "Tiếp tục với cảnh báo", "Dùng best-effort", "Để sau":
            coordinator?.showTimer(state: .tracking)
        case "Xóa mốc này":
            coordinator?.showTimer(state: .deleteTargetConfirm)
        case "Xóa mốc giờ":
            coordinator?.showTimer(state: .tracking)
        case "Giữ lại", "Giữ bản máy này", "Dùng bản cloud":
            coordinator?.showTimer(state: .targetDetail)
        default:
            Toast.show("Tính năng đang được cập nhật", type: .info)
        }
    }

    private func handleTopPillTap() {
        switch state {
        case .home:
            coordinator?.showTimer(state: .tracking)
        case .tracking:
            coordinator?.showTimer(state: .alarmRinging)
        case .targetDetail:
            coordinator?.showTimer(state: .alarmRinging)
        case .settings:
            coordinator?.showTimer(state: .tracking)
        default:
            Toast.show("Tính năng đang được cập nhật", type: .info)
        }
    }

    private func handleBackTap() {
        switch state {
        case .home:
            coordinator?.closeTimer()
        case .targetDetail, .targetForm, .alertRules, .pipSetup, .pipFloating,
             .trackingEmpty, .trackingLoading, .trackingError, .targetMissed,
             .deviceTimeDrift, .notificationPermission, .exactAlarmPermission,
             .pipUnsupported, .pipSuspended, .deleteTargetConfirm, .targetSyncConflict:
            coordinator?.showTimer(state: .tracking)
        case .focusRunning, .focusPaused, .focusDone, .focusSetup,
             .presets, .stopwatch, .settings, .tracking, .alarmRinging:
            coordinator?.showTimer(state: .home)
        }
    }

    private func removeArrangedSubviews() {
        contentStackView.arrangedSubviews.forEach { view in
            contentStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
