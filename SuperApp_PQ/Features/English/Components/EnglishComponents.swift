//
//  EnglishComponents.swift
//  SuperApp_PQ
//
//  Created by Codex on 12/06/26.
//

import SnapKit
import UIKit

extension EnglishTone {
    var color: UIColor {
        switch self {
        case .accent:
            return EnglishColor.accent
        case .success:
            return EnglishColor.success
        case .danger:
            return EnglishColor.danger
        case .warning:
            return EnglishColor.warning
        case .muted:
            return EnglishColor.textMuted
        }
    }

    var backgroundColor: UIColor {
        switch self {
        case .accent:
            return EnglishColor.accentSurface
        case .success, .danger, .warning:
            return color.withAlphaComponent(0.14)
        case .muted:
            return EnglishColor.elevatedSurface
        }
    }
}

extension EnglishButtonStyle {
    var backgroundColor: UIColor {
        switch self {
        case .primary:
            return EnglishColor.accent
        case .secondary:
            return EnglishColor.elevatedSurface
        case .danger:
            return EnglishColor.danger
        }
    }

    var titleColor: UIColor {
        switch self {
        case .primary, .danger:
            return EnglishColor.textInverse
        case .secondary:
            return EnglishColor.textPrimary
        }
    }

    var borderColor: UIColor {
        switch self {
        case .primary:
            return EnglishColor.accent
        case .secondary:
            return EnglishColor.border
        case .danger:
            return EnglishColor.danger
        }
    }
}

final class EnglishTopBarView: UIView {

    var onBackTap: (() -> Void)?
    var onRightTap: (() -> Void)?

    private let backLabel = UILabel()
    private let titleLabel = UILabel()
    private let pillButton = UIControl()
    private let pillLabel = UILabel()
    private let dividerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupActions()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(backTitle: String, title: String, pill: String) {
        backLabel.text = backTitle
        titleLabel.text = title
        pillLabel.text = pill
        pillButton.isHidden = pill.isEmpty
    }

    private func setupViews() {
        backgroundColor = EnglishColor.navigation
        backLabel.font = AppFont.font(size: 13, weight: .regular)
        backLabel.textColor = EnglishColor.textSecondary
        backLabel.isUserInteractionEnabled = true
        backLabel.numberOfLines = 1

        titleLabel.font = AppFont.font(size: 19, weight: .semibold)
        titleLabel.textColor = EnglishColor.textPrimary
        titleLabel.textAlignment = .center

        pillButton.backgroundColor = EnglishColor.accent
        pillButton.layer.cornerRadius = 15
        pillLabel.font = AppFont.font(size: 12, weight: .regular)
        pillLabel.textColor = EnglishColor.textInverse
        pillLabel.textAlignment = .center

        dividerView.backgroundColor = EnglishColor.border

        addSubview(backLabel)
        addSubview(titleLabel)
        addSubview(pillButton)
        pillButton.addSubview(pillLabel)
        addSubview(dividerView)
    }

    private func setupConstraints() {
        backLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(28)
            make.bottom.equalToSuperview().inset(24)
            make.width.lessThanOrEqualTo(104)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backLabel)
            make.leading.greaterThanOrEqualTo(backLabel.snp.trailing).offset(AppSpacing.medium)
            make.trailing.lessThanOrEqualTo(pillButton.snp.leading).offset(-AppSpacing.medium)
        }

        pillButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(backLabel)
            make.width.greaterThanOrEqualTo(64)
            make.height.equalTo(30)
        }

        pillLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12))
        }

        dividerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    private func setupActions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapBack))
        backLabel.addGestureRecognizer(tap)
        pillButton.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)
    }

    @objc private func didTapBack() {
        AppAnimation.haptic(.light)
        onBackTap?()
    }

    @objc private func didTapRight() {
        AppAnimation.haptic(.light)
        onRightTap?()
    }
}

final class EnglishBottomNavView: UIView {

    private let dividerView = UIView()
    private let itemsStackView = UIStackView()
    private var itemViews: [EnglishBottomNavItemView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with items: [EnglishNavItem], onSelect: @escaping (EnglishNavItem) -> Void) {
        itemViews.forEach { $0.removeFromSuperview() }
        itemViews.removeAll()
        itemsStackView.arrangedSubviews.forEach { view in
            itemsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        items.forEach { item in
            let itemView = EnglishBottomNavItemView()
            itemView.configure(with: item)
            itemView.onTap = { onSelect(item) }
            itemsStackView.addArrangedSubview(itemView)
            itemViews.append(itemView)
        }
    }

    private func setupViews() {
        backgroundColor = EnglishColor.navigation
        dividerView.backgroundColor = EnglishColor.border
        itemsStackView.axis = .horizontal
        itemsStackView.distribution = .fillEqually
        addSubview(dividerView)
        addSubview(itemsStackView)
    }

    private func setupConstraints() {
        dividerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        itemsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

private final class EnglishBottomNavItemView: UIControl {

    var onTap: (() -> Void)?

    private let indicatorView = UIView()
    private let iconLabel = UILabel()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with item: EnglishNavItem) {
        let color = item.isSelected ? EnglishColor.accentStrong : EnglishColor.textMuted
        indicatorView.isHidden = !item.isSelected
        iconLabel.text = item.icon
        iconLabel.textColor = color
        titleLabel.text = item.title
        titleLabel.textColor = color
    }

    private func setupViews() {
        indicatorView.backgroundColor = EnglishColor.accentStrong
        indicatorView.layer.cornerRadius = 1.5
        indicatorView.isHidden = true

        iconLabel.font = AppFont.font(size: 17, weight: .semibold)
        iconLabel.textAlignment = .center
        titleLabel.font = AppFont.font(size: 10, weight: .regular)
        titleLabel.textAlignment = .center

        addSubview(indicatorView)
        addSubview(iconLabel)
        addSubview(titleLabel)
    }

    private func setupConstraints() {
        indicatorView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(32)
            make.height.equalTo(3)
        }

        iconLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
    }

    @objc private func didTap() {
        AppAnimation.haptic(.light)
        onTap?()
    }
}

class EnglishCardView: UIView {

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = EnglishColor.surface
        layer.cornerRadius = AppRadius.large
        layer.borderWidth = 1
        layer.borderColor = EnglishColor.border.cgColor
    }
}

final class EnglishGoalCardView: EnglishCardView {

    private let eyebrowLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let progressLabel = UILabel()
    private let progressTrackView = UIView()
    private let progressFillView = UIView()

    override init() {
        super.init()
        setupContent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with content: EnglishGoalContent) {
        eyebrowLabel.text = content.eyebrow
        titleLabel.text = content.title
        subtitleLabel.text = content.subtitle
        progressLabel.text = content.progressText
        let progress = max(0.02, min(content.progress, 1))
        progressFillView.snp.remakeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(progressTrackView.snp.width).multipliedBy(progress)
        }
    }

    private func setupContent() {
        backgroundColor = EnglishColor.elevatedSurface
        layer.borderColor = EnglishColor.accent.withAlphaComponent(0.45).cgColor

        eyebrowLabel.font = AppFont.font(size: 11, weight: .bold)
        eyebrowLabel.textColor = EnglishColor.accent
        titleLabel.font = AppFont.font(size: 28, weight: .bold)
        titleLabel.textColor = EnglishColor.textPrimary
        subtitleLabel.font = AppFont.font(size: 14, weight: .regular)
        subtitleLabel.textColor = EnglishColor.textSecondary
        subtitleLabel.numberOfLines = 2
        progressLabel.font = AppFont.font(size: 13, weight: .semibold)
        progressLabel.textColor = EnglishColor.accent
        progressLabel.textAlignment = .right

        progressTrackView.backgroundColor = EnglishColor.background
        progressTrackView.layer.cornerRadius = 5
        progressTrackView.clipsToBounds = true
        progressFillView.backgroundColor = EnglishColor.accent
        progressFillView.layer.cornerRadius = 5

        addSubview(eyebrowLabel)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(progressLabel)
        addSubview(progressTrackView)
        progressTrackView.addSubview(progressFillView)

        eyebrowLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(AppSpacing.xLarge)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(eyebrowLabel)
            make.top.equalTo(eyebrowLabel.snp.bottom).offset(AppSpacing.medium)
        }

        progressLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.centerY.equalTo(titleLabel)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(AppSpacing.medium)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(eyebrowLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(AppSpacing.small)
        }

        progressTrackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(eyebrowLabel)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(AppSpacing.large)
            make.bottom.equalToSuperview().inset(AppSpacing.xLarge)
            make.height.equalTo(10)
        }
    }
}

final class EnglishStatGridView: UIView {

    private let statsStackView = UIStackView()

    init(items: [EnglishStatItem]) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configure(with: items)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with items: [EnglishStatItem]) {
        statsStackView.arrangedSubviews.forEach { view in
            statsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        items.forEach { item in
            let view = EnglishStatCardView(item: item)
            statsStackView.addArrangedSubview(view)
        }
    }

    private func setupViews() {
        statsStackView.axis = .horizontal
        statsStackView.spacing = AppSpacing.medium
        statsStackView.distribution = .fillEqually
        addSubview(statsStackView)
    }

    private func setupConstraints() {
        statsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

private final class EnglishStatCardView: EnglishCardView {

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    private let trailingLabel = UILabel()

    init(item: EnglishStatItem) {
        super.init()
        setupContent()
        configure(with: item)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(with item: EnglishStatItem) {
        titleLabel.text = item.title
        valueLabel.text = item.value
        trailingLabel.text = item.trailing
        trailingLabel.isHidden = item.trailing == nil
    }

    private func setupContent() {
        titleLabel.font = AppFont.font(size: 10, weight: .bold)
        titleLabel.textColor = EnglishColor.textMuted
        titleLabel.numberOfLines = 1
        valueLabel.font = AppFont.font(size: 18, weight: .bold)
        valueLabel.textColor = EnglishColor.textPrimary
        valueLabel.numberOfLines = 1
        trailingLabel.font = AppFont.font(size: 14, weight: .semibold)
        trailingLabel.textColor = EnglishColor.accent
        trailingLabel.textAlignment = .right

        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(trailingLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(AppSpacing.medium)
        }

        valueLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(AppSpacing.medium)
            make.trailing.lessThanOrEqualTo(trailingLabel.snp.leading).offset(-AppSpacing.small)
        }

        trailingLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(AppSpacing.medium)
        }
    }
}

final class EnglishSegmentedView: EnglishCardView {

    private let segmentsStackView = UIStackView()

    init(items: [String], selectedIndex: Int) {
        super.init()
        setupContent()
        configure(items: items, selectedIndex: selectedIndex)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(items: [String], selectedIndex: Int) {
        segmentsStackView.arrangedSubviews.forEach { view in
            segmentsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        items.enumerated().forEach { index, title in
            let segmentLabel = UILabel()
            segmentLabel.text = title
            segmentLabel.font = AppFont.font(size: 13, weight: index == selectedIndex ? .semibold : .regular)
            segmentLabel.textColor = index == selectedIndex ? EnglishColor.textInverse : EnglishColor.textSecondary
            segmentLabel.textAlignment = .center
            segmentLabel.backgroundColor = index == selectedIndex ? EnglishColor.accent : UIColor.clear
            segmentLabel.layer.cornerRadius = 16
            segmentLabel.clipsToBounds = true
            segmentsStackView.addArrangedSubview(segmentLabel)
        }
    }

    private func setupContent() {
        segmentsStackView.axis = .horizontal
        segmentsStackView.spacing = AppSpacing.small
        segmentsStackView.distribution = .fillEqually
        addSubview(segmentsStackView)

        segmentsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
            make.height.equalTo(32)
        }
    }
}

final class EnglishSectionHeaderView: UIView {

    private let titleLabel = UILabel()
    private let trailingLabel = UILabel()

    init(title: String, trailing: String?) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configure(title: title, trailing: trailing)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(title: String, trailing: String?) {
        titleLabel.text = title
        trailingLabel.text = trailing
        trailingLabel.isHidden = trailing == nil
    }

    private func setupViews() {
        titleLabel.font = AppFont.font(size: 12, weight: .bold)
        titleLabel.textColor = EnglishColor.textMuted
        trailingLabel.font = AppFont.font(size: 12, weight: .semibold)
        trailingLabel.textColor = EnglishColor.accent
        trailingLabel.textAlignment = .right
        addSubview(titleLabel)
        addSubview(trailingLabel)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
        }

        trailingLabel.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(AppSpacing.medium)
        }
    }
}

final class EnglishTopicsGridView: UIView {

    private let rowsStackView = UIStackView()
    private let onSelect: (EnglishTopicItem) -> Void

    init(items: [EnglishTopicItem], onSelect: @escaping (EnglishTopicItem) -> Void) {
        self.onSelect = onSelect
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configure(with: items)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(with items: [EnglishTopicItem]) {
        rowsStackView.arrangedSubviews.forEach { view in
            rowsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        stride(from: 0, to: items.count, by: 2).forEach { index in
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = AppSpacing.medium
            rowStackView.distribution = .fillEqually

            [items[index], items[safe: index + 1]].compactMap { $0 }.forEach { item in
                let topicView = EnglishTopicCardView(item: item)
                topicView.onTap = { [onSelect] in onSelect(item) }
                rowStackView.addArrangedSubview(topicView)
            }

            if rowStackView.arrangedSubviews.count == 1 {
                rowStackView.addArrangedSubview(UIView())
            }
            rowsStackView.addArrangedSubview(rowStackView)
        }
    }

    private func setupViews() {
        rowsStackView.axis = .vertical
        rowsStackView.spacing = AppSpacing.medium
        addSubview(rowsStackView)
    }

    private func setupConstraints() {
        rowsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

private final class EnglishTopicCardView: EnglishCardView {

    var onTap: (() -> Void)?

    private let badgeLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let iconView = UIView()

    init(item: EnglishTopicItem) {
        super.init()
        setupContent()
        configure(with: item)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(with item: EnglishTopicItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        badgeLabel.text = item.badge
        badgeLabel.textColor = item.tone == .muted ? EnglishColor.textMuted : item.tone.color
        iconView.backgroundColor = item.tone.backgroundColor
        layer.borderColor = item.tone == .muted ? EnglishColor.border.cgColor : item.tone.color.withAlphaComponent(0.36).cgColor
    }

    private func setupContent() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
        isUserInteractionEnabled = true

        iconView.layer.cornerRadius = 15
        badgeLabel.font = AppFont.font(size: 11, weight: .semibold)
        badgeLabel.textAlignment = .right
        titleLabel.font = AppFont.font(size: 17, weight: .semibold)
        titleLabel.textColor = EnglishColor.textPrimary
        subtitleLabel.font = AppFont.font(size: 13, weight: .regular)
        subtitleLabel.textColor = EnglishColor.textSecondary

        addSubview(iconView)
        addSubview(badgeLabel)
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        iconView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(AppSpacing.large)
            make.size.equalTo(30)
        }

        badgeLabel.snp.makeConstraints { make in
            make.trailing.top.equalToSuperview().inset(AppSpacing.large)
            make.leading.greaterThanOrEqualTo(iconView.snp.trailing).offset(AppSpacing.small)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(AppSpacing.large)
            make.top.equalTo(iconView.snp.bottom).offset(AppSpacing.large)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.bottom.equalToSuperview().inset(AppSpacing.large)
        }
    }

    @objc private func didTap() {
        AppAnimation.haptic(.light)
        onTap?()
    }
}

final class EnglishRowsView: UIView {

    private let rowsStackView = UIStackView()
    private let onSelect: (EnglishRowItem) -> Void

    init(rows: [EnglishRowItem], onSelect: @escaping (EnglishRowItem) -> Void) {
        self.onSelect = onSelect
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configure(with: rows)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(with rows: [EnglishRowItem]) {
        rowsStackView.arrangedSubviews.forEach { view in
            rowsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        rows.forEach { row in
            let rowView = EnglishRowView(row: row)
            rowView.onTap = { [onSelect] in onSelect(row) }
            rowsStackView.addArrangedSubview(rowView)
        }
    }

    private func setupViews() {
        rowsStackView.axis = .vertical
        rowsStackView.spacing = AppSpacing.medium
        addSubview(rowsStackView)
    }

    private func setupConstraints() {
        rowsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

private final class EnglishRowView: UIControl {

    var onTap: (() -> Void)?

    private let cardView = EnglishCardView()
    private let accentView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let actionLabel = UILabel()

    init(row: EnglishRowItem) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configure(with: row)
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(with row: EnglishRowItem) {
        titleLabel.text = row.title
        subtitleLabel.text = row.subtitle
        actionLabel.text = row.actionTitle
        actionLabel.isHidden = row.actionTitle == nil
        actionLabel.textColor = row.tone == .muted ? EnglishColor.accent : row.tone.color
        accentView.backgroundColor = row.tone.color
    }

    private func setupViews() {
        titleLabel.font = AppFont.font(size: 15, weight: .semibold)
        titleLabel.textColor = EnglishColor.textPrimary
        titleLabel.numberOfLines = 1
        subtitleLabel.font = AppFont.font(size: 13, weight: .regular)
        subtitleLabel.textColor = EnglishColor.textSecondary
        subtitleLabel.numberOfLines = 2
        actionLabel.font = AppFont.font(size: 12, weight: .semibold)
        actionLabel.textAlignment = .right
        accentView.layer.cornerRadius = 3

        addSubview(cardView)
        cardView.addSubview(accentView)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(actionLabel)
    }

    private func setupConstraints() {
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.greaterThanOrEqualTo(68)
        }

        accentView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.large)
            make.centerY.equalToSuperview()
            make.width.equalTo(6)
            make.height.equalTo(34)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(accentView.snp.trailing).offset(AppSpacing.medium)
            make.top.equalToSuperview().inset(AppSpacing.medium)
            make.trailing.lessThanOrEqualTo(actionLabel.snp.leading).offset(-AppSpacing.small)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.trailing.lessThanOrEqualTo(actionLabel.snp.leading).offset(-AppSpacing.small)
            make.bottom.equalToSuperview().inset(AppSpacing.medium)
        }

        actionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(AppSpacing.large)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(88)
        }
    }

    @objc private func didTap() {
        AppAnimation.haptic(.light)
        onTap?()
    }
}

final class EnglishWordChipsView: EnglishCardView {

    private let rowsStackView = UIStackView()

    init(words: [String]) {
        super.init()
        setupContent()
        configure(with: words)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(with words: [String]) {
        rowsStackView.arrangedSubviews.forEach { view in
            rowsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        stride(from: 0, to: words.count, by: 3).forEach { index in
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.spacing = AppSpacing.small
            rowStackView.distribution = .fillEqually

            words[index..<min(index + 3, words.count)].forEach { word in
                let chipLabel = UILabel()
                chipLabel.text = word
                chipLabel.font = AppFont.font(size: 13, weight: .semibold)
                chipLabel.textColor = EnglishColor.accent
                chipLabel.textAlignment = .center
                chipLabel.backgroundColor = EnglishColor.accentSurface
                chipLabel.layer.cornerRadius = 16
                chipLabel.clipsToBounds = true
                rowStackView.addArrangedSubview(chipLabel)
            }

            while rowStackView.arrangedSubviews.count < 3 {
                rowStackView.addArrangedSubview(UIView())
            }
            rowsStackView.addArrangedSubview(rowStackView)
        }
    }

    private func setupContent() {
        rowsStackView.axis = .vertical
        rowsStackView.spacing = AppSpacing.small
        addSubview(rowsStackView)

        rowsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(AppSpacing.medium)
        }
    }
}

final class EnglishFlashcardView: EnglishCardView {

    var onUnknownTap: (() -> Void)?
    var onKnownTap: (() -> Void)?
    var onSkipTap: (() -> Void)?

    private let progressTitleLabel = UILabel()
    private let progressTextLabel = UILabel()
    private let progressTrackView = UIView()
    private let progressFillView = UIView()
    private let partOfSpeechLabel = UILabel()
    private let wordLabel = UILabel()
    private let pronunciationLabel = UILabel()
    private let meaningLabel = UILabel()
    private let exampleLabel = UILabel()
    private let actionsStackView = UIStackView()
    private let unknownButton = EnglishActionButton()
    private let knownButton = EnglishActionButton()
    private let nextTitleLabel = UILabel()
    private let nextWordsStackView = UIStackView()

    override init() {
        super.init()
        setupContent()
        setupActions()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with content: EnglishFlashcardContent) {
        progressTitleLabel.text = content.progressTitle
        progressTextLabel.text = content.progressText
        partOfSpeechLabel.text = content.partOfSpeech
        wordLabel.text = content.word
        pronunciationLabel.text = content.pronunciation
        meaningLabel.text = content.meaning
        exampleLabel.text = content.example
        unknownButton.configure(title: "Chưa biết", style: .secondary, isSelected: content.selectedAnswer == .unknown)
        knownButton.configure(title: "Đã biết", style: .primary, isSelected: content.selectedAnswer == .known)
        actionsStackView.isHidden = content.nextWords.isEmpty || !content.progressTitle.hasPrefix("Thẻ")
        nextTitleLabel.isHidden = content.nextWords.isEmpty
        configureNextWords(content.nextWords)

        let progress = max(0.02, min(content.progress, 1))
        progressFillView.snp.remakeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(progressTrackView.snp.width).multipliedBy(progress)
        }
    }

    private func configureNextWords(_ words: [String]) {
        nextWordsStackView.arrangedSubviews.forEach { view in
            nextWordsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        words.forEach { word in
            let wordLabel = UILabel()
            wordLabel.text = word
            wordLabel.font = AppFont.font(size: 13, weight: .semibold)
            wordLabel.textColor = EnglishColor.textSecondary
            wordLabel.textAlignment = .center
            wordLabel.numberOfLines = 2
            wordLabel.backgroundColor = EnglishColor.background
            wordLabel.layer.cornerRadius = 12
            wordLabel.clipsToBounds = true
            nextWordsStackView.addArrangedSubview(wordLabel)
        }
    }

    private func setupContent() {
        backgroundColor = EnglishColor.elevatedSurface
        layer.borderColor = EnglishColor.accent.withAlphaComponent(0.42).cgColor

        progressTitleLabel.font = AppFont.font(size: 12, weight: .bold)
        progressTitleLabel.textColor = EnglishColor.textMuted
        progressTextLabel.font = AppFont.font(size: 12, weight: .semibold)
        progressTextLabel.textColor = EnglishColor.accent
        progressTextLabel.textAlignment = .right
        progressTrackView.backgroundColor = EnglishColor.background
        progressTrackView.layer.cornerRadius = 4
        progressTrackView.clipsToBounds = true
        progressFillView.backgroundColor = EnglishColor.accent
        progressFillView.layer.cornerRadius = 4

        partOfSpeechLabel.font = AppFont.font(size: 13, weight: .bold)
        partOfSpeechLabel.textColor = EnglishColor.textInverse
        partOfSpeechLabel.textAlignment = .center
        partOfSpeechLabel.backgroundColor = EnglishColor.accent
        partOfSpeechLabel.layer.cornerRadius = 16
        partOfSpeechLabel.clipsToBounds = true
        wordLabel.font = AppFont.font(size: 34, weight: .bold)
        wordLabel.textColor = EnglishColor.textPrimary
        wordLabel.textAlignment = .center
        pronunciationLabel.font = AppFont.font(size: 16, weight: .regular)
        pronunciationLabel.textColor = EnglishColor.accent
        pronunciationLabel.textAlignment = .center
        meaningLabel.font = AppFont.font(size: 22, weight: .semibold)
        meaningLabel.textColor = EnglishColor.textPrimary
        meaningLabel.textAlignment = .center
        meaningLabel.numberOfLines = 2
        exampleLabel.font = AppFont.font(size: 15, weight: .regular)
        exampleLabel.textColor = EnglishColor.textSecondary
        exampleLabel.textAlignment = .center
        exampleLabel.numberOfLines = 3

        actionsStackView.axis = .horizontal
        actionsStackView.spacing = AppSpacing.medium
        actionsStackView.distribution = .fillEqually
        actionsStackView.addArrangedSubview(unknownButton)
        actionsStackView.addArrangedSubview(knownButton)

        nextTitleLabel.text = "Tiếp theo"
        nextTitleLabel.font = AppFont.font(size: 12, weight: .bold)
        nextTitleLabel.textColor = EnglishColor.textMuted
        nextWordsStackView.axis = .horizontal
        nextWordsStackView.spacing = AppSpacing.small
        nextWordsStackView.distribution = .fillEqually

        addSubview(progressTitleLabel)
        addSubview(progressTextLabel)
        addSubview(progressTrackView)
        progressTrackView.addSubview(progressFillView)
        addSubview(partOfSpeechLabel)
        addSubview(wordLabel)
        addSubview(pronunciationLabel)
        addSubview(meaningLabel)
        addSubview(exampleLabel)
        addSubview(actionsStackView)
        addSubview(nextTitleLabel)
        addSubview(nextWordsStackView)

        progressTitleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(AppSpacing.xLarge)
        }

        progressTextLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.centerY.equalTo(progressTitleLabel)
        }

        progressTrackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.top.equalTo(progressTitleLabel.snp.bottom).offset(AppSpacing.medium)
            make.height.equalTo(8)
        }

        partOfSpeechLabel.snp.makeConstraints { make in
            make.top.equalTo(progressTrackView.snp.bottom).offset(AppSpacing.xLarge)
            make.centerX.equalToSuperview()
            make.width.equalTo(48)
            make.height.equalTo(32)
        }

        wordLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.top.equalTo(partOfSpeechLabel.snp.bottom).offset(AppSpacing.large)
        }

        pronunciationLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(wordLabel)
            make.top.equalTo(wordLabel.snp.bottom).offset(AppSpacing.small)
        }

        meaningLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(wordLabel)
            make.top.equalTo(pronunciationLabel.snp.bottom).offset(AppSpacing.xLarge)
        }

        exampleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(wordLabel)
            make.top.equalTo(meaningLabel.snp.bottom).offset(AppSpacing.large)
        }

        actionsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.top.equalTo(exampleLabel.snp.bottom).offset(AppSpacing.xLarge)
            make.height.equalTo(48)
        }

        nextTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(AppSpacing.xLarge)
            make.top.equalTo(actionsStackView.snp.bottom).offset(AppSpacing.large)
        }

        nextWordsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.top.equalTo(nextTitleLabel.snp.bottom).offset(AppSpacing.small)
            make.bottom.equalToSuperview().inset(AppSpacing.xLarge)
            make.height.greaterThanOrEqualTo(38)
        }
    }

    private func setupActions() {
        unknownButton.onTap = { [weak self] in self?.onUnknownTap?() }
        knownButton.onTap = { [weak self] in self?.onKnownTap?() }
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCard))
        addGestureRecognizer(tap)
    }

    @objc private func didTapCard() {
        guard actionsStackView.isHidden else { return }
        AppAnimation.haptic(.light)
        onSkipTap?()
    }
}

final class EnglishQuizView: EnglishCardView {

    var onAnswerTap: ((EnglishAnswerItem) -> Void)?

    private let progressTitleLabel = UILabel()
    private let timerLabel = UILabel()
    private let promptLabel = UILabel()
    private let wordLabel = UILabel()
    private let pronunciationLabel = UILabel()
    private let answersStackView = UIStackView()
    private let messageLabel = UILabel()

    override init() {
        super.init()
        setupContent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with content: EnglishQuizContent) {
        progressTitleLabel.text = content.progressTitle
        timerLabel.text = content.timerText
        promptLabel.text = content.prompt
        wordLabel.text = content.word
        pronunciationLabel.text = content.pronunciation
        messageLabel.text = content.message
        messageLabel.textColor = content.messageTone.color
        messageLabel.backgroundColor = content.messageTone.backgroundColor
        messageLabel.isHidden = content.message == nil

        answersStackView.arrangedSubviews.forEach { view in
            answersStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        content.answers.forEach { answer in
            let answerView = EnglishAnswerView(answer: answer)
            answerView.onTap = { [weak self] in self?.onAnswerTap?(answer) }
            answersStackView.addArrangedSubview(answerView)
        }
    }

    private func setupContent() {
        backgroundColor = EnglishColor.elevatedSurface
        layer.borderColor = EnglishColor.accent.withAlphaComponent(0.42).cgColor

        progressTitleLabel.font = AppFont.font(size: 12, weight: .bold)
        progressTitleLabel.textColor = EnglishColor.textMuted
        timerLabel.font = AppFont.font(size: 18, weight: .bold)
        timerLabel.textColor = EnglishColor.warning
        timerLabel.textAlignment = .right
        promptLabel.font = AppFont.font(size: 14, weight: .regular)
        promptLabel.textColor = EnglishColor.textSecondary
        promptLabel.textAlignment = .center
        wordLabel.font = AppFont.font(size: 34, weight: .bold)
        wordLabel.textColor = EnglishColor.textPrimary
        wordLabel.textAlignment = .center
        pronunciationLabel.font = AppFont.font(size: 15, weight: .regular)
        pronunciationLabel.textColor = EnglishColor.accent
        pronunciationLabel.textAlignment = .center
        answersStackView.axis = .vertical
        answersStackView.spacing = AppSpacing.medium
        messageLabel.font = AppFont.font(size: 13, weight: .semibold)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 3
        messageLabel.layer.cornerRadius = 14
        messageLabel.clipsToBounds = true

        addSubview(progressTitleLabel)
        addSubview(timerLabel)
        addSubview(promptLabel)
        addSubview(wordLabel)
        addSubview(pronunciationLabel)
        addSubview(answersStackView)
        addSubview(messageLabel)

        progressTitleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(AppSpacing.xLarge)
        }

        timerLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.centerY.equalTo(progressTitleLabel)
        }

        promptLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.top.equalTo(progressTitleLabel.snp.bottom).offset(AppSpacing.xLarge)
        }

        wordLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(promptLabel)
            make.top.equalTo(promptLabel.snp.bottom).offset(AppSpacing.small)
        }

        pronunciationLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(promptLabel)
            make.top.equalTo(wordLabel.snp.bottom).offset(AppSpacing.small)
        }

        answersStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.top.equalTo(pronunciationLabel.snp.bottom).offset(AppSpacing.xLarge)
        }

        messageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.top.equalTo(answersStackView.snp.bottom).offset(AppSpacing.large)
            make.bottom.equalToSuperview().inset(AppSpacing.xLarge)
            make.height.greaterThanOrEqualTo(38)
        }
    }
}

private final class EnglishAnswerView: UIControl {

    var onTap: (() -> Void)?

    private let letterLabel = UILabel()
    private let titleLabel = UILabel()

    init(answer: EnglishAnswerItem) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configure(with: answer)
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(with answer: EnglishAnswerItem) {
        let color = answer.tone == .muted ? EnglishColor.textSecondary : answer.tone.color
        letterLabel.text = answer.letter
        titleLabel.text = answer.title
        letterLabel.textColor = answer.tone == .muted ? EnglishColor.textMuted : EnglishColor.textInverse
        letterLabel.backgroundColor = answer.tone == .muted ? EnglishColor.surface : answer.tone.color
        titleLabel.textColor = color
        backgroundColor = answer.tone.backgroundColor
        layer.borderColor = answer.tone == .muted ? EnglishColor.border.cgColor : answer.tone.color.withAlphaComponent(0.72).cgColor
    }

    private func setupViews() {
        layer.cornerRadius = AppRadius.medium
        layer.borderWidth = 1
        letterLabel.font = AppFont.font(size: 13, weight: .bold)
        letterLabel.textAlignment = .center
        letterLabel.layer.cornerRadius = 16
        letterLabel.clipsToBounds = true
        titleLabel.font = AppFont.font(size: 15, weight: .semibold)
        titleLabel.numberOfLines = 2
        addSubview(letterLabel)
        addSubview(titleLabel)
    }

    private func setupConstraints() {
        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(58)
        }

        letterLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(AppSpacing.medium)
            make.centerY.equalToSuperview()
            make.size.equalTo(32)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(letterLabel.snp.trailing).offset(AppSpacing.medium)
            make.trailing.equalToSuperview().inset(AppSpacing.medium)
            make.top.bottom.equalToSuperview().inset(AppSpacing.medium)
        }
    }

    @objc private func didTap() {
        AppAnimation.haptic(.light)
        onTap?()
    }
}

final class EnglishResultView: EnglishCardView {

    private let scoreLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let xpLabel = UILabel()
    private let statsStackView = UIStackView()

    override init() {
        super.init()
        setupContent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with content: EnglishResultContent) {
        scoreLabel.text = content.score
        titleLabel.text = content.title
        subtitleLabel.text = content.subtitle
        xpLabel.text = content.xp
        statsStackView.arrangedSubviews.forEach { view in
            statsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        content.stats.forEach { item in
            let statLabel = UILabel()
            statLabel.text = "\(item.value)\n\(item.title)"
            statLabel.font = AppFont.font(size: 13, weight: .semibold)
            statLabel.textColor = EnglishColor.textSecondary
            statLabel.textAlignment = .center
            statLabel.numberOfLines = 2
            statsStackView.addArrangedSubview(statLabel)
        }
    }

    private func setupContent() {
        backgroundColor = EnglishColor.elevatedSurface
        layer.borderColor = EnglishColor.success.withAlphaComponent(0.5).cgColor

        scoreLabel.font = AppFont.font(size: 32, weight: .bold)
        scoreLabel.textColor = EnglishColor.success
        scoreLabel.textAlignment = .center
        scoreLabel.backgroundColor = EnglishColor.success.withAlphaComponent(0.12)
        scoreLabel.layer.cornerRadius = 46
        scoreLabel.clipsToBounds = true
        titleLabel.font = AppFont.font(size: 24, weight: .bold)
        titleLabel.textColor = EnglishColor.textPrimary
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        subtitleLabel.font = AppFont.font(size: 15, weight: .regular)
        subtitleLabel.textColor = EnglishColor.textSecondary
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 3
        xpLabel.font = AppFont.font(size: 20, weight: .bold)
        xpLabel.textColor = EnglishColor.accent
        xpLabel.textAlignment = .center
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = AppSpacing.medium

        addSubview(scoreLabel)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(xpLabel)
        addSubview(statsStackView)

        scoreLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(AppSpacing.xLarge)
            make.centerX.equalToSuperview()
            make.size.equalTo(92)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.top.equalTo(scoreLabel.snp.bottom).offset(AppSpacing.large)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(AppSpacing.small)
        }

        xpLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(AppSpacing.large)
        }

        statsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.top.equalTo(xpLabel.snp.bottom).offset(AppSpacing.xLarge)
            make.bottom.equalToSuperview().inset(AppSpacing.xLarge)
        }
    }
}

final class EnglishStateCardView: EnglishCardView {

    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()

    override init() {
        super.init()
        setupContent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with content: EnglishStateContent) {
        iconLabel.text = content.icon
        iconLabel.isHidden = content.icon.isEmpty
        iconLabel.textColor = content.tone.color
        iconLabel.backgroundColor = content.tone.backgroundColor
        titleLabel.text = content.title
        messageLabel.text = content.message
        layer.borderColor = content.tone == .muted ? EnglishColor.border.cgColor : content.tone.color.withAlphaComponent(0.5).cgColor
    }

    private func setupContent() {
        backgroundColor = EnglishColor.elevatedSurface
        iconLabel.font = AppFont.font(size: 24, weight: .bold)
        iconLabel.textAlignment = .center
        iconLabel.layer.cornerRadius = 28
        iconLabel.clipsToBounds = true
        titleLabel.font = AppFont.font(size: 22, weight: .bold)
        titleLabel.textColor = EnglishColor.textPrimary
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 3
        messageLabel.font = AppFont.font(size: 15, weight: .regular)
        messageLabel.textColor = EnglishColor.textSecondary
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0

        addSubview(iconLabel)
        addSubview(titleLabel)
        addSubview(messageLabel)

        iconLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(AppSpacing.xLarge)
            make.centerX.equalToSuperview()
            make.size.equalTo(56)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.top.equalTo(iconLabel.snp.bottom).offset(AppSpacing.large)
        }

        messageLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(AppSpacing.medium)
            make.bottom.equalToSuperview().inset(AppSpacing.xLarge)
        }
    }
}

final class EnglishOptionsView: EnglishCardView {

    private let titleLabel = UILabel()
    private let optionsStackView = UIStackView()

    init(group: EnglishOptionGroup) {
        super.init()
        setupContent()
        configure(with: group)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(with group: EnglishOptionGroup) {
        titleLabel.text = group.title
        optionsStackView.arrangedSubviews.forEach { view in
            optionsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        group.options.forEach { option in
            let optionLabel = UILabel()
            optionLabel.text = option.subtitle.isEmpty ? option.title : "\(option.title)\n\(option.subtitle)"
            optionLabel.font = AppFont.font(size: 14, weight: option.isSelected ? .semibold : .regular)
            optionLabel.textColor = option.isSelected ? EnglishColor.textInverse : EnglishColor.textSecondary
            optionLabel.textAlignment = .center
            optionLabel.numberOfLines = 2
            optionLabel.backgroundColor = option.isSelected ? EnglishColor.accent : EnglishColor.background
            optionLabel.layer.cornerRadius = 15
            optionLabel.clipsToBounds = true
            optionsStackView.addArrangedSubview(optionLabel)
        }
    }

    private func setupContent() {
        titleLabel.font = AppFont.font(size: 12, weight: .bold)
        titleLabel.textColor = EnglishColor.textMuted
        optionsStackView.axis = .horizontal
        optionsStackView.spacing = AppSpacing.small
        optionsStackView.distribution = .fillEqually

        addSubview(titleLabel)
        addSubview(optionsStackView)

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(AppSpacing.large)
        }

        optionsStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(AppSpacing.large)
            make.top.equalTo(titleLabel.snp.bottom).offset(AppSpacing.medium)
            make.height.equalTo(44)
        }
    }
}

final class EnglishButtonsView: UIView {

    private let buttonsStackView = UIStackView()
    private let onSelect: (EnglishButtonItem) -> Void

    init(items: [EnglishButtonItem], onSelect: @escaping (EnglishButtonItem) -> Void) {
        self.onSelect = onSelect
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configure(with: items)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(with items: [EnglishButtonItem]) {
        buttonsStackView.axis = items.count > 2 ? .vertical : .horizontal
        buttonsStackView.arrangedSubviews.forEach { view in
            buttonsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        items.forEach { item in
            let itemButton = EnglishActionButton()
            itemButton.configure(title: item.title, style: item.style, isSelected: false)
            itemButton.onTap = { [onSelect] in onSelect(item) }
            buttonsStackView.addArrangedSubview(itemButton)
        }
    }

    private func setupViews() {
        buttonsStackView.spacing = AppSpacing.medium
        buttonsStackView.distribution = .fillEqually
        addSubview(buttonsStackView)
    }

    private func setupConstraints() {
        buttonsStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

final class EnglishSearchView: EnglishCardView {

    private let iconLabel = UILabel()
    private let placeholderLabel = UILabel()

    init(placeholder: String) {
        super.init()
        setupContent()
        configure(placeholder: placeholder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(placeholder: String) {
        placeholderLabel.text = placeholder
    }

    private func setupContent() {
        iconLabel.text = "⌕"
        iconLabel.font = AppFont.font(size: 20, weight: .semibold)
        iconLabel.textColor = EnglishColor.accent
        iconLabel.textAlignment = .center
        placeholderLabel.font = AppFont.font(size: 15, weight: .regular)
        placeholderLabel.textColor = EnglishColor.textMuted

        addSubview(iconLabel)
        addSubview(placeholderLabel)

        iconLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(AppSpacing.large)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }

        placeholderLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconLabel.snp.trailing).offset(AppSpacing.medium)
            make.trailing.equalToSuperview().inset(AppSpacing.large)
            make.top.bottom.equalToSuperview().inset(AppSpacing.large)
        }
    }
}

private final class EnglishActionButton: UIControl {

    var onTap: (() -> Void)?

    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, style: EnglishButtonStyle, isSelected: Bool) {
        titleLabel.text = title
        titleLabel.textColor = style.titleColor
        titleLabel.font = AppFont.font(size: 15, weight: isSelected ? .bold : .semibold)
        backgroundColor = isSelected ? EnglishColor.accentSurface : style.backgroundColor
        layer.borderColor = (isSelected ? EnglishColor.accent : style.borderColor).cgColor
    }

    private func setupViews() {
        layer.cornerRadius = 20
        layer.borderWidth = 1
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        addSubview(titleLabel)
    }

    private func setupConstraints() {
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        }
    }

    @objc private func didTap() {
        AppAnimation.haptic(.light)
        onTap?()
    }
}
