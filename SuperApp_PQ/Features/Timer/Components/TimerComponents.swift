//
//  TimerComponents.swift
//  SuperApp_PQ
//
//  Created by Codex on 12/06/26.
//

import SnapKit
import UIKit

final class TimerTopBarView: UIView {

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
    }

    private func setupViews() {
        backgroundColor = TimerColor.navigation
        backLabel.font = AppFont.font(size: 13, weight: .regular)
        backLabel.textColor = TimerColor.textSecondary
        backLabel.isUserInteractionEnabled = true
        titleLabel.font = AppFont.font(size: 19, weight: .semibold)
        titleLabel.textColor = TimerColor.textPrimary
        titleLabel.textAlignment = .center
        pillButton.backgroundColor = TimerColor.accent
        pillButton.layer.cornerRadius = 15
        pillLabel.font = AppFont.font(size: 12, weight: .regular)
        pillLabel.textColor = TimerColor.textInverse
        pillLabel.textAlignment = .center
        dividerView.backgroundColor = TimerColor.border
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
            make.width.greaterThanOrEqualTo(74)
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

final class TimerBottomNavView: UIView {

    private let dividerView = UIView()
    private let itemsStackView = UIStackView()
    private var itemViews: [TimerBottomNavItemView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with items: [TimerNavItem], onSelect: @escaping (TimerNavItem) -> Void) {
        itemViews.forEach { $0.removeFromSuperview() }
        itemViews.removeAll()
        itemsStackView.arrangedSubviews.forEach { view in
            itemsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        items.forEach { item in
            let itemView = TimerBottomNavItemView()
            itemView.configure(with: item)
            itemView.onTap = { onSelect(item) }
            itemsStackView.addArrangedSubview(itemView)
            itemViews.append(itemView)
        }
    }

    private func setupViews() {
        backgroundColor = TimerColor.navigation
        dividerView.backgroundColor = TimerColor.border
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

private final class TimerBottomNavItemView: UIControl {

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

    func configure(with item: TimerNavItem) {
        let color = item.isSelected ? TimerColor.accentStrong : TimerColor.textMuted
        indicatorView.isHidden = !item.isSelected
        iconLabel.text = item.icon
        iconLabel.textColor = color
        titleLabel.text = item.title
        titleLabel.textColor = color
    }

    private func setupViews() {
        indicatorView.backgroundColor = TimerColor.accentStrong
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

class TimerCardView: UIView {

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = TimerColor.surface
        layer.cornerRadius = AppRadius.large
        layer.borderWidth = 1
        layer.borderColor = TimerColor.border.cgColor
    }
}

final class TimerHeroView: TimerCardView {

    var onActionTap: (() -> Void)?

    private let eyebrowLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let timeLabel = UILabel()
    private let ringView = TimerRingProgressView()
    private let actionButton = UIControl()
    private let actionLabel = UILabel()

    override init() {
        super.init()
        setupContent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with content: TimerHeroContent) {
        let toneColor = content.tone.color
        layer.borderColor = toneColor.withAlphaComponent(0.72).cgColor
        backgroundColor = content.tone == .danger ? TimerColor.danger.withAlphaComponent(0.22) : TimerColor.elevatedSurface
        eyebrowLabel.text = content.eyebrow
        eyebrowLabel.isHidden = content.eyebrow.isEmpty
        eyebrowLabel.textColor = toneColor
        titleLabel.text = content.title
        subtitleLabel.text = content.subtitle
        timeLabel.text = content.time
        timeLabel.isHidden = content.time == nil
        timeLabel.textColor = toneColor
        ringView.isHidden = content.time == nil
        ringView.configure(progress: content.progress, tone: toneColor)
        actionLabel.text = content.actionTitle
        actionButton.isHidden = content.actionTitle == nil
    }

    private func setupContent() {
        eyebrowLabel.font = AppFont.font(size: 11, weight: .bold)
        titleLabel.font = AppFont.font(size: 24, weight: .bold)
        titleLabel.textColor = TimerColor.textPrimary
        subtitleLabel.font = AppFont.font(size: 13, weight: .regular)
        subtitleLabel.textColor = TimerColor.textSecondary
        subtitleLabel.numberOfLines = 2
        timeLabel.font = AppFont.font(size: 30, weight: .bold)
        timeLabel.textAlignment = .center
        actionButton.backgroundColor = TimerColor.accent
        actionButton.layer.cornerRadius = 21
        actionButton.addTarget(self, action: #selector(didTapAction), for: .touchUpInside)
        actionLabel.font = AppFont.font(size: 15, weight: .regular)
        actionLabel.textColor = TimerColor.textInverse
        actionLabel.textAlignment = .center
        addSubview(eyebrowLabel)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(ringView)
        addSubview(timeLabel)
        addSubview(actionButton)
        actionButton.addSubview(actionLabel)

        eyebrowLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualTo(ringView.snp.leading).offset(-AppSpacing.medium)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(eyebrowLabel)
            make.top.equalTo(eyebrowLabel.snp.bottom).offset(AppSpacing.medium)
            make.trailing.lessThanOrEqualTo(ringView.snp.leading).offset(-AppSpacing.medium)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(eyebrowLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.width.equalTo(212)
        }

        ringView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(26)
            make.trailing.equalToSuperview().inset(40)
            make.size.equalTo(78)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(ringView.snp.bottom).offset(AppSpacing.medium)
            make.centerX.equalTo(ringView)
        }

        actionButton.snp.makeConstraints { make in
            make.leading.equalTo(eyebrowLabel)
            make.top.greaterThanOrEqualTo(subtitleLabel.snp.bottom).offset(AppSpacing.small)
            make.bottom.equalToSuperview().inset(18)
            make.width.equalTo(188)
            make.height.equalTo(42)
        }

        actionLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        }
    }

    @objc private func didTapAction() {
        AppAnimation.haptic(.light)
        onActionTap?()
    }
}

final class TimerStatGridView: UIView {

    private let rootStackView = UIStackView()

    init(items: [TimerStatItem]) {
        super.init(frame: .zero)
        setupViews()
        configure(items: items)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        rootStackView.axis = .horizontal
        rootStackView.distribution = .fillEqually
        rootStackView.spacing = AppSpacing.large
        addSubview(rootStackView)
        rootStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func configure(items: [TimerStatItem]) {
        items.forEach { item in
            rootStackView.addArrangedSubview(TimerStatCardView(item: item))
        }
    }
}

private final class TimerStatCardView: TimerCardView {

    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    init(item: TimerStatItem) {
        super.init()
        layer.cornerRadius = AppRadius.large
        setupContent()
        configure(item: item)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContent() {
        titleLabel.font = AppFont.font(size: 11, weight: .bold)
        titleLabel.textColor = TimerColor.textMuted
        valueLabel.font = AppFont.font(size: 18, weight: .semibold)
        valueLabel.textColor = TimerColor.textPrimary
        addSubview(titleLabel)
        addSubview(valueLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(12)
        }
        valueLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(AppSpacing.small)
            make.bottom.lessThanOrEqualToSuperview().inset(12)
        }
    }

    private func configure(item: TimerStatItem) {
        titleLabel.text = item.title
        valueLabel.text = item.value
    }
}

final class TimerSectionTitleView: UILabel {

    init(title: String) {
        super.init(frame: .zero)
        text = title
        font = AppFont.font(size: 12, weight: .bold)
        textColor = TimerColor.textMuted
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class TimerRowsView: UIStackView {

    init(rows: [TimerRowItem], onTap: @escaping (TimerRowItem) -> Void) {
        super.init(frame: .zero)
        axis = .vertical
        spacing = AppSpacing.small
        rows.forEach { row in
            let rowView = TimerRowView(item: row)
            rowView.onTap = { onTap(row) }
            addArrangedSubview(rowView)
        }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class TimerRowView: UIControl {

    var onTap: (() -> Void)?

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let actionLabel = UILabel()
    private let dotView = UIView()

    init(item: TimerRowItem) {
        super.init(frame: .zero)
        setupContent()
        configure(item: item)
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContent() {
        backgroundColor = TimerColor.surface
        layer.cornerRadius = AppRadius.large
        layer.borderWidth = 1
        layer.borderColor = TimerColor.border.cgColor
        titleLabel.font = AppFont.font(size: 15, weight: .regular)
        titleLabel.textColor = TimerColor.textPrimary
        subtitleLabel.font = AppFont.font(size: 11, weight: .regular)
        subtitleLabel.textColor = TimerColor.textMuted
        actionLabel.font = AppFont.font(size: 12, weight: .regular)
        actionLabel.textColor = TimerColor.accent
        actionLabel.textAlignment = .right
        dotView.layer.cornerRadius = 8
        dotView.isHidden = true
        addSubview(dotView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(actionLabel)

        snp.makeConstraints { make in
            make.height.equalTo(58)
        }

        dotView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.large)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.large)
            make.top.equalToSuperview().offset(9)
            make.trailing.lessThanOrEqualTo(actionLabel.snp.leading).offset(-AppSpacing.medium)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.trailing.lessThanOrEqualTo(actionLabel.snp.leading).offset(-AppSpacing.medium)
        }

        actionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(AppSpacing.large)
            make.centerY.equalToSuperview()
            make.width.equalTo(68)
        }
    }

    private func configure(item: TimerRowItem) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        actionLabel.text = item.actionTitle
        actionLabel.isHidden = item.actionTitle == nil
        dotView.backgroundColor = item.tone.color
        let showDot = item.tone == .danger || item.tone == .warning || item.tone == .success
        dotView.isHidden = !showDot
        titleLabel.snp.updateConstraints { make in
            make.leading.equalToSuperview().offset(showDot ? 42 : AppSpacing.large)
        }
    }

    @objc private func didTap() {
        AppAnimation.haptic(.light)
        onTap?()
    }
}

final class TimerDurationPickerView: UIStackView {

    init(items: [TimerDurationItem]) {
        super.init(frame: .zero)
        axis = .horizontal
        distribution = .fillEqually
        spacing = AppSpacing.small
        items.forEach { item in
            addArrangedSubview(TimerDurationOptionView(item: item))
        }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class TimerDurationOptionView: TimerCardView {

    private let valueLabel = UILabel()
    private let subtitleLabel = UILabel()

    init(item: TimerDurationItem) {
        super.init()
        layer.cornerRadius = 18
        setupContent()
        configure(item: item)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContent() {
        valueLabel.font = AppFont.font(size: 22, weight: .bold)
        valueLabel.textAlignment = .center
        subtitleLabel.font = AppFont.font(size: 11, weight: .regular)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = TimerColor.textMuted
        addSubview(valueLabel)
        addSubview(subtitleLabel)
        snp.makeConstraints { make in
            make.height.equalTo(66)
        }
        valueLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(valueLabel.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview()
        }
    }

    private func configure(item: TimerDurationItem) {
        backgroundColor = item.isSelected ? TimerColor.accentSurface : TimerColor.surface
        layer.borderColor = (item.isSelected ? TimerColor.accentBorder : TimerColor.border).cgColor
        valueLabel.text = item.value
        valueLabel.textColor = item.isSelected ? TimerColor.accent : TimerColor.textPrimary
        subtitleLabel.text = item.subtitle
    }
}

final class TimerRingView: UIView {

    private let eyebrowLabel = UILabel()
    private let ringView = TimerRingProgressView()
    private let timeLabel = UILabel()
    private let subtitleLabel = UILabel()

    init(content: TimerRingContent) {
        super.init(frame: .zero)
        setupViews()
        configure(content: content)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        eyebrowLabel.font = AppFont.font(size: 12, weight: .bold)
        eyebrowLabel.textAlignment = .center
        timeLabel.font = AppFont.font(size: 58, weight: .bold)
        timeLabel.textColor = TimerColor.textPrimary
        timeLabel.textAlignment = .center
        subtitleLabel.font = AppFont.font(size: 14, weight: .regular)
        subtitleLabel.textColor = TimerColor.textSecondary
        subtitleLabel.textAlignment = .center
        addSubview(eyebrowLabel)
        addSubview(ringView)
        addSubview(timeLabel)
        addSubview(subtitleLabel)
        snp.makeConstraints { make in
            make.height.equalTo(390)
        }
        eyebrowLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(18)
        }
        ringView.snp.makeConstraints { make in
            make.top.equalTo(eyebrowLabel.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
            make.size.equalTo(250)
        }
        timeLabel.snp.makeConstraints { make in
            make.center.equalTo(ringView)
            make.leading.trailing.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(AppSpacing.small)
            make.leading.trailing.equalToSuperview()
        }
    }

    private func configure(content: TimerRingContent) {
        let color = content.tone.color
        eyebrowLabel.text = content.eyebrow
        eyebrowLabel.textColor = color
        timeLabel.text = content.time
        subtitleLabel.text = content.subtitle
        ringView.configure(progress: content.progress, tone: color)
    }
}

final class TimerRingProgressView: UIView {

    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private var progress: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(progress: CGFloat, tone: UIColor) {
        self.progress = min(max(progress, 0), 1)
        progressLayer.strokeColor = tone.cgColor
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let lineWidth: CGFloat = bounds.width > 100 ? 12 : 10
        let radius = min(bounds.width, bounds.height) / 2 - lineWidth / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: 1.5 * .pi,
            clockwise: true
        )
        trackLayer.frame = bounds
        trackLayer.path = path.cgPath
        trackLayer.lineWidth = lineWidth
        progressLayer.frame = bounds
        progressLayer.path = path.cgPath
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeEnd = progress
    }

    private func setupLayers() {
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = TimerColor.accentSurface.cgColor
        trackLayer.lineCap = .butt
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = TimerColor.accent.cgColor
        progressLayer.lineCap = .butt
        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
    }
}

final class TimerControlsView: UIStackView {

    init(items: [TimerButtonItem], onTap: @escaping (TimerButtonItem) -> Void) {
        super.init(frame: .zero)
        axis = .horizontal
        distribution = .fillEqually
        spacing = AppSpacing.medium
        backgroundColor = TimerColor.surface
        layer.cornerRadius = 28
        layer.borderWidth = 1
        layer.borderColor = TimerColor.border.cgColor
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 18, bottom: 12, trailing: 18)
        items.forEach { item in
            let btn = TimerActionButton(item: item, compact: true)
            btn.onTap = { onTap(item) }
            addArrangedSubview(btn)
        }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class TimerButtonsView: UIStackView {

    init(items: [TimerButtonItem], onTap: @escaping (TimerButtonItem) -> Void) {
        super.init(frame: .zero)
        let shouldUseHorizontalLayout = items.count > 1 && items.count <= 3 && items.allSatisfy { $0.style == .primary }
        axis = shouldUseHorizontalLayout ? .horizontal : .vertical
        distribution = shouldUseHorizontalLayout ? .fillEqually : .fill
        spacing = AppSpacing.medium
        items.forEach { item in
            let btn = TimerActionButton(item: item, compact: false)
            btn.onTap = { onTap(item) }
            addArrangedSubview(btn)
        }
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class TimerActionButton: UIControl {

    var onTap: (() -> Void)?

    private let titleLabel = UILabel()
    private let compact: Bool

    init(item: TimerButtonItem, compact: Bool) {
        self.compact = compact
        super.init(frame: .zero)
        setupViews()
        configure(item: item)
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        layer.cornerRadius = compact ? 24 : 26
        titleLabel.font = AppFont.font(size: compact ? 14 : 15, weight: .regular)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        snp.makeConstraints { make in
            make.height.equalTo(compact ? 48 : 52)
        }
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
        }
    }

    private func configure(item: TimerButtonItem) {
        titleLabel.text = item.title
        switch item.style {
        case .primary:
            backgroundColor = TimerColor.accent
            layer.borderWidth = 0
            titleLabel.textColor = TimerColor.textInverse
        case .secondary:
            backgroundColor = TimerColor.accent.withAlphaComponent(0.14)
            layer.borderWidth = 1
            layer.borderColor = TimerColor.border.cgColor
            titleLabel.textColor = TimerColor.accent
        case .danger:
            backgroundColor = TimerColor.danger
            layer.borderWidth = 0
            titleLabel.textColor = TimerColor.textInverse
        }
    }

    @objc private func didTap() {
        AppAnimation.haptic(.light)
        onTap?()
    }
}

final class TimerProgressCardView: TimerCardView {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let trackView = UIView()
    private let fillView = UIView()
    private var progress: CGFloat = 0

    init(content: TimerProgressContent) {
        super.init()
        setupContent()
        configure(content: content)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContent() {
        titleLabel.font = AppFont.font(size: 15, weight: .regular)
        titleLabel.textColor = TimerColor.textPrimary
        subtitleLabel.font = AppFont.font(size: 12, weight: .regular)
        subtitleLabel.textColor = TimerColor.textMuted
        trackView.backgroundColor = TimerColor.accentSurface
        trackView.layer.cornerRadius = 2.5
        fillView.layer.cornerRadius = 2.5
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(trackView)
        trackView.addSubview(fillView)
        snp.makeConstraints { make in
            make.height.equalTo(76)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(18)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.trailing.equalTo(titleLabel)
        }
        trackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(18)
            make.height.equalTo(5)
        }
        fillView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0)
        }
    }

    private func configure(content: TimerProgressContent) {
        progress = min(max(content.progress, 0), 1)
        titleLabel.text = content.title
        subtitleLabel.text = content.subtitle
        fillView.backgroundColor = content.tone.color
        fillView.snp.remakeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(progress)
        }
    }
}

final class TimerStateCardView: TimerCardView {

    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()

    init(content: TimerStateContent) {
        super.init()
        setupContent()
        configure(content: content)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContent() {
        iconLabel.font = AppFont.font(size: 34, weight: .bold)
        iconLabel.textAlignment = .center
        iconLabel.layer.cornerRadius = 34
        iconLabel.clipsToBounds = true
        titleLabel.font = AppFont.font(size: 23, weight: .semibold)
        titleLabel.textColor = TimerColor.textPrimary
        titleLabel.numberOfLines = 0
        messageLabel.font = AppFont.font(size: 14, weight: .regular)
        messageLabel.textColor = TimerColor.textSecondary
        messageLabel.numberOfLines = 0
        addSubview(iconLabel)
        addSubview(titleLabel)
        addSubview(messageLabel)
        iconLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview().inset(AppSpacing.large)
            make.size.equalTo(68)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconLabel.snp.bottom).offset(AppSpacing.large)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
        }
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(AppSpacing.small)
            make.leading.trailing.bottom.equalToSuperview().inset(AppSpacing.xLarge)
        }
    }

    private func configure(content: TimerStateContent) {
        let color = content.tone.color
        iconLabel.text = content.icon
        let hasIcon = !content.icon.isEmpty
        iconLabel.isHidden = !hasIcon
        iconLabel.backgroundColor = color
        iconLabel.textColor = TimerColor.textInverse
        titleLabel.text = content.title
        messageLabel.text = content.message
        backgroundColor = content.tone == .muted ? .clear : TimerColor.elevatedSurface
        layer.borderWidth = content.tone == .muted ? 0 : 1
        layer.borderColor = TimerColor.border.cgColor

        iconLabel.snp.remakeConstraints { make in
            make.top.centerX.equalToSuperview().inset(hasIcon ? AppSpacing.large : 0)
            make.size.equalTo(hasIcon ? 68 : 0)
        }

        titleLabel.snp.remakeConstraints { make in
            if hasIcon {
                make.top.equalTo(iconLabel.snp.bottom).offset(AppSpacing.large)
            } else {
                make.top.equalToSuperview()
            }
            make.leading.trailing.equalToSuperview().inset(content.tone == .muted ? 4 : AppSpacing.xLarge)
        }

        messageLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(AppSpacing.small)
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalToSuperview().inset(content.tone == .muted ? 0 : AppSpacing.xLarge)
        }
    }
}

final class TimerSegmentedView: TimerCardView {

    private let titleLabel = UILabel()
    private let optionsStackView = UIStackView()

    init(content: TimerSegmentedContent) {
        super.init()
        setupContent()
        configure(content: content)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContent() {
        titleLabel.font = AppFont.font(size: 17, weight: .regular)
        titleLabel.textColor = TimerColor.textPrimary
        optionsStackView.axis = .horizontal
        optionsStackView.distribution = .fillEqually
        optionsStackView.spacing = AppSpacing.small
        addSubview(titleLabel)
        addSubview(optionsStackView)
        snp.makeConstraints { make in
            make.height.equalTo(128)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(AppSpacing.large)
        }
        optionsStackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(AppSpacing.large)
            make.height.equalTo(40)
        }
    }

    private func configure(content: TimerSegmentedContent) {
        titleLabel.text = content.title
        content.options.enumerated().forEach { index, option in
            let optionLabel = UILabel()
            optionLabel.text = option
            optionLabel.font = AppFont.font(size: 13, weight: .regular)
            optionLabel.textAlignment = .center
            optionLabel.textColor = index == content.selectedIndex ? TimerColor.textInverse : TimerColor.textMuted
            optionLabel.backgroundColor = index == content.selectedIndex ? TimerColor.accent : TimerColor.elevatedSurface
            optionLabel.layer.cornerRadius = 20
            optionLabel.clipsToBounds = true
            optionsStackView.addArrangedSubview(optionLabel)
        }
    }
}

final class TimerPIPPreviewView: TimerCardView {

    private let pipView = FloatingPIPView()

    init(content: TimerPIPPreviewContent) {
        super.init()
        setupContent()
        configure(content: content)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContent() {
        backgroundColor = .clear
        layer.borderWidth = 0
        layer.shadowColor = nil
        layer.shadowOpacity = 0

        addSubview(pipView)
        pipView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(176)
            make.height.equalTo(128)
            make.top.bottom.equalToSuperview().inset(6)
        }
    }

    private func configure(content: TimerPIPPreviewContent) {
        pipView.configure(
            title: content.title,
            subtitle: content.subtitle,
            time: content.time,
            badge: content.badge,
            tone: content.tone
        )
    }
}

private extension TimerTone {
    var color: UIColor {
        switch self {
        case .accent:
            return TimerColor.accent
        case .danger:
            return TimerColor.danger
        case .warning:
            return TimerColor.warning
        case .success:
            return TimerColor.success
        case .muted:
            return TimerColor.textMuted
        }
    }
}
