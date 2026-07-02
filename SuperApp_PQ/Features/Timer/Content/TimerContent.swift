//
//  TimerContent.swift
//  SuperApp_PQ
//
//  Created by Codex on 12/06/26.
//

import UIKit

protocol TimerContentProviding {
    func makeContent(for state: TimerScreenState) -> TimerScreenContent
}

struct LocalizedTimerContentProvider: TimerContentProviding {

    func makeContent(for state: TimerScreenState) -> TimerScreenContent {
        switch state {
        case .home:
            return makeHomeContent()
        case .focusSetup:
            return makeFocusSetupContent()
        case .focusRunning:
            return makeFocusRunningContent()
        case .focusPaused:
            return makeFocusPausedContent()
        case .focusDone:
            return makeFocusDoneContent()
        case .presets:
            return makePresetsContent()
        case .stopwatch:
            return makeStopwatchContent()
        case .settings:
            return makeSettingsContent()
        case .tracking:
            return makeTrackingContent()
        case .targetDetail:
            return makeTargetDetailContent()
        case .targetForm:
            return makeTargetFormContent()
        case .alertRules:
            return makeAlertRulesContent()
        case .pipSetup:
            return makePIPSetupContent()
        case .pipFloating:
            return makePIPFloatingContent()
        case .trackingEmpty:
            return makeStateContent(
                state: state,
                title: "Tracking",
                pill: "Empty",
                icon: "+",
                stateTitle: "Chưa có mốc nào",
                message: "Tạo mốc săn sale, PK game hoặc mở bán vé để theo dõi bằng countdown và PIP.",
                rows: [
                    row("Săn sale flash", "20:00 hôm nay · nháy T-60s", action: "Dùng"),
                    row("PK boss game", "Lặp hằng ngày · alarm đúng giờ", action: "Dùng"),
                    row("Mở bán vé", "Báo trước 10 phút · bật PIP", action: "Dùng")
                ],
                buttons: [button("Thêm mốc giờ")]
            )
        case .trackingLoading:
            return makeStateContent(
                state: state,
                title: "Tracking",
                pill: "Sync",
                icon: "↻",
                stateTitle: "Đang đồng bộ mốc giờ",
                message: "Giữ countdown local nếu có mốc đang chạy. Dữ liệu cloud sẽ cập nhật khi kết nối ổn định.",
                rows: [],
                buttons: []
            )
        case .trackingError:
            return makeStateContent(
                state: state,
                title: "Tracking",
                pill: "Error",
                icon: "!",
                stateTitle: "Không tải được tracking",
                message: "Countdown đang chạy vẫn dùng dữ liệu local. Kiểm tra mạng rồi thử đồng bộ lại.",
                tone: .danger,
                rows: [
                    row("Flash sale 20:00", "Bản local · cập nhật 09:40", action: "Track"),
                    row("Cloud sync lỗi", "Không ghi đè cho tới khi sync lại", action: "Chi tiết")
                ],
                buttons: [button("Thử lại"), button("Dùng local", style: .secondary)]
            )
        case .targetMissed:
            return makeStateContent(
                state: state,
                title: "Missed",
                pill: "00:00",
                icon: "0",
                stateTitle: "Mốc giờ đã qua",
                message: "Flash sale 20:00 đã qua 2 phút. Chọn lưu kết quả, tạo lại hoặc xoá mốc này.",
                tone: .danger,
                rows: [
                    row("Săn sale flash 20:00", "Missed · không có thao tác checkout", action: "Log")
                ],
                buttons: [
                    button("Tạo lại ngày mai"),
                    button("Đánh dấu đã xong", style: .secondary),
                    button("Xóa mốc này", style: .danger)
                ]
            )
        case .deviceTimeDrift:
            return makeStateContent(
                state: state,
                title: "Lệch giờ",
                pill: "Risk",
                icon: "±",
                stateTitle: "Giờ thiết bị có thể lệch",
                message: "Countdown chính xác cần dùng timezone và clock đáng tin cậy. Đồng bộ giờ trước khi vào T-60s.",
                tone: .warning,
                rows: [
                    row("Giờ máy", "19:51:48 · lệch +42 giây", action: "Sửa"),
                    row("Giờ chuẩn", "19:51:06 · Asia/Ho_Chi_Minh", action: "OK")
                ],
                buttons: [button("Đồng bộ giờ"), button("Tiếp tục với cảnh báo", style: .secondary)]
            )
        case .notificationPermission:
            return makeStateContent(
                state: state,
                title: "Quyền",
                pill: "Notify",
                icon: "N",
                stateTitle: "Chưa bật thông báo",
                message: "Luma cần notification để báo trước T-10 phút khi app đang nền hoặc màn hình khóa.",
                tone: .warning,
                rows: [
                    row("T-10 phút", "Không hiện notification nếu bị tắt", action: "Required"),
                    row("PIP đang mở", "Countdown vẫn chạy trong app/PIP", action: "OK")
                ],
                buttons: [button("Mở cài đặt thông báo"), button("Để sau", style: .secondary)]
            )
        case .exactAlarmPermission:
            return makeStateContent(
                state: state,
                title: "Quyền",
                pill: "Alarm",
                icon: "A",
                stateTitle: "Chưa có quyền alarm chính xác",
                message: "Một số máy Android cần quyền alarm để báo đúng giây. Nếu không có, app sẽ dùng notification best-effort.",
                tone: .warning,
                rows: [
                    row("Đúng giờ", "Có thể trễ nếu hệ thống tiết kiệm pin", action: "Risk"),
                    row("Khi app mở", "Countdown và nháy vẫn chính xác", action: "OK")
                ],
                buttons: [button("Bật quyền alarm"), button("Dùng best-effort", style: .secondary)]
            )
        case .pipUnsupported:
            return makeStateContent(
                state: state,
                title: "PIP",
                pill: "Blocked",
                icon: "P",
                stateTitle: "PIP không khả dụng",
                message: "Thiết bị hoặc trạng thái hiện tại không hỗ trợ floating countdown. App sẽ chuyển sang fallback nếu có.",
                tone: .danger,
                rows: [
                    row("Lý do", "PIP possible = false hoặc bị system block", action: "Info"),
                    row("Fallback", "Notification + màn tracking trong app", action: "Use")
                ],
                buttons: [button("Thử lại PIP"), button("Dùng fallback", style: .secondary)]
            )
        case .pipSuspended:
            return makeStateContent(
                state: state,
                title: "PIP",
                pill: "Paused",
                icon: "II",
                stateTitle: "PIP đang bị tạm dừng",
                message: "Hệ thống có thể suspend PIP khi có cuộc gọi, media khác hoặc user đóng floating window.",
                tone: .warning,
                rows: [
                    row("Trạng thái", "Countdown vẫn chạy local trong app", action: "Live"),
                    row("Lần cuối hiển thị", "19:51:08 · còn 08:12", action: "Log")
                ],
                buttons: [button("Mở lại PIP"), button("Theo dõi trong app", style: .secondary)]
            )
        case .alarmRinging:
            return makeAlarmContent()
        case .deleteTargetConfirm:
            return makeStateContent(
                state: state,
                title: "Xóa mốc",
                pill: "Confirm",
                icon: "×",
                stateTitle: "Xóa mốc giờ này?",
                message: "Mốc, checklist và rule cảnh báo sẽ bị xóa khỏi thiết bị này và cloud sau khi sync.",
                tone: .danger,
                rows: [
                    row("Flash sale voucher", "20:00 hôm nay · 4 rule cảnh báo")
                ],
                buttons: [button("Xóa mốc giờ", style: .danger), button("Giữ lại", style: .secondary)]
            )
        case .targetSyncConflict:
            return makeStateContent(
                state: state,
                title: "Conflict",
                pill: "Sync",
                icon: "⇄",
                stateTitle: "Mốc giờ bị sửa ở nơi khác",
                message: "Bản trên máy này và bản cloud có thời điểm/rule khác nhau. Chọn bản trước khi bật alarm.",
                tone: .warning,
                rows: [
                    row("Bản máy này", "20:00 · nháy T-60s · PIP góc phải", action: "Chọn"),
                    row("Bản cloud", "20:30 · báo T-10m · không PIP", action: "Chọn")
                ],
                buttons: [button("Giữ bản máy này"), button("Dùng bản cloud", style: .secondary)]
            )
        }
    }

    private func makeHomeContent() -> TimerScreenContent {
        TimerScreenContent(
            state: .home,
            backTitle: "← Luma",
            title: "Timer",
            topPill: "Hôm nay",
            navItems: nav(selected: .timer),
            blocks: [
                .hero(TimerHeroContent(
                    eyebrow: "PHIÊN TẬP TRUNG TIẾP THEO",
                    title: "Deep Work",
                    subtitle: "25 phút · không làm phiền · nhạc nhẹ",
                    time: "25:00",
                    actionTitle: "Bắt đầu focus",
                    progress: 0.74,
                    tone: .accent
                )),
                .stats([
                    TimerStatItem(title: "FOCUS", value: "3h 20m"),
                    TimerStatItem(title: "STREAK", value: "9 ngày"),
                    TimerStatItem(title: "PHIÊN", value: "6/8")
                ]),
                .sectionTitle("HẸN GIỜ NHANH"),
                .rows([
                    row("Focus 25 phút", "Pomodoro · nghỉ 5 phút", action: "Start"),
                    row("Nghỉ 10 phút", "Reset năng lượng nhanh", action: "Start"),
                    row("Tùy chỉnh timer", "Chọn giờ, phút, âm báo", action: "Sửa")
                ]),
                .sectionTitle("THEO DÕI LIVE"),
                .rows([
                    row("Săn sale flash 20:00", "T-08:12 · nháy ở 60 giây cuối", action: "Track")
                ])
            ]
        )
    }

    private func makeFocusSetupContent() -> TimerScreenContent {
        TimerScreenContent(
            state: .focusSetup,
            backTitle: "← Timer",
            title: "Focus",
            topPill: "Setup",
            navItems: nav(selected: .focus),
            blocks: [
                .state(TimerStateContent(
                    icon: "",
                    title: "Thiết lập phiên tập trung",
                    message: "Chọn thời lượng, nghỉ giữa phiên và môi trường tập trung.",
                    tone: .muted
                )),
                .sectionTitle("THỜI LƯỢNG"),
                .durationPicker([
                    TimerDurationItem(value: "15", subtitle: "nhanh", isSelected: false),
                    TimerDurationItem(value: "25", subtitle: "chuẩn", isSelected: true),
                    TimerDurationItem(value: "45", subtitle: "deep", isSelected: false),
                    TimerDurationItem(value: "60", subtitle: "dài", isSelected: false)
                ]),
                .sectionTitle("CHẾ ĐỘ"),
                .rows([
                    row("Deep Work", "Chặn thông báo, giữ màn hình tối", action: "ON"),
                    row("Pomodoro loop", "25 phút focus + 5 phút nghỉ", action: "OFF"),
                    row("Âm nền nhẹ", "Rain room · âm lượng 35%", action: "Đổi")
                ]),
                .hero(TimerHeroContent(
                    eyebrow: "",
                    title: "Nghỉ sau phiên",
                    subtitle: "5 phút · nhắc đứng dậy và uống nước",
                    time: nil,
                    actionTitle: nil,
                    progress: 0,
                    tone: .accent
                )),
                .buttons([button("Bắt đầu 25:00")])
            ]
        )
    }

    private func makeFocusRunningContent() -> TimerScreenContent {
        TimerScreenContent(
            state: .focusRunning,
            backTitle: "← Timer",
            title: "Focus",
            topPill: "Đang chạy",
            navItems: nav(selected: .focus),
            blocks: [
                .timerRing(TimerRingContent(
                    eyebrow: "DEEP WORK",
                    time: "16:24",
                    subtitle: "còn lại · kết thúc lúc 10:05",
                    progress: 0.66,
                    tone: .accent
                )),
                .controls([
                    button("Ⅱ"),
                    button("■"),
                    button("+5")
                ]),
                .rows([
                    row("Không làm phiền", "3 thông báo đang giữ lại", action: "Xem"),
                    row("Rain room", "Đang phát · 35% volume", action: "Đổi")
                ]),
                .progress(TimerProgressContent(
                    title: "Mục tiêu hôm nay",
                    subtitle: "6/8 phiên · còn 2 phiên để hoàn tất",
                    progress: 0.75,
                    tone: .accent
                ))
            ]
        )
    }

    private func makeFocusPausedContent() -> TimerScreenContent {
        TimerScreenContent(
            state: .focusPaused,
            backTitle: "← Timer",
            title: "Focus",
            topPill: "Tạm dừng",
            navItems: nav(selected: .focus),
            blocks: [
                .timerRing(TimerRingContent(
                    eyebrow: "ĐANG TẠM DỪNG",
                    time: "16:24",
                    subtitle: "resume để tiếp tục phiên Deep Work",
                    progress: 0.66,
                    tone: .warning
                )),
                .state(TimerStateContent(
                    icon: "",
                    title: "Tạm dừng phiên",
                    message: "Timer đang đứng lại. Tiếp tục khi bạn sẵn sàng hoặc kết thúc sớm để lưu log.",
                    tone: .warning
                )),
                .buttons([
                    button("Tiếp tục"),
                    button("Kết thúc sớm", style: .secondary)
                ]),
                .rows([
                    row("Lý do tạm dừng", "Uống nước · chưa ghi chú", action: "Sửa")
                ])
            ]
        )
    }

    private func makeFocusDoneContent() -> TimerScreenContent {
        TimerScreenContent(
            state: .focusDone,
            backTitle: "← Timer",
            title: "Hoàn tất",
            topPill: "Done",
            navItems: nav(selected: .timer),
            blocks: [
                .state(TimerStateContent(
                    icon: "✓",
                    title: "Hoàn thành phiên focus",
                    message: "Deep Work 25 phút · không bỏ giữa chừng.",
                    tone: .success
                )),
                .stats([
                    TimerStatItem(title: "TIME", value: "25m"),
                    TimerStatItem(title: "XP", value: "+45"),
                    TimerStatItem(title: "STREAK", value: "9")
                ]),
                .rows([
                    row("Nghỉ tiếp theo", "5 phút · đứng dậy và uống nước", action: "Start"),
                    row("Phiên kế tiếp", "Deep Work 25 phút", action: "Set")
                ]),
                .buttons([
                    button("Bắt đầu nghỉ"),
                    button("Về Timer", style: .secondary)
                ])
            ]
        )
    }

    private func makePresetsContent() -> TimerScreenContent {
        TimerScreenContent(
            state: .presets,
            backTitle: "← Timer",
            title: "Mẫu",
            topPill: "8 mẫu",
            navItems: nav(selected: .presets),
            blocks: [
                .state(TimerStateContent(
                    icon: "",
                    title: "Mẫu timer",
                    message: "Lưu những cấu hình bạn dùng thường xuyên.",
                    tone: .muted
                )),
                .rows([
                    row("Focus 25 / 5", "Pomodoro chuẩn · tự lặp 4 vòng", action: "Start"),
                    row("Deep Work 45", "Không làm phiền · âm nền nhẹ", action: "Start"),
                    row("Nghỉ 10 phút", "Đứng dậy, giãn vai, uống nước", action: "Start"),
                    row("Nấu ăn 12 phút", "Âm báo lớn · không loop", action: "Start"),
                    row("Tạo preset mới", "Tên, thời lượng, âm báo, loop", action: "Tạo")
                ]),
                .hero(TimerHeroContent(
                    eyebrow: "",
                    title: "Gợi ý từ thói quen",
                    subtitle: "Bạn thường focus tốt nhất lúc 9:00-10:30.",
                    time: nil,
                    actionTitle: "Dùng gợi ý",
                    progress: 0,
                    tone: .accent
                ))
            ]
        )
    }

    private func makeStopwatchContent() -> TimerScreenContent {
        TimerScreenContent(
            state: .stopwatch,
            backTitle: "← Timer",
            title: "Bấm giờ",
            topPill: "00 lap",
            navItems: nav(selected: .stopwatch),
            blocks: [
                .timerRing(TimerRingContent(
                    eyebrow: "",
                    time: "00:12.48",
                    subtitle: "Đang đo · lap gần nhất 00:03.21",
                    progress: 0.42,
                    tone: .accent
                )),
                .controls([
                    button("Lap"),
                    button("Ⅱ"),
                    button("Reset", style: .secondary)
                ]),
                .sectionTitle("LAP HISTORY"),
                .rows([
                    row("Lap 04", "00:03.21 · nhanh nhất", action: "Best"),
                    row("Lap 03", "00:03.44"),
                    row("Lap 02", "00:03.05 · nhanh"),
                    row("Lap 01", "00:02.78")
                ])
            ]
        )
    }

    private func makeSettingsContent() -> TimerScreenContent {
        TimerScreenContent(
            state: .settings,
            backTitle: "← Timer",
            title: "Cài đặt",
            topPill: "Timer",
            navItems: nav(selected: .settings),
            blocks: [
                .sectionTitle("TÙY CHỌN TIMER"),
                .rows([
                    row("Âm báo kết thúc", "Soft bell · âm lượng 70%", action: "Đổi"),
                    row("Rung khi hoàn tất", "Bật trên thiết bị hỗ trợ", action: "ON"),
                    row("Không làm phiền", "Giữ thông báo tới cuối phiên", action: "ON"),
                    row("Tự gợi ý nghỉ", "Sau mỗi phiên focus dài", action: "ON")
                ]),
                .sectionTitle("DỮ LIỆU"),
                .rows([
                    row("Đồng bộ phiên focus", "Lưu lịch sử và streak trên cloud", action: "ON"),
                    row("Tracking & PIP", "Nháy gần giờ, floating countdown", action: "Cài"),
                    row("Xóa lịch sử timer", "Không xoá streak tổng", action: "Xóa", tone: .danger)
                ]),
                .buttons([button("Lưu cài đặt")])
            ]
        )
    }

    private func makeTrackingContent() -> TimerScreenContent {
        TimerScreenContent(
            state: .tracking,
            backTitle: "← Timer",
            title: "Tracking",
            topPill: "Live",
            navItems: nav(selected: .timer),
            blocks: [
                .hero(TimerHeroContent(
                    eyebrow: "MỐC ĐANG THEO DÕI",
                    title: "Săn sale flash 20:00",
                    subtitle: "Shopee · chuẩn bị checkout · nháy mạnh ở 60s cuối",
                    time: "00:08:12",
                    actionTitle: nil,
                    progress: 0.72,
                    tone: .accent
                )),
                .buttons([
                    button("+ Thêm mốc giờ"),
                    button("Mở PIP")
                ]),
                .sectionTitle("SỰ KIỆN SẮP TỚI"),
                .rows([
                    row("Flash sale voucher", "20:00 hôm nay · nháy từ T-60s", action: "Track"),
                    row("PK boss liên server", "21:30 · bật rung + full-screen", action: "Set", tone: .danger),
                    row("Mở bán vé concert", "Thứ 7 10:00 · báo trước 10 phút", action: "PIP", tone: .warning),
                    row("Game drop reset", "00:00 · lặp mỗi ngày", action: "Loop", tone: .success),
                    row("PIP đang tắt", "Bật để ghim countdown khi chuyển app.", action: "Thiết lập")
                ])
            ]
        )
    }

    private func makeTargetDetailContent() -> TimerScreenContent {
        TimerScreenContent(
            state: .targetDetail,
            backTitle: "← Timer",
            title: "Chi tiết",
            topPill: "T-08m",
            navItems: nav(selected: .timer),
            blocks: [
                .timerRing(TimerRingContent(
                    eyebrow: "SĂN SALE FLASH",
                    time: "00:08:12",
                    subtitle: "20:00 hôm nay · Asia/Ho_Chi_Minh",
                    progress: 0.72,
                    tone: .accent
                )),
                .controls([
                    button("10m"),
                    button("1m"),
                    button("10s"),
                    button("GO")
                ]),
                .rows([
                    row("T-10 phút", "Thông báo + mở PIP nếu đang bật", action: "ON"),
                    row("T-60 giây", "Viền PIP nháy cyan mỗi 1 giây", action: "ON"),
                    row("T-10 giây", "Nháy đỏ + rung ngắn liên tục", action: "ON"),
                    row("Checklist săn sale", "Mở app, chọn voucher, sẵn sàng checkout", action: "Xem")
                ]),
                .buttons([
                    button("Bật theo dõi"),
                    button("Mở PIP", style: .secondary),
                    button("Sửa mốc giờ", style: .secondary)
                ])
            ]
        )
    }

    private func makeTargetFormContent() -> TimerScreenContent {
        TimerScreenContent(
            state: .targetForm,
            backTitle: "← Timer",
            title: "Thêm mốc",
            topPill: "Sale",
            navItems: nav(selected: .timer),
            blocks: [
                .rows([
                    row("Tên mốc", "Săn sale flash 20:00", action: "Sửa"),
                    row("Thời điểm", "Hôm nay · 20:00:00", action: "Đổi"),
                    row("Loại mốc", "Săn sale · checkout nhanh", action: "Chọn")
                ]),
                .segmented(TimerSegmentedContent(
                    title: "Lặp lại",
                    options: ["Một lần", "Hằng ngày", "Tuần"],
                    selectedIndex: 0
                )),
                .state(TimerStateContent(
                    icon: "",
                    title: "Chuẩn bị trước giờ",
                    message: "Tạo checklist săn để không quên bước quan trọng.\n• Mở trang sản phẩm\n• Kiểm tra voucher và địa chỉ",
                    tone: .muted
                )),
                .buttons([
                    button("Lưu mốc giờ"),
                    button("Cài cảnh báo", style: .secondary)
                ])
            ]
        )
    }

    private func makeAlertRulesContent() -> TimerScreenContent {
        TimerScreenContent(
            state: .alertRules,
            backTitle: "← Timer",
            title: "Cảnh báo",
            topPill: "Nháy",
            navItems: nav(selected: .timer),
            blocks: [
                .state(TimerStateContent(
                    icon: "",
                    title: "Nháy khi gần giờ",
                    message: "T-60s nháy cyan · T-10s nháy đỏ · đúng giờ ring lớn",
                    tone: .accent
                )),
                .rows([
                    row("T-10 phút", "Notification + âm ngắn", action: "ON"),
                    row("T-60 giây", "PIP nháy cyan, tăng độ sáng viền", action: "ON"),
                    row("T-10 giây", "Nháy đỏ + rung ngắn liên tục", action: "ON"),
                    row("Đúng giờ", "Full-screen alarm + nút Dừng/Snooze", action: "ON")
                ]),
                .progress(TimerProgressContent(
                    title: "Cường độ nháy",
                    subtitle: "Balanced · đủ nổi bật nhưng không chói",
                    progress: 0.64,
                    tone: .danger
                )),
                .buttons([button("Lưu cảnh báo")])
            ]
        )
    }

    private func makePIPSetupContent() -> TimerScreenContent {
        TimerScreenContent(
            state: .pipSetup,
            backTitle: "← Timer",
            title: "PIP",
            topPill: "Overlay",
            navItems: nav(selected: .timer),
            blocks: [
                .pipPreview(TimerPIPPreviewContent(
                    title: "Shop Live",
                    subtitle: "SALE 20:00",
                    time: "08:12",
                    badge: "nháy T-60s",
                    tone: .accent
                )),
                .rows([
                    row("Kích thước", "Vừa · hiển thị countdown + event", action: "Đổi"),
                    row("Vị trí mặc định", "Góc phải trên · tránh che CTA", action: "Đổi"),
                    row("Nháy trong PIP", "Tự bật theo rule của từng mốc", action: "ON")
                ]),
                .buttons([button("Bật PIP")])
            ]
        )
    }

    private func makePIPFloatingContent() -> TimerScreenContent {
        TimerScreenContent(
            state: .pipFloating,
            backTitle: "← Timer",
            title: "PIP Live",
            topPill: "00:08",
            navItems: nav(selected: .timer),
            blocks: [
                .pipPreview(TimerPIPPreviewContent(
                    title: "SALE 20:00",
                    subtitle: "Flash deal · voucher",
                    time: "00:08:12",
                    badge: "nháy ở T-60s",
                    tone: .danger
                )),
                .rows([
                    row("Shop Live", "Voucher 50% · flash item 99k", action: "Mở"),
                    row("Gaming pack", "299k · deal đang live", action: "Ghim")
                ]),
                .buttons([
                    button("Ẩn", style: .secondary),
                    button("Ghim"),
                    button("Mở", style: .secondary)
                ])
            ]
        )
    }

    private func makeAlarmContent() -> TimerScreenContent {
        TimerScreenContent(
            state: .alarmRinging,
            backTitle: "← Timer",
            title: "Đúng giờ",
            topPill: "GO",
            navItems: [],
            blocks: [
                .hero(TimerHeroContent(
                    eyebrow: "ĐÚNG GIỜ",
                    title: "Săn sale flash 20:00",
                    subtitle: "Full-screen alarm · rung mạnh · nút dừng lớn để tránh bấm nhầm.",
                    time: "00:00",
                    actionTitle: nil,
                    progress: 1,
                    tone: .danger
                )),
                .buttons([
                    button("Dừng"),
                    button("Snooze 1 phút", style: .secondary)
                ])
            ]
        )
    }

    private func makeStateContent(
        state: TimerScreenState,
        title: String,
        pill: String,
        icon: String,
        stateTitle: String,
        message: String,
        tone: TimerTone = .accent,
        rows: [TimerRowItem],
        buttons: [TimerButtonItem]
    ) -> TimerScreenContent {
        TimerScreenContent(
            state: state,
            backTitle: "← Timer",
            title: title,
            topPill: pill,
            navItems: nav(selected: .timer),
            blocks: [
                .state(TimerStateContent(icon: icon, title: stateTitle, message: message, tone: tone)),
                .rows(rows),
                .buttons(buttons)
            ]
        )
    }

    private func nav(selected: TimerNavKind) -> [TimerNavItem] {
        [
            TimerNavItem(kind: .timer, title: "Timer", icon: "◴", isSelected: selected == .timer),
            TimerNavItem(kind: .focus, title: "Focus", icon: "◎", isSelected: selected == .focus),
            TimerNavItem(kind: .stopwatch, title: "Bấm giờ", icon: "↻", isSelected: selected == .stopwatch),
            TimerNavItem(kind: .presets, title: "Mẫu", icon: "☷", isSelected: selected == .presets),
            TimerNavItem(kind: .settings, title: "Cài đặt", icon: "⚙", isSelected: selected == .settings)
        ]
    }

    private func row(
        _ title: String,
        _ subtitle: String,
        action: String? = nil,
        tone: TimerTone = .accent
    ) -> TimerRowItem {
        TimerRowItem(title: title, subtitle: subtitle, actionTitle: action, tone: tone)
    }

    private func button(_ title: String, style: TimerButtonStyle = .primary) -> TimerButtonItem {
        TimerButtonItem(title: title, style: style)
    }
}
