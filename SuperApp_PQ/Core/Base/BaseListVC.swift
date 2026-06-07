//
//  BaseListVC.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

/// Backward-compatible name for older collection-based list screens.
/// New screens should choose `BaseTableVC` for simple row lists or
/// `BaseCollectionVC` for complex layouts after analyzing the design.
class BaseListVC<VM: BaseVM>: BaseCollectionVC<VM> {}
