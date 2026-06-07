//
//  DebugInfoVC.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 28/05/26.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class DebugInfoVC: BaseVC<DebugInfoVM> {

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.backgroundColor = AppColor.surface
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Setup

    override func setupViews() {
        view.backgroundColor = AppColor.groupedBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(iconImageView)
        contentView.addSubview(infoLabel)
        
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = closeButton
    }

    override func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(AppSpacing.xLarge)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(AppSpacing.large)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.large)
            make.bottom.equalToSuperview().inset(AppSpacing.large)
        }
    }

    override func setupNavigation() {
        navigationItem.largeTitleDisplayMode = .never
    }

    override func setupBindings() {
        super.setupBindings()

        let closeTap = navigationItem.rightBarButtonItem?.rx.tap.asSignal() ?? .empty()
        
        let input = DebugInfoVM.Input(
            closeTap: closeTap
        )
        let output = viewModel.transform(input: input)

        output.title
            .drive(rx.title)
            .disposed(by: disposeBag)
            
        output.configInfo
            .drive(infoLabel.rx.text)
            .disposed(by: disposeBag)
            
        output.appIcon
            .drive(iconImageView.rx.image)
            .disposed(by: disposeBag)
            
        output.routeToClose
            .emit(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
