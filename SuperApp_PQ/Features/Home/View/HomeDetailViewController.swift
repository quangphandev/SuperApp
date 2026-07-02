//
//  HomeDetailViewController.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class HomeDetailViewController: BaseViewController<HomeDetailViewModel> {

    // MARK: - UI Components

    private let stateView = StateView()

    // MARK: - Setup

    override func setupViews() {
        view.backgroundColor = AppColor.groupedBackground
        view.addSubview(stateView)
    }

    override func setupConstraints() {
        stateView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(AppSpacing.xLarge)
            make.centerY.equalToSuperview()
        }
    }

    override func setupBindings() {
        super.setupBindings()

        let output = viewModel.transform()

        output.navigationTitle
            .drive(rx.title)
            .disposed(by: disposeBag)

        Driver.combineLatest(output.title, output.message)
            .drive(onNext: { [weak self] title, message in
                self?.stateView.configure(title: title, message: message)
            })
            .disposed(by: disposeBag)
    }
}
