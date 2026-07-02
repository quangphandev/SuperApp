//
//  FitRunningLiveActivityController.swift
//  SuperApp_PQ
//
//  Created by Codex on 08/06/26.
//

import Foundation

#if canImport(ActivityKit)
import ActivityKit
#endif

final class FitRunningLiveActivityController {

    static let shared = FitRunningLiveActivityController()

    private init() {}

#if canImport(ActivityKit)
    private var currentActivity: Any?
#endif

    func sync(state: FitRunningState, content: FitRunningContent) {
        guard #available(iOS 16.1, *) else { return }

        switch state {
        case .active:
            startOrUpdate(content: content, isPaused: false)
        case .paused, .confirmStop:
            startOrUpdate(content: content, isPaused: true)
        case .summary:
            end(content: content)
        case .ready,
             .locationPermission,
             .gpsWeak,
             .backgroundBlocked,
             .musicPermission,
             .playlistPicker,
             .goalSetup,
             .history,
             .historyDetail:
            break
        }
    }

    func handle(url: URL) -> FitRunningState? {
        guard url.scheme == "luma", url.host == "fit" else { return nil }
        let components = url.pathComponents.filter { $0 != "/" }
        guard components.first == "running", let action = components.last else { return nil }

        switch action {
        case "pause":
            updateControl(status: "Tạm dừng", isPaused: true)
            return .paused
        case "resume":
            updateControl(status: "Đang chạy", isPaused: false)
            return .active
        case "stop":
            updateControl(status: "Đã lưu", isPaused: false)
            return .summary
        default:
            return nil
        }
    }

    @available(iOS 16.1, *)
    private func startOrUpdate(content: FitRunningContent, isPaused: Bool) {
#if canImport(ActivityKit)
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let state = makeContentState(from: content, isPaused: isPaused)

        Task {
            if let activity = currentActivity as? Activity<FitRunningLiveActivityAttributes> {
                await update(activity, with: state)
                return
            }

            do {
                let attributes = FitRunningLiveActivityAttributes(
                    runId: UUID().uuidString,
                    title: "Luma Fit"
                )
                currentActivity = try Activity.request(
                    attributes: attributes,
                    contentState: state,
                    pushType: nil
                )
            } catch {
                Logger.error("Cannot start Fit running live activity: \(error.localizedDescription)", category: .ui)
            }
        }
#endif
    }

    @available(iOS 16.1, *)
    private func end(content: FitRunningContent) {
#if canImport(ActivityKit)
        guard let activity = currentActivity as? Activity<FitRunningLiveActivityAttributes> else { return }
        let state = makeContentState(from: content, isPaused: false)
        self.currentActivity = nil

        Task {
            if #available(iOS 16.2, *) {
                await activity.end(
                    ActivityContent(state: state, staleDate: nil),
                    dismissalPolicy: .default
                )
            } else {
                await activity.end(using: state, dismissalPolicy: .default)
            }
        }
#endif
    }

    private func updateControl(status: String, isPaused: Bool) {
        guard #available(iOS 16.1, *) else { return }
#if canImport(ActivityKit)
        guard let activity = currentActivity as? Activity<FitRunningLiveActivityAttributes> else { return }
        let state = FitRunningLiveActivityAttributes.ContentState(
            status: status,
            distance: activity.contentState.distance,
            elapsedTime: activity.contentState.elapsedTime,
            pace: activity.contentState.pace,
            calories: activity.contentState.calories,
            isPaused: isPaused,
            updatedAt: Date()
        )

        Task {
            await update(activity, with: state)
        }
#endif
    }

#if canImport(ActivityKit)
    @available(iOS 16.1, *)
    private func update(
        _ activity: Activity<FitRunningLiveActivityAttributes>,
        with state: FitRunningLiveActivityAttributes.ContentState
    ) async {
        if #available(iOS 16.2, *) {
            await activity.update(ActivityContent(state: state, staleDate: Date().addingTimeInterval(60)))
        } else {
            await activity.update(using: state)
        }
    }

    private func makeContentState(
        from content: FitRunningContent,
        isPaused: Bool
    ) -> FitRunningLiveActivityAttributes.ContentState {
        FitRunningLiveActivityAttributes.ContentState(
            status: content.topPill,
            distance: value(for: ["ĐANG CHẠY", "ĐÃ TẠM DỪNG", "DISTANCE", "HOÀN THÀNH"], in: content) ?? "0.00 km",
            elapsedTime: value(for: ["TIME"], in: content) ?? "--",
            pace: value(for: ["PACE"], in: content) ?? "-- /km",
            calories: value(for: ["CALORIES"], in: content) ?? "0 kcal",
            isPaused: isPaused,
            updatedAt: Date()
        )
    }

    private func value(for titles: [String], in content: FitRunningContent) -> String? {
        guard let stat = content.stats.first(where: { titles.contains($0.title) }) else {
            return nil
        }

        if stat.subtitle.isEmpty {
            return stat.value
        }
        return "\(stat.value) \(stat.subtitle)"
    }
#endif
}
