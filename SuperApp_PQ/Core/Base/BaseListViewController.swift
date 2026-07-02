//
//  BaseListViewController.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

/// Backward-compatible name for older collection-based list screens.
/// New screens should choose `BaseTableViewController` for simple row lists or
/// `BaseCollectionViewController` for complex layouts after analyzing the design.
class BaseListViewController<ViewModel: BaseViewModel>: BaseCollectionViewController<ViewModel> {}
