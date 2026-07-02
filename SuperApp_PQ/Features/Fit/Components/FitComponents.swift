//
//  FitComponents.swift
//  SuperApp_PQ
//
//  Created by Codex on 08/06/26.
//

import CoreLocation
import MapKit
import SnapKit
import UIKit

class FitCardView: UIView {

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = FitColor.surface
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = FitColor.border.cgColor
    }
}

class FitPillButton: UIControl {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.captionMedium
        label.textAlignment = .center
        return label
    }()

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

    func configure(text: String, filled: Bool = true, accent: UIColor = FitColor.accent, textColor: UIColor? = nil) {
        titleLabel.text = text
        backgroundColor = filled ? accent : FitColor.surface
        layer.borderColor = accent.cgColor
        layer.borderWidth = 1
        titleLabel.textColor = textColor ?? (filled ? FitColor.textInverse : accent)
    }

    private func setupViews() {
        layer.cornerRadius = 13
        addSubview(titleLabel)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10))
        }
    }

    @objc private func didTap() {
        AppAnimation.haptic(.light)
    }
}

final class FitProgressView: UIView {

    private let trackView = UIView()
    private let fillView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(progress: CGFloat, color: UIColor = FitColor.accent) {
        fillView.backgroundColor = color
        fillView.snp.remakeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(min(max(progress, 0), 1))
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let radius = bounds.height / 2
        trackView.layer.cornerRadius = radius
        fillView.layer.cornerRadius = radius
    }

    private func setupViews() {
        backgroundColor = .clear
        trackView.backgroundColor = FitColor.border
        fillView.backgroundColor = FitColor.accent
        addSubview(trackView)
        addSubview(fillView)
    }

    private func setupConstraints() {
        trackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        fillView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(0)
        }
    }
}

final class FitTopBarView: UIView {

    private let backLabel = UILabel()
    private let titleLabel = UILabel()
    private let rightPill = FitPillButton()
    private let divider = UIView()

    var onBackTap: (() -> Void)?
    var onRightTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        let backTap = UITapGestureRecognizer(target: self, action: #selector(didTapBack))
        backLabel.isUserInteractionEnabled = true
        backLabel.addGestureRecognizer(backTap)
        rightPill.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(backTitle: String = "< Fit", title: String, rightTitle: String, rightFilled: Bool = true) {
        backLabel.text = backTitle
        titleLabel.text = title
        rightPill.configure(text: rightTitle, filled: rightFilled)
    }

    private func setupViews() {
        backgroundColor = FitColor.background
        backLabel.font = AppFont.bodyMedium
        backLabel.textColor = FitColor.textSecondary
        titleLabel.font = AppFont.headline
        titleLabel.textColor = FitColor.textPrimary
        titleLabel.textAlignment = .center
        divider.backgroundColor = FitColor.border
        addSubview(backLabel)
        addSubview(titleLabel)
        addSubview(rightPill)
        addSubview(divider)
    }

    private func setupConstraints() {
        backLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.xLarge)
            make.bottom.equalTo(divider.snp.top).offset(-AppSpacing.large)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backLabel)
            make.leading.greaterThanOrEqualTo(backLabel.snp.trailing).offset(AppSpacing.medium)
            make.trailing.lessThanOrEqualTo(rightPill.snp.leading).offset(-AppSpacing.medium)
        }

        rightPill.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.centerY.equalTo(backLabel)
            make.height.equalTo(26)
            make.width.greaterThanOrEqualTo(56)
        }

        divider.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
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

final class FitBottomNavView: UIView {

    private let divider = UIView()
    private let indicator = UIView()
    private let stackView = UIStackView()
    private var itemViews: [FitBottomNavItemView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with items: [FitNavItem], onSelect: ((FitNavItem) -> Void)? = nil) {
        itemViews.forEach { $0.removeFromSuperview() }
        itemViews.removeAll()
        stackView.arrangedSubviews.forEach { subview in
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }

        items.forEach { item in
            let itemView = FitBottomNavItemView()
            itemView.configure(with: item)
            itemView.onTap = { onSelect?(item) }
            stackView.addArrangedSubview(itemView)
            itemViews.append(itemView)
        }
    }

    private func setupViews() {
        backgroundColor = FitColor.navigation
        divider.backgroundColor = FitColor.border
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        addSubview(divider)
        addSubview(stackView)
    }

    private func setupConstraints() {
        divider.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        stackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}

private final class FitBottomNavItemView: UIControl {

    var onTap: (() -> Void)?

    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let indicatorDot = UIView()

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

    func configure(with item: FitNavItem) {
        let tint = item.isSelected ? FitColor.accent : FitColor.textMuted
        let iconName: String
        switch item.kind {
        case .home:
            iconName = item.isSelected ? "fit_home_active" : "fit_home_inactive"
        case .workout:
            iconName = item.isSelected ? "fit_workout_active" : "fit_workout_inactive"
        case .nutrition:
            iconName = item.isSelected ? "fit_nutrition_active" : "fit_nutrition_inactive"
        case .sleep:
            iconName = item.isSelected ? "fit_sleep_active" : "fit_sleep_inactive"
        case .profile:
            iconName = item.isSelected ? "fit_profile_active" : "fit_profile_inactive"
        }
        iconView.image = UIImage(named: iconName)?.withRenderingMode(.alwaysTemplate)
        iconView.tintColor = tint
        titleLabel.text = item.title
        titleLabel.textColor = tint
        titleLabel.font = AppFont.font(size: 10, weight: item.isSelected ? .medium : .regular)
        indicatorDot.isHidden = !item.isSelected
    }

    private func setupViews() {
        iconView.contentMode = .scaleAspectFit
        iconView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular)
        titleLabel.textAlignment = .center
        indicatorDot.backgroundColor = FitColor.accent
        indicatorDot.layer.cornerRadius = 2
        indicatorDot.isHidden = true
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(indicatorDot)
    }

    private func setupConstraints() {
        iconView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.size.equalTo(16)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }

        indicatorDot.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.size.equalTo(4)
            make.bottom.lessThanOrEqualToSuperview().offset(-3)
        }
    }

    @objc private func didTap() {
        AppAnimation.haptic(.light)
        onTap?()
    }
}

final class FitRoutePreviewView: UIView, MKMapViewDelegate {

    private let routeCoordinates = [
        CLLocationCoordinate2D(latitude: 10.7769, longitude: 106.7009),
        CLLocationCoordinate2D(latitude: 10.7794, longitude: 106.7042),
        CLLocationCoordinate2D(latitude: 10.7820, longitude: 106.7030),
        CLLocationCoordinate2D(latitude: 10.7842, longitude: 106.7067),
        CLLocationCoordinate2D(latitude: 10.7865, longitude: 106.7048)
    ]

    private let mapProviderLabel = UILabel()
    private let statusLabel = UILabel()
    private let trailingPill = FitPillButton()
    private let mapContainerView = UIView()
    private var mapContentView: UIView?

    private var appleMapView: MKMapView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(labelText: String?, trailingText: String?, routeColor: UIColor = FitColor.route) {
        statusLabel.text = labelText ?? "Live route"
        trailingPill.isHidden = trailingText == nil
        if let trailingText {
            trailingPill.configure(text: trailingText)
        }
    }

    private func setupViews() {
        backgroundColor = FitColor.surface
        layer.cornerRadius = AppRadius.medium
        layer.borderWidth = 1
        layer.borderColor = FitColor.border.cgColor
        clipsToBounds = true
        mapProviderLabel.font = AppFont.font(size: 11, weight: .medium)
        mapProviderLabel.textColor = FitColor.textMuted
        mapProviderLabel.text = "Apple Maps"
        statusLabel.font = AppFont.font(size: 11, weight: .medium)
        statusLabel.textColor = FitColor.textSecondary
        trailingPill.configure(text: "Live route")
        mapContainerView.backgroundColor = FitColor.background
        mapContainerView.clipsToBounds = true
        addSubview(mapContainerView)
        addSubview(mapProviderLabel)
        addSubview(statusLabel)
        addSubview(trailingPill)
        installMapView()
    }

    private func setupConstraints() {
        mapContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        mapProviderLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(AppSpacing.medium)
        }

        statusLabel.snp.makeConstraints { make in
            make.leading.equalTo(mapProviderLabel)
            make.top.equalTo(mapProviderLabel.snp.bottom).offset(2)
        }

        trailingPill.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(AppSpacing.medium)
            make.height.equalTo(26)
        }
    }

    private func installMapView() {
        installAppleMapView()
    }

    private func installAppleMapView() {
        let mapView = MKMapView()
        mapView.overrideUserInterfaceStyle = .dark
        mapView.delegate = self
        mapView.pointOfInterestFilter = .excludingAll
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false
        mapContainerView.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
        mapView.addOverlay(polyline)
        mapView.setVisibleMapRect(
            polyline.boundingMapRect,
            edgePadding: UIEdgeInsets(top: 44, left: 28, bottom: 28, right: 28),
            animated: false
        )
        appleMapView = mapView
        mapContentView = mapView
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }

        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = FitColor.accent
        renderer.lineWidth = 5
        renderer.lineCap = .round
        renderer.lineJoin = .round
        return renderer
    }
}
