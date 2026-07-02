//
//  NotesHomeViewModel.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 12/06/26.
//

import Foundation
import RxSwift
import RxCocoa

final class NotesHomeViewModel: BaseViewModel {

    struct Input {
        let reloadTrigger: Driver<Void>
    }

    struct Output {
        let pinnedNote: Driver<NoteItem?>
        let recentNotes: Driver<[NoteItem]>
        let folders: Driver<[NoteFolder]>
    }

    private let observeNotesUseCase: ObserveNotesUseCaseProtocol
    private let observeFoldersUseCase: ObserveFoldersUseCaseProtocol

    init(
        observeNotesUseCase: ObserveNotesUseCaseProtocol,
        observeFoldersUseCase: ObserveFoldersUseCaseProtocol
    ) {
        self.observeNotesUseCase = observeNotesUseCase
        self.observeFoldersUseCase = observeFoldersUseCase
        super.init()
    }

    func transform(input: Input) -> Output {
        let notesObservable = input.reloadTrigger.asObservable()
            .flatMapLatest { [observeNotesUseCase] in
                observeNotesUseCase.execute()
            }
            .share(replay: 1)

        let foldersObservable = input.reloadTrigger.asObservable()
            .flatMapLatest { [observeFoldersUseCase] in
                observeFoldersUseCase.execute()
            }
            .share(replay: 1)

        let pinnedNote = notesObservable
            .map { notes in
                notes.first { $0.id == "note_pinned_1" }
            }
            .asDriver(onErrorJustReturn: nil)

        let recentNotes = notesObservable
            .map { notes in
                // Recent notes are notes other than the main pinned note, limit to 3 to match Figma
                notes.filter { $0.id != "note_pinned_1" }
            }
            .asDriver(onErrorJustReturn: [])

        let folders = foldersObservable
            .asDriver(onErrorJustReturn: [])

        return Output(
            pinnedNote: pinnedNote,
            recentNotes: recentNotes,
            folders: folders
        )
    }
}
