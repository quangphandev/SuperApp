//
//  Loadable.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import UIKit

// MARK: - Loadable Protocol

protocol Loadable: AnyObject {
    func showLoading()
    func hideLoading()
}

// MARK: - Default Implementation for UIViewController

extension Loadable where Self: UIViewController {

    func showLoading() {
        DispatchQueue.main.async {
            LoadingOverlay.show(in: self.view)
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            LoadingOverlay.hide(from: self.view)
        }
    }
}

// MARK: - LoadingOverlay

private final class LoadingOverlay: UIView {

    // MARK: - UI Components

    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.layer.cornerRadius = 14
        return view
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        return indicator
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

    // MARK: - Setup

    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.black.withAlphaComponent(0.15)
        addSubview(containerView)
        containerView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 80),
            containerView.heightAnchor.constraint(equalToConstant: 80),

            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }

    // MARK: - Static Helpers

    static func show(in view: UIView) {
        guard !view.subviews.contains(where: { $0 is LoadingOverlay }) else { return }
        let overlay = LoadingOverlay()
        view.addSubview(overlay)
        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.bringSubviewToFront(overlay)
    }

    static func hide(from view: UIView) {
        view.subviews
            .filter { $0 is LoadingOverlay }
            .forEach { $0.removeFromSuperview() }
    }
}
