//
//  FitRunningLiveActivityWidget.swift
//  SuperApp_PQLiveActivity
//
//  Created by Codex on 08/06/26.
//

import ActivityKit
import SwiftUI
import WidgetKit

@main
struct FitRunningLiveActivityBundle: WidgetBundle {
    var body: some Widget {
        FitRunningLiveActivityWidget()
    }
}

struct FitRunningLiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FitRunningLiveActivityAttributes.self) { context in
            FitRunningLockScreenView(context: context)
                .activityBackgroundTint(Color.fitBackground)
                .activitySystemActionForegroundColor(.white)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    FitMetricView(title: "DIST", value: context.state.distance)
                }
                DynamicIslandExpandedRegion(.center) {
                    FitMetricView(title: "TIME", value: context.state.elapsedTime)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    FitMetricView(title: "PACE", value: context.state.pace)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    FitRunningControlsView(state: context.state, isCompact: false)
                }
            } compactLeading: {
                Label(context.state.distance, systemImage: "figure.run")
                    .font(.caption2.weight(.semibold))
            } compactTrailing: {
                Text(context.state.elapsedTime)
                    .font(.caption2.weight(.semibold))
            } minimal: {
                Image(systemName: context.state.isPaused ? "pause.fill" : "figure.run")
            }
        }
    }
}

private struct FitRunningLockScreenView: View {
    let context: ActivityViewContext<FitRunningLiveActivityAttributes>

    var body: some View {
        VStack(spacing: 14) {
            HStack(alignment: .center, spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color.fitAccent.opacity(0.18))
                    Image(systemName: context.state.isPaused ? "pause.fill" : "figure.run")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(Color.fitAccent)
                }
                .frame(width: 38, height: 38)

                VStack(alignment: .leading, spacing: 2) {
                    Text(context.attributes.title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)
                    Text(context.state.status)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(Color.white.opacity(0.68))
                }

                Spacer()

                Text(context.state.elapsedTime)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .monospacedDigit()
            }

            HStack(spacing: 8) {
                FitMetricView(title: "DISTANCE", value: context.state.distance)
                FitMetricView(title: "PACE", value: context.state.pace)
                FitMetricView(title: "KCAL", value: context.state.calories)
            }

            FitRunningControlsView(state: context.state, isCompact: false)
        }
        .padding(16)
    }
}

private struct FitMetricView: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(Color.white.opacity(0.46))
            Text(value)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 9)
        .padding(.horizontal, 10)
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct FitRunningControlsView: View {
    let state: FitRunningLiveActivityAttributes.ContentState
    let isCompact: Bool

    var body: some View {
        HStack(spacing: 8) {
            Link(destination: controlURL(action: state.isPaused ? "resume" : "pause")) {
                Label(state.isPaused ? "Play" : "Pause", systemImage: state.isPaused ? "play.fill" : "pause.fill")
                    .labelStyle(.titleAndIcon)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            .font(.caption.weight(.bold))
            .foregroundStyle(Color.fitTextInverse)
            .padding(.vertical, isCompact ? 6 : 10)
            .background(Color.fitAccent, in: Capsule())

            Link(destination: controlURL(action: "stop")) {
                Label("Stop", systemImage: "stop.fill")
                    .labelStyle(.titleAndIcon)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.plain)
            .font(.caption.weight(.bold))
            .foregroundStyle(.white)
            .padding(.vertical, isCompact ? 6 : 10)
            .background(Color.white.opacity(0.13), in: Capsule())
        }
    }

    private func controlURL(action: String) -> URL {
        URL(string: "luma://fit/running/\(action)") ?? URL(string: "luma://fit/running")!
    }
}

private extension Color {
    static let fitBackground = Color(red: 0.01, green: 0.05, blue: 0.03)
    static let fitAccent = Color(red: 0.24, green: 0.91, blue: 0.43)
    static let fitTextInverse = Color(red: 0.02, green: 0.08, blue: 0.04)
}
