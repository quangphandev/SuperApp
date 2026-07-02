//
//  HomeStateView.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import SnapKit
import UIKit

final class HomeStateView: UIView {

    // MARK: - Properties

    private var primaryActionKind: HomeStateActionKind?
    private var secondaryActionKind: HomeStateActionKind?
    private var onAction: ((HomeStateActionKind) -> Void)?

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = AppSpacing.large
        return stackView
    }()

    private let eyebrowLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.captionMedium
        label.numberOfLines = 1
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.title
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 0
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 0
        return label
    }()

    private let stateCardView = AppCardView()

    private let iconRingView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.elevatedSurface
        view.layer.borderWidth = 1.5
        view.layer.cornerRadius = 36
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(
            pointSize: 28,
            weight: .semibold
        )
        return imageView
    }()

    private let loadingIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()

    private let cardTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.headline
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let cardMessageLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textColor = AppColor.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let rowsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = AppSpacing.medium
        return stackView
    }()

    private let actionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = AppSpacing.small
        return stackView
    }()

    private lazy var primaryButton: AppButton = {
        let button = AppButton(title: "", style: .primary, size: .large)
        button.addTarget(self, action: #selector(didTapPrimaryButton), for: .touchUpInside)
        return button
    }()

    private lazy var secondaryButton: AppButton = {
        let button = AppButton(title: "", style: .ghost, size: .medium)
        button.addTarget(self, action: #selector(didTapSecondaryButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - API

    func configure(
        with content: HomeStateContent,
        onAction: @escaping (HomeStateActionKind) -> Void
    ) {
        self.onAction = onAction

        let accentColor = content.accent.color
        eyebrowLabel.text = content.eyebrow.uppercased()
        eyebrowLabel.textColor = accentColor
        titleLabel.text = content.title
        messageLabel.text = content.message
        iconRingView.layer.borderColor = accentColor.cgColor
        iconImageView.tintColor = accentColor
        loadingIndicatorView.color = accentColor
        cardTitleLabel.text = content.cardTitle
        cardMessageLabel.text = content.cardMessage

        configureIcon(content)
        configureRows(content.rows)
        configureButton(primaryButton, with: content.primaryAction)
        configureButton(secondaryButton, with: content.secondaryAction)

        primaryActionKind = content.primaryAction?.kind
        secondaryActionKind = content.secondaryAction?.kind
        actionsStackView.isHidden = content.primaryAction == nil && content.secondaryAction == nil
    }

    func setVisible(_ isVisible: Bool, animated: Bool) {
        guard isHidden != !isVisible else { return }

        if isVisible {
            isHidden = false
            guard animated else {
                alpha = 1
                transform = .identity
                return
            }

            alpha = 0
            transform = CGAffineTransform(translationX: 0, y: AppSpacing.medium)
            AppAnimation.spring {
                self.alpha = 1
                self.transform = .identity
            }
        } else {
            guard animated else {
                isHidden = true
                alpha = 0
                return
            }

            AppAnimation.animate(
                duration: AppAnimation.Duration.fast,
                animations: {
                    self.alpha = 0
                    self.transform = CGAffineTransform(translationX: 0, y: AppSpacing.small)
                },
                completion: { _ in
                    self.isHidden = true
                    self.transform = .identity
                }
            )
        }
    }

    // MARK: - Setup

    private func setupViews() {
        backgroundColor = AppColor.groupedBackground
        isHidden = true
        alpha = 0

        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)

        contentStackView.addArrangedSubview(eyebrowLabel)
        contentStackView.setCustomSpacing(AppSpacing.xSmall, after: eyebrowLabel)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.setCustomSpacing(AppSpacing.small, after: titleLabel)
        contentStackView.addArrangedSubview(messageLabel)
        contentStackView.addArrangedSubview(stateCardView)
        contentStackView.addArrangedSubview(rowsStackView)
        contentStackView.addArrangedSubview(actionsStackView)

        stateCardView.addSubview(iconRingView)
        iconRingView.addSubview(iconImageView)
        iconRingView.addSubview(loadingIndicatorView)
        stateCardView.addSubview(cardTitleLabel)
        stateCardView.addSubview(cardMessageLabel)

        actionsStackView.addArrangedSubview(primaryButton)
        actionsStackView.addArrangedSubview(secondaryButton)
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        contentStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppSpacing.xLarge)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.bottom.lessThanOrEqualToSuperview().inset(AppSpacing.section)
        }

        stateCardView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(196)
        }

        iconRingView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppSpacing.xLarge)
            make.centerX.equalToSuperview()
            make.size.equalTo(72)
        }

        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(32)
        }

        loadingIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        cardTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconRingView.snp.bottom).offset(AppSpacing.large)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
        }

        cardMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(cardTitleLabel.snp.bottom).offset(AppSpacing.small)
            make.leading.trailing.bottom.equalToSuperview().inset(AppSpacing.xLarge)
        }

        primaryButton.snp.makeConstraints { make in
            make.height.equalTo(AppButton.Size.large.height)
        }

        secondaryButton.snp.makeConstraints { make in
            make.height.equalTo(AppButton.Size.medium.height)
        }
    }

    // MARK: - Actions

    @objc private func didTapPrimaryButton() {
        guard let primaryActionKind else { return }
        onAction?(primaryActionKind)
    }

    @objc private func didTapSecondaryButton() {
        guard let secondaryActionKind else { return }
        onAction?(secondaryActionKind)
    }

    // MARK: - Helpers

    private func configureIcon(_ content: HomeStateContent) {
        if content.kind == .loading {
            iconImageView.isHidden = true
            loadingIndicatorView.startAnimating()
        } else {
            iconImageView.image = content.icon.templateImage
            iconImageView.isHidden = false
            loadingIndicatorView.stopAnimating()
        }
    }

    private func configureRows(_ rows: [HomeStateRow]) {
        rowsStackView.arrangedSubviews.forEach { view in
            rowsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        rowsStackView.isHidden = rows.isEmpty
        rows.forEach { row in
            let rowView = HomeStateRowView()
            rowView.configure(with: row)
            rowsStackView.addArrangedSubview(rowView)
        }
    }

    private func configureButton(_ button: AppButton, with action: HomeStateAction?) {
        guard let action else {
            button.isHidden = true
            return
        }

        button.isHidden = false
        button.configure(
            title: action.title,
            style: action.style.buttonStyle,
            size: button === primaryButton ? .large : .medium
        )
    }
}

// MARK: - Row

private final class HomeStateRowView: UIView {

    // MARK: - UI Components

    private let dotView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.bodyMedium
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 1
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 1
        return label
    }()

    private let actionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.captionMedium
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - API

    func configure(with row: HomeStateRow) {
        let accentColor = row.accent.color
        dotView.backgroundColor = accentColor
        titleLabel.text = row.title
        subtitleLabel.text = row.subtitle
        actionLabel.text = row.actionTitle
        actionLabel.textColor = accentColor
        actionLabel.isHidden = row.actionTitle == nil
    }

    // MARK: - Setup

    private func setupViews() {
        backgroundColor = AppColor.surface
        layer.cornerRadius = AppRadius.large
        layer.borderWidth = 1
        layer.borderColor = AppColor.border.cgColor

        addSubview(dotView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(actionLabel)
    }

    private func setupConstraints() {
        snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(64)
        }

        dotView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.large)
            make.centerY.equalToSuperview()
            make.size.equalTo(12)
        }

        actionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(AppSpacing.large)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(84)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppSpacing.medium)
            make.leading.equalTo(dotView.snp.trailing).offset(AppSpacing.medium)
            make.trailing.equalTo(actionLabel.snp.leading).offset(-AppSpacing.small)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
            make.bottom.lessThanOrEqualToSuperview().inset(AppSpacing.medium)
        }
    }
}

// MARK: - UI Mapping

private extension HomeStateAccent {

    var color: UIColor {
        switch self {
        case .home:
            return AppColor.accent
        case .english:
            return AppColor.accentSecondary
        case .fit:
            return AppColor.success
        case .todo:
            return AppColor.warning
        case .warning:
            return AppColor.warning
        case .error:
            return AppColor.error
        case .conflict:
            return AppColor.accentSecondary
        case .muted:
            return AppColor.textSecondary
        }
    }
}

private extension HomeStateActionStyle {

    var buttonStyle: AppButton.Style {
        switch self {
        case .primary:
            return .primary
        case .secondary:
            return .secondary
        case .destructive:
            return .destructive
        case .ghost:
            return .ghost
        }
    }
}
