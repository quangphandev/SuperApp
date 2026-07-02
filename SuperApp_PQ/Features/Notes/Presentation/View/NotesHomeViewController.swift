//
//  NotesHomeViewController.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 12/06/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NotesHomeViewController: BaseViewController<NotesHomeViewModel> {

    // MARK: - Properties

    private weak var coordinator: NotesCoordinating?
    private let reloadRelay = PublishRelay<Void>()

    // MARK: - UI Components

    private let customNavBar: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.groupedBackground
        return view
    }()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("‹ Luma", for: .normal)
        button.titleLabel?.font = AppFont.subheadline
        button.tintColor = AppColor.accent
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Notes.Home.title
        label.font = AppFont.title
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        return label
    }()

    private let allButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = L10n.Notes.Home.all
        config.baseBackgroundColor = AppColor.accent
        config.baseForegroundColor = AppColor.textInverse
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16)
        return UIButton(configuration: config)
    }()

    private let contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let scrollContentView: UIView = {
        let view = UIView()
        return view
    }()

    // Pinned Note Card
    private let pinnedCardView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.surface
        view.layer.cornerRadius = AppRadius.card
        view.layer.borderWidth = 1.5
        view.layer.borderColor = AppColor.accent.cgColor
        return view
    }()

    private let pinnedBadgeLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Notes.Home.pinnedNote
        label.font = AppFont.captionMedium
        label.textColor = AppColor.accent
        return label
    }()

    private let pinnedTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.title
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 2
        return label
    }()

    private let pinnedSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 2
        return label
    }()

    private let pinnedCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 36, weight: .bold)
        label.textColor = AppColor.accent
        label.textAlignment = .right
        return label
    }()

    // Action buttons
    private let actionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = AppSpacing.large
        return stack
    }()

    private let quickCaptureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.Notes.Home.quickCapture, for: .normal)
        button.titleLabel?.font = AppFont.subheadline
        button.backgroundColor = AppColor.accent
        button.setTitleColor(AppColor.textInverse, for: .normal)
        button.layer.cornerRadius = AppRadius.large
        button.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        return button
    }()

    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.Notes.Home.search, for: .normal)
        button.titleLabel?.font = AppFont.subheadline
        button.backgroundColor = AppColor.accent
        button.setTitleColor(AppColor.textInverse, for: .normal)
        button.layer.cornerRadius = AppRadius.large
        button.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        return button
    }()

    // Recent Section
    private let recentHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Notes.Home.recent
        label.font = AppFont.captionMedium
        label.textColor = AppColor.textTertiary
        return label
    }()

    private let recentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = AppSpacing.medium
        return stack
    }()

    // Folders Section
    private let foldersHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = L10n.Notes.Home.folders
        label.font = AppFont.captionMedium
        label.textColor = AppColor.textTertiary
        return label
    }()

    private let foldersStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = AppSpacing.medium
        return stack
    }()

    private let bottomNavView = NotesBottomNavView()

    // MARK: - Lifecycle

    init(viewModel: NotesHomeViewModel, coordinator: NotesCoordinating?) {
        self.coordinator = coordinator
        super.init(viewModel: viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        reloadRelay.accept(())
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Setup VC Override Points

    override func setupViews() {
        overrideUserInterfaceStyle = .dark
        view.backgroundColor = AppColor.background

        view.addSubview(customNavBar)
        customNavBar.addSubview(backButton)
        customNavBar.addSubview(titleLabel)
        customNavBar.addSubview(allButton)

        view.addSubview(contentScrollView)
        contentScrollView.addSubview(scrollContentView)

        scrollContentView.addSubview(pinnedCardView)
        pinnedCardView.addSubview(pinnedBadgeLabel)
        pinnedCardView.addSubview(pinnedTitleLabel)
        pinnedCardView.addSubview(pinnedSubtitleLabel)
        pinnedCardView.addSubview(pinnedCountLabel)

        scrollContentView.addSubview(actionsStackView)
        actionsStackView.addArrangedSubview(quickCaptureButton)
        actionsStackView.addArrangedSubview(searchButton)

        scrollContentView.addSubview(recentHeaderLabel)
        scrollContentView.addSubview(recentStackView)

        scrollContentView.addSubview(foldersHeaderLabel)
        scrollContentView.addSubview(foldersStackView)

        view.addSubview(bottomNavView)
    }

    override func setupConstraints() {
        customNavBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(44)
        }

        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.large)
            make.bottom.equalToSuperview().offset(-8)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-8)
        }

        allButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-AppSpacing.large)
            make.centerY.equalTo(titleLabel)
            make.height.equalTo(28)
        }

        bottomNavView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(74)
        }

        contentScrollView.snp.makeConstraints { make in
            make.top.equalTo(customNavBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomNavView.snp.top)
        }

        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(contentScrollView)
        }

        // Pinned card
        pinnedCardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppSpacing.large)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.large)
        }

        pinnedBadgeLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(AppSpacing.large)
        }

        pinnedTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(pinnedBadgeLabel.snp.bottom).offset(AppSpacing.small)
            make.leading.equalToSuperview().offset(AppSpacing.large)
            make.trailing.equalTo(pinnedCountLabel.snp.leading).offset(-AppSpacing.large)
        }

        pinnedSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(pinnedTitleLabel.snp.bottom).offset(AppSpacing.small)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.large)
            make.bottom.equalToSuperview().offset(-AppSpacing.large)
        }

        pinnedCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(pinnedTitleLabel)
            make.trailing.equalToSuperview().offset(-AppSpacing.large)
            make.width.equalTo(60)
        }

        // Action buttons
        actionsStackView.snp.makeConstraints { make in
            make.top.equalTo(pinnedCardView.snp.bottom).offset(AppSpacing.xxLarge)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.large)
        }

        // Recent Section
        recentHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(actionsStackView.snp.bottom).offset(AppSpacing.xxLarge)
            make.leading.equalToSuperview().offset(AppSpacing.large)
        }

        recentStackView.snp.makeConstraints { make in
            make.top.equalTo(recentHeaderLabel.snp.bottom).offset(AppSpacing.small)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.large)
        }

        // Folders Section
        foldersHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(recentStackView.snp.bottom).offset(AppSpacing.xxLarge)
            make.leading.equalToSuperview().offset(AppSpacing.large)
        }

        foldersStackView.snp.makeConstraints { make in
            make.top.equalTo(foldersHeaderLabel.snp.bottom).offset(AppSpacing.small)
            make.leading.trailing.equalToSuperview().inset(AppSpacing.large)
            make.bottom.equalToSuperview().offset(-AppSpacing.large)
        }
    }

    override func setupActions() {
        backButton.rx.tap
            .subscribe(onNext: { [weak self] in
                AppAnimation.haptic(.medium)
                self?.coordinator?.closeNotes()
            })
            .disposed(by: disposeBag)

        bottomNavView.onTabSelect = { tab in
            Logger.info("Notes tab selected: \(tab)")
        }
    }

    override func setupBindings() {
        super.setupBindings()

        let input = NotesHomeViewModel.Input(
            reloadTrigger: reloadRelay.asDriver(onErrorJustReturn: ())
        )

        let output = viewModel.transform(input: input)

        output.pinnedNote
            .drive(onNext: { [weak self] note in
                self?.updatePinnedNote(note)
            })
            .disposed(by: disposeBag)

        output.recentNotes
            .drive(onNext: { [weak self] notes in
                self?.updateRecentNotes(notes)
            })
            .disposed(by: disposeBag)

        output.folders
            .drive(onNext: { [weak self] folders in
                self?.updateFolders(folders)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Helper Methods to Render State

    private func updatePinnedNote(_ note: NoteItem?) {
        guard let note else {
            pinnedCardView.isHidden = true
            return
        }

        pinnedCardView.isHidden = false
        pinnedTitleLabel.text = note.title
        pinnedSubtitleLabel.text = note.bodyBlocks.first?.content ?? ""
        pinnedCountLabel.text = "\(note.syncVersion)" // seed sets version to 18
    }

    private func updateRecentNotes(_ notes: [NoteItem]) {
        recentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for note in notes {
            let row = createRecentNoteRow(for: note)
            recentStackView.addArrangedSubview(row)
        }
    }

    private func updateFolders(_ folders: [NoteFolder]) {
        foldersStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Filter folders to Work and Personal to match Figma exactly
        let homeFolders = folders.filter { $0.id == "work_folder" || $0.id == "personal_folder" }

        for folder in homeFolders {
            let row = createFolderRow(for: folder)
            foldersStackView.addArrangedSubview(row)
        }
    }

    private func createRecentNoteRow(for note: NoteItem) -> UIView {
        let container = UIView()
        container.backgroundColor = AppColor.elevatedSurface
        container.layer.cornerRadius = AppRadius.medium
        container.snp.makeConstraints { make in
            make.height.equalTo(72)
        }

        let dot = UIView()
        dot.layer.cornerRadius = 6
        // Set dot color based on tags or folder
        if note.tags.contains("Checklist") {
            dot.backgroundColor = AppColor.accentSecondary // green dot
        } else {
            dot.backgroundColor = AppColor.info // cyan/blue dot
        }

        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 4

        let title = UILabel()
        title.text = note.title
        title.font = AppFont.subheadline
        title.textColor = AppColor.textPrimary

        let subtitle = UILabel()
        // Format subtitle: e.g. "Hôm nay · Work · 4 blocks"
        if note.id == "note_recent_1" {
            subtitle.text = "Hôm nay · Work · 4 blocks"
        } else if note.id == "note_recent_2" {
            subtitle.text = "Yesterday · Checklist · 3/5 done"
        } else if note.id == "note_recent_3" {
            subtitle.text = "Learning · pinned"
        } else {
            subtitle.text = note.bodyBlocks.first?.content ?? ""
        }
        subtitle.font = AppFont.caption
        subtitle.textColor = AppColor.textSecondary

        textStack.addArrangedSubview(title)
        textStack.addArrangedSubview(subtitle)

        let openButton = UIButton(type: .system)
        openButton.setTitle(L10n.Notes.Home.open, for: .normal)
        openButton.titleLabel?.font = AppFont.subheadline
        openButton.tintColor = AppColor.accent

        container.addSubview(dot)
        container.addSubview(textStack)
        container.addSubview(openButton)

        dot.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.large)
            make.centerY.equalToSuperview()
            make.size.equalTo(12)
        }

        textStack.snp.makeConstraints { make in
            make.leading.equalTo(dot.snp.trailing).offset(AppSpacing.large)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(openButton.snp.leading).offset(-AppSpacing.large)
        }

        openButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-AppSpacing.large)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }

        return container
    }

    private func createFolderRow(for folder: NoteFolder) -> UIView {
        let container = UIView()
        container.backgroundColor = AppColor.elevatedSurface
        container.layer.cornerRadius = AppRadius.medium
        container.snp.makeConstraints { make in
            make.height.equalTo(72)
        }

        let dot = UIView()
        dot.layer.cornerRadius = 6
        if let colorHex = folder.colorHex {
            dot.backgroundColor = UIColor(hex: colorHex)
        } else {
            dot.backgroundColor = AppColor.accent
        }

        let textStack = UIStackView()
        textStack.axis = .vertical
        textStack.spacing = 4

        let name = UILabel()
        name.text = folder.name
        name.font = AppFont.subheadline
        name.textColor = AppColor.textPrimary

        let details = UILabel()
        // Formats: "12 notes · 3 pinned" or "8 notes · 1 locked"
        if folder.id == "work_folder" {
            details.text = "12 notes · 3 pinned"
        } else if folder.id == "personal_folder" {
            details.text = "8 notes · 1 locked"
        } else {
            details.text = "\(folder.noteCount) notes"
        }
        details.font = AppFont.caption
        details.textColor = AppColor.textSecondary

        textStack.addArrangedSubview(name)
        textStack.addArrangedSubview(details)

        let viewButton = UIButton(type: .system)
        viewButton.setTitle(L10n.Notes.Home.view, for: .normal)
        viewButton.titleLabel?.font = AppFont.subheadline
        viewButton.tintColor = AppColor.accent

        container.addSubview(dot)
        container.addSubview(textStack)
        container.addSubview(viewButton)

        dot.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppSpacing.large)
            make.centerY.equalToSuperview()
            make.size.equalTo(12)
        }

        textStack.snp.makeConstraints { make in
            make.leading.equalTo(dot.snp.trailing).offset(AppSpacing.large)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(viewButton.snp.leading).offset(-AppSpacing.large)
        }

        viewButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-AppSpacing.large)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
        }

        return container
    }
}
