//
//  SplashActionCell.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import SnapKit
import UIKit

final class SplashActionCell: BaseCollectionCell {

    // MARK: - Properties

    var onTap: (() -> Void)?

    // MARK: - UI Components

    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        return button
    }()

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        onTap = nil
    }

    // MARK: - API

    func configure(title: String, isEnabled: Bool, accentColor: UIColor) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = isEnabled ? accentColor : AppColor.disabledSurface
        config.baseForegroundColor = isEnabled ? AppColor.textInverse : AppColor.textTertiary
        config.background.backgroundColor = isEnabled ? accentColor : AppColor.disabledSurface
        config.background.cornerRadius = 18
        config.contentInsets = NSDirectionalEdgeInsets(
            top: AppSpacing.medium,
            leading: AppSpacing.xLarge,
            bottom: AppSpacing.medium,
            trailing: AppSpacing.xLarge
        )
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { attrs in
            var output = attrs
            output.font = AppFont.headline
            return output
        }

        continueButton.configuration = config
        continueButton.isEnabled = isEnabled
        continueButton.alpha = 1
    }

    // MARK: - Setup

    override func setupViews() {
        contentView.addSubview(continueButton)
        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
    }

    override func setupConstraints() {
        continueButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27)
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
            make.height.equalTo(48)
            make.bottom.equalToSuperview()
        }
    }

    // MARK: - Actions

    @objc private func didTapContinue() {
        AppAnimation.haptic(.light)
        onTap?()
    }
}
