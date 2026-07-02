//
//  NoteRepository.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 12/06/26.
//

import Foundation
import RxSwift

final class NoteRepository: NoteRepositoryProtocol {

    private let localService: NotesLocalServiceProtocol

    init(localService: NotesLocalServiceProtocol) {
        self.localService = localService
    }

    func observeNotes() -> Observable<[NoteItem]> {
        Observable.merge(.just(()), localService.changes)
            .flatMapLatest { [localService] in
                localService.fetchNotes()
            }
            .map { $0.map(NoteMapper.mapNote) }
    }

    func observeFolders() -> Observable<[NoteFolder]> {
        Observable.merge(.just(()), localService.changes)
            .flatMapLatest { [localService] in
                localService.fetchFolders()
            }
            .map { folders in
                folders.map { dto in
                    NoteMapper.mapFolder(
                        dto,
                        noteCount: dto.noteCount,
                        pinnedCount: dto.pinnedCount,
                        lockedCount: dto.lockedCount
                    )
                }
            }
    }

    func addNote(_ draft: NoteDraft) -> Observable<NoteItem> {
        let dto = NoteMapper.makeNoteDTO(from: draft)
        return localService.insertNote(dto)
            .map(NoteMapper.mapNote)
    }

    func deleteNote(id: String) -> Observable<Void> {
        localService.deleteNote(id: id)
    }
}
