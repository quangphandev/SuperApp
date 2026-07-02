//
//  EnglishViewController.swift
//  SuperApp_PQ
//
//  Created by Codex on 12/06/26.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class EnglishViewController: BaseViewController<EnglishViewModel> {

    private weak var coordinator: EnglishCoordinating?
    private let state: EnglishScreenState
    private let topBarView = EnglishTopBarView()
    private let bottomNavView = EnglishBottomNavView()
    private let contentScrollView = UIScrollView()
    private let contentStackView = UIStackView()

    init(viewModel: EnglishViewModel, coordinator: EnglishCoordinating?, state: EnglishScreenState) {
        self.coordinator = coordinator
        self.state = state
        super.init(viewModel: viewModel)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    override func setupViews() {
        overrideUserInterfaceStyle = .dark
        super.setupViews()
        view.backgroundColor = EnglishColor.background
        topBarView.overrideUserInterfaceStyle = .dark
        bottomNavView.overrideUserInterfaceStyle = .dark
        contentScrollView.backgroundColor = EnglishColor.background
        contentScrollView.showsVerticalScrollIndicator = false
        contentScrollView.alwaysBounceVertical = true
        contentStackView.axis = .vertical
        contentStackView.spacing = AppSpacing.medium
        contentStackView.alignment = .fill

        view.addSubview(topBarView)
        view.addSubview(bottomNavView)
        view.addSubview(contentScrollView)
        contentScrollView.addSubview(contentStackView)
    }

    override func setupConstraints() {
        super.setupConstraints()
        topBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(90)
        }

        bottomNavView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(64)
        }

        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(topBarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomNavView.snp.top)
        }

        contentStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(AppSpacing.xLarge)
            make.leading.trailing.equalTo(view).inset(AppSpacing.xLarge)
            make.width.equalTo(view).offset(-AppSpacing.xLarge * 2)
        }
    }

    override func setupBindings() {
        super.setupBindings()
        let output = viewModel.transform(input: EnglishViewModel.Input())
        output.content
            .drive(onNext: { [weak self] content in
                self?.render(content)
            })
            .disposed(by: disposeBag)
    }

    private func render(_ content: EnglishScreenContent) {
        topBarView.configure(backTitle: content.backTitle, title: content.title, pill: content.topPill)
        topBarView.onBackTap = { [weak self] in self?.handleBackTap() }
        topBarView.onRightTap = { [weak self] in self?.handleTopPillTap() }
        bottomNavView.configure(with: content.navItems) { [weak self] item in
            self?.route(to: item.kind)
        }

        removeArrangedSubviews()
        content.blocks.forEach { block in
            guard let view = makeView(for: block) else { return }
            contentStackView.addArrangedSubview(view)
        }
    }

    private func makeView(for block: EnglishBlock) -> UIView? {
        switch block {
        case .goal(let content):
            let view = EnglishGoalCardView()
            view.configure(with: content)
            return view
        case .stats(let items):
            guard !items.isEmpty else { return nil }
            let view = EnglishStatGridView(items: items)
            view.snp.makeConstraints { make in
                make.height.equalTo(74)
            }
            return view
        case .segments(let items, let selectedIndex):
            guard !items.isEmpty else { return nil }
            let view = EnglishSegmentedView(items: items, selectedIndex: selectedIndex)
            view.snp.makeConstraints { make in
                make.height.equalTo(44)
            }
            return view
        case .sectionTitle(let title, let trailing):
            let view = EnglishSectionHeaderView(title: title, trailing: trailing)
            view.snp.makeConstraints { make in
                make.height.equalTo(22)
            }
            return view
        case .topics(let items):
            guard !items.isEmpty else { return nil }
            return EnglishTopicsGridView(items: items) { [weak self] item in
                self?.handle(item)
            }
        case .rows(let rows):
            guard !rows.isEmpty else { return nil }
            return EnglishRowsView(rows: rows) { [weak self] row in
                self?.handle(row)
            }
        case .wordChips(let words):
            guard !words.isEmpty else { return nil }
            return EnglishWordChipsView(words: words)
        case .flashcard(let content):
            let view = EnglishFlashcardView()
            view.configure(with: content)
            view.onUnknownTap = { [weak self] in self?.coordinator?.showEnglish(state: .flashcardUnknown) }
            view.onKnownTap = { [weak self] in self?.coordinator?.showEnglish(state: .flashcardKnown) }
            view.onSkipTap = { [weak self] in self?.coordinator?.showEnglish(state: .wordDetail) }
            return view
        case .quiz(let content):
            let view = EnglishQuizView()
            view.configure(with: content)
            view.onAnswerTap = { [weak self] answer in
                self?.handle(answer)
            }
            return view
        case .result(let content):
            let view = EnglishResultView()
            view.configure(with: content)
            return view
        case .state(let content):
            let view = EnglishStateCardView()
            view.configure(with: content)
            return view
        case .options(let group):
            return EnglishOptionsView(group: group)
        case .buttons(let items):
            guard !items.isEmpty else { return nil }
            return EnglishButtonsView(items: items) { [weak self] item in
                self?.handle(item)
            }
        case .search(let placeholder):
            return EnglishSearchView(placeholder: placeholder)
        }
    }

    private func route(to kind: EnglishNavKind) {
        switch kind {
        case .home:
            coordinator?.showEnglish(state: .home)
        case .vocabulary:
            coordinator?.showEnglish(state: .topics)
        case .quiz:
            coordinator?.showEnglish(state: .quiz)
        case .review:
            coordinator?.showEnglish(state: .review)
        case .settings:
            coordinator?.showEnglish(state: .studySettings)
        }
    }

    private func handle(_ topic: EnglishTopicItem) {
        if topic.badge == "Locked" {
            Toast.show("Chủ đề này sẽ mở sau khi hoàn thành thêm từ vựng", type: .info)
            return
        }
        coordinator?.showEnglish(state: .topicDetail)
    }

    private func handle(_ row: EnglishRowItem) {
        switch row.title {
        case "Vocabulary · Animals", "Animals":
            coordinator?.showEnglish(state: .topicDetail)
        case "Flashcards":
            coordinator?.showEnglish(state: .flashcard)
        case "Quiz Animals":
            coordinator?.showEnglish(state: .quiz)
        case "Review Spaced":
            coordinator?.showEnglish(state: .review)
        case "Grammar", "Grammar · Present Perfect", "present perfect":
            coordinator?.showEnglish(state: .grammarLesson)
        case "Listening", "Listening · Daily Talk":
            coordinator?.showEnglish(state: .listeningLesson)
        case "Ambiguous", "ambiguous", "Persevere", "persevere", "Eloquent", "Benevolent", "Meticulous", "Ephemeral":
            coordinator?.showEnglish(state: .wordDetail)
        case "Gợi ý bắt đầu", "TỪ VỰNG THEO CHỦ ĐỀ":
            coordinator?.showEnglish(state: .topics)
        case "KIỂM TRA NHANH":
            coordinator?.showEnglish(state: .quiz)
        case "Đặt lại tiến độ chủ đề":
            coordinator?.showEnglish(state: .resetProgressConfirm)
        case "Nhắc học mỗi ngày", "GIỜ NHẮC", "SỐ TỪ / NGÀY", "TRÌNH ĐỘ":
            coordinator?.showEnglish(state: .editStudyGoal)
        default:
            handleRowAction(row.actionTitle)
        }
    }

    private func handleRowAction(_ title: String?) {
        switch title {
        case "Mở", "xem tất cả":
            coordinator?.showEnglish(state: .topics)
        case "Thêm":
            coordinator?.showEnglish(state: .search)
        case "Bắt đầu", "60%", "80%", "→":
            coordinator?.showEnglish(state: .quiz)
        case "Reset":
            coordinator?.showEnglish(state: .resetProgressConfirm)
        case "ôn lại", "HOT", "KHÓ", "B1", "B2", "C1", "DỄ":
            coordinator?.showEnglish(state: .wordDetail)
        case "Copy":
            Toast.show("Đã copy mã lỗi", type: .success)
        default:
            Toast.show("Tính năng đang được cập nhật", type: .info)
        }
    }

    private func handle(_ answer: EnglishAnswerItem) {
        switch answer.letter {
        case "A":
            coordinator?.showEnglish(state: .quizCorrect)
        case "D", "C", "-":
            coordinator?.showEnglish(state: .quizWrong)
        case "✓":
            coordinator?.showEnglish(state: .quizCorrect)
        default:
            Toast.show("Đã chọn đáp án", type: .info)
        }
    }

    private func handle(_ item: EnglishButtonItem) {
        switch item.title {
        case "Bắt đầu học", "Học flashcards", "Ôn từ này":
            coordinator?.showEnglish(state: .flashcard)
        case "Dùng gợi ý (-5 XP)":
            coordinator?.showEnglish(state: .quizHint)
        case "Hết giờ":
            coordinator?.showEnglish(state: .quizTimeout)
        case "Câu tiếp theo":
            coordinator?.showEnglish(state: state == .quizCorrect ? .resultPerfect : .result)
        case "Làm quiz Animals", "Luyện 5 câu", "Kiểm tra đáp án":
            coordinator?.showEnglish(state: .quiz)
        case "Ôn lại từ sai", "Bắt đầu ôn tập  →":
            coordinator?.showEnglish(state: .reviewPractice)
        case "Chủ đề tiếp theo", "Chọn chủ đề", "Về chủ đề", "Tiếp tục học":
            coordinator?.showEnglish(state: .topics)
        case "Về trang chủ", "Lưu và bắt đầu học":
            coordinator?.showEnglish(state: .home)
        case "Thẻ tiếp theo":
            coordinator?.showEnglish(state: .flashcard)
        case "Hoàn thành deck":
            coordinator?.showEnglish(state: .flashcardDone)
        case "Lưu cài đặt", "Lưu mục tiêu":
            coordinator?.showEnglish(state: .studySettings)
        case "Reset tiến độ":
            coordinator?.showEnglish(state: .empty)
        case "Thử lại":
            coordinator?.showEnglish(state: .loading)
        case "Xem lỗi":
            coordinator?.showEnglish(state: .error)
        case "Xem lại từ":
            coordinator?.showEnglish(state: .wordDetail)
        case "Dùng bản offline":
            coordinator?.showEnglish(state: .topicDetail)
        case "Hủy":
            coordinator?.showEnglish(state: .studySettings)
        case "Hủy tải":
            coordinator?.showEnglish(state: .topics)
        case "Quay lại":
            handleBackTap()
        case "Chia sẻ kết quả":
            Toast.show("Đã chuẩn bị nội dung chia sẻ", type: .success)
        case "Dễ":
            coordinator?.showEnglish(state: .reviewDone)
        case "Sai rồi", "Khó", "Tốt":
            Toast.show("Đã cập nhật lịch ôn", type: .success)
        default:
            Toast.show("Tính năng đang được cập nhật", type: .info)
        }
    }

    private func handleTopPillTap() {
        switch state {
        case .home:
            coordinator?.showEnglish(state: .review)
        case .topicDetail, .flashcard, .flashcardKnown, .flashcardUnknown, .flashcardDone:
            coordinator?.showEnglish(state: .search)
        case .studySettings, .editStudyGoal, .levelSetup:
            coordinator?.showEnglish(state: .levelSetup)
        default:
            Toast.show("Tính năng đang được cập nhật", type: .info)
        }
    }

    private func handleBackTap() {
        switch state {
        case .home:
            coordinator?.closeEnglish()
        case .topicDetail, .flashcard, .flashcardKnown, .flashcardUnknown,
             .flashcardDone, .wordDetail, .search, .empty, .loading, .error:
            coordinator?.showEnglish(state: .topics)
        case .quiz, .quizCorrect, .quizWrong, .quizHint, .quizTimeout,
             .result, .resultPerfect, .grammarLesson, .listeningLesson:
            coordinator?.showEnglish(state: .home)
        case .reviewPractice, .reviewDone:
            coordinator?.showEnglish(state: .review)
        case .studySettings:
            coordinator?.showEnglish(state: .home)
        case .levelSetup, .editStudyGoal, .resetProgressConfirm:
            coordinator?.showEnglish(state: .studySettings)
        case .review, .topics:
            coordinator?.showEnglish(state: .home)
        }
    }

    private func removeArrangedSubviews() {
        contentStackView.arrangedSubviews.forEach { view in
            contentStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
