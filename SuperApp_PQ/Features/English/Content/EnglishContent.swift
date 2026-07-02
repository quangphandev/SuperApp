//
//  EnglishContent.swift
//  SuperApp_PQ
//
//  Created by Codex on 12/06/26.
//

import UIKit

protocol EnglishContentProviding {
    func makeContent(for state: EnglishScreenState) -> EnglishScreenContent
}

struct LocalizedEnglishContentProvider: EnglishContentProviding {

    func makeContent(for state: EnglishScreenState) -> EnglishScreenContent {
        switch state {
        case .home:
            return makeHomeContent()
        case .flashcard:
            return makeFlashcardContent(state: state, answer: nil)
        case .flashcardUnknown:
            return makeFlashcardContent(state: state, answer: .unknown)
        case .flashcardKnown:
            return makeFlashcardContent(state: state, answer: .known)
        case .quiz:
            return makeQuizContent(state: state, message: nil, tone: .muted)
        case .quizCorrect:
            return makeQuizContent(state: state, message: "Chính xác! mơ hồ = ambiguous", tone: .success)
        case .quizWrong:
            return makeQuizContent(state: state, message: "Sai rồi! Đáp án đúng là: mơ hồ, không rõ ràng", tone: .danger)
        case .result:
            return makeResultContent(isPerfect: false)
        case .resultPerfect:
            return makeResultContent(isPerfect: true)
        case .review:
            return makeReviewContent()
        case .reviewDone:
            return makeReviewDoneContent()
        case .topics:
            return makeTopicsContent()
        case .topicDetail:
            return makeTopicDetailContent()
        case .flashcardDone:
            return makeFlashcardDoneContent()
        case .reviewPractice:
            return makeReviewPracticeContent()
        case .wordDetail:
            return makeWordDetailContent()
        case .grammarLesson:
            return makeGrammarLessonContent()
        case .listeningLesson:
            return makeListeningLessonContent()
        case .quizHint:
            return makeQuizHintContent()
        case .quizTimeout:
            return makeQuizTimeoutContent()
        case .search:
            return makeSearchContent()
        case .levelSetup:
            return makeLevelSetupContent()
        case .studySettings:
            return makeStudySettingsContent()
        case .empty:
            return makeStateContent(
                state: .empty,
                title: "Từ vựng",
                pill: "Trống",
                icon: "☰",
                headline: "Chưa có từ nào trong deck",
                message: "Chọn một chủ đề hoặc nhập từ mới để bắt đầu lộ trình học.",
                rows: [
                    row("Gợi ý bắt đầu", "Animals · Travel · Daily Talk", action: "Mở"),
                    row("Nhập nhanh", "Thêm từ từ clipboard", action: "Thêm")
                ],
                buttons: [button("Chọn chủ đề"), button("Thêm từ mới", style: .secondary)]
            )
        case .loading:
            return makeStateContent(
                state: .loading,
                title: "Đang tải",
                pill: "Sync",
                icon: "...",
                headline: "Đang chuẩn bị bài học",
                message: "Luma đang tải deck, audio và lịch ôn mới nhất.",
                rows: [
                    row("Tải deck học", "Đồng bộ danh sách từ mới nhất"),
                    row("Chuẩn bị audio", "Tải phát âm cho thẻ đầu tiên"),
                    row("Xếp lịch ôn", "Cập nhật spaced repetition")
                ],
                buttons: [button("Hủy tải", style: .secondary), button("Xem lỗi", style: .danger)]
            )
        case .error:
            return makeStateContent(
                state: .error,
                title: "Lỗi bài học",
                pill: "Error",
                icon: "!",
                headline: "Không tải được bài học",
                message: "Máy chủ không phản hồi. Bài đã lưu offline vẫn có thể mở được.",
                tone: .danger,
                rows: [
                    row("Mã lỗi", "ENG_LESSON_504", action: "Copy"),
                    row("Bản offline", "Animals deck · cập nhật hôm qua", action: "Mở")
                ],
                buttons: [button("Thử lại"), button("Dùng bản offline", style: .secondary)]
            )
        case .editStudyGoal:
            return makeEditGoalContent()
        case .resetProgressConfirm:
            return makeResetConfirmContent()
        }
    }

    private func makeHomeContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .home,
            backTitle: "< Luma",
            title: "Tiếng Anh",
            topPill: "7 ngày",
            navItems: nav(selected: .home),
            blocks: [
                .goal(EnglishGoalContent(
                    eyebrow: "MỤC TIÊU HÔM NAY",
                    title: "12 / 20 từ",
                    subtitle: "còn 8 từ nữa là xong!",
                    progressText: "60%",
                    progress: 0.6
                )),
                .stats([
                    EnglishStatItem(title: "XP HÔM NAY", value: "245 xp", trailing: "✦"),
                    EnglishStatItem(title: "STREAK", value: "7 ngày", trailing: "•••••••")
                ]),
                .segments(["Từ vựng", "Ngữ pháp", "Luyện nghe"], selectedIndex: 0),
                .sectionTitle("CHỦ ĐỀ", trailing: "xem tất cả"),
                .topics([
                    topic("Animals", "20 từ", badge: "Hoàn thành", tone: .accent),
                    topic("Travel", "15 từ", badge: "8/15", tone: .accent),
                    topic("Business", "25 từ", badge: "Locked", tone: .muted)
                ]),
                .sectionTitle("BÀI HÔM NAY", trailing: nil),
                .rows([
                    row("Vocabulary · Animals", "20 từ · hoàn thành", action: "✓ Done", tone: .success),
                    row("Grammar · Present Perfect", "12 câu · 8 phút", action: "60%"),
                    row("Listening · Daily Talk", "15 câu · 10 phút", action: nil)
                ]),
                .sectionTitle("CẦN ÔN LẠI   3", trailing: nil),
                .wordChips(["ambiguous", "persevere", "eloquent"]),
                .buttons([button("Bắt đầu học")])
            ]
        )
    }

    private func makeFlashcardContent(
        state: EnglishScreenState,
        answer: EnglishFlashcardAnswer?
    ) -> EnglishScreenContent {
        EnglishScreenContent(
            state: state,
            backTitle: "Tiếng Anh",
            title: "Từ vựng",
            topPill: "Animals",
            navItems: nav(selected: .vocabulary),
            blocks: [
                .flashcard(EnglishFlashcardContent(
                    progressTitle: "Thẻ 8 / 20",
                    progressText: "40%",
                    progress: 0.4,
                    partOfSpeech: "adj",
                    word: "ambiguous",
                    pronunciation: "/æmˈbɪɡ.ju.əs/",
                    meaning: "mơ hồ, không rõ ràng",
                    example: "The instructions were ambiguous.",
                    selectedAnswer: answer,
                    nextWords: ["Benevolent", "Eloquent", "Persevere"]
                )),
                .buttons(answer == nil ? [] : [button("Thẻ tiếp theo"), button("Hoàn thành deck", style: .secondary)])
            ]
        )
    }

    private func makeQuizContent(
        state: EnglishScreenState,
        message: String?,
        tone: EnglishTone
    ) -> EnglishScreenContent {
        EnglishScreenContent(
            state: state,
            backTitle: "Tiếng Anh",
            title: "Quiz",
            topPill: "5 / 10",
            navItems: nav(selected: .quiz),
            blocks: [
                .quiz(EnglishQuizContent(
                    progressTitle: "Thời gian",
                    timerText: "12s",
                    prompt: "Chọn nghĩa đúng",
                    word: "Ambiguous",
                    pronunciation: "/æmˈbɪɡjuəs/",
                    answers: [
                        EnglishAnswerItem(letter: "A", title: "mơ hồ, không rõ ràng", tone: state == .quizCorrect ? .success : .muted),
                        EnglishAnswerItem(letter: "B", title: "tham vọng, có hoài bão", tone: .muted),
                        EnglishAnswerItem(letter: "C", title: "rõ ràng, minh bạch", tone: .muted),
                        EnglishAnswerItem(letter: "D", title: "kiên trì, bền bỉ", tone: state == .quizWrong ? .danger : .muted)
                    ],
                    message: message,
                    messageTone: tone
                )),
                .buttons(message == nil ? [
                    button("Dùng gợi ý (-5 XP)", style: .secondary),
                    button("Hết giờ", style: .secondary)
                ] : [button("Câu tiếp theo")]),
                .stats([
                    EnglishStatItem(title: "trả lời đúng", value: "+10 XP", trailing: "☆"),
                    EnglishStatItem(title: "trả lời nhanh", value: "Bonus +5", trailing: "◷"),
                    EnglishStatItem(title: "đang x7 streak", value: "x2 Streak", trailing: "♨")
                ])
            ]
        )
    }

    private func makeResultContent(isPerfect: Bool) -> EnglishScreenContent {
        EnglishScreenContent(
            state: isPerfect ? .resultPerfect : .result,
            backTitle: "",
            title: "Kết quả",
            topPill: "Animals",
            navItems: nav(selected: .review),
            blocks: [
                .result(EnglishResultContent(
                    score: isPerfect ? "10/10" : "8/10",
                    title: isPerfect ? "Hoàn hảo! 🏆" : "Xuất sắc! 🎉",
                    subtitle: isPerfect ? "Bạn đã trả lời đúng 100% câu hỏi" : "Bạn đã trả lời đúng 80% câu hỏi",
                    xp: isPerfect ? "+200 XP" : "+135 XP",
                    stats: [
                        EnglishStatItem(title: "chính xác", value: isPerfect ? "100%" : "80%", trailing: nil),
                        EnglishStatItem(title: "phút", value: "4:32", trailing: nil),
                        EnglishStatItem(title: "ngày liên tiếp", value: "x7", trailing: nil)
                    ]
                )),
                .sectionTitle(isPerfect ? "Không có từ nào cần ôn lại!" : "CẦN ÔN LẠI", trailing: isPerfect ? nil : "2 từ"),
                .rows(isPerfect ? [] : [
                    row("Ambiguous", "mơ hồ, không rõ ràng", action: "→", tone: .danger),
                    row("Persevere", "kiên trì, bền bỉ", action: "→", tone: .danger)
                ]),
                .buttons(isPerfect ? [button("Chủ đề tiếp theo"), button("Chia sẻ kết quả", style: .secondary)] : [button("Ôn lại từ sai", style: .secondary), button("Tiếp tục học")])
            ]
        )
    }

    private func makeReviewContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .review,
            backTitle: "← Tiếng Anh",
            title: "Ôn tập",
            topPill: "12 từ",
            navItems: nav(selected: .review),
            blocks: [
                .state(EnglishStateContent(
                    icon: "⏱",
                    title: "ÔN TẬP HÔM NAY",
                    message: "12 từ cần ôn\nDựa trên lịch spaced repetition",
                    tone: .accent
                )),
                .stats([
                    EnglishStatItem(title: "streak", value: "7 ngày", trailing: "🔥"),
                    EnglishStatItem(title: "8 từ tiếp", value: "Ngày mai", trailing: "📅")
                ]),
                .sectionTitle("DANH SÁCH ÔN TẬP", trailing: nil),
                .rows(reviewRows()),
                .buttons([button("Bắt đầu ôn tập  →")])
            ]
        )
    }

    private func makeReviewDoneContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .reviewDone,
            backTitle: "",
            title: "Ôn tập",
            topPill: "12 từ",
            navItems: nav(selected: .review),
            blocks: [
                .state(EnglishStateContent(
                    icon: "🏆",
                    title: "Hoàn thành rồi! 🎉",
                    message: "Bạn đã ôn tập hết 12 từ hôm nay",
                    tone: .success
                )),
                .sectionTitle("ÔN TẬP TIẾP THEO", trailing: nil),
                .rows([row("Ngày mai · 8 từ", "Lịch SRS tiếp theo", action: "🌙")]),
                .sectionTitle("KẾT QUẢ HÔM NAY", trailing: nil),
                .stats([
                    EnglishStatItem(title: "từ dễ", value: "8", trailing: nil),
                    EnglishStatItem(title: "bình thường", value: "2", trailing: nil),
                    EnglishStatItem(title: "từ khó", value: "2", trailing: nil)
                ]),
                .buttons([button("Về trang chủ")])
            ]
        )
    }

    private func makeTopicsContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .topics,
            backTitle: "← Tiếng Anh",
            title: "Chủ đề",
            topPill: "20 chủ đề",
            navItems: nav(selected: .vocabulary),
            blocks: [
                .sectionTitle("TỪ VỰNG THEO CHỦ ĐỀ", trailing: nil),
                .segments(["Tất cả", "Đang học", "Đã khóa"], selectedIndex: 0),
                .topics([
                    topic("Animals", "20 từ", badge: "Done", tone: .success),
                    topic("Travel", "15 từ", badge: "8/15", tone: .accent),
                    topic("Business", "25 từ", badge: "Locked", tone: .muted),
                    topic("Food", "18 từ", badge: "Mới", tone: .warning),
                    topic("Work", "22 từ", badge: "B1", tone: .accent),
                    topic("Daily Talk", "30 câu", badge: "A2", tone: .accent)
                ]),
                .goal(EnglishGoalContent(
                    eyebrow: "TIẾN ĐỘ TUẦN NÀY",
                    title: "4/7 ngày học",
                    subtitle: "còn 36 từ để mở Business",
                    progressText: "57%",
                    progress: 0.57
                )),
                .buttons([button("Tiếp tục Animals")])
            ]
        )
    }

    private func makeTopicDetailContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .topicDetail,
            backTitle: "← Tiếng Anh",
            title: "Animals",
            topPill: "20 từ",
            navItems: nav(selected: .vocabulary),
            blocks: [
                .goal(EnglishGoalContent(
                    eyebrow: "Animals",
                    title: "20 từ · A1-A2",
                    subtitle: "60% hoàn thành · 8 từ còn lại",
                    progressText: "60%",
                    progress: 0.6
                )),
                .sectionTitle("BÀI HỌC", trailing: nil),
                .rows([
                    row("Vocabulary · Animals", "20 từ · hoàn thành", action: "Done", tone: .success),
                    row("Flashcards", "ôn lại 8 từ chưa chắc", action: "8 từ"),
                    row("Quiz Animals", "10 câu · kiểm tra nghĩa", action: "80%"),
                    row("Review Spaced", "lịch ôn ngày mai", action: "3 từ"),
                    row("Grammar", "Present simple", action: "→"),
                    row("Listening", "Audio 0:18", action: "→")
                ]),
                .sectionTitle("TỪ ĐANG CẦN ÔN", trailing: nil),
                .wordChips(["ambiguous", "persevere", "eloquent", "benevolent", "meticulous", "ephemeral"]),
                .buttons([button("Học flashcards")])
            ]
        )
    }

    private func makeFlashcardDoneContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .flashcardDone,
            backTitle: "← Tiếng Anh",
            title: "Từ vựng",
            topPill: "Animals",
            navItems: nav(selected: .vocabulary),
            blocks: [
                .state(EnglishStateContent(
                    icon: "🏆",
                    title: "Hoàn thành deck!",
                    message: "Bạn đã học hết 20 thẻ Animals",
                    tone: .success
                )),
                .stats([
                    EnglishStatItem(title: "ĐÃ BIẾT", value: "14", trailing: nil),
                    EnglishStatItem(title: "CẦN ÔN", value: "6", trailing: nil),
                    EnglishStatItem(title: "XP", value: "+80", trailing: nil)
                ]),
                .state(EnglishStateContent(
                    icon: "",
                    title: "GỢI Ý TIẾP THEO",
                    message: "Làm quiz để khóa kiến thức\n10 câu · mất khoảng 4 phút · nhận thêm XP",
                    tone: .accent
                )),
                .rows([row("6 từ chưa chắc", "ambiguous, persevere, eloquent...", action: "ôn lại")]),
                .buttons([button("Làm quiz Animals"), button("Về chủ đề", style: .secondary)])
            ]
        )
    }

    private func makeReviewPracticeContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .reviewPractice,
            backTitle: "← Tiếng Anh",
            title: "Ôn tập",
            topPill: "3 / 12",
            navItems: nav(selected: .review),
            blocks: [
                .flashcard(EnglishFlashcardContent(
                    progressTitle: "SPACED REPETITION",
                    progressText: "B1 · Danh từ",
                    progress: 0.25,
                    partOfSpeech: "B1",
                    word: "ambiguous",
                    pronunciation: "/æmˈbɪɡ.ju.əs/",
                    meaning: "Bạn còn nhớ nghĩa không?",
                    example: "Nhấn để xem đáp án",
                    selectedAnswer: nil,
                    nextWords: ["persevere · eloquent · benevolent", "9 từ", "Hoàn thành sau 9 từ"]
                )),
                .sectionTitle("ĐÁNH GIÁ SAU KHI XEM ĐÁP ÁN", trailing: nil),
                .buttons([
                    button("Sai rồi", style: .danger),
                    button("Khó", style: .secondary),
                    button("Tốt"),
                    button("Dễ", style: .secondary)
                ])
            ]
        )
    }

    private func makeWordDetailContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .wordDetail,
            backTitle: "← Tiếng Anh",
            title: "Chi tiết từ",
            topPill: "B1",
            navItems: nav(selected: .vocabulary),
            blocks: [
                .flashcard(EnglishFlashcardContent(
                    progressTitle: "adj · Danh từ trong quiz",
                    progressText: "B1",
                    progress: 0.66,
                    partOfSpeech: "🔊",
                    word: "ambiguous",
                    pronunciation: "/æmˈbɪɡ.ju.əs/",
                    meaning: "mơ hồ, không rõ ràng",
                    example: "The instructions were ambiguous.",
                    selectedAnswer: nil,
                    nextWords: []
                )),
                .stats([
                    EnglishStatItem(title: "SAI", value: "3 lần", trailing: nil),
                    EnglishStatItem(title: "ĐÚNG", value: "8/12", trailing: nil),
                    EnglishStatItem(title: "NEXT", value: "hôm nay", trailing: nil)
                ]),
                .state(EnglishStateContent(
                    icon: "",
                    title: "GHI NHỚ NHANH",
                    message: "ambiguous = chưa rõ một nghĩa duy nhất\nDùng khi thông tin, hướng dẫn hoặc câu trả lời chưa đủ rõ.",
                    tone: .accent
                )),
                .rows([
                    row("Lịch ôn SRS", "Sai gần nhất trong Quiz Animals", action: "B1"),
                    row("Ví dụ tự tạo", "Viết lại 1 câu với ambiguous", action: "+5 XP"),
                    row("Đã gặp trong chủ đề", "Animals · Flashcards · Quiz", action: "3 lần")
                ]),
                .buttons([button("Ôn từ này"), button("Quay lại", style: .secondary)])
            ]
        )
    }

    private func makeGrammarLessonContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .grammarLesson,
            backTitle: "← Tiếng Anh",
            title: "Ngữ pháp",
            topPill: "A2",
            navItems: nav(selected: .quiz),
            blocks: [
                .state(EnglishStateContent(
                    icon: "",
                    title: "Grammar · Animals\nPresent Simple",
                    message: "Thói quen và sự thật\nSubject + V(s/es)",
                    tone: .accent
                )),
                .sectionTitle("CẤU TRÚC", trailing: nil),
                .rows([
                    row("He / She / It", "Thêm s hoặc es vào động từ chính", action: "H"),
                    row("Negative", "Dùng do not hoặc does not", action: "N"),
                    row("Question", "Đảo do hoặc does lên đầu câu", action: "Q")
                ]),
                .sectionTitle("KIỂM TRA NHANH", trailing: nil),
                .rows([
                    row("She ___ every morning.", "runs / run", action: "Tip")
                ]),
                .buttons([button("Luyện 5 câu")])
            ]
        )
    }

    private func makeListeningLessonContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .listeningLesson,
            backTitle: "← Tiếng Anh",
            title: "Listening",
            topPill: "A1",
            navItems: nav(selected: .quiz),
            blocks: [
                .state(EnglishStateContent(
                    icon: "▶",
                    title: "Audio · Animals",
                    message: "The zebra is near the river.\n0:18 · 1.0x · Replay",
                    tone: .accent
                )),
                .sectionTitle("CÂU HỎI", trailing: nil),
                .rows([
                    row("Where is the zebra?", "Chọn đáp án đúng sau khi nghe audio."),
                    row("Near the river", "đáp án đúng", action: "A", tone: .success),
                    row("In the forest", "nhiễu nghĩa", action: "B"),
                    row("At the zoo", "nhiễu ngữ cảnh", action: "C"),
                    row("Transcript", "Mở sau 2 lượt nghe để không lộ đáp án quá sớm.", action: "Mở")
                ]),
                .buttons([button("Kiểm tra đáp án")])
            ]
        )
    }

    private func makeQuizHintContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .quizHint,
            backTitle: "← Tiếng Anh",
            title: "Quiz",
            topPill: "5/10",
            navItems: nav(selected: .quiz),
            blocks: [
                .state(EnglishStateContent(
                    icon: "",
                    title: "Gợi ý",
                    message: "Từ này dùng khi hướng dẫn chưa rõ; bắt đầu bằng am-.",
                    tone: .warning
                )),
                .quiz(EnglishQuizContent(
                    progressTitle: "Thời gian",
                    timerText: "12s",
                    prompt: "Chọn nghĩa đúng",
                    word: "Ambiguous",
                    pronunciation: "/æmˈbɪɡ.ju.əs/",
                    answers: [
                        EnglishAnswerItem(letter: "A", title: "mơ hồ, không rõ ràng", tone: .accent),
                        EnglishAnswerItem(letter: "B", title: "kiên trì, bền bỉ", tone: .muted),
                        EnglishAnswerItem(letter: "C", title: "tạm thời, ngắn ngủi", tone: .danger),
                        EnglishAnswerItem(letter: "D", title: "rộng lượng, tốt bụng", tone: .muted)
                    ],
                    message: "Đã dùng gợi ý · -5 XP",
                    messageTone: .warning
                ))
            ]
        )
    }

    private func makeQuizTimeoutContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .quizTimeout,
            backTitle: "← Tiếng Anh",
            title: "Quiz",
            topPill: "5/10",
            navItems: nav(selected: .quiz),
            blocks: [
                .quiz(EnglishQuizContent(
                    progressTitle: "Thời gian",
                    timerText: "0s",
                    prompt: "Hết giờ",
                    word: "Ambiguous",
                    pronunciation: "/æmˈbɪɡ.ju.əs/",
                    answers: [
                        EnglishAnswerItem(letter: "✓", title: "Đáp án đúng · mơ hồ, không rõ ràng", tone: .success),
                        EnglishAnswerItem(letter: "-", title: "-10 XP · Thêm ambiguous vào hàng đợi ôn tập.", tone: .danger)
                    ],
                    message: "Câu này được tính là sai và từ sẽ được đưa vào lịch ôn hôm nay.",
                    messageTone: .danger
                )),
                .buttons([button("Xem lại từ", style: .secondary), button("Câu tiếp theo")])
            ]
        )
    }

    private func makeSearchContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .search,
            backTitle: "← Tiếng Anh",
            title: "Tìm kiếm",
            topPill: "",
            navItems: nav(selected: .vocabulary),
            blocks: [
                .search("Từ vựng, chủ đề, mẫu câu..."),
                .sectionTitle("TÌM GẦN ĐÂY", trailing: nil),
                .rows([
                    row("ambiguous", "Danh từ · B1", action: "→"),
                    row("persevere", "Động từ · B2", action: "→"),
                    row("present perfect", "Ngữ pháp", action: "→")
                ]),
                .sectionTitle("CHỦ ĐỀ PHỔ BIẾN", trailing: nil),
                .topics([
                    topic("Animals", "20 từ", badge: "A1", tone: .accent),
                    topic("Travel", "15 từ", badge: "A2", tone: .accent),
                    topic("Business", "25 từ", badge: "B1", tone: .muted),
                    topic("Food", "18 từ", badge: "A2", tone: .warning)
                ]),
                .sectionTitle("GỢI Ý HỌC TIẾP", trailing: nil),
                .rows([row("Listening · Daily Talk", "15 câu · 10 phút", action: "→")])
            ]
        )
    }

    private func makeLevelSetupContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .levelSetup,
            backTitle: "← Tiếng Anh",
            title: "Thiết lập học",
            topPill: "B1",
            navItems: nav(selected: .settings),
            blocks: [
                .state(EnglishStateContent(
                    icon: "",
                    title: "Chọn mục tiêu",
                    message: "Chọn mục tiêu để Luma gợi ý bài học phù hợp.",
                    tone: .accent
                )),
                .rows([row("KIỂM TRA NHANH", "Xác định trình độ trong 5 phút · 10 câu", action: "Bắt đầu")]),
                .options(EnglishOptionGroup(
                    title: "TRÌNH ĐỘ MỤC TIÊU",
                    options: ["A2", "B1", "B2", "C1"].map { EnglishOptionItem(title: $0, subtitle: "", isSelected: $0 == "B1") }
                )),
                .options(EnglishOptionGroup(
                    title: "MỤC TIÊU MỖI NGÀY",
                    options: [
                        EnglishOptionItem(title: "10 từ", subtitle: "Nhẹ nhàng", isSelected: false),
                        EnglishOptionItem(title: "20 từ", subtitle: "Cân bằng", isSelected: true),
                        EnglishOptionItem(title: "35 từ", subtitle: "Tăng tốc", isSelected: false)
                    ]
                )),
                .buttons([button("Lưu và bắt đầu học")])
            ]
        )
    }

    private func makeStudySettingsContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .studySettings,
            backTitle: "← Tiếng Anh",
            title: "Cài đặt học",
            topPill: "",
            navItems: nav(selected: .settings),
            blocks: [
                .rows([
                    row("Nhắc học mỗi ngày", "20:30 · Từ vựng và ôn tập sai"),
                    row("7 ngày streak", "Đang duy trì tốt", action: "✓")
                ]),
                .sectionTitle("NỘI DUNG ƯU TIÊN", trailing: nil),
                .rows([
                    row("Từ vựng", "20 từ/ngày", action: "Bật", tone: .accent),
                    row("Ngữ pháp", "3 bài/tuần", action: nil),
                    row("Listening", "10 phút/ngày", action: nil),
                    row("Ôn tập sai", "Tự động", action: nil),
                    row("Đặt lại tiến độ chủ đề", "Không xoá streak và XP", action: "Reset", tone: .danger)
                ]),
                .buttons([button("Lưu cài đặt")])
            ]
        )
    }

    private func makeEditGoalContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .editStudyGoal,
            backTitle: "← Tiếng Anh",
            title: "Mục tiêu học",
            topPill: "B1",
            navItems: nav(selected: .settings),
            blocks: [
                .state(EnglishStateContent(
                    icon: "",
                    title: "Chỉnh mục tiêu hằng ngày",
                    message: "Thay đổi này áp dụng cho gợi ý bài học và reminder.",
                    tone: .accent
                )),
                .rows([
                    row("GIỜ NHẮC", "20:30"),
                    row("SỐ TỪ / NGÀY", "20 từ"),
                    row("TRÌNH ĐỘ", "B1"),
                    row("Từ vựng trước", "Ưu tiên deck và SRS", action: "✓"),
                    row("Quiz sau bài học", "Gợi ý quiz sau deck"),
                    row("Nghe mỗi ngày", "10 phút listening")
                ]),
                .buttons([button("Lưu mục tiêu")])
            ]
        )
    }

    private func makeResetConfirmContent() -> EnglishScreenContent {
        EnglishScreenContent(
            state: .resetProgressConfirm,
            backTitle: "← Cài đặt",
            title: "Reset",
            topPill: "Danger",
            navItems: nav(selected: .settings),
            blocks: [
                .state(EnglishStateContent(
                    icon: "!",
                    title: "Đặt lại tiến độ học?",
                    message: "Deck, quiz result và lịch ôn của English sẽ quay về trạng thái mới. XP tổng và tài khoản không bị xoá.\n\nKhông thể hoàn tác sau khi xác nhận.",
                    tone: .danger
                )),
                .buttons([button("Hủy", style: .secondary), button("Reset tiến độ", style: .danger)])
            ]
        )
    }

    private func makeStateContent(
        state: EnglishScreenState,
        title: String,
        pill: String,
        icon: String,
        headline: String,
        message: String,
        tone: EnglishTone = .accent,
        rows: [EnglishRowItem],
        buttons: [EnglishButtonItem]
    ) -> EnglishScreenContent {
        EnglishScreenContent(
            state: state,
            backTitle: "← Tiếng Anh",
            title: title,
            topPill: pill,
            navItems: nav(selected: .vocabulary),
            blocks: [
                .state(EnglishStateContent(icon: icon, title: headline, message: message, tone: tone)),
                .rows(rows),
                .buttons(buttons)
            ]
        )
    }

    private func reviewRows() -> [EnglishRowItem] {
        [
            row("Ambiguous", "Sai 3 lần · Danh từ · B1", action: "HOT", tone: .danger),
            row("Persevere", "Sai 2 lần · Động từ · B2", action: "KHÓ", tone: .warning),
            row("Eloquent", "Sai 1 lần · Tính từ · C1", action: "C1"),
            row("Benevolent", "Sai 1 lần · Tính từ · B2", action: "B2"),
            row("Meticulous", "Gần thuộc · Tính từ · C1", action: "DỄ", tone: .success),
            row("Ephemeral", "Gần thuộc · Tính từ · B2", action: "DỄ", tone: .success)
        ]
    }

    private func nav(selected: EnglishNavKind) -> [EnglishNavItem] {
        [
            EnglishNavItem(kind: .home, title: "Home", icon: "⌂", isSelected: selected == .home),
            EnglishNavItem(kind: .vocabulary, title: "Từ vựng", icon: "☰", isSelected: selected == .vocabulary),
            EnglishNavItem(kind: .quiz, title: "Quiz", icon: "✎", isSelected: selected == .quiz),
            EnglishNavItem(kind: .review, title: "Ôn tập", icon: "↺", isSelected: selected == .review),
            EnglishNavItem(kind: .settings, title: "Cài đặt", icon: "⚙", isSelected: selected == .settings)
        ]
    }

    private func row(
        _ title: String,
        _ subtitle: String,
        action: String? = nil,
        tone: EnglishTone = .muted
    ) -> EnglishRowItem {
        EnglishRowItem(title: title, subtitle: subtitle, actionTitle: action, tone: tone)
    }

    private func topic(
        _ title: String,
        _ subtitle: String,
        badge: String,
        tone: EnglishTone
    ) -> EnglishTopicItem {
        EnglishTopicItem(title: title, subtitle: subtitle, badge: badge, tone: tone)
    }

    private func button(_ title: String, style: EnglishButtonStyle = .primary) -> EnglishButtonItem {
        EnglishButtonItem(title: title, style: style)
    }
}
