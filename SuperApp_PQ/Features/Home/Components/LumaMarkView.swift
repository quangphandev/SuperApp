//
//  LumaMarkView.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 07/06/26.
//

import SnapKit
import UIKit

final class LumaMarkView: UIView {

    // MARK: - UI Components

    private let orbitView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = AppColor.accent.cgColor
        view.layer.cornerRadius = 11
        view.transform = CGAffineTransform(rotationAngle: -0.18)
        return view
    }()

    private let coreView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.accent
        view.layer.cornerRadius = 3
        return view
    }()

    private let sparkView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.error
        view.layer.cornerRadius = 3
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
            make.leading.bottom.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(18)
        }

        coreView.snp.makeConstraints { make in
            make.center.equalTo(orbitView)
            make.size.equalTo(6)
        }

        sparkView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.size.equalTo(6)
        }
    }
}
