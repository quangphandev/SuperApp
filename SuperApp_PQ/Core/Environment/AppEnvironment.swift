//
//  AppEnvironment.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 28/05/26.
//

import Foundation
import UIKit

/// Định nghĩa các loại môi trường trong hệ thống
public enum AppEnv: String, CaseIterable {
    case debug = "Debug"
    case qa = "QA"
    case staging = "Staging"
    case production = "Production"
}

/// Namespace chứa tất cả các cấu hình được đọc từ Info.plist (xcconfig)
public enum AppEnvironment {
    
    // MARK: - Private Keys
    
    private enum Keys: String {
        case environment = "APP_ENVIRONMENT"
        case baseURL = "BASE_URL"
        case displayName = "CFBundleDisplayName"
        case bundleName = "CFBundleName"
        case shortVersion = "CFBundleShortVersionString"
        case buildVersion = "CFBundleVersion"
    }
    
    // MARK: - Private Properties
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Info.plist could not be loaded!")
        }
        return dict
    }()
    
    // MARK: - Public Properties
    
    /// Môi trường hiện tại của ứng dụng (Debug, QA, Staging, Production)
    public static let active: AppEnv = {
        guard let envString = infoDictionary[Keys.environment.rawValue] as? String,
              let env = AppEnv(rawValue: envString) else {
            fatalError("Key 'APP_ENVIRONMENT' is missing or invalid in Info.plist!")
        }
        return env
    }()
    
    /// Base URL cho các API request
    public static let baseURL: URL = {
        guard let urlString = infoDictionary[Keys.baseURL.rawValue] as? String,
              let url = URL(string: urlString) else {
            fatalError("Key 'BASE_URL' is missing or invalid in Info.plist!")
        }
        return url
    }()
    
    /// Tên hiển thị của App dưới Icon màn hình chính
    public static let appName: String = {
        let name = infoDictionary[Keys.displayName.rawValue] as? String
            ?? infoDictionary[Keys.bundleName.rawValue] as? String
            ?? "SuperApp"
        return name
    }()
    
    /// Phiên bản của ứng dụng (Marketing Version - e.g. 1.0.0)
    public static let appVersion: String = {
        let version = infoDictionary[Keys.shortVersion.rawValue] as? String ?? "1.0.0"
        return version
    }()
    
    /// Số hiệu build (Build Number - e.g. 14)
    public static let buildNumber: String = {
        let build = infoDictionary[Keys.buildVersion.rawValue] as? String ?? "1"
        return build
    }()
    
    /// Bundle Identifier của App (e.g. com.vn.SuperAPP.Debug)
    public static let bundleIdentifier: String = {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            fatalError("Bundle Identifier is missing!")
        }
        return bundleId
    }()
    
    /// Lấy Icon hiện tại của ứng dụng dynamically
    public static var appIcon: UIImage? {
        if let icons = infoDictionary["CFBundleIcons"] as? [String: Any],
           let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
           let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
           let lastIcon = iconFiles.last {
            return UIImage(named: lastIcon)
        }
        return nil
    }
}
