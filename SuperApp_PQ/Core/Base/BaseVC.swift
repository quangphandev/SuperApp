//
//  BaseVC.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import UIKit
import RxSwift
import RxCocoa

class BaseVC<VM: BaseVM>: UIViewController, Loadable {

    // MARK: - Properties

    let viewModel: VM
    let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(viewModel: VM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        Logger.debug("deinit: \(String(describing: type(of: self)))", category: .ui)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        setupConstraints()
        setupNavigation()
        setupBindings()
        setupActions()
        reloadData()
    }

    // MARK: - Setup (override in subclass)

    func setupViews() {}

    func setupConstraints() {}

    func setupNavigation() {}

    func setupBindings() {
        bindLoading()
        bindError()
    }

    func setupActions() {}

    func reloadData() {}

    // MARK: - Private Binding

    private func bindLoading() {
        viewModel.isLoadingRelay
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                isLoading ? self?.showLoading() : self?.hideLoading()
            })
            .disposed(by: disposeBag)
    }

    private func bindError() {
        viewModel.errorRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                self?.showError(error.message)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Helpers

    func showError(
        _ message: String,
        title: String = "Lỗi",
        actionTitle: String = "Đóng"
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default))
        present(alert, animated: true)
    }

    func showAlert(
        title: String,
        message: String,
        actions: [UIAlertAction] = []
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.isEmpty {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            actions.forEach { alert.addAction($0) }
        }
        present(alert, animated: true)
    }
}
