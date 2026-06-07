//
//  BaseTableHeaderFooterView.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 03/06/26.
//

import RxSwift
import UIKit

/// Base reusable header/footer view for table sections.
class BaseTableHeaderFooterView: UITableViewHeaderFooterView, Reusable {

    // MARK: - Properties

    /// Reset on every reuse to cancel stale subscriptions.
    var disposeBag = DisposeBag()

    // MARK: - Lifecycle

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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

    // MARK: - Setup

    func setupViews() {}

    func setupConstraints() {}
}
