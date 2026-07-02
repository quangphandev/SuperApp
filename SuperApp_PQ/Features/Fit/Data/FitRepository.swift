//
//  FitRepository.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 13/06/26.
//

import Foundation
import RxSwift
import RxCocoa

protocol FitRepositoryProtocol: AnyObject {
    var stepsToday: BehaviorRelay<Int> { get }
    var stepsGoal: BehaviorRelay<Int> { get }
    var kcalBurned: BehaviorRelay<Int> { get }
    var kcalGoal: BehaviorRelay<Int> { get }
    var waterMl: BehaviorRelay<Int> { get }
    var waterGoalMl: BehaviorRelay<Int> { get }
    var streakDays: BehaviorRelay<Int> { get }
    var sleepHours: BehaviorRelay<Double> { get }
    var weightKg: BehaviorRelay<Double> { get }
    var heightCm: BehaviorRelay<Double> { get }
    
    // Active Workout ID (nil means no session)
    var activeWorkoutId: BehaviorRelay<String?> { get }
    
    // Workout state machine
    var exercises: BehaviorRelay<[FitWorkoutItem]> { get }
    var currentExerciseIndex: BehaviorRelay<Int> { get }
    var currentSet: BehaviorRelay<Int> { get }
    var restSecondsRemaining: BehaviorRelay<Int> { get }
    var isResting: BehaviorRelay<Bool> { get }
    var isWorkoutDone: BehaviorRelay<Bool> { get }
    
    func startWorkout()
    func nextExerciseStep()
    func skipRest()
    func completeWorkout()
    func logWater(ml: Int)
}

final class FitRepository: FitRepositoryProtocol {
    
    let stepsToday = BehaviorRelay<Int>(value: 6240)
    let stepsGoal = BehaviorRelay<Int>(value: 10000)
    let kcalBurned = BehaviorRelay<Int>(value: 1680)
    let kcalGoal = BehaviorRelay<Int>(value: 2000)
    let waterMl = BehaviorRelay<Int>(value: 2100)
    let waterGoalMl = BehaviorRelay<Int>(value: 3000)
    let streakDays = BehaviorRelay<Int>(value: 12)
    let sleepHours = BehaviorRelay<Double>(value: 7.33)
    let weightKg = BehaviorRelay<Double>(value: 68.5)
    let heightCm = BehaviorRelay<Double>(value: 172.0)
    
    let activeWorkoutId = BehaviorRelay<String?>(value: nil)
    
    let exercises = BehaviorRelay<[FitWorkoutItem]>(value: [])
    let currentExerciseIndex = BehaviorRelay<Int>(value: 0)
    let currentSet = BehaviorRelay<Int>(value: 1)
    let restSecondsRemaining = BehaviorRelay<Int>(value: 0)
    let isResting = BehaviorRelay<Bool>(value: false)
    let isWorkoutDone = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    private var restTimerDisposable: Disposable?
    
    init() {
        resetExercises()
    }
    
    private func resetExercises() {
        let defaultExercises = [
            FitWorkoutItem(title: "Warm Up", subtitle: "5 phút", trailingText: nil, icon: "✓", progress: 1.0),
            FitWorkoutItem(title: "Bench Press", subtitle: "4 sets × 10 reps · 80kg", trailingText: "Set 1/4", icon: "▶", progress: 0.0),
            FitWorkoutItem(title: "Incline Dumbbell Press", subtitle: "3 sets × 12 reps · 20kg", trailingText: "→", icon: "3", progress: 0.0),
            FitWorkoutItem(title: "Cable Fly", subtitle: "3 sets × 15 reps · 15kg", trailingText: "→", icon: "4", progress: 0.0),
            FitWorkoutItem(title: "Shoulder Press", subtitle: "4 sets × 10 reps · 40kg", trailingText: "→", icon: "5", progress: 0.0),
            FitWorkoutItem(title: "Lateral Raise", subtitle: "3 sets × 12 reps · 10kg", trailingText: "→", icon: "6", progress: 0.0),
            FitWorkoutItem(title: "Tricep Pushdown", subtitle: "3 sets × 15 reps · 25kg", trailingText: "→", icon: "7", progress: 0.0),
            FitWorkoutItem(title: "Cool Down", subtitle: "5 phút stretching", trailingText: "→", icon: "8", progress: 0.0)
        ]
        exercises.accept(defaultExercises)
        currentExerciseIndex.accept(1) // Start at Bench Press (index 1) since Warm Up is completed
        currentSet.accept(1)
        isResting.accept(false)
        restSecondsRemaining.accept(0)
        isWorkoutDone.accept(false)
    }
    
    func startWorkout() {
        resetExercises()
        activeWorkoutId.accept("upper_body")
        isWorkoutDone.accept(false)
        
        // Update first exercise state in representation
        var list = exercises.value
        list[0] = FitWorkoutItem(title: "Warm Up", subtitle: "5 phút · hoàn thành", trailingText: nil, icon: "✓", progress: 1.0)
        list[1] = FitWorkoutItem(title: "Bench Press", subtitle: "4 sets × 10 reps · 80kg", trailingText: "Set 1/4", icon: "▶", progress: 0.25)
        exercises.accept(list)
    }
    
    func nextExerciseStep() {
        guard activeWorkoutId.value != nil else { return }
        
        let index = currentExerciseIndex.value
        let currentExercises = exercises.value
        guard index < currentExercises.count else { return }
        
        // If currently resting, skip or finish rest
        if isResting.value {
            finishRest()
            return
        }
        
        // Exercise sets:
        // Bench Press has 4 sets (index 1). Incline dumbbell has 3 sets, etc.
        let totalSets: Int
        if index == 1 { totalSets = 4 } // Bench Press
        else if index == 2 { totalSets = 3 } // Incline Dumbbell
        else if index == 3 { totalSets = 3 } // Cable Fly
        else if index == 4 { totalSets = 4 } // Shoulder Press
        else if index == 5 { totalSets = 3 } // Lateral Raise
        else if index == 6 { totalSets = 3 } // Tricep Pushdown
        else { totalSets = 1 } // Cool Down
        
        let currentS = currentSet.value
        if currentS < totalSets {
            // Move to next set
            currentSet.accept(currentS + 1)
            var list = currentExercises
            let progress = CGFloat(currentS + 1) / CGFloat(totalSets)
            list[index] = FitWorkoutItem(
                title: list[index].title,
                subtitle: list[index].subtitle,
                trailingText: "Set \(currentS + 1)/\(totalSets)",
                icon: "▶",
                progress: progress
            )
            exercises.accept(list)
        } else {
            // Completed sets for this exercise, go to rest (unless it's the last exercise)
            var list = currentExercises
            list[index] = FitWorkoutItem(
                title: list[index].title,
                subtitle: list[index].subtitle,
                trailingText: "hoàn thành",
                icon: "✓",
                progress: 1.0
            )
            
            if index == currentExercises.count - 1 {
                // Cool Down completed, finish workout
                exercises.accept(list)
                completeWorkout()
            } else {
                // Start rest timer
                exercises.accept(list)
                startRest(countdown: 15) // Use 15 seconds for fast demo/prototype, spec says default 60
            }
        }
    }
    
    private func startRest(countdown: Int) {
        restTimerDisposable?.dispose()
        isResting.accept(true)
        restSecondsRemaining.accept(countdown)
        
        // Update the active row's trailing text to show resting countdown
        var list = exercises.value
        let nextIndex = currentExerciseIndex.value + 1
        if nextIndex < list.count {
            list[nextIndex] = FitWorkoutItem(
                title: list[nextIndex].title,
                subtitle: list[nextIndex].subtitle,
                trailingText: "Nghỉ: \(countdown)s",
                icon: "⏱",
                progress: 0.0
            )
            exercises.accept(list)
        }
        
        restTimerDisposable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] elapsed in
                guard let self else { return }
                let remaining = countdown - elapsed - 1
                if remaining <= 0 {
                    self.finishRest()
                } else {
                    self.restSecondsRemaining.accept(remaining)
                    var list = self.exercises.value
                    if nextIndex < list.count {
                        list[nextIndex] = FitWorkoutItem(
                            title: list[nextIndex].title,
                            subtitle: list[nextIndex].subtitle,
                            trailingText: "Nghỉ: \(remaining)s",
                            icon: "⏱",
                            progress: 0.0
                        )
                        self.exercises.accept(list)
                    }
                }
            })
    }
    
    func skipRest() {
        finishRest()
    }
    
    private func finishRest() {
        restTimerDisposable?.dispose()
        isResting.accept(false)
        restSecondsRemaining.accept(0)
        
        let nextIndex = currentExerciseIndex.value + 1
        var list = exercises.value
        
        if nextIndex < list.count {
            currentExerciseIndex.accept(nextIndex)
            currentSet.accept(1)
            
            // Set next exercise active
            let totalSets: Int
            if nextIndex == 1 { totalSets = 4 }
            else if nextIndex == 2 { totalSets = 3 }
            else if nextIndex == 3 { totalSets = 3 }
            else if nextIndex == 4 { totalSets = 4 }
            else if nextIndex == 5 { totalSets = 3 }
            else if nextIndex == 6 { totalSets = 3 }
            else { totalSets = 1 }
            
            list[nextIndex] = FitWorkoutItem(
                title: list[nextIndex].title,
                subtitle: list[nextIndex].subtitle,
                trailingText: totalSets > 1 ? "Set 1/\(totalSets)" : "Đang thực hiện",
                icon: "▶",
                progress: 1.0 / CGFloat(totalSets)
            )
            exercises.accept(list)
        }
    }
    
    func completeWorkout() {
        restTimerDisposable?.dispose()
        activeWorkoutId.accept(nil)
        isWorkoutDone.accept(true)
        
        // Community side effects:
        // 1. Add 320 kcal to burned
        kcalBurned.accept(kcalBurned.value + 320)
        // 2. Increment streak days
        streakDays.accept(streakDays.value + 1)
    }
    
    func logWater(ml: Int) {
        waterMl.accept(waterMl.value + ml)
    }
}
