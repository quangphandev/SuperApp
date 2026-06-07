//
//  BaseHeaderView.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 31/05/26.
//

import UIKit
import RxSwift
import SnapKit

// MARK: - BaseHeaderView

/// Base class for `UICollectionReusableView` section headers and footers.
/// Conforms to `Reusable` — use `collectionView.registerHeader(MyHeader.self)`.
///
/// Usage:
/// ```swift
/// final class SectionHeader: BaseHeaderView {
///     private let titleLabel = UILabel.make(font: AppFont.bodyMedium)
///
///     override func setupViews() {
///         contentView.addSubview(titleLabel)
///     }
///
///     override func setupConstraints() {
///         titleLabel.snp.makeConstraints { $0.edges.equalToSuperview().inset(16) }
///     }
///
///     override func prepareForReuse() {
///         super.prepareForReuse()
///         titleLabel.text = nil
///     }
///
///     func configure(title: String) {
///         titleLabel.text = title
///     }
/// }
/// ```
class BaseHeaderView: UICollectionReusableView, Reusable {

    // MARK: - Properties

    /// Reset on every `prepareForReuse` to cancel stale subscriptions.
    var disposeBag = DisposeBag()

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

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    // MARK: - Setup (override in subclass)

    func setupViews() {}
    func setupConstraints() {}
}

// MARK: - UICollectionView Header/Footer Registration

extension UICollectionView {

    // MARK: Footer

    func registerFooter<T: UICollectionReusableView>(_ viewType: T.Type) where T: Reusable {
        register(
            viewType,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: viewType.reuseIdentifier
        )
    }

    func dequeueFooter<T: UICollectionReusableView>(_ viewType: T.Type, for indexPath: IndexPath) -> T where T: Reusable {
        guard let footer = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: viewType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("❌ Could not dequeue footer: \(viewType.reuseIdentifier)")
        }
        return footer
    }
}
