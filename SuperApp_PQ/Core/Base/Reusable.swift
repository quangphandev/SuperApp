//
//  Reusable.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import UIKit

// MARK: - Reusable Protocol

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

// MARK: - UICollectionView Extension

extension UICollectionView {

    func register<T: UICollectionViewCell>(_ cellType: T.Type) where T: Reusable {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    func registerCells(_ cellTypes: (UICollectionViewCell & Reusable).Type...) {
        cellTypes.forEach { cellType in
            register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
        }
    }

    func dequeue<T: UICollectionViewCell>(
        _ cellType: T.Type,
        for indexPath: IndexPath,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            ReuseError.fail(
                "Could not dequeue collection cell: \(cellType.reuseIdentifier)",
                file: file,
                line: line
            )
        }
        return cell
    }

    func registerHeader<T: UICollectionReusableView>(_ viewType: T.Type) where T: Reusable {
        register(
            viewType,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: viewType.reuseIdentifier
        )
    }

    func dequeueHeader<T: UICollectionReusableView>(
        _ viewType: T.Type,
        for indexPath: IndexPath,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> T where T: Reusable {
        guard let header = dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: viewType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            ReuseError.fail(
                "Could not dequeue collection header: \(viewType.reuseIdentifier)",
                file: file,
                line: line
            )
        }
        return header
    }
}

// MARK: - UITableView Extension

extension UITableView {

    func register<T: UITableViewCell>(_ cellType: T.Type) where T: Reusable {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }

    func registerCells(_ cellTypes: (UITableViewCell & Reusable).Type...) {
        cellTypes.forEach { cellType in
            register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
        }
    }

    func dequeue<T: UITableViewCell>(
        _ cellType: T.Type,
        for indexPath: IndexPath,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(
            withIdentifier: cellType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            ReuseError.fail(
                "Could not dequeue table cell: \(cellType.reuseIdentifier)",
                file: file,
                line: line
            )
        }
        return cell
    }

    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ viewType: T.Type) where T: Reusable {
        register(viewType, forHeaderFooterViewReuseIdentifier: viewType.reuseIdentifier)
    }

    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(
        _ viewType: T.Type,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> T where T: Reusable {
        guard let view = dequeueReusableHeaderFooterView(
            withIdentifier: viewType.reuseIdentifier
        ) as? T else {
            ReuseError.fail(
                "Could not dequeue table header/footer: \(viewType.reuseIdentifier)",
                file: file,
                line: line
            )
        }
        return view
    }
}

private enum ReuseError {

    static func fail(
        _ message: String,
        file: StaticString,
        line: UInt
    ) -> Never {
        Logger.error(message, category: .ui, file: file, line: line)
        fatalError(message, file: file, line: line)
    }
}
