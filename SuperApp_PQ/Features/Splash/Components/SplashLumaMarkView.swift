//
//  SplashLumaMarkView.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import SnapKit
import UIKit

final class SplashLumaMarkView: UIView {

    // MARK: - UI Components

    private let orbitView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColor.brandOrbit.withAlphaComponent(0.72).cgColor
        view.layer.cornerRadius = 21
        view.transform = CGAffineTransform(rotationAngle: -0.18)
        return view
    }()

    private let coreView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.brandCore
        view.layer.cornerRadius = 11
        return view
    }()

    private let sparkView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.brandSpark
        view.layer.cornerRadius = 7
        return view
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
        addSubview(orbitView)
        addSubview(coreView)
        addSubview(sparkView)
    }

    private func setupConstraints() {
        orbitView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(10)
            make.width.equalTo(64)
            make.height.equalTo(42)
        }

        coreView.snp.makeConstraints { make in
            make.center.equalTo(orbitView)
            make.size.equalTo(22)
        }

        sparkView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.trailing.equalToSuperview().inset(12)
            make.size.equalTo(14)
        }
    }
}
