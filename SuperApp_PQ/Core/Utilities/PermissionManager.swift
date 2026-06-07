//
//  PermissionManager.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 01/06/26.
//

import AVFoundation
import Photos
import RxSwift
import UIKit
import UserNotifications

/// Centralized permission request and status management.
///
/// All requests return `Single<PermissionStatus>`, which completes
/// with the current status after (optionally) requesting access.
///
/// Usage:
/// ```swift
/// PermissionManager.shared.requestCamera()
///     .subscribe(onSuccess: { status in
///         switch status {
///         case .granted:  self.openCamera()
///         case .denied:   self.showSettingsAlert()
///         case .notDetermined: break
///         }
///     })
///     .disposed(by: disposeBag)
/// ```
final class PermissionManager {

    // MARK: - Singleton

    static let shared = PermissionManager()
    private init() {}

    // MARK: - Types

    enum PermissionStatus {
        case granted
        case denied
        case restricted
        case notDetermined
        case limited          // Photos library
    }

    enum PermissionType {
        case camera
        case photoLibrary
        case notification
        case locationWhenInUse
    }

    // MARK: - Camera

    /// Requests access to the device camera.
    func requestCamera() -> Single<PermissionStatus> {
        Single.create { observer in
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .authorized:
                observer(.success(.granted))
            case .denied, .restricted:
                observer(.success(status == .restricted ? .restricted : .denied))
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    DispatchQueue.main.async {
                        observer(.success(granted ? .granted : .denied))
                    }
                }
            @unknown default:
                observer(.success(.denied))
            }
            return Disposables.create()
        }
    }

    // MARK: - Photo Library

    /// Requests access to the photo library.
    func requestPhotoLibrary() -> Single<PermissionStatus> {
        Single.create { observer in
            let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
            switch status {
            case .authorized:
                observer(.success(.granted))
            case .limited:
                observer(.success(.limited))
            case .denied:
                observer(.success(.denied))
            case .restricted:
                observer(.success(.restricted))
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                    DispatchQueue.main.async {
                        switch newStatus {
                        case .authorized:    observer(.success(.granted))
                        case .limited:       observer(.success(.limited))
                        case .denied:        observer(.success(.denied))
                        case .restricted:    observer(.success(.restricted))
                        default:             observer(.success(.notDetermined))
                        }
                    }
                }
            @unknown default:
                observer(.success(.denied))
            }
            return Disposables.create()
        }
    }

    // MARK: - Notifications

    /// Requests permission to send push notifications.
    func requestNotifications() -> Single<PermissionStatus> {
        Single.create { observer in
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound]
            ) { granted, _ in
                DispatchQueue.main.async {
                    observer(.success(granted ? .granted : .denied))
                }
            }
            return Disposables.create()
        }
    }

    // MARK: - Current Status (sync)

    /// Returns the current status without requesting (no prompt).
    func currentStatus(for type: PermissionType) -> PermissionStatus {
        switch type {
        case .camera:
            return mapAVStatus(AVCaptureDevice.authorizationStatus(for: .video))
        case .photoLibrary:
            return mapPHStatus(PHPhotoLibrary.authorizationStatus(for: .readWrite))
        case .notification:
            return .notDetermined  // Async only — use requestNotifications()
        case .locationWhenInUse:
            return .notDetermined  // Requires CLLocationManager
        }
    }

    // MARK: - Open Settings

    /// Opens the app's settings page in iOS Settings app.
    /// Use when the user has permanently denied a permission.
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    // MARK: - Alert Helper

    /// Shows an alert prompting the user to enable the permission in Settings.
    func showDeniedAlert(
        for type: PermissionType,
        from viewController: UIViewController
    ) {
        let name: String
        switch type {
        case .camera:         name = "Camera"
        case .photoLibrary:   name = "Ảnh"
        case .notification:   name = "Thông báo"
        case .locationWhenInUse: name = "Vị trí"
        }

        let alert = UIAlertController(
            title: "\(name) bị từ chối",
            message: "Vui lòng vào Cài đặt để cho phép quyền truy cập \(name.lowercased()).",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Hủy", style: .cancel))
        alert.addAction(UIAlertAction(title: "Mở Cài đặt", style: .default) { [weak self] _ in
            self?.openAppSettings()
        })
        viewController.present(alert, animated: true)
    }

    // MARK: - Private Mappers

    private func mapAVStatus(_ status: AVAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .authorized:    return .granted
        case .denied:        return .denied
        case .restricted:    return .restricted
        case .notDetermined: return .notDetermined
        @unknown default:    return .denied
        }
    }

    private func mapPHStatus(_ status: PHAuthorizationStatus) -> PermissionStatus {
        switch status {
        case .authorized:    return .granted
        case .limited:       return .limited
        case .denied:        return .denied
        case .restricted:    return .restricted
        case .notDetermined: return .notDetermined
        @unknown default:    return .denied
        }
    }
}
