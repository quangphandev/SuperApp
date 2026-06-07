//
//  BaseTableCell.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import UIKit
import RxSwift

class BaseTableCell: UITableViewCell, Reusable {

    // MARK: - Properties

    /// Reset on every prepareForReuse to cancel stale subscriptions.
    var disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    // MARK: - Setup (override in subclass)

    func setupViews() {}

    func setupConstraints() {}

    /// Called by the feature cell to bind data/model.
    func bindData() {}
}
