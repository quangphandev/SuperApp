//
//  NoteUseCases.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 12/06/26.
//

import Foundation
import RxSwift

protocol ObserveNotesUseCaseProtocol {
    func execute() -> Observable<[NoteItem]>
}

protocol ObserveFoldersUseCaseProtocol {
    func execute() -> Observable<[NoteFolder]>
}

final class ObserveNotesUseCase: ObserveNotesUseCaseProtocol {
    private let repository: NoteRepositoryProtocol

    init(repository: NoteRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> Observable<[NoteItem]> {
        repository.observeNotes()
    }
}

final class ObserveFoldersUseCase: ObserveFoldersUseCaseProtocol {
    private let repository: NoteRepositoryProtocol

    init(repository: NoteRepositoryProtocol) {
        self.repository = repository
    }

    func execute() -> Observable<[NoteFolder]> {
        repository.observeFolders()
    }
}
