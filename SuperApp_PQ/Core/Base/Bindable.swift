//
//  Bindable.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 22/5/26.
//

import Foundation

/// Bindable defines the contract for a view or cell that accepts a ViewModel.
/// Used primarily in Cells or reusable Views that receive data via `bind(viewModel:)`.
protocol Bindable: AnyObject {
    associatedtype ViewModelType
    func bind(viewModel: ViewModelType)
}
