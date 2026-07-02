//
//  NoteRepositoryProtocol.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 12/06/26.
//

import Foundation
import RxSwift

protocol NoteRepositoryProtocol {
    func observeNotes() -> Observable<[NoteItem]>
    func observeFolders() -> Observable<[NoteFolder]>
    func addNote(_ draft: NoteDraft) -> Observable<NoteItem>
    func deleteNote(id: String) -> Observable<Void>
}
