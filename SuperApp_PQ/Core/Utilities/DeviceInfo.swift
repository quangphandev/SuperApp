//
//  DeviceInfo.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import UIKit

enum DeviceInfo {

    static var systemVersion: String {
        UIDevice.current.systemVersion
    }

    static var model: String {
        UIDevice.current.model
    }
}

