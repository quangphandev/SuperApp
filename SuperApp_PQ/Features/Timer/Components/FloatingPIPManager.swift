//
//  FloatingPIPManager.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 12/06/26.
//

import UIKit

final class FloatingPIPManager {
    static let shared = FloatingPIPManager()

    private var activePIPView: FloatingPIPView?
    private var navigationController: UINavigationController?
    private var dependencyContainer: AppDependencyContainer?
    private var currentPosition: CGPoint = .zero

    private init() {}

    func showPIP(
        navigationController: UINavigationController,
        dependencyContainer: AppDependencyContainer,
        title: String = "SALE 20:00",
        subtitle: String = "Flash deal · voucher",
        duration: TimeInterval = 491,
        badge: String = "đang chạy · T-60s",
        tone: TimerTone = .danger
    ) {
        if let existing = activePIPView {
            existing.configure(title: title, subtitle: subtitle, time: "00:08:12", badge: badge, tone: tone)
            return
        }

        self.navigationController = navigationController
        self.dependencyContainer = dependencyContainer

        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let window = windowScene.windows.first(where: { $0.isKeyWindow })
        else { return }

        let pip = FloatingPIPView()
        pip.configure(title: title, subtitle: subtitle, time: "00:08:12", badge: badge, tone: tone)

        let safeArea = window.safeAreaInsets
        let pipWidth: CGFloat = 176
        let pipHeight: CGFloat = 128
        let startX = window.bounds.width - safeArea.right - pipWidth / 2 - 16
        let startY = safeArea.top + pipHeight / 2 + 80

        pip.frame = CGRect(x: 0, y: 0, width: pipWidth, height: pipHeight)
        pip.center = CGPoint(x: startX, y: startY)

        window.addSubview(pip)
        self.activePIPView = pip

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pip.addGestureRecognizer(pan)

        pip.onCloseTap = { [weak self] in
            self?.dismissPIP()
            self?.routeToTracking()
        }

        pip.onOpenTap = { [weak self] in
            self?.dismissPIP()
            self?.routeToTargetDetail()
        }

        pip.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        pip.alpha = 0
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            pip.transform = .identity
            pip.alpha = 1
        }, completion: nil)
    }

    func dismissPIP() {
        guard let pip = activePIPView else { return }
        UIView.animate(withDuration: 0.2, animations: {
            pip.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            pip.alpha = 0
        }) { _ in
            pip.removeFromSuperview()
            if self.activePIPView === pip {
                self.activePIPView = nil
                self.navigationController = nil
                self.dependencyContainer = nil
            }
        }
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let pipView = activePIPView, let window = pipView.window else { return }
        let translation = gesture.translation(in: window)

        switch gesture.state {
        case .began:
            currentPosition = pipView.center
        case .changed:
            var newCenter = CGPoint(x: currentPosition.x + translation.x, y: currentPosition.y + translation.y)

            let safeArea = window.safeAreaInsets
            let minX = safeArea.left + pipView.bounds.width / 2 + 10
            let maxX = window.bounds.width - safeArea.right - pipView.bounds.width / 2 - 10
            let minY = safeArea.top + pipView.bounds.height / 2 + 10
            let maxY = window.bounds.height - safeArea.bottom - pipView.bounds.height / 2 - 10

            newCenter.x = min(max(newCenter.x, minX), maxX)
            newCenter.y = min(max(newCenter.y, minY), maxY)

            pipView.center = newCenter
        case .ended, .cancelled:
            let safeArea = window.safeAreaInsets
            let midX = window.bounds.width / 2
            let leftX = safeArea.left + pipView.bounds.width / 2 + 16
            let rightX = window.bounds.width - safeArea.right - pipView.bounds.width / 2 - 16

            let targetX = pipView.center.x < midX ? leftX : rightX
            let targetY = pipView.center.y

            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                pipView.center = CGPoint(x: targetX, y: targetY)
            }, completion: nil)
        default:
            break
        }
    }

    private func routeToTracking() {
        guard let nav = navigationController, let container = dependencyContainer else { return }
        let timerCoordinator = container.makeTimerCoordinator(navigationController: nav)
        timerCoordinator.start()
        timerCoordinator.showTimer(state: .tracking)
    }

    private func routeToTargetDetail() {
        guard let nav = navigationController, let container = dependencyContainer else { return }
        let timerCoordinator = container.makeTimerCoordinator(navigationController: nav)
        timerCoordinator.start()
        timerCoordinator.showTimer(state: .targetDetail)
    }
}
