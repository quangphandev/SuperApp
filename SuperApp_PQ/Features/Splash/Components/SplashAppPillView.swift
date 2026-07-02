//
//  SplashAppPillView.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import SnapKit
import UIKit

final class SplashAppPillView: UIControl {

    // MARK: - Properties

    var onTap: ((SplashAppKind) -> Void)?
    private var item: SplashAppItem?

    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            guard isHighlighted != oldValue else { return }
            animatePress(isPressed: isHighlighted)
        }
    }

    // MARK: - UI Components

    private let iconBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 13
        return view
    }()

    private let initialsLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(size: 10, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.font(size: 10, weight: .semibold)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        return label
    }()

    // MARK: - Lifecycle

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

    // MARK: - API

    func configure(with item: SplashAppItem, isSelected: Bool) {
        self.item = item
        initialsLabel.text = item.initials
        titleLabel.text = item.title
        self.isSelected = isSelected
        updateAppearance()
    }

    // MARK: - Setup

    private func setupViews() {
        layer.cornerRadius = AppRadius.large
        layer.borderWidth = 1
        clipsToBounds = true

        addSubview(iconBackgroundView)
        addSubview(initialsLabel)
        addSubview(titleLabel)
    }

    private func setupConstraints() {
        iconBackgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(7)
            make.centerX.equalToSuperview()
            make.size.equalTo(26)
        }

        initialsLabel.snp.makeConstraints { make in
            make.center.equalTo(iconBackgroundView)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.small)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xSmall)
            make.bottom.equalToSuperview().inset(7)
        }
    }

    // MARK: - Helpers

    private func updateAppearance() {
        guard let item else { return }
        let accentColor = item.accent.color

        if isSelected {
            backgroundColor = accentColor
            layer.borderColor = accentColor.cgColor
            iconBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.22)
            initialsLabel.textColor = AppColor.textInverse
            titleLabel.textColor = AppColor.textInverse
        } else {
            backgroundColor = AppColor.surface
            layer.borderColor = AppColor.border.cgColor
            iconBackgroundView.backgroundColor = accentColor.withAlphaComponent(0.20)
            initialsLabel.textColor = accentColor
            titleLabel.textColor = AppColor.textPrimary
        }
    }

    private func animatePress(isPressed: Bool) {
        UIView.animate(
            withDuration: 0.14,
            delay: 0,
            options: [.allowUserInteraction, .curveEaseOut]
        ) {
            self.transform = isPressed ? CGAffineTransform(scaleX: 0.96, y: 0.96) : .identity
        }
    }

    // MARK: - Actions

    @objc private func didTap() {
        guard let item else { return }
        AppAnimation.haptic(.light)
        onTap?(item.kind)
    }
}
