//
//  EnglishModels.swift
//  SuperApp_PQ
//
//  Created by Codex on 12/06/26.
//

import UIKit

enum EnglishScreenState: Hashable {
    case home
    case flashcard
    case flashcardUnknown
    case flashcardKnown
    case quiz
    case quizCorrect
    case quizWrong
    case result
    case resultPerfect
    case review
    case reviewDone
    case topics
    case topicDetail
    case flashcardDone
    case reviewPractice
    case wordDetail
    case grammarLesson
    case listeningLesson
    case quizHint
    case quizTimeout
    case search
    case levelSetup
    case studySettings
    case empty
    case loading
    case error
    case editStudyGoal
    case resetProgressConfirm
}

enum EnglishNavKind: Hashable {
    case home
    case vocabulary
    case quiz
    case review
    case settings
}

enum EnglishTone: Hashable {
    case accent
    case success
    case danger
    case warning
    case muted
}

enum EnglishButtonStyle: Hashable {
    case primary
    case secondary
    case danger
}

enum EnglishBlock: Hashable {
    case goal(EnglishGoalContent)
    case stats([EnglishStatItem])
    case segments([String], selectedIndex: Int)
    case sectionTitle(String, trailing: String?)
    case topics([EnglishTopicItem])
    case rows([EnglishRowItem])
    case wordChips([String])
    case flashcard(EnglishFlashcardContent)
    case quiz(EnglishQuizContent)
    case result(EnglishResultContent)
    case state(EnglishStateContent)
    case options(EnglishOptionGroup)
    case buttons([EnglishButtonItem])
    case search(String)
}

struct EnglishScreenContent: Hashable {
    let state: EnglishScreenState
    let backTitle: String
    let title: String
    let topPill: String
    let navItems: [EnglishNavItem]
    let blocks: [EnglishBlock]
}

struct EnglishNavItem: Hashable {
    let kind: EnglishNavKind
    let title: String
    let icon: String
    let isSelected: Bool
}

struct EnglishGoalContent: Hashable {
    let eyebrow: String
    let title: String
    let subtitle: String
    let progressText: String
    let progress: CGFloat
}

struct EnglishStatItem: Hashable {
    let title: String
    let value: String
    let trailing: String?
}

struct EnglishTopicItem: Hashable {
    let title: String
    let subtitle: String
    let badge: String
    let tone: EnglishTone
}

struct EnglishRowItem: Hashable {
    let title: String
    let subtitle: String
    let actionTitle: String?
    let tone: EnglishTone
}

struct EnglishFlashcardContent: Hashable {
    let progressTitle: String
    let progressText: String
    let progress: CGFloat
    let partOfSpeech: String
    let word: String
    let pronunciation: String
    let meaning: String
    let example: String
    let selectedAnswer: EnglishFlashcardAnswer?
    let nextWords: [String]
}

enum EnglishFlashcardAnswer: Hashable {
    case unknown
    case known
}

struct EnglishQuizContent: Hashable {
    let progressTitle: String
    let timerText: String
    let prompt: String
    let word: String
    let pronunciation: String
    let answers: [EnglishAnswerItem]
    let message: String?
    let messageTone: EnglishTone
}

struct EnglishAnswerItem: Hashable {
    let letter: String
    let title: String
    let tone: EnglishTone
}

struct EnglishResultContent: Hashable {
    let score: String
    let title: String
    let subtitle: String
    let xp: String
    let stats: [EnglishStatItem]
}

struct EnglishStateContent: Hashable {
    let icon: String
    let title: String
    let message: String
    let tone: EnglishTone
}

struct EnglishOptionGroup: Hashable {
    let title: String
    let options: [EnglishOptionItem]
}

struct EnglishOptionItem: Hashable {
    let title: String
    let subtitle: String
    let isSelected: Bool
}

struct EnglishButtonItem: Hashable {
    let title: String
    let style: EnglishButtonStyle
}
