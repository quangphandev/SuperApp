//
//  FitContent.swift
//  SuperApp_PQ
//
//  Created by Codex on 08/06/26.
//

import UIKit
import RxSwift
import RxRelay

struct FitHomeContent: Hashable {
    let greeting: String
    let name: String
    let energyBadge: String
    let progressTitle: String
    let progressSubtitle: String
    let progressValue: String
    let progressPercent: String
    let quickStats: [FitQuickStat]
    let workoutTitle: String
    let workoutSubtitle: String
    let workoutProgress: CGFloat
    let activeExerciseTitle: String
    let activeExerciseSubtitle: String
    let healthCards: [FitHomeHealthCard]
    let habitsTitle: String
    let habits: [FitHabitItem]
    let navItems: [FitNavItem]
    let activeWorkoutId: String?
}

struct FitHomeHealthCard: Hashable {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
}

struct FitWorkoutContent: Hashable {
    let title: String
    let dayLabel: String
    let activeTitle: String
    let activeSubtitle: String
    let todayLabel: String
    let weekDays: [FitWorkoutDay]
    let exercises: [FitWorkoutItem]
    let summary: String
    let navItems: [FitNavItem]
    let activeWorkoutId: String?
    let isWorkoutDone: Bool
}

struct FitWorkoutDay: Hashable {
    let title: String
    let subtitle: String
    let isActive: Bool
    let hasDot: Bool
}

struct FitNutritionContent: Hashable {
    let title: String
    let topPill: String
    let caloriesTitle: String
    let caloriesValue: String
    let caloriesMeta: String
    let caloriesRemaining: String
    let caloriesProgress: CGFloat
    let macros: [FitMacroItem]
    let mealsTitle: String
    let addText: String
    let meals: [FitMealItem]
    let tipTitle: String
    let tipSubtitle: String
    let navItems: [FitNavItem]
}

struct FitMacroItem: Hashable {
    let title: String
    let value: String
    let progress: CGFloat
}

struct FitProfileContent: Hashable {
    let title: String
    let editTitle: String
    let heroName: String
    let heroSubtitle: String
    let joinedTitle: String
    let energyBadge: String
    let stats: [FitProfileStat]
    let bodyTitle: String
    let bodyMetrics: [FitBodyMetric]
    let goalTitle: String
    let goals: [FitGoalItem]
    let settingsTitle: String
    let settings: [FitSettingItem]
    let navItems: [FitNavItem]
}

struct FitBodyMetric: Hashable {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
}

struct FitSettingItem: Hashable {
    let title: String
    let subtitle: String
    let trailingText: String
    let icon: String
}

struct FitRunningContent: Hashable {
    let title: String
    let topPill: String
    let sublabel: String?
    let bannerTitle: String
    let bannerSubtitle: String
    let mapLabelLeft: String?
    let mapLabelRight: String?
    let mapBadge: String?
    let stats: [FitRunningStat]
    let musicTitle: String
    let musicSubtitle: String
    let musicActionTitle: String
    let actions: [FitRunningAction]
    let chips: [String]
    let footerNote: String?
    let navItems: [FitNavItem]
}

struct FitRunningStat: Hashable {
    let title: String
    let value: String
    let subtitle: String
}

struct FitRunningAction: Hashable {
    let title: String
    let subtitle: String?
    let trailingText: String?
    let icon: String
}

protocol FitContentProviding {
    func makeHomeContent() -> FitHomeContent
    func makeWorkoutContent() -> FitWorkoutContent
    func makeNutritionContent() -> FitNutritionContent
    func makeProfileContent() -> FitProfileContent
    func makeRunningContent(for state: FitRunningState) -> FitRunningContent
}

struct LocalizedFitContentProvider: FitContentProviding {

    private let repository: FitRepositoryProtocol
    
    init(repository: FitRepositoryProtocol) {
        self.repository = repository
    }

    func makeHomeContent() -> FitHomeContent {
        let hour = Calendar.current.component(.hour, from: Date())
        let greeting: String
        switch hour {
        case 5...10:
            greeting = "Chào buổi sáng 👋"
        case 11...16:
            greeting = "Chào buổi trưa"
        case 17...21:
            greeting = "Chào buổi tối"
        default:
            greeting = "Chào đêm khuya"
        }
        
        let steps = repository.stepsToday.value
        let stepsGoal = repository.stepsGoal.value
        let kcal = repository.kcalBurned.value
        let kcalGoal = repository.kcalGoal.value
        let water = repository.waterMl.value
        let waterGoal = repository.waterGoalMl.value
        let streak = repository.streakDays.value
        
        let stepsPct = Double(steps) / Double(stepsGoal)
        let kcalPct = Double(kcal) / Double(kcalGoal)
        let waterPct = Double(water) / Double(waterGoal)
        let avgPct = (stepsPct + kcalPct + waterPct) / 3.0
        let percentText = "\(Int(round(avgPct * 100)))%"
        
        let remainingKcal = max(0, kcalGoal - kcal)
        let progressVal: String
        if remainingKcal > 0 {
            progressVal = "Còn \(remainingKcal) kcal nữa là đạt mục tiêu"
        } else {
            progressVal = "Đã hoàn thành mục tiêu kcal hôm nay! 🎉"
        }
        
        let formattedSteps = NumberFormatter.localizedString(from: NSNumber(value: steps), number: .decimal)
        let formattedKcal = NumberFormatter.localizedString(from: NSNumber(value: kcal), number: .decimal)
        let formattedWater = String(format: "%.1fL", Double(water) / 1000.0)
        
        let currentExercises = repository.exercises.value
        let activeIdx = repository.currentExerciseIndex.value
        let isDone = repository.isWorkoutDone.value
        
        let activeExTitle: String
        let activeExSubtitle: String
        if repository.activeWorkoutId.value != nil && activeIdx < currentExercises.count {
            let item = currentExercises[activeIdx]
            activeExTitle = "Đang thực hiện: \(item.title) · \(item.trailingText ?? "")"
            activeExSubtitle = repository.isResting.value ? "Nghỉ: \(repository.restSecondsRemaining.value)s" : "Đang tập"
        } else {
            activeExTitle = isDone ? "Đã hoàn thành bài tập hôm nay! 🎉" : "Không có bài tập đang chạy"
            activeExSubtitle = isDone ? "Tập thể dục: 100%" : "Bấm vào thẻ Workout để bắt đầu"
        }
        
        return FitHomeContent(
            greeting: greeting,
            name: "Minh Khoa",
            energyBadge: "🔥 \(streak)",
            progressTitle: "Hôm nay",
            progressSubtitle: avgPct >= 1.0 ? "Mục tiêu đã đạt!" : "Good progress!",
            progressValue: progressVal,
            progressPercent: percentText,
            quickStats: [
                FitQuickStat(value: formattedSteps, subtitle: "bước", icon: "👟", progress: CGFloat(stepsPct)),
                FitQuickStat(value: formattedKcal, subtitle: "kcal", icon: "🔥", progress: CGFloat(kcalPct)),
                FitQuickStat(value: formattedWater, subtitle: "nước", icon: "💧", progress: CGFloat(waterPct))
            ],
            workoutTitle: "Upper Body Strength",
            workoutSubtitle: isDone ? "Đã hoàn thành · 320 kcal" : "8 bài tập · 45 phút · 320 kcal",
            workoutProgress: isDone ? 1.0 : (repository.activeWorkoutId.value != nil ? CGFloat(activeIdx) / 8.0 : 0.0),
            activeExerciseTitle: activeExTitle,
            activeExerciseSubtitle: activeExSubtitle,
            healthCards: [
                FitHomeHealthCard(title: "Giấc ngủ", value: "7h 20m", subtitle: "Tốt · 11pm–6:20am", icon: "🌙"),
                FitHomeHealthCard(title: "Cân nặng", value: "\(repository.weightKg.value) kg", subtitle: String(format: "BMI %.1f · Bình thường", repository.weightKg.value / (1.72 * 1.72)), icon: "⚖️")
            ],
            habitsTitle: "Thói quen tuần này",
            habits: [
                FitHabitItem(title: "Tập thể dục", subtitle: "", icon: "⚡", progress: isDone ? 1.0 : 6.0 / 7.0),
                FitHabitItem(title: "Uống đủ nước", subtitle: "", icon: "💧", progress: water >= waterGoal ? 1.0 : 5.0 / 7.0),
                FitHabitItem(title: "Ngủ đủ giấc", subtitle: "", icon: "🌙", progress: 6.0 / 7.0)
            ],
            navItems: [
                FitNavItem(kind: .home, title: "Home", icon: .homeFill, isSelected: true),
                FitNavItem(kind: .workout, title: "Workout", icon: .figureRun, isSelected: false),
                FitNavItem(kind: .nutrition, title: "Dinh dưỡng", icon: .tray, isSelected: false),
                FitNavItem(kind: .sleep, title: "Giấc ngủ", icon: .moon, isSelected: false),
                FitNavItem(kind: .profile, title: "Hồ sơ", icon: .personCircle, isSelected: false)
            ],
            activeWorkoutId: repository.activeWorkoutId.value
        )
    }

    func makeWorkoutContent() -> FitWorkoutContent {
        let currentExercises = repository.exercises.value
        let activeIdx = repository.currentExerciseIndex.value
        let isActive = repository.activeWorkoutId.value != nil
        let isDone = repository.isWorkoutDone.value
        
        let activeTitle = isActive ? "Upper Body Strength" : (isDone ? "Hoàn thành buổi tập!" : "Chưa có lịch tập")
        
        let activeSubtitle: String
        if isActive && activeIdx < currentExercises.count {
            let item = currentExercises[activeIdx]
            activeSubtitle = repository.isResting.value ? "Nghỉ: \(repository.restSecondsRemaining.value)s" : "\(item.title) · \(item.trailingText ?? "Đang tập")"
        } else if isDone {
            activeSubtitle = "Đã lưu 320 kcal vào hoạt động hôm nay"
        } else {
            activeSubtitle = "Bấm nút bên dưới để bắt đầu tập luyện"
        }
        
        return FitWorkoutContent(
            title: "Workout",
            dayLabel: "Thứ 2",
            activeTitle: activeTitle,
            activeSubtitle: activeSubtitle,
            todayLabel: "Upper Body · 45 phút",
            weekDays: [
                FitWorkoutDay(title: "T2", subtitle: "20", isActive: false, hasDot: false),
                FitWorkoutDay(title: "T3", subtitle: "21", isActive: false, hasDot: false),
                FitWorkoutDay(title: "T4", subtitle: "22", isActive: true, hasDot: true),
                FitWorkoutDay(title: "T5", subtitle: "23", isActive: false, hasDot: false),
                FitWorkoutDay(title: "T6", subtitle: "24", isActive: false, hasDot: true),
                FitWorkoutDay(title: "T7", subtitle: "25", isActive: false, hasDot: true),
                FitWorkoutDay(title: "CN", subtitle: "26", isActive: false, hasDot: false)
            ],
            exercises: currentExercises,
            summary: "8 bài tập · 45 phút",
            navItems: [
                FitNavItem(kind: .home, title: "Home", icon: .home, isSelected: false),
                FitNavItem(kind: .workout, title: "Workout", icon: .figureRun, isSelected: true),
                FitNavItem(kind: .nutrition, title: "Dinh dưỡng", icon: .tray, isSelected: false),
                FitNavItem(kind: .sleep, title: "Giấc ngủ", icon: .moon, isSelected: false),
                FitNavItem(kind: .profile, title: "Hồ sơ", icon: .personCircle, isSelected: false)
            ],
            activeWorkoutId: repository.activeWorkoutId.value,
            isWorkoutDone: isDone
        )
    }

    func makeNutritionContent() -> FitNutritionContent {
        let kcal = repository.kcalBurned.value
        let kcalGoal = repository.kcalGoal.value
        
        let remainingKcal = max(0, kcalGoal - kcal)
        let kcalProgress = CGFloat(kcal) / CGFloat(kcalGoal)
        
        return FitNutritionContent(
            title: "Dinh dưỡng",
            topPill: "Hôm nay",
            caloriesTitle: "MỤC TIÊU HÔM NAY",
            caloriesValue: NumberFormatter.localizedString(from: NSNumber(value: kcal), number: .decimal),
            caloriesMeta: "/ \(kcalGoal) kcal",
            caloriesRemaining: remainingKcal > 0 ? "Còn \(remainingKcal) kcal · Protein thiếu 18g" : "Đạt mục tiêu kcal! 🎉",
            caloriesProgress: kcalProgress,
            macros: [
                FitMacroItem(title: "Protein", value: "82g", progress: 0.74),
                FitMacroItem(title: "Carb", value: "210g", progress: 0.62),
                FitMacroItem(title: "Fat", value: "54g", progress: 0.78)
            ],
            mealsTitle: "BỮA ĂN",
            addText: "+ thêm",
            meals: [
                FitMealItem(title: "Sáng", subtitle: "Oats, trứng, chuối", kcal: "430 kcal"),
                FitMealItem(title: "Trưa", subtitle: "Cơm gà, rau xanh", kcal: "620 kcal"),
                FitMealItem(title: "Tối", subtitle: kcalProgress >= 1.0 ? "Salad ức gà" : "Chưa ghi nhận", kcal: kcalProgress >= 1.0 ? "450 kcal" : "--"),
                FitMealItem(title: "Snack", subtitle: "Sữa chua Hy Lạp", kcal: "180 kcal")
            ],
            tipTitle: "Gợi ý: thêm 1 khẩu phần ức gà",
            tipSubtitle: "+26g protein · 165 kcal",
            navItems: [
                FitNavItem(kind: .home, title: "Home", icon: .home, isSelected: false),
                FitNavItem(kind: .workout, title: "Workout", icon: .figureRun, isSelected: false),
                FitNavItem(kind: .nutrition, title: "Dinh dưỡng", icon: .tray, isSelected: true),
                FitNavItem(kind: .sleep, title: "Giấc ngủ", icon: .moon, isSelected: false),
                FitNavItem(kind: .profile, title: "Hồ sơ", icon: .personCircle, isSelected: false)
            ]
        )
    }

    func makeProfileContent() -> FitProfileContent {
        return FitProfileContent(
            title: "Hồ sơ",
            editTitle: "Sửa",
            heroName: "Minh Khoa",
            heroSubtitle: "Fitness enthusiast · Ho Chi Minh",
            joinedTitle: "Tham gia 3 tháng",
            energyBadge: "🔥 \(repository.streakDays.value) ngày",
            stats: [
                FitProfileStat(value: "247", subtitle: "ngày tập", isPrimary: false),
                FitProfileStat(value: "\(repository.kcalBurned.value)", subtitle: "kcal đốt", isPrimary: false),
                FitProfileStat(value: "82", subtitle: "sleep score", isPrimary: true),
                FitProfileStat(value: "\(repository.stepsToday.value)", subtitle: "bước/ngày", isPrimary: false)
            ],
            bodyTitle: "CHỈ SỐ CƠ THỂ",
            bodyMetrics: [
                FitBodyMetric(title: "Cân nặng", value: "\(repository.weightKg.value) kg", subtitle: String(format: "BMI %.1f · Bình thường", repository.weightKg.value / (1.72 * 1.72)), icon: "⚖"),
                FitBodyMetric(title: "Chiều cao", value: "\(Int(repository.heightCm.value)) cm", subtitle: "Tỉ lệ cơ thể ổn định", icon: "↕")
            ],
            goalTitle: "MỤC TIÊU",
            goals: [
                FitGoalItem(title: "Giảm cân", subtitle: "Mục tiêu 65 kg", progress: 0.48, icon: "🏃"),
                FitGoalItem(title: "Tăng cơ bắp", subtitle: "Upper body · 4 buổi/tuần", progress: 0.52, icon: "💪"),
                FitGoalItem(title: "Cải thiện tim mạch", subtitle: "Resting HR 62 BPM", progress: 0.77, icon: "🫀")
            ],
            settingsTitle: "CÀI ĐẶT",
            settings: [
                FitSettingItem(title: "Thông báo", subtitle: "Nhắc lịch tập và ngủ", trailingText: "Bật", icon: "🔔"),
                FitSettingItem(title: "Giao diện", subtitle: "Theme hiện tại", trailingText: "Dark", icon: "🌙")
            ],
            navItems: [
                FitNavItem(kind: .home, title: "Home", icon: .home, isSelected: false),
                FitNavItem(kind: .workout, title: "Workout", icon: .figureRun, isSelected: false),
                FitNavItem(kind: .nutrition, title: "Dinh dưỡng", icon: .tray, isSelected: false),
                FitNavItem(kind: .sleep, title: "Giấc ngủ", icon: .moon, isSelected: false),
                FitNavItem(kind: .profile, title: "Hồ sơ", icon: .personCircle, isSelected: true)
            ]
        )
    }

    func makeRunningContent(for state: FitRunningState) -> FitRunningContent {
        switch state {
        case .ready:
            return FitRunningContent(
                title: "Chạy bộ",
                topPill: "Sẵn sàng",
                sublabel: nil,
                bannerTitle: "Sẵn sàng bắt đầu",
                bannerSubtitle: "",
                mapLabelLeft: "GPS sẵn sàng",
                mapLabelRight: "Route preview",
                mapBadge: nil,
                stats: [
                    FitRunningStat(title: "DISTANCE", value: "0.00", subtitle: "km"),
                    FitRunningStat(title: "SPEED", value: "0.0", subtitle: "km/h"),
                    FitRunningStat(title: "PACE", value: "--", subtitle: "/km")
                ],
                musicTitle: "Run Boost Mix",
                musicSubtitle: "128 BPM · tự phát khi bắt đầu",
                musicActionTitle: "Đổi",
                actions: [
                    FitRunningAction(title: "Bắt đầu chạy", subtitle: "Yêu cầu vị trí rồi bắt đầu GPS/timer", trailingText: nil, icon: "play.fill"),
                    FitRunningAction(title: "Lịch sử", subtitle: "12 buổi chạy gần đây", trailingText: nil, icon: "clock")
                ],
                chips: ["Mục tiêu 5 km", "Outdoor", "Auto pause"],
                footerNote: nil,
                navItems: runningNav(selected: .workout)
            )
        case .active:
            return FitRunningContent(
                title: "Chạy bộ",
                topPill: "Đang chạy",
                sublabel: nil,
                bannerTitle: "Đang chạy",
                bannerSubtitle: "",
                mapLabelLeft: "GPS tốt",
                mapLabelRight: "Live route",
                mapBadge: "Live route",
                stats: [
                    FitRunningStat(title: "ĐANG CHẠY", value: "2.18", subtitle: "km"),
                    FitRunningStat(title: "TIME", value: "12:48", subtitle: ""),
                    FitRunningStat(title: "PACE", value: "5'52\"", subtitle: "/km")
                ],
                musicTitle: "Run Boost Mix",
                musicSubtitle: "Đang phát · Bài 03 · 128 BPM",
                musicActionTitle: "Đổi",
                actions: [
                    FitRunningAction(title: "Tạm dừng", subtitle: nil, trailingText: nil, icon: "pause.fill"),
                    FitRunningAction(title: "Kết thúc", subtitle: nil, trailingText: nil, icon: "xmark")
                ],
                chips: [],
                footerNote: nil,
                navItems: runningNav(selected: .workout)
            )
        case .paused:
            return FitRunningContent(
                title: "Chạy bộ",
                topPill: "Tạm dừng",
                sublabel: nil,
                bannerTitle: "Đã tạm dừng",
                bannerSubtitle: "GPS và timer đang giữ",
                mapLabelLeft: nil,
                mapLabelRight: nil,
                mapBadge: nil,
                stats: [
                    FitRunningStat(title: "ĐÃ TẠM DỪNG", value: "2.18", subtitle: "km"),
                    FitRunningStat(title: "TIME", value: "12:48", subtitle: ""),
                    FitRunningStat(title: "PACE", value: "5'52\"", subtitle: "/km")
                ],
                musicTitle: "Run Boost Mix",
                musicSubtitle: "Đang phát · Bài 03 · 128 BPM",
                musicActionTitle: "Đổi",
                actions: [
                    FitRunningAction(title: "Tiếp tục", subtitle: nil, trailingText: nil, icon: "play.fill"),
                    FitRunningAction(title: "Kết thúc", subtitle: nil, trailingText: nil, icon: "xmark")
                ],
                chips: [],
                footerNote: "Nhạc vẫn phát\nBạn có thể pause nhạc riêng. Bài chạy tiếp tục khi bấm Tiếp tục.",
                navItems: runningNav(selected: .workout)
            )
        case .confirmStop:
            return FitRunningContent(
                title: "Chạy bộ",
                topPill: "Xác nhận",
                sublabel: nil,
                bannerTitle: "Kết thúc buổi chạy?",
                bannerSubtitle: "2.18 km · 12:48 · pace 5'52\" sẽ được lưu vào lịch sử tập luyện.",
                mapLabelLeft: nil,
                mapLabelRight: nil,
                mapBadge: nil,
                stats: [],
                musicTitle: "Run Boost Mix",
                musicSubtitle: "tiếp tục phát",
                musicActionTitle: "tiếp tục phát",
                actions: [
                    FitRunningAction(title: "Tiếp tục chạy", subtitle: nil, trailingText: nil, icon: "play.fill"),
                    FitRunningAction(title: "Kết thúc và lưu", subtitle: nil, trailingText: nil, icon: "checkmark")
                ],
                chips: [],
                footerNote: nil,
                navItems: runningNav(selected: .workout)
            )
        case .summary:
            return FitRunningContent(
                title: "Tổng kết",
                topPill: "Đã lưu",
                sublabel: nil,
                bannerTitle: "Tổng kết",
                bannerSubtitle: "",
                mapLabelLeft: nil,
                mapLabelRight: "2.18 km",
                mapBadge: "2.18 km",
                stats: [
                    FitRunningStat(title: "HOÀN THÀNH", value: "2.18", subtitle: "km"),
                    FitRunningStat(title: "CALORIES", value: "184", subtitle: "kcal"),
                    FitRunningStat(title: "AVG HR", value: "148", subtitle: "bpm"),
                    FitRunningStat(title: "CADENCE", value: "172", subtitle: "spm"),
                    FitRunningStat(title: "ELEVATION", value: "+38", subtitle: "m"),
                    FitRunningStat(title: "WEATHER", value: "29°C", subtitle: "")
                ],
                musicTitle: "Run Boost Mix · 4 bài",
                musicSubtitle: "Pace TB 5'52\" /km",
                musicActionTitle: "Xong",
                actions: [
                    FitRunningAction(title: "Chạy lại", subtitle: nil, trailingText: nil, icon: "arrow.counterclockwise"),
                    FitRunningAction(title: "Xong", subtitle: nil, trailingText: nil, icon: "checkmark")
                ],
                chips: [],
                footerNote: nil,
                navItems: runningNav(selected: .workout)
            )
        case .locationPermission:
            return FitRunningContent(
                title: "Chạy bộ",
                topPill: "Cần quyền",
                sublabel: nil,
                bannerTitle: "Cho phép vị trí",
                bannerSubtitle: "Fit cần quyền vị trí để đo quãng đường, tốc độ và vẽ lại đường chạy của bạn.",
                mapLabelLeft: "Vị trí chưa được cấp quyền",
                mapLabelRight: "GPS off",
                mapBadge: nil,
                stats: [
                    FitRunningStat(title: "Khi dùng app", value: "1", subtitle: "Đủ để bắt đầu khi app đang mở"),
                    FitRunningStat(title: "Luôn cho phép", value: "∞", subtitle: "Cần cho lock screen/background")
                ],
                musicTitle: "",
                musicSubtitle: "",
                musicActionTitle: "",
                actions: [
                    FitRunningAction(title: "Cho phép", subtitle: nil, trailingText: nil, icon: "location.fill"),
                    FitRunningAction(title: "Để sau", subtitle: nil, trailingText: nil, icon: "xmark")
                ],
                chips: [],
                footerNote: nil,
                navItems: runningNav(selected: .workout)
            )
        case .gpsWeak:
            return FitRunningContent(
                title: "Chạy bộ",
                topPill: "GPS yếu",
                sublabel: nil,
                bannerTitle: "Tín hiệu GPS yếu",
                bannerSubtitle: "Timer vẫn chạy, nhưng speed/pace có thể chưa chính xác. Route sẽ được làm mượt khi tín hiệu ổn định.",
                mapLabelLeft: nil,
                mapLabelRight: "Đang tìm GPS",
                mapBadge: nil,
                stats: [
                    FitRunningStat(title: "TIME", value: "13:22", subtitle: ""),
                    FitRunningStat(title: "ACCURACY", value: "~42", subtitle: "m")
                ],
                musicTitle: "",
                musicSubtitle: "",
                musicActionTitle: "",
                actions: [
                    FitRunningAction(title: "Thử lại GPS", subtitle: nil, trailingText: nil, icon: "location.fill"),
                    FitRunningAction(title: "Tiếp tục", subtitle: nil, trailingText: nil, icon: "arrow.right")
                ],
                chips: [],
                footerNote: "Nếu mất GPS lâu hơn 60s, app đánh dấu đoạn route là ước tính.",
                navItems: runningNav(selected: .workout)
            )
        case .backgroundBlocked:
            return FitRunningContent(
                title: "Chạy bộ",
                topPill: "Chạy nền",
                sublabel: nil,
                bannerTitle: "Chạy nền bị chặn",
                bannerSubtitle: "Battery saver hoặc quyền chạy nền có thể làm dừng GPS khi khóa màn hình.",
                mapLabelLeft: nil,
                mapLabelRight: nil,
                mapBadge: nil,
                stats: [],
                musicTitle: "",
                musicSubtitle: "",
                musicActionTitle: "",
                actions: [
                    FitRunningAction(title: "Mở cài đặt", subtitle: nil, trailingText: nil, icon: "gearshape"),
                    FitRunningAction(title: "Chạy ngay khi mở app", subtitle: nil, trailingText: nil, icon: "play.fill")
                ],
                chips: [],
                footerNote: nil,
                navItems: runningNav(selected: .workout)
            )
        case .musicPermission:
            return FitRunningContent(
                title: "Chạy bộ",
                topPill: "Nhạc",
                sublabel: nil,
                bannerTitle: "Kết nối nhạc khi chạy",
                bannerSubtitle: "Cho phép Fit đọc playlist và điều khiển phát nhạc trên lock screen.",
                mapLabelLeft: nil,
                mapLabelRight: nil,
                mapBadge: nil,
                stats: [],
                musicTitle: "",
                musicSubtitle: "",
                musicActionTitle: "",
                actions: [
                    FitRunningAction(title: "Cho phép điều khiển nhạc", subtitle: "Bật play/pause/next ngoài lock screen", trailingText: "Đề xuất", icon: "music.note"),
                    FitRunningAction(title: "Chạy không nhạc", subtitle: "Tracking vận động đầy đủ", trailingText: nil, icon: "xmark"),
                    FitRunningAction(title: "Chưa có playlist", subtitle: "Tạo \"Run Boost Mix\" từ nhạc gần đây", trailingText: "Tạo", icon: "plus")
                ],
                chips: [],
                footerNote: "Không có quyền nhạc không ảnh hưởng GPS, timer hoặc route.",
                navItems: runningNav(selected: .workout)
            )
        case .playlistPicker:
            return FitRunningContent(
                title: "Chọn nhạc",
                topPill: "Auto",
                sublabel: nil,
                bannerTitle: "Chọn playlist khi chạy",
                bannerSubtitle: "Nhạc sẽ tự phát khi bắt đầu nếu Auto đang bật. Đổi playlist không ảnh hưởng GPS hoặc timer.",
                mapLabelLeft: nil,
                mapLabelRight: nil,
                mapBadge: nil,
                stats: [],
                musicTitle: "",
                musicSubtitle: "",
                musicActionTitle: "",
                actions: [
                    FitRunningAction(title: "Run Boost Mix", subtitle: "128 BPM · đang chọn", trailingText: "Đang chọn", icon: "music.note"),
                    FitRunningAction(title: "High Cadence Mix", subtitle: "150 BPM · interval run", trailingText: nil, icon: "music.note.list"),
                    FitRunningAction(title: "Chạy không nhạc", subtitle: "Tắt autoplay cho buổi chạy này", trailingText: nil, icon: "xmark"),
                    FitRunningAction(title: "Tạo playlist mới", subtitle: "Tạo từ nhạc gần đây", trailingText: "Tạo", icon: "plus")
                ],
                chips: ["Auto play", "Keep playing", "Shuffle"],
                footerNote: "Theo spec, nhạc fade out 1.5s khi kết thúc trừ khi chọn keep playing.",
                navItems: runningNav(selected: .workout)
            )
        case .goalSetup:
            return FitRunningContent(
                title: "Mục tiêu chạy",
                topPill: "Setup",
                sublabel: nil,
                bannerTitle: "Thiết lập mục tiêu",
                bannerSubtitle: "Chọn mục tiêu trước khi bắt đầu. App sẽ giữ GPS, pace và auto pause theo cấu hình này.",
                mapLabelLeft: nil,
                mapLabelRight: nil,
                mapBadge: nil,
                stats: [
                    FitRunningStat(title: "DEFAULT", value: "5", subtitle: "km"),
                    FitRunningStat(title: "PACE ALERT", value: "6'00\"", subtitle: "/km"),
                    FitRunningStat(title: "AUTO PAUSE", value: "On", subtitle: "")
                ],
                musicTitle: "",
                musicSubtitle: "",
                musicActionTitle: "",
                actions: [
                    FitRunningAction(title: "5 km", subtitle: "Mục tiêu quãng đường", trailingText: "Chọn", icon: "flag"),
                    FitRunningAction(title: "30 phút", subtitle: "Mục tiêu thời gian", trailingText: nil, icon: "timer"),
                    FitRunningAction(title: "Không mục tiêu", subtitle: "Chạy tự do", trailingText: nil, icon: "infinity"),
                    FitRunningAction(title: "Lưu mục tiêu", subtitle: "Áp dụng cho buổi chạy", trailingText: nil, icon: "checkmark")
                ],
                chips: ["Outdoor", "Auto pause", "Pace alert"],
                footerNote: nil,
                navItems: runningNav(selected: .workout)
            )
        case .history:
            return FitRunningContent(
                title: "Lịch sử chạy",
                topPill: "12 buổi",
                sublabel: nil,
                bannerTitle: "12 buổi chạy gần đây",
                bannerSubtitle: "Tổng 42.6 km · pace TB 5'58\"/km · 3 kỷ lục cá nhân.",
                mapLabelLeft: nil,
                mapLabelRight: nil,
                mapBadge: nil,
                stats: [
                    FitRunningStat(title: "TOTAL", value: "42.6", subtitle: "km"),
                    FitRunningStat(title: "RUNS", value: "12", subtitle: "buổi"),
                    FitRunningStat(title: "AVG PACE", value: "5'58\"", subtitle: "/km")
                ],
                musicTitle: "",
                musicSubtitle: "",
                musicActionTitle: "",
                actions: [
                    FitRunningAction(title: "2.18 km · Hôm nay", subtitle: "12:48 · pace 5'52\" · Run Boost Mix", trailingText: "Chi tiết", icon: "figure.run"),
                    FitRunningAction(title: "5.04 km · Chủ nhật", subtitle: "29:42 · pace 5'53\"", trailingText: nil, icon: "figure.run"),
                    FitRunningAction(title: "3.20 km · Thứ 5", subtitle: "19:31 · pace 6'06\"", trailingText: nil, icon: "figure.run"),
                    FitRunningAction(title: "Chạy lại", subtitle: "Bắt đầu một buổi chạy mới", trailingText: nil, icon: "arrow.counterclockwise")
                ],
                chips: [],
                footerNote: "Chạm một buổi chạy để xem route, pace, nhịp tim và playlist đã phát.",
                navItems: runningNav(selected: .workout)
            )
        case .historyDetail:
            return FitRunningContent(
                title: "Chi tiết buổi chạy",
                topPill: "Đã lưu",
                sublabel: nil,
                bannerTitle: "Hôm nay · 2.18 km",
                bannerSubtitle: "12:48 · pace 5'52\"/km · Run Boost Mix phát 4 bài.",
                mapLabelLeft: "Route đã lưu",
                mapLabelRight: nil,
                mapBadge: "2.18 km",
                stats: [
                    FitRunningStat(title: "DISTANCE", value: "2.18", subtitle: "km"),
                    FitRunningStat(title: "TIME", value: "12:48", subtitle: ""),
                    FitRunningStat(title: "PACE", value: "5'52\"", subtitle: "/km"),
                    FitRunningStat(title: "CALORIES", value: "184", subtitle: "kcal"),
                    FitRunningStat(title: "AVG HR", value: "148", subtitle: "bpm"),
                    FitRunningStat(title: "CADENCE", value: "172", subtitle: "spm")
                ],
                musicTitle: "",
                musicSubtitle: "",
                musicActionTitle: "",
                actions: [
                    FitRunningAction(title: "Chạy lại", subtitle: "Dùng lại mục tiêu và playlist", trailingText: nil, icon: "arrow.counterclockwise"),
                    FitRunningAction(title: "Xong", subtitle: "Quay lại lịch sử", trailingText: nil, icon: "checkmark")
                ],
                chips: [],
                footerNote: "FinishRun đã dừng GPS/timer, lưu route và fade out nhạc theo spec.",
                navItems: runningNav(selected: .workout)
            )
        }
    }

    private func runningNav(selected: FitNavKind) -> [FitNavItem] {
        [
            FitNavItem(kind: .home, title: "Home", icon: .home, isSelected: selected == .home),
            FitNavItem(kind: .workout, title: "Workout", icon: .figureRun, isSelected: selected == .workout),
            FitNavItem(kind: .nutrition, title: "Dinh dưỡng", icon: .tray, isSelected: selected == .nutrition),
            FitNavItem(kind: .sleep, title: "Giấc ngủ", icon: .moon, isSelected: selected == .sleep),
            FitNavItem(kind: .profile, title: "Hồ sơ", icon: .personCircle, isSelected: selected == .profile)
        ]
    }
}
