//
//  Logger.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 24/05/26.
//

import Foundation
import os

enum Logger {

    enum Category: String {
        case app = "APP"
        case auth = "AUTH"
        case network = "NETWORK"
        case ui = "UI"

        fileprivate var osLogger: os.Logger {
            os.Logger(
                subsystem: Bundle.main.bundleIdentifier ?? "SuperApp_PQ",
                category: rawValue
            )
        }
    }

    static func debug(
        _ message: @autoclosure () -> String,
        category: Category = .app,
        file: StaticString = #fileID,
        line: UInt = #line
    ) {
        #if DEBUG
        let msg = "\(file):\(line) - \(message())"
        category.osLogger.debug("\(msg)")
        #endif
    }

    static func info(
        _ message: @autoclosure () -> String,
        category: Category = .app,
        file: StaticString = #fileID,
        line: UInt = #line
    ) {
        #if DEBUG
        let msg = "\(file):\(line) - \(message())"
        category.osLogger.info("\(msg)")
        #endif
    }

    static func error(
        _ message: @autoclosure () -> String,
        category: Category = .app,
        file: StaticString = #fileID,
        line: UInt = #line
    ) {
        let msg = "\(file):\(line) - \(message())"
        category.osLogger.error("\(msg)")
    }
}
