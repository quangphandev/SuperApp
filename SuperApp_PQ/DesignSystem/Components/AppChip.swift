//
//  AppChip.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

/// A compact chip/tag component for filters, categories, and labels.
///
/// Modes:
/// - `.display`    — read-only label chip (cannot be tapped)
/// - `.selectable` — tappable, toggles between selected/unselected
/// - `.dismissible` — has an × button; calls `onDismiss` when tapped
///
/// Style:
/// - `.filled`   — colored background, white text
/// - `.outlined` — transparent background, colored border + text
///
/// Usage:
/// ```swift
/// // Filter chip
/// let chip = AppChip(title: "Cardio", mode: .selectable)
/// chip.isSelected = true
///
/// // Tag chip
/// let tag = AppChip(title: "Swift", mode: .display, style: .filled, color: AppColor.accent)
///
/// // Dismissible
/// let chip = AppChip(title: "Hà Nội", mode: .dismissible)
/// chip.onDismiss = { [weak self] in self?.removeChip(chip) }
/// ```
final class AppChip: UIView {

    // MARK: - Types

    enum Mode { case display, selectable, dismissible }
    enum Style { case filled, outlined }

    // MARK: - Callbacks

    var onDismiss:   (() -> Void)?
    var onSelect:    ((Bool) -> Void)?

    // MARK: - Public State

    var isSelected: Bool = false {
        didSet { updateAppearance() }
    }

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    // MARK: - UI

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = AppFont.caption
        l.textAlignment = .center
        return l
    }()

    private lazy var dismissButton: UIButton = {
        let b = UIButton(type: .custom)
        b.setImage(UIImage(systemName: "xmark")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 9, weight: .medium)
        ), for: .normal)
        b.addTarget(self, action: #selector(_dismiss), for: .touchUpInside)
        return b
    }()

    // MARK: - Private

    private let mode:  Mode
    private let style: Style
    private let accentColor: UIColor

    // MARK: - Init

    init(
        title: String,
        mode:  Mode  = .selectable,
        style: Style = .outlined,
        color: UIColor = AppColor.accent
    ) {
        self.mode        = mode
        self.style       = style
        self.accentColor = color
        super.init(frame: .zero)
        titleLabel.text  = title
        setupViews()
        setupGesture()
        updateAppearance()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setupViews() {
        layer.cornerRadius = 14
        clipsToBounds = true

        let stack = UIStackView(arrangedSubviews: [titleLabel])
        stack.axis    = .horizontal
        stack.spacing = 4
        stack.alignment = .center

        if mode == .dismissible {
            dismissButton.tintColor = accentColor
            stack.addArrangedSubview(dismissButton)
            dismissButton.snp.makeConstraints { make in make.size.equalTo(14) }
        }

        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(
                top: 6,
                left: AppSpacing.medium,
                bottom: 6,
                right: mode == .dismissible ? 8 : AppSpacing.medium
            ))
        }
    }

    private func setupGesture() {
        guard mode == .selectable else { return }
        let tap = UITapGestureRecognizer(target: self, action: #selector(_toggleSelect))
        addGestureRecognizer(tap)
    }

    private func updateAppearance() {
        let isActive = (mode == .selectable && isSelected) || mode == .display

        switch style {
        case .filled:
            backgroundColor = isActive ? accentColor : AppColor.surface
            layer.borderWidth = 0
            titleLabel.textColor = isActive ? AppColor.textInverse : AppColor.textSecondary

        case .outlined:
            backgroundColor = isActive ? accentColor.withAlphaComponent(0.12) : .clear
            layer.borderWidth = 1
            layer.borderColor = (isActive ? accentColor : UIColor.separator).cgColor
            titleLabel.textColor = isActive ? accentColor : AppColor.textSecondary
        }

        UIView.animate(withDuration: 0.15) { self.transform = .identity }
    }

    // MARK: - Actions

    @objc private func _toggleSelect() {
        isSelected = !isSelected
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) { self.transform = .identity }
        }
        onSelect?(isSelected)
    }

    @objc private func _dismiss() {
        onDismiss?()
    }
}

// MARK: - Reactive

extension Reactive where Base: AppChip {

    var isSelected: Binder<Bool> {
        Binder(base) { chip, value in chip.isSelected = value }
    }

    var selectedState: Observable<Bool> {
        Observable.create { [weak base] observer in
            let original = base?.onSelect
            base?.onSelect = { isSelected in
                original?(isSelected)
                observer.onNext(isSelected)
            }
            return Disposables.create()
        }
    }
}
