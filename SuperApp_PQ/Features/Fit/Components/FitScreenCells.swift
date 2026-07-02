//
//  FitScreenCells.swift
//  SuperApp_PQ
//
//  Created by Codex on 08/06/26.
//

import SnapKit
import UIKit

class FitHostedCell: BaseCollectionCell {

    private var hostedView: UIView?

    override func setupViews() {
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = false
        clipsToBounds = false
    }

    func host(_ view: UIView) {
        hostedView?.removeFromSuperview()
        hostedView = view
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

final class FitSectionTitleCell: BaseCollectionCell {

    private let titleLabel = UILabel()
    private let trailingLabel = UILabel()

    override func setupViews() {
        contentView.backgroundColor = .clear
        titleLabel.font = AppFont.font(size: 11, weight: .medium)
        titleLabel.textColor = FitColor.textMuted
        trailingLabel.font = AppFont.font(size: 11, weight: .medium)
        trailingLabel.textColor = FitColor.accent
        trailingLabel.textAlignment = .right
        contentView.addSubview(titleLabel)
        contentView.addSubview(trailingLabel)
    }

    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(trailingLabel.snp.leading).offset(-AppSpacing.medium)
        }

        trailingLabel.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }
    }

    func configure(title: String, trailing: String? = nil, trailingColor: UIColor = FitColor.accent) {
        titleLabel.text = title
        trailingLabel.text = trailing
        trailingLabel.textColor = trailingColor
        trailingLabel.isHidden = trailing == nil
    }
}

final class FitHomeTodayCell: FitHostedCell {

    func configure(with content: FitHomeContent) {
        let view = FitTodayCardView()
        view.configure(with: content)
        host(view)
    }
}

final class FitQuickStatCell: FitHostedCell {

    func configure(with item: FitQuickStat) {
        host(FitQuickStatCardView(item: item))
    }
}

final class FitWorkoutPreviewCell: FitHostedCell {

    func configure(title: String, subtitle: String, progress: CGFloat) {
        let view = FitWorkoutPreviewView()
        view.configure(title: title, subtitle: subtitle, progress: progress)
        host(view)
    }
}

final class FitActiveExerciseCell: FitHostedCell {

    func configure(title: String, subtitle: String) {
        let view = FitActiveExerciseView()
        view.configure(title: title, subtitle: subtitle)
        host(view)
    }
}

final class FitRunningQuickActionCell: FitHostedCell {

    func configure(title: String) {
        let view = FitRunningQuickActionView()
        view.configure(title: title)
        host(view)
    }
}

final class FitHealthCardCell: FitHostedCell {

    func configure(with item: FitHomeHealthCard) {
        host(FitHealthCardView(item: item))
    }
}

final class FitHabitCell: FitHostedCell {

    func configure(with item: FitHabitItem) {
        host(FitHabitRowView(item: item))
    }
}

final class FitWorkoutBannerCell: FitHostedCell {

    func configure(title: String, subtitle: String) {
        let view = FitWorkoutBannerView()
        view.configure(title: title, subtitle: subtitle)
        host(view)
    }
}

final class FitWorkoutDayCell: FitHostedCell {

    func configure(with item: FitWorkoutDay) {
        host(FitWorkoutDayView(item: item))
    }
}

final class FitWorkoutExerciseCell: FitHostedCell {

    func configure(with item: FitWorkoutItem) {
        host(FitWorkoutExerciseRowView(item: item))
    }
}

final class FitSummaryCell: FitHostedCell {

    func configure(left: String, right: String) {
        let view = FitSummaryCardView()
        view.configure(left: left, right: right)
        host(view)
    }
}

final class FitNutritionHeroCell: FitHostedCell {

    func configure(with content: FitNutritionContent) {
        let view = FitNutritionHeroView()
        view.configure(
            title: content.caloriesTitle,
            value: content.caloriesValue,
            meta: content.caloriesMeta,
            remaining: content.caloriesRemaining,
            progress: content.caloriesProgress
        )
        host(view)
    }
}

final class FitMacroCell: FitHostedCell {

    func configure(with item: FitMacroItem) {
        host(FitMacroCardView(item: item))
    }
}

final class FitMealCell: FitHostedCell {

    func configure(with item: FitMealItem) {
        host(FitMealRowView(item: item))
    }
}

final class FitTipCell: FitHostedCell {

    func configure(title: String, subtitle: String) {
        let view = FitTipCardView()
        view.configure(title: title, subtitle: subtitle)
        host(view)
    }
}

final class FitProfileHeroCell: FitHostedCell {

    func configure(with content: FitProfileContent) {
        let view = FitProfileHeroView()
        view.configure(
            name: content.heroName,
            subtitle: content.heroSubtitle,
            joinedTitle: content.joinedTitle,
            energyBadge: content.energyBadge
        )
        host(view)
    }
}

final class FitProfileStatCell: FitHostedCell {

    func configure(with item: FitProfileStat) {
        host(FitProfileStatView(item: item))
    }
}

final class FitBodyMetricCell: FitHostedCell {

    func configure(with item: FitBodyMetric) {
        host(FitBodyMetricCardView(item: item))
    }
}

final class FitGoalCell: FitHostedCell {

    func configure(with item: FitGoalItem) {
        host(FitGoalRowView(item: item))
    }
}

final class FitSettingCell: FitHostedCell {

    func configure(with item: FitSettingItem) {
        host(FitSettingRowView(item: item))
    }
}

final class FitRoutePreviewCell: FitHostedCell {

    func configure(with content: FitRunningContent) {
        let view = FitRoutePreviewView()
        view.configure(labelText: content.mapLabelLeft, trailingText: content.mapLabelRight)
        host(view)
    }
}

final class FitRunningStateCell: FitHostedCell {

    func configure(with content: FitRunningContent, state: FitRunningState) {
        let view = FitRunningStateCardView()
        view.configure(content: content, state: state)
        host(view)
    }
}

final class FitRunningPanelCell: FitHostedCell {

    func configure(
        with content: FitRunningContent,
        state: FitRunningState,
        onAction: @escaping (FitRunningAction) -> Void,
        onMusicTap: @escaping () -> Void
    ) {
        let view = FitRunningSessionPanelView()
        view.configure(
            with: content,
            state: state,
            onAction: onAction,
            onMusicTap: onMusicTap
        )
        host(view)
    }
}

final class FitRunningStatCell: FitHostedCell {

    func configure(with item: FitRunningStat, isReady: Bool) {
        if isReady {
            host(FitRunningReadyStatView(item: item))
        } else {
            host(FitRunningStatCardView(item: item))
        }
    }
}

final class FitRunningMusicCell: FitHostedCell {

    func configure(with content: FitRunningContent, state: FitRunningState) {
        let view = FitRunningMusicView()
        view.configure(
            title: content.musicTitle,
            subtitle: content.musicSubtitle,
            actionTitle: content.musicActionTitle,
            state: state
        )
        host(view)
    }
}

final class FitRunningActionCell: FitHostedCell {

    func configure(with item: FitRunningAction) {
        host(FitRunningActionButton(item: item))
    }
}

final class FitChipCell: FitHostedCell {

    func configure(text: String) {
        host(FitChipView(text: text))
    }
}

// MARK: - Small Views

private final class FitRunningSessionPanelView: FitCardView {

    private let rootStackView = UIStackView()
    private let statusLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let statsStackView = UIStackView()
    private let musicButton = UIControl()
    private let musicTitleLabel = UILabel()
    private let musicSubtitleLabel = UILabel()
    private let musicActionLabel = UILabel()
    private let actionsStackView = UIStackView()
    private let chipsStackView = UIStackView()
    private let footerLabel = UILabel()
    private var onMusicTap: (() -> Void)?

    override init() {
        super.init()
        layer.cornerRadius = 12
        layer.borderWidth = 0
        setupContent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(
        with content: FitRunningContent,
        state: FitRunningState,
        onAction: @escaping (FitRunningAction) -> Void,
        onMusicTap: @escaping () -> Void
    ) {
        self.onMusicTap = onMusicTap
        statusLabel.text = content.topPill
        statusLabel.backgroundColor = statusColor(for: state)
        titleLabel.text = content.bannerTitle.isEmpty ? content.title : content.bannerTitle
        subtitleLabel.text = content.bannerSubtitle.isEmpty ? content.sublabel : content.bannerSubtitle
        subtitleLabel.isHidden = subtitleLabel.text?.isEmpty ?? true
        configureStats(content.stats)
        configureMusic(content: content)
        configureActions(content.actions, onAction: onAction)
        configureChips(content.chips)
        footerLabel.text = content.footerNote
        footerLabel.isHidden = content.footerNote == nil
    }

    private func setupContent() {
        rootStackView.axis = .vertical
        rootStackView.spacing = AppSpacing.medium
        rootStackView.alignment = .fill
        statusLabel.font = AppFont.font(size: 11, weight: .medium)
        statusLabel.textColor = FitColor.textInverse
        statusLabel.textAlignment = .center
        statusLabel.layer.cornerRadius = 11
        statusLabel.clipsToBounds = true
        titleLabel.font = AppFont.font(size: 22, weight: .bold)
        titleLabel.textColor = FitColor.textPrimary
        subtitleLabel.font = AppFont.font(size: 12, weight: .regular)
        subtitleLabel.textColor = FitColor.textSecondary
        subtitleLabel.numberOfLines = 2
        statsStackView.axis = .vertical
        statsStackView.spacing = AppSpacing.small
        musicButton.backgroundColor = FitColor.elevatedSurface
        musicButton.layer.cornerRadius = AppRadius.small
        musicButton.addTarget(self, action: #selector(didTapMusic), for: .touchUpInside)
        musicTitleLabel.font = AppFont.font(size: 13, weight: .medium)
        musicTitleLabel.textColor = FitColor.textPrimary
        musicSubtitleLabel.font = AppFont.font(size: 11, weight: .regular)
        musicSubtitleLabel.textColor = FitColor.textMuted
        musicActionLabel.font = AppFont.font(size: 11, weight: .medium)
        musicActionLabel.textColor = FitColor.accent
        actionsStackView.axis = .vertical
        actionsStackView.spacing = AppSpacing.small
        chipsStackView.axis = .horizontal
        chipsStackView.spacing = AppSpacing.small
        chipsStackView.distribution = .fillEqually
        footerLabel.font = AppFont.font(size: 11, weight: .regular)
        footerLabel.textColor = FitColor.textMuted
        footerLabel.numberOfLines = 2

        let header = UIView()
        header.addSubview(titleLabel)
        header.addSubview(statusLabel)
        header.addSubview(subtitleLabel)
        rootStackView.addArrangedSubview(header)
        rootStackView.addArrangedSubview(statsStackView)
        rootStackView.addArrangedSubview(musicButton)
        rootStackView.addArrangedSubview(actionsStackView)
        rootStackView.addArrangedSubview(chipsStackView)
        rootStackView.addArrangedSubview(footerLabel)
        addSubview(rootStackView)

        rootStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(AppSpacing.large)
        }
        header.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(58)
        }
        statusLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.width.greaterThanOrEqualTo(72)
            make.height.equalTo(22)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.trailing.lessThanOrEqualTo(statusLabel.snp.leading).offset(-AppSpacing.medium)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        musicButton.snp.makeConstraints { make in
            make.height.equalTo(54)
        }
        setupMusicContent()
    }

    private func setupMusicContent() {
        let iconView = UIView()
        let iconLabel = UILabel()
        let textStackView = UIStackView(arrangedSubviews: [musicTitleLabel, musicSubtitleLabel])
        iconView.backgroundColor = FitColor.accentSoft
        iconView.layer.cornerRadius = 8
        iconLabel.text = "♪"
        iconLabel.font = AppFont.font(size: 18, weight: .bold)
        iconLabel.textColor = FitColor.accent
        iconLabel.textAlignment = .center
        textStackView.axis = .vertical
        textStackView.spacing = 2
        musicButton.addSubview(iconView)
        iconView.addSubview(iconLabel)
        musicButton.addSubview(textStackView)
        musicButton.addSubview(musicActionLabel)
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.medium)
            make.centerY.equalToSuperview()
            make.size.equalTo(34)
        }
        iconLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        textStackView.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(AppSpacing.medium)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(musicActionLabel.snp.leading).offset(-AppSpacing.medium)
        }
        musicActionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(AppSpacing.medium)
            make.centerY.equalToSuperview()
        }
    }

    private func configureStats(_ stats: [FitRunningStat]) {
        removeArrangedSubviews(from: statsStackView)
        statsStackView.isHidden = stats.isEmpty

        stats.chunked(by: 3).forEach { rowStats in
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = AppSpacing.small
            rowStackView.distribution = .fillEqually
            rowStats.forEach { stat in
                rowStackView.addArrangedSubview(FitRunningPanelStatView(item: stat))
            }
            statsStackView.addArrangedSubview(rowStackView)
        }
    }

    private func configureMusic(content: FitRunningContent) {
        let isHidden = content.musicTitle.isEmpty && content.musicSubtitle.isEmpty
        musicButton.isHidden = isHidden
        musicTitleLabel.text = content.musicTitle
        musicSubtitleLabel.text = content.musicSubtitle
        musicActionLabel.text = content.musicActionTitle
    }

    private func configureActions(
        _ actions: [FitRunningAction],
        onAction: @escaping (FitRunningAction) -> Void
    ) {
        removeArrangedSubviews(from: actionsStackView)
        actionsStackView.isHidden = actions.isEmpty

        actions.chunked(by: 2).forEach { rowActions in
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = AppSpacing.small
            rowStackView.distribution = .fillEqually
            rowActions.forEach { action in
                let view = FitRunningPanelActionView(action: action)
                view.onTap = { onAction(action) }
                rowStackView.addArrangedSubview(view)
            }
            if rowActions.count == 1 {
                rowStackView.addArrangedSubview(UIView())
            }
            actionsStackView.addArrangedSubview(rowStackView)
        }
    }

    private func configureChips(_ chips: [String]) {
        removeArrangedSubviews(from: chipsStackView)
        chipsStackView.isHidden = chips.isEmpty
        chips.prefix(3).forEach { chip in
            chipsStackView.addArrangedSubview(FitChipView(text: chip))
        }
    }

    private func statusColor(for state: FitRunningState) -> UIColor {
        switch state {
        case .active:
            return FitColor.accent
        case .paused, .confirmStop:
            return FitColor.warning
        case .gpsWeak, .backgroundBlocked, .locationPermission:
            return FitColor.danger
        case .summary, .history, .historyDetail:
            return FitColor.success
        case .ready, .musicPermission, .playlistPicker, .goalSetup:
            return FitColor.accent
        }
    }

    private func removeArrangedSubviews(from stack: UIStackView) {
        stack.arrangedSubviews.forEach { view in
            stack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }

    @objc private func didTapMusic() {
        AppAnimation.haptic(.light)
        onMusicTap?()
    }
}

private final class FitRunningPanelStatView: UIView {

    init(item: FitRunningStat) {
        super.init(frame: .zero)
        setupContent(item: item)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private func setupContent(item: FitRunningStat) {
        backgroundColor = FitColor.elevatedSurface
        layer.cornerRadius = AppRadius.small
        let titleLabel = UILabel()
        let valueLabel = UILabel()
        let subtitleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = AppFont.font(size: 9, weight: .medium)
        titleLabel.textColor = FitColor.textMuted
        valueLabel.text = item.value
        valueLabel.font = AppFont.font(size: 17, weight: .bold)
        valueLabel.textColor = FitColor.textPrimary
        subtitleLabel.text = item.subtitle
        subtitleLabel.font = AppFont.font(size: 10, weight: .regular)
        subtitleLabel.textColor = FitColor.textMuted
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(subtitleLabel)
        snp.makeConstraints { make in
            make.height.equalTo(54)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(AppSpacing.small)
            make.trailing.equalToSuperview().inset(AppSpacing.small)
        }
        valueLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(valueLabel.snp.trailing).offset(2)
            make.lastBaseline.equalTo(valueLabel)
            make.trailing.lessThanOrEqualToSuperview().inset(AppSpacing.small)
        }
    }
}

private final class FitRunningPanelActionView: UIControl {

    var onTap: (() -> Void)?

    private let action: FitRunningAction

    init(action: FitRunningAction) {
        self.action = action
        super.init(frame: .zero)
        setupContent()
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private func setupContent() {
        backgroundColor = isPrimary ? FitColor.accent : FitColor.elevatedSurface
        layer.cornerRadius = 28 // spec: Border radius button | 28px
        layer.borderWidth = isPrimary ? 0 : 1
        layer.borderColor = FitColor.border.cgColor
        let titleLabel = UILabel()
        let subtitleLabel = UILabel()
        let trailingLabel = UILabel()
        titleLabel.text = action.title
        titleLabel.font = AppFont.font(size: 13, weight: .medium)
        titleLabel.textColor = isPrimary ? FitColor.textInverse : FitColor.textPrimary
        subtitleLabel.text = action.subtitle
        subtitleLabel.font = AppFont.font(size: 10, weight: .regular)
        subtitleLabel.textColor = isPrimary ? FitColor.textInverse.withAlphaComponent(0.72) : FitColor.textMuted
        subtitleLabel.isHidden = action.subtitle == nil
        trailingLabel.text = action.trailingText ?? actionIcon
        trailingLabel.font = AppFont.font(size: 12, weight: .medium)
        trailingLabel.textColor = isPrimary ? FitColor.textInverse : FitColor.accent
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(trailingLabel)
        snp.makeConstraints { make in
            make.height.equalTo(56) // Perfect pill shape height
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.medium)
            make.centerY.equalToSuperview().offset(action.subtitle == nil ? 0 : -7)
            make.trailing.lessThanOrEqualTo(trailingLabel.snp.leading).offset(-AppSpacing.small)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.trailing.lessThanOrEqualTo(trailingLabel.snp.leading).offset(-AppSpacing.small)
        }
        trailingLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(AppSpacing.medium)
            make.centerY.equalToSuperview()
        }
    }

    private var isPrimary: Bool {
        action.title.contains("Bắt đầu") ||
        action.title.contains("Tiếp tục") ||
        action.title.contains("Cho phép") ||
        action.title.contains("Lưu")
    }

    private var actionIcon: String {
        switch action.icon {
        case "pause.fill":
            return "Pause"
        case "play.fill":
            return "Play"
        case "xmark":
            return "Stop"
        default:
            return "→"
        }
    }

    @objc private func didTap() {
        AppAnimation.haptic(.light)
        onTap?()
    }
}

private final class FitTodayCardView: FitCardView {

    private let eyebrowLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let progressView = FitProgressView()
    private let progressLabel = UILabel()

    override init() {
        super.init()
        layer.cornerRadius = 12
        layer.borderWidth = 0
        setupContent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with content: FitHomeContent) {
        eyebrowLabel.text = content.progressTitle
        titleLabel.text = content.progressSubtitle.replacingOccurrences(of: " 💪", with: "")
        subtitleLabel.text = content.progressValue
        progressLabel.text = content.progressPercent
        progressView.configure(progress: percentValue(from: content.progressPercent))
    }

    private func setupContent() {
        eyebrowLabel.font = AppFont.font(size: 10, weight: .medium)
        eyebrowLabel.textColor = FitColor.textMuted
        titleLabel.font = AppFont.font(size: 15, weight: .bold)
        titleLabel.textColor = FitColor.textPrimary
        subtitleLabel.font = AppFont.font(size: 11, weight: .regular)
        subtitleLabel.textColor = FitColor.textSecondary
        progressLabel.font = AppFont.font(size: 13, weight: .bold)
        progressLabel.textColor = FitColor.accent
        progressLabel.textAlignment = .right
        addSubview(eyebrowLabel)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(progressView)
        addSubview(progressLabel)
        eyebrowLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.large)
            make.top.equalToSuperview().offset(AppSpacing.medium)
            make.width.equalTo(80)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(eyebrowLabel)
            make.top.equalTo(eyebrowLabel.snp.bottom).offset(2)
            make.width.equalTo(220)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(eyebrowLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.width.equalTo(240)
        }
        progressView.snp.makeConstraints { make in
            make.leading.equalTo(eyebrowLabel)
            make.bottom.equalToSuperview().inset(AppSpacing.medium)
            make.width.equalTo(220)
            make.height.equalTo(4)
        }
        progressLabel.snp.makeConstraints { make in
            make.leading.equalTo(progressView.snp.trailing).offset(AppSpacing.small)
            make.centerY.equalTo(progressView)
            make.width.equalTo(40)
        }
    }

    private func percentValue(from text: String) -> CGFloat {
        let value = text.replacingOccurrences(of: "%", with: "")
        return CGFloat((Double(value) ?? 0) / 100)
    }
}

private final class FitQuickStatCardView: FitCardView {

    private let iconView = UIView()
    private let iconLabel = UILabel()
    private let valueLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let progressView = FitProgressView()

    init(item: FitQuickStat) {
        super.init()
        layer.cornerRadius = 12
        layer.borderWidth = 0
        setupContent()
        configure(item: item)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private func setupContent() {
        iconView.backgroundColor = FitColor.accent
        iconView.layer.cornerRadius = 5
        iconLabel.font = AppFont.font(size: 12, weight: .regular)
        iconLabel.textAlignment = .center
        valueLabel.font = AppFont.font(size: 15, weight: .bold)
        valueLabel.textColor = FitColor.textPrimary
        subtitleLabel.font = AppFont.font(size: 11, weight: .regular)
        subtitleLabel.textColor = FitColor.textMuted
        addSubview(iconView)
        iconView.addSubview(iconLabel)
        addSubview(valueLabel)
        addSubview(subtitleLabel)
        addSubview(progressView)
        iconView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(AppSpacing.medium)
            make.width.equalTo(28)
            make.height.equalTo(22)
        }
        iconLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        valueLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView)
            make.top.equalTo(iconView.snp.bottom).offset(6)
            make.width.equalTo(82)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView)
            make.top.equalTo(valueLabel.snp.bottom)
            make.width.equalTo(82)
        }
        progressView.snp.makeConstraints { make in
            make.leading.equalTo(iconView)
            make.bottom.equalToSuperview().inset(9)
            make.width.equalTo(82)
            make.height.equalTo(3)
        }
    }

    private func configure(item: FitQuickStat) {
        iconLabel.text = item.icon
        valueLabel.text = item.value
        subtitleLabel.text = targetText(for: item)
        progressView.configure(progress: item.progress)
    }

    private func targetText(for item: FitQuickStat) -> String {
        switch item.subtitle {
        case "bước":
            return "/ 10k bước"
        case "kcal":
            return "/ 2k kcal"
        case "nước":
            return "/ 3L nước"
        default:
            return item.subtitle
        }
    }
}

private final class FitWorkoutPreviewView: UIView {

    private let seeMoreLabel = UILabel()
    private let cardView = FitCardView()
    private let iconView = UIView()
    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let progressView = FitProgressView()
    private let percentLabel = UILabel()
    private let arrowLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func configure(title: String, subtitle: String, progress: CGFloat) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        percentLabel.text = "\(Int(progress * 100))%"
        progressView.configure(progress: progress)
    }

    private func setupContent() {
        backgroundColor = .clear
        seeMoreLabel.text = "xem thêm →"
        seeMoreLabel.font = AppFont.font(size: 11, weight: .regular)
        seeMoreLabel.textColor = FitColor.textPrimary
        seeMoreLabel.textAlignment = .right
        cardView.layer.cornerRadius = 12
        cardView.layer.borderWidth = 0
        iconView.backgroundColor = FitColor.accent
        iconView.layer.cornerRadius = 10
        iconLabel.text = "💪"
        iconLabel.font = AppFont.font(size: 18, weight: .regular)
        iconLabel.textAlignment = .center
        titleLabel.font = AppFont.font(size: 13, weight: .regular)
        titleLabel.textColor = FitColor.textPrimary
        subtitleLabel.font = AppFont.font(size: 11, weight: .regular)
        subtitleLabel.textColor = FitColor.textMuted
        percentLabel.font = AppFont.font(size: 10, weight: .regular)
        percentLabel.textColor = FitColor.textMuted
        arrowLabel.text = "→"
        arrowLabel.font = AppFont.font(size: 16, weight: .bold)
        arrowLabel.textColor = FitColor.textPrimary
        addSubview(seeMoreLabel)
        addSubview(cardView)
        cardView.addSubview(iconView)
        iconView.addSubview(iconLabel)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(progressView)
        cardView.addSubview(percentLabel)
        cardView.addSubview(arrowLabel)
        seeMoreLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(AppSpacing.xLarge)
            make.width.equalTo(74)
        }
        cardView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(AppSpacing.medium)
        }
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
            make.size.equalTo(48)
        }
        iconLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(AppSpacing.medium)
            make.top.equalToSuperview().offset(14)
            make.trailing.lessThanOrEqualTo(arrowLabel.snp.leading).offset(-AppSpacing.small)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.trailing.lessThanOrEqualTo(arrowLabel.snp.leading).offset(-AppSpacing.small)
        }
        progressView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(AppSpacing.medium)
            make.width.equalTo(200)
            make.height.equalTo(3)
        }
        percentLabel.snp.makeConstraints { make in
            make.leading.equalTo(progressView.snp.trailing).offset(6)
            make.centerY.equalTo(progressView)
            make.width.equalTo(32)
        }
        arrowLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }
}

private final class FitActiveExerciseView: FitCardView {

    private let dotView = UIView()
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()

    override init() {
        super.init()
        layer.cornerRadius = 12
        layer.borderWidth = 0
        setupContent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        timeLabel.text = subtitle
    }

    private func setupContent() {
        dotView.backgroundColor = FitColor.accent
        dotView.layer.cornerRadius = 4
        titleLabel.font = AppFont.font(size: 12, weight: .regular)
        titleLabel.textColor = FitColor.textPrimary
        timeLabel.font = AppFont.font(size: 12, weight: .regular)
        timeLabel.textColor = FitColor.textPrimary
        timeLabel.textAlignment = .right
        addSubview(dotView)
        addSubview(titleLabel)
        addSubview(timeLabel)
        dotView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
            make.size.equalTo(8)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(dotView.snp.trailing).offset(AppSpacing.small)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(timeLabel.snp.leading).offset(-AppSpacing.small)
        }
        timeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
            make.width.equalTo(42)
        }
    }
}

private final class FitRunningQuickActionView: UIView {

    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let arrowLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func configure(title: String) {
        titleLabel.text = title
    }

    private func setupContent() {
        backgroundColor = UIColor(hex: "#04180E")
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = FitColor.accentBorder.cgColor
        iconLabel.text = "🏃"
        iconLabel.font = AppFont.font(size: 11, weight: .regular)
        iconLabel.textAlignment = .center
        titleLabel.font = AppFont.font(size: 12, weight: .medium)
        titleLabel.textColor = FitColor.accent
        arrowLabel.text = "→"
        arrowLabel.font = AppFont.font(size: 13, weight: .medium)
        arrowLabel.textColor = FitColor.accent
        addSubview(iconLabel)
        addSubview(titleLabel)
        addSubview(arrowLabel)
        iconLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconLabel.snp.trailing).offset(AppSpacing.small)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(arrowLabel.snp.leading).offset(-AppSpacing.small)
        }
        arrowLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
        }
    }
}

private final class FitHealthCardView: FitCardView {

    init(item: FitHomeHealthCard) {
        super.init()
        layer.cornerRadius = 10
        layer.borderWidth = 0
        setupContent(item: item)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private func setupContent(item: FitHomeHealthCard) {
        let iconLabel = UILabel()
        let titleLabel = UILabel()
        let valueLabel = UILabel()
        let subtitleLabel = UILabel()
        iconLabel.text = item.icon
        iconLabel.font = AppFont.font(size: 12, weight: .regular)
        titleLabel.text = item.title
        titleLabel.font = AppFont.font(size: 10, weight: .regular)
        titleLabel.textColor = FitColor.textMuted
        valueLabel.text = item.value
        valueLabel.font = AppFont.font(size: 17, weight: .bold)
        valueLabel.textColor = FitColor.textPrimary
        subtitleLabel.text = item.subtitle.replacingOccurrences(of: "✓ ", with: "")
        subtitleLabel.font = AppFont.font(size: 10, weight: .regular)
        subtitleLabel.textColor = FitColor.textMuted
        addSubview(iconLabel)
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(subtitleLabel)
        iconLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.top.equalToSuperview().offset(14)
            make.width.equalTo(20)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconLabel.snp.trailing).offset(2)
            make.centerY.equalTo(iconLabel)
            make.trailing.equalToSuperview().inset(AppSpacing.small)
        }
        valueLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconLabel)
            make.top.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().inset(14)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconLabel)
            make.top.equalTo(valueLabel.snp.bottom)
            make.trailing.equalToSuperview().inset(10)
        }
    }
}

private final class FitHabitRowView: FitCardView {

    init(item: FitHabitItem) {
        super.init()
        layer.cornerRadius = 12
        layer.borderWidth = 0
        setupContent(item: item)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    private func setupContent(item: FitHabitItem) {
        let iconView = UIView()
        let iconLabel = UILabel()
        let titleLabel = UILabel()
        let progressStackView = UIStackView()
        iconView.backgroundColor = FitColor.accent
        iconView.layer.cornerRadius = 6
        iconLabel.text = item.icon
        iconLabel.font = AppFont.font(size: 11, weight: .regular)
        iconLabel.textAlignment = .center
        titleLabel.text = item.title
        titleLabel.font = AppFont.font(size: 13, weight: .regular)
        titleLabel.textColor = FitColor.textPrimary
        progressStackView.axis = .horizontal
        progressStackView.spacing = 4
        progressStackView.alignment = .center
        (0..<7).forEach { index in
            let blockView = UIView()
            blockView.backgroundColor = index < Int(item.progress * 7.0) ? FitColor.accent : FitColor.border
            blockView.layer.cornerRadius = 4
            blockView.snp.makeConstraints { make in
                make.size.equalTo(8)
            }
            progressStackView.addArrangedSubview(blockView)
        }
        addSubview(iconView)
        iconView.addSubview(iconLabel)
        addSubview(titleLabel)
        addSubview(progressStackView)
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.medium)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        iconLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(AppSpacing.small)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(progressStackView.snp.leading).offset(-AppSpacing.small)
        }
        progressStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(2)
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
        }
    }
}

private final class FitWorkoutBannerView: FitCardView {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let pill = FitPillButton()

    override init() {
        super.init()
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        titleLabel.font = AppFont.headline
        titleLabel.textColor = FitColor.textPrimary
        subtitleLabel.font = AppFont.captionMedium
        subtitleLabel.textColor = FitColor.textSecondary
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        addSubview(stack)
        addSubview(pill)
        stack.snp.makeConstraints { make in make.leading.top.bottom.equalToSuperview().inset(AppSpacing.medium); make.trailing.lessThanOrEqualTo(pill.snp.leading).offset(-AppSpacing.medium) }
        pill.snp.makeConstraints { make in make.trailing.equalToSuperview().inset(AppSpacing.medium); make.centerY.equalToSuperview(); make.height.equalTo(40) }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        pill.configure(text: "⏸")
    }
}

private final class FitWorkoutDayView: FitCardView {

    init(item: FitWorkoutDay) {
        super.init()
        backgroundColor = item.isActive ? FitColor.accent : FitColor.surface
        let title = UILabel()
        title.text = item.title
        title.font = AppFont.captionMedium
        title.textColor = item.isActive ? FitColor.textInverse : FitColor.textPrimary
        let subtitle = UILabel()
        subtitle.text = item.subtitle
        subtitle.font = AppFont.bodyMedium
        subtitle.textColor = item.isActive ? FitColor.textInverse : FitColor.textPrimary
        addSubview(title)
        addSubview(subtitle)
        title.snp.makeConstraints { make in make.top.equalToSuperview().offset(5); make.centerX.equalToSuperview() }
        subtitle.snp.makeConstraints { make in make.top.equalTo(title.snp.bottom).offset(2); make.centerX.equalToSuperview(); make.bottom.equalToSuperview().inset(5) }
        if item.hasDot {
            let dot = UIView()
            dot.backgroundColor = FitColor.accent
            dot.layer.cornerRadius = 2
            addSubview(dot)
            dot.snp.makeConstraints { make in make.centerX.equalToSuperview(); make.bottom.equalToSuperview().inset(4); make.size.equalTo(4) }
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

private final class FitWorkoutExerciseRowView: FitCardView {

    init(item: FitWorkoutItem) {
        super.init()
        let icon = FitPillButton()
        icon.configure(text: item.icon)
        icon.isUserInteractionEnabled = false
        icon.snp.makeConstraints { make in make.size.equalTo(28) }

        let title = UILabel()
        title.text = item.title
        title.font = AppFont.bodyMedium
        title.textColor = FitColor.textPrimary
        let subtitle = UILabel()
        subtitle.text = item.subtitle
        subtitle.font = AppFont.caption
        subtitle.textColor = FitColor.textSecondary
        let textStack = UIStackView(arrangedSubviews: [title, subtitle])
        textStack.axis = .vertical
        textStack.spacing = 2

        let rightLabel = UILabel()
        rightLabel.text = item.trailingText
        rightLabel.font = AppFont.bodyMedium
        rightLabel.textColor = FitColor.textPrimary

        let root = UIView()
        root.addSubview(icon)
        root.addSubview(textStack)
        root.addSubview(rightLabel)
        addSubview(root)
        icon.snp.makeConstraints { make in make.leading.centerY.equalToSuperview(); make.size.equalTo(28) }
        textStack.snp.makeConstraints { make in make.leading.equalTo(icon.snp.trailing).offset(AppSpacing.medium); make.centerY.equalTo(icon); make.trailing.lessThanOrEqualTo(rightLabel.snp.leading).offset(-AppSpacing.small) }
        rightLabel.snp.makeConstraints { make in make.trailing.centerY.equalToSuperview() }
        root.snp.makeConstraints { make in make.edges.equalToSuperview().inset(AppSpacing.medium) }
        if let trailing = item.trailingText, trailing == "→" {
            rightLabel.font = AppFont.headline
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

private final class FitSummaryCardView: FitCardView {

    private let leftLabel = UILabel()
    private let rightLabel = UILabel()

    override init() {
        super.init()
        let row = UIView()
        leftLabel.font = AppFont.bodyMedium
        leftLabel.textColor = FitColor.textPrimary
        rightLabel.font = AppFont.bodyMedium
        rightLabel.textColor = FitColor.accent
        row.addSubview(leftLabel)
        row.addSubview(rightLabel)
        leftLabel.snp.makeConstraints { make in make.leading.top.bottom.equalToSuperview().inset(AppSpacing.medium) }
        rightLabel.snp.makeConstraints { make in make.trailing.top.bottom.equalToSuperview().inset(AppSpacing.medium) }
        addSubview(row)
        row.snp.makeConstraints { make in make.edges.equalToSuperview() }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func configure(left: String, right: String) {
        leftLabel.text = left
        rightLabel.text = right
    }
}

private final class FitNutritionHeroView: FitCardView {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let metaLabel = UILabel()
    private let remainingLabel = UILabel()
    private let progressView = FitProgressView()
    private let iconLabel = UILabel()

    override init() {
        super.init()
        titleLabel.font = AppFont.captionMedium
        titleLabel.textColor = FitColor.textMuted
        valueLabel.font = AppFont.largeTitle
        valueLabel.textColor = FitColor.textPrimary
        metaLabel.font = AppFont.bodyMedium
        metaLabel.textColor = FitColor.textMuted
        remainingLabel.font = AppFont.body
        remainingLabel.textColor = FitColor.textSecondary
        iconLabel.text = "🥗"
        iconLabel.font = AppFont.title
        let right = UIView()
        right.backgroundColor = FitColor.accent
        right.layer.cornerRadius = 26
        right.addSubview(iconLabel)
        iconLabel.snp.makeConstraints { make in make.center.equalToSuperview() }
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel, metaLabel, remainingLabel, progressView])
        stack.axis = .vertical
        stack.spacing = 4
        addSubview(stack)
        addSubview(right)
        stack.snp.makeConstraints { make in make.leading.top.bottom.equalToSuperview().inset(AppSpacing.medium); make.trailing.equalTo(right.snp.leading).offset(-AppSpacing.medium) }
        right.snp.makeConstraints { make in make.top.trailing.equalToSuperview().inset(AppSpacing.medium); make.size.equalTo(52) }
        progressView.snp.makeConstraints { make in make.height.equalTo(5) }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func configure(title: String, value: String, meta: String, remaining: String, progress: CGFloat) {
        titleLabel.text = title
        valueLabel.text = value
        metaLabel.text = meta
        remainingLabel.text = remaining
        progressView.configure(progress: progress)
    }
}

private final class FitMacroCardView: FitCardView {
    init(item: FitMacroItem) {
        super.init()
        let title = UILabel()
        title.text = item.title
        title.font = AppFont.captionMedium
        title.textColor = FitColor.textMuted
        let value = UILabel()
        value.text = item.value
        value.font = AppFont.headline
        value.textColor = FitColor.textPrimary
        let progress = FitProgressView()
        let stack = UIStackView(arrangedSubviews: [title, value, progress])
        stack.axis = .vertical
        stack.spacing = 6
        addSubview(stack)
        stack.snp.makeConstraints { make in make.edges.equalToSuperview().inset(AppSpacing.medium) }
        progress.snp.makeConstraints { make in make.height.equalTo(5) }
        progress.configure(progress: item.progress)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

private final class FitMealRowView: FitCardView {
    init(item: FitMealItem) {
        super.init()
        let icon = UIView()
        icon.backgroundColor = FitColor.accent
        icon.layer.cornerRadius = 14
        let title = UILabel()
        title.text = item.title
        title.font = AppFont.bodyMedium
        title.textColor = FitColor.textPrimary
        let subtitle = UILabel()
        subtitle.text = item.subtitle
        subtitle.font = AppFont.caption
        subtitle.textColor = FitColor.textMuted
        let right = UILabel()
        right.text = item.kcal
        right.font = AppFont.bodyMedium
        right.textColor = FitColor.textPrimary
        let textStack = UIStackView(arrangedSubviews: [title, subtitle])
        textStack.axis = .vertical
        textStack.spacing = 2
        addSubview(icon)
        addSubview(textStack)
        addSubview(right)
        icon.snp.makeConstraints { make in make.leading.centerY.equalToSuperview().offset(16); make.size.equalTo(28) }
        textStack.snp.makeConstraints { make in make.leading.equalTo(icon.snp.trailing).offset(AppSpacing.medium); make.centerY.equalTo(icon) }
        right.snp.makeConstraints { make in make.trailing.centerY.equalToSuperview().inset(AppSpacing.medium) }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

private final class FitTipCardView: FitCardView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    override init() {
        super.init()
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 2
        titleLabel.font = AppFont.bodyMedium
        titleLabel.textColor = FitColor.textPrimary
        subtitleLabel.font = AppFont.caption
        subtitleLabel.textColor = FitColor.textMuted
        addSubview(stack)
        stack.snp.makeConstraints { make in make.edges.equalToSuperview().inset(AppSpacing.medium) }
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    func configure(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}

private final class FitProfileHeroView: FitCardView {
    private let avatar = UIView()
    private let nameLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let joinedPill = FitPillButton()
    private let badgePill = FitPillButton()

    override init() {
        super.init()
        avatar.backgroundColor = FitColor.accent
        avatar.layer.cornerRadius = 32
        let initials = UILabel()
        initials.text = "MK"
        initials.font = AppFont.headline
        initials.textColor = FitColor.textInverse
        initials.textAlignment = .center
        avatar.addSubview(initials)
        initials.snp.makeConstraints { make in make.center.equalToSuperview() }
        nameLabel.font = AppFont.headline
        nameLabel.textColor = FitColor.textPrimary
        subtitleLabel.font = AppFont.caption
        subtitleLabel.textColor = FitColor.textSecondary
        joinedPill.isUserInteractionEnabled = false
        badgePill.isUserInteractionEnabled = false
        let textStack = UIStackView(arrangedSubviews: [nameLabel, subtitleLabel, joinedPill])
        textStack.axis = .vertical
        textStack.spacing = 4
        addSubview(avatar)
        addSubview(textStack)
        addSubview(badgePill)
        avatar.snp.makeConstraints { make in make.leading.top.equalToSuperview().inset(AppSpacing.medium); make.size.equalTo(64) }
        textStack.snp.makeConstraints { make in make.leading.equalTo(avatar.snp.trailing).offset(AppSpacing.medium); make.centerY.equalTo(avatar) }
        badgePill.snp.makeConstraints { make in make.trailing.top.equalToSuperview().inset(AppSpacing.medium); make.height.equalTo(24) }
        joinedPill.snp.makeConstraints { make in make.height.equalTo(24) }
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    func configure(name: String, subtitle: String, joinedTitle: String, energyBadge: String) {
        nameLabel.text = name
        subtitleLabel.text = subtitle
        joinedPill.configure(text: joinedTitle)
        badgePill.configure(text: energyBadge)
    }
}

private final class FitProfileStatView: FitCardView {
    init(item: FitProfileStat) {
        super.init()
        let value = UILabel()
        value.text = item.value
        value.font = item.isPrimary ? AppFont.headline : AppFont.bodyMedium
        value.textColor = item.isPrimary ? FitColor.textInverse : FitColor.textPrimary
        let subtitle = UILabel()
        subtitle.text = item.subtitle
        subtitle.font = AppFont.caption
        subtitle.textColor = item.isPrimary ? FitColor.textInverse : FitColor.textMuted
        let stack = UIStackView(arrangedSubviews: [value, subtitle])
        stack.axis = .vertical
        stack.spacing = 2
        addSubview(stack)
        stack.snp.makeConstraints { make in make.edges.equalToSuperview().inset(AppSpacing.medium) }
        backgroundColor = item.isPrimary ? FitColor.accent : FitColor.surface
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

private final class FitBodyMetricCardView: FitCardView {
    init(item: FitBodyMetric) {
        super.init()
        let icon = UILabel()
        icon.text = item.icon
        icon.font = AppFont.bodyMedium
        let title = UILabel()
        title.text = item.title
        title.font = AppFont.captionMedium
        title.textColor = FitColor.textMuted
        let value = UILabel()
        value.text = item.value
        value.font = AppFont.headline
        value.textColor = FitColor.textPrimary
        let subtitle = UILabel()
        subtitle.text = item.subtitle
        subtitle.font = AppFont.caption
        subtitle.textColor = FitColor.textSecondary
        let row = UIStackView(arrangedSubviews: [icon, title])
        row.axis = .horizontal
        row.spacing = 8
        let stack = UIStackView(arrangedSubviews: [row, value, subtitle])
        stack.axis = .vertical
        stack.spacing = 4
        addSubview(stack)
        stack.snp.makeConstraints { make in make.edges.equalToSuperview().inset(AppSpacing.medium) }
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

private final class FitGoalRowView: FitCardView {
    init(item: FitGoalItem) {
        super.init()
        let icon = UILabel()
        icon.text = item.icon
        icon.font = AppFont.bodyMedium
        let title = UILabel()
        title.text = item.title
        title.font = AppFont.bodyMedium
        title.textColor = FitColor.textPrimary
        let subtitle = UILabel()
        subtitle.text = item.subtitle
        subtitle.font = AppFont.caption
        subtitle.textColor = FitColor.textSecondary
        let percent = UILabel()
        percent.text = "\(Int(item.progress * 100))%"
        percent.font = AppFont.captionMedium
        percent.textColor = FitColor.textMuted
        let textStack = UIStackView(arrangedSubviews: [title, subtitle])
        textStack.axis = .vertical
        textStack.spacing = 2
        addSubview(icon)
        addSubview(textStack)
        addSubview(percent)
        icon.snp.makeConstraints { make in make.leading.centerY.equalToSuperview().offset(14) }
        textStack.snp.makeConstraints { make in make.leading.equalTo(icon.snp.trailing).offset(AppSpacing.medium); make.centerY.equalToSuperview() }
        percent.snp.makeConstraints { make in make.trailing.centerY.equalToSuperview().inset(AppSpacing.medium) }
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

private final class FitSettingRowView: FitCardView {
    init(item: FitSettingItem) {
        super.init()
        let icon = UILabel()
        icon.text = item.icon
        icon.font = AppFont.bodyMedium
        let title = UILabel()
        title.text = item.title
        title.font = AppFont.bodyMedium
        title.textColor = FitColor.textPrimary
        let subtitle = UILabel()
        subtitle.text = item.subtitle
        subtitle.font = AppFont.caption
        subtitle.textColor = FitColor.textSecondary
        let trailing = UILabel()
        trailing.text = item.trailingText
        trailing.font = AppFont.captionMedium
        trailing.textColor = FitColor.textMuted
        let textStack = UIStackView(arrangedSubviews: [title, subtitle])
        textStack.axis = .vertical
        textStack.spacing = 2
        addSubview(icon)
        addSubview(textStack)
        addSubview(trailing)
        icon.snp.makeConstraints { make in make.leading.centerY.equalToSuperview().offset(14) }
        textStack.snp.makeConstraints { make in make.leading.equalTo(icon.snp.trailing).offset(AppSpacing.medium); make.centerY.equalToSuperview() }
        trailing.snp.makeConstraints { make in make.trailing.centerY.equalToSuperview().inset(AppSpacing.medium) }
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

private final class FitRunningStateCardView: FitCardView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let badge = FitPillButton()
    private let mapBadge = FitPillButton()

    override init() {
        super.init()
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 2
        titleLabel.font = AppFont.headline
        titleLabel.textColor = FitColor.textPrimary
        subtitleLabel.font = AppFont.captionMedium
        subtitleLabel.textColor = FitColor.textSecondary
        addSubview(stack)
        addSubview(badge)
        addSubview(mapBadge)
        stack.snp.makeConstraints { make in make.leading.top.equalToSuperview().inset(AppSpacing.medium); make.trailing.lessThanOrEqualTo(mapBadge.snp.leading).offset(-AppSpacing.medium) }
        badge.snp.makeConstraints { make in make.trailing.top.equalToSuperview().inset(AppSpacing.medium); make.height.equalTo(26) }
        mapBadge.snp.makeConstraints { make in make.trailing.bottom.equalToSuperview().inset(AppSpacing.medium); make.height.equalTo(26) }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func configure(content: FitRunningContent, state: FitRunningState) {
        titleLabel.text = content.bannerTitle
        subtitleLabel.text = content.bannerSubtitle
        badge.configure(text: content.topPill)
        badge.isHidden = state == .confirmStop
        mapBadge.configure(text: content.mapBadge ?? "")
        mapBadge.isHidden = content.mapBadge == nil
        if state == .confirmStop {
            backgroundColor = .clear
            layer.borderWidth = 0
            layer.backgroundColor = UIColor.clear.cgColor
            titleLabel.textAlignment = .center
            subtitleLabel.textAlignment = .center
        }
    }
}

private final class FitRunningReadyStatView: FitCardView {
    init(item: FitRunningStat) {
        super.init()
        let title = UILabel()
        title.text = item.title
        title.font = AppFont.captionMedium
        title.textColor = FitColor.textMuted
        let value = UILabel()
        value.text = item.value
        value.font = AppFont.headline
        value.textColor = FitColor.textPrimary
        let subtitle = UILabel()
        subtitle.text = item.subtitle
        subtitle.font = AppFont.caption
        subtitle.textColor = FitColor.textSecondary
        let stack = UIStackView(arrangedSubviews: [title, value, subtitle])
        stack.axis = .vertical
        stack.spacing = 2
        addSubview(stack)
        stack.snp.makeConstraints { make in make.edges.equalToSuperview().inset(AppSpacing.medium) }
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

private final class FitRunningStatCardView: FitCardView {
    init(item: FitRunningStat) {
        super.init()
        let title = UILabel()
        title.text = item.title
        title.font = AppFont.captionMedium
        title.textColor = FitColor.textMuted
        let value = UILabel()
        value.text = item.value
        value.font = AppFont.headline
        value.textColor = FitColor.textPrimary
        let subtitle = UILabel()
        subtitle.text = item.subtitle
        subtitle.font = AppFont.caption
        subtitle.textColor = FitColor.textSecondary
        let stack = UIStackView(arrangedSubviews: [title, value, subtitle])
        stack.axis = .vertical
        stack.spacing = 2
        addSubview(stack)
        stack.snp.makeConstraints { make in make.edges.equalToSuperview().inset(AppSpacing.medium) }
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

private final class FitRunningMusicView: FitCardView {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let actionButton = FitPillButton()

    override init() {
        super.init()
        let icon = FitPillButton()
        icon.configure(text: "♪")
        icon.isUserInteractionEnabled = false
        icon.snp.makeConstraints { make in make.size.equalTo(38) }
        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        titleLabel.font = AppFont.bodyMedium
        titleLabel.textColor = FitColor.textPrimary
        subtitleLabel.font = AppFont.caption
        subtitleLabel.textColor = FitColor.textSecondary
        let row = UIView()
        row.addSubview(icon)
        row.addSubview(textStack)
        row.addSubview(actionButton)
        addSubview(row)
        icon.snp.makeConstraints { make in make.leading.centerY.equalToSuperview().offset(AppSpacing.medium); make.size.equalTo(38) }
        textStack.snp.makeConstraints { make in make.leading.equalTo(icon.snp.trailing).offset(AppSpacing.medium); make.centerY.equalTo(icon) }
        actionButton.snp.makeConstraints { make in make.trailing.centerY.equalToSuperview().inset(AppSpacing.medium); make.height.equalTo(24) }
        row.snp.makeConstraints { make in make.edges.equalToSuperview().inset(AppSpacing.medium) }
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
    func configure(title: String, subtitle: String, actionTitle: String, state: FitRunningState) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        actionButton.configure(text: actionTitle.isEmpty ? "Đổi" : actionTitle, filled: false)
        actionButton.isHidden = title.isEmpty && subtitle.isEmpty
    }
}

private final class FitRunningActionButton: FitCardView {
    init(item: FitRunningAction) {
        super.init()
        let icon = UILabel()
        icon.text = item.icon
        icon.font = AppFont.headline
        let title = UILabel()
        title.text = item.title
        title.font = AppFont.bodyMedium
        title.textColor = FitColor.textPrimary
        title.numberOfLines = 1
        title.adjustsFontSizeToFitWidth = true
        title.minimumScaleFactor = 0.85
        let subtitle = UILabel()
        subtitle.text = item.subtitle
        subtitle.font = AppFont.caption
        subtitle.textColor = FitColor.textMuted
        subtitle.numberOfLines = 2
        let trailing = UILabel()
        trailing.text = item.trailingText
        trailing.font = AppFont.captionMedium
        trailing.textColor = FitColor.textSecondary
        trailing.setContentCompressionResistancePriority(.required, for: .horizontal)
        let textStack = UIStackView(arrangedSubviews: [title, subtitle])
        textStack.axis = .vertical
        textStack.spacing = 2
        addSubview(icon)
        addSubview(textStack)
        addSubview(trailing)
        icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.medium)
            make.centerY.equalToSuperview()
        }
        textStack.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(AppSpacing.medium)
            make.centerY.equalToSuperview()
            make.trailing.lessThanOrEqualTo(trailing.snp.leading).offset(-AppSpacing.small)
        }
        trailing.snp.makeConstraints { make in make.trailing.centerY.equalToSuperview().inset(AppSpacing.medium) }
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}

private final class FitChipView: FitPillButton {
    init(text: String) {
        super.init(frame: .zero)
        configure(text: text, filled: false)
    }
    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }
}
