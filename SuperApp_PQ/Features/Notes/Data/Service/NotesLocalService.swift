//
//  NotesLocalService.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 12/06/26.
//

import Foundation
import RxSwift
import SQLite3

protocol NotesLocalServiceProtocol {
    var changes: Observable<Void> { get }

    func fetchNotes() -> Observable<[NoteItemDTO]>
    func fetchFolders() -> Observable<[NoteFolderDTO]>
    func insertNote(_ dto: NoteItemDTO) -> Observable<NoteItemDTO>
    func deleteNote(id: String) -> Observable<Void>
}

enum NotesStorageError: Error {
    case openDatabase
    case prepare(String)
    case step(String)
}

final class NotesLocalService: NotesLocalServiceProtocol {

    private enum SQL {
        static let createNotesTable = """
        CREATE TABLE IF NOT EXISTS note_items (
            id TEXT PRIMARY KEY NOT NULL,
            title TEXT NOT NULL,
            body_blocks TEXT NOT NULL,
            plain_text_index TEXT NOT NULL,
            folder_id TEXT,
            tags TEXT NOT NULL,
            is_pinned INTEGER NOT NULL,
            is_archived INTEGER NOT NULL,
            is_locked INTEGER NOT NULL,
            attachments TEXT NOT NULL,
            created_at REAL NOT NULL,
            updated_at REAL NOT NULL,
            deleted_at REAL,
            sync_version INTEGER NOT NULL
        );
        """

        static let createFoldersTable = """
        CREATE TABLE IF NOT EXISTS note_folders (
            id TEXT PRIMARY KEY NOT NULL,
            name TEXT NOT NULL,
            color_hex TEXT,
            created_at REAL NOT NULL,
            updated_at REAL NOT NULL
        );
        """
    }

    private let databaseURL: URL
    private let queue = DispatchQueue(label: "com.luma.notes.sqlite", qos: .userInitiated)
    private let changeSubject = PublishSubject<Void>()
    private var database: OpaquePointer?
    private var didMigrate = false

    var changes: Observable<Void> {
        changeSubject.asObservable()
    }

    init(databaseURL: URL? = nil) {
        if let databaseURL {
            self.databaseURL = databaseURL
        } else {
            self.databaseURL = Self.defaultDatabaseURL()
        }
    }

    deinit {
        if let database {
            sqlite3_close(database)
        }
    }

    func fetchNotes() -> Observable<[NoteItemDTO]> {
        perform { service in
            try service.fetchNoteDTOs()
        }
    }

    func fetchFolders() -> Observable<[NoteFolderDTO]> {
        perform { service in
            try service.fetchFolderDTOs()
        }
    }

    func insertNote(_ dto: NoteItemDTO) -> Observable<NoteItemDTO> {
        performMutation { service in
            try service.insertNoteDTO(dto)
            return dto
        }
    }

    func deleteNote(id: String) -> Observable<Void> {
        performMutation { service in
            try service.deleteNoteDTO(id: id)
        }
    }

    private static func defaultDatabaseURL() -> URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent("luma_notes.sqlite")
    }

    private func perform<T>(_ work: @escaping (NotesLocalService) throws -> T) -> Observable<T> {
        Observable.create { [weak self] observer in
            guard let self else {
                observer.onCompleted()
                return Disposables.create()
            }

            self.queue.async {
                do {
                    try self.openIfNeeded()
                    let value = try work(self)
                    observer.onNext(value)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }

            return Disposables.create()
        }
    }

    private func performMutation<T>(_ work: @escaping (NotesLocalService) throws -> T) -> Observable<T> {
        perform(work)
            .do(onNext: { [weak self] _ in
                self?.changeSubject.onNext(())
            })
    }

    private func openIfNeeded() throws {
        guard database == nil else {
            try migrateIfNeeded()
            return
        }

        let directory = databaseURL.deletingLastPathComponent()
        try FileManager.default.createDirectory(
            at: directory,
            withIntermediateDirectories: true
        )

        guard sqlite3_open(databaseURL.path, &database) == SQLITE_OK else {
            throw NotesStorageError.openDatabase
        }

        try migrateIfNeeded()
    }

    private func migrateIfNeeded() throws {
        guard !didMigrate else { return }
        try execute(SQL.createNotesTable)
        try execute(SQL.createFoldersTable)
        try seedInitialDataIfNeeded()
        didMigrate = true
    }

    private func execute(_ sql: String) throws {
        guard sqlite3_exec(database, sql, nil, nil, nil) == SQLITE_OK else {
            throw NotesStorageError.step(lastErrorMessage())
        }
    }

    private func seedInitialDataIfNeeded() throws {
        // Check if folders already exist
        var folderCount = 0
        let checkStmt = try prepare("SELECT COUNT(*) FROM note_folders;")
        if sqlite3_step(checkStmt) == SQLITE_ROW {
            folderCount = Int(sqlite3_column_int(checkStmt, 0))
        }
        sqlite3_finalize(checkStmt)

        guard folderCount == 0 else { return }

        // Seed default folders
        let now = Date().timeIntervalSince1970
        let folders = [
            NoteFolderDTO(id: "work_folder", name: "Work", colorHex: "#36E3A1", createdAt: now, updatedAt: now),
            NoteFolderDTO(id: "personal_folder", name: "Personal", colorHex: "#FFC544", createdAt: now, updatedAt: now),
            NoteFolderDTO(id: "learning_folder", name: "Learning", colorHex: "#7DB3FF", createdAt: now, updatedAt: now),
            NoteFolderDTO(id: "inbox_folder", name: "Inbox", colorHex: "#FF6F98", createdAt: now, updatedAt: now),
            NoteFolderDTO(id: "archived_folder", name: "Archived", colorHex: "#8E8CA0", createdAt: now, updatedAt: now)
        ]

        for folder in folders {
            let stmt = try prepare("INSERT INTO note_folders (id, name, color_hex, created_at, updated_at) VALUES (?, ?, ?, ?, ?);")
            sqlite3_bind_text(stmt, 1, folder.id, -1, transientDestructor)
            sqlite3_bind_text(stmt, 2, folder.name, -1, transientDestructor)
            if let color = folder.colorHex {
                sqlite3_bind_text(stmt, 3, color, -1, transientDestructor)
            } else {
                sqlite3_bind_null(stmt, 3)
            }
            sqlite3_bind_double(stmt, 4, folder.createdAt)
            sqlite3_bind_double(stmt, 5, folder.updatedAt)
            try step(stmt)
            sqlite3_finalize(stmt)
        }

        // Seed mock notes to match Figma
        // 1. Pinned Note: "Ý tưởng Luma Notes"
        let pinnedNote = NoteItemDTO(
            id: "note_pinned_1",
            title: "Ý tưởng Luma Notes",
            bodyBlocks: "[{\"id\":\"1\",\"type\":\"paragraph\",\"content\":\"Autosave · tags · offline search · locked notes\",\"sortOrder\":0}]",
            plainTextIndex: "Autosave · tags · offline search · locked notes",
            folderId: nil,
            tags: "[]",
            isPinned: 1,
            isArchived: 0,
            isLocked: 0,
            attachments: "[]",
            createdAt: now - 3600,
            updatedAt: now - 3600,
            deletedAt: nil,
            syncVersion: 18
        )

        // 2. Recent Note 1: "Meeting với team design"
        let note1 = NoteItemDTO(
            id: "note_recent_1",
            title: "Meeting với team design",
            bodyBlocks: "[]",
            plainTextIndex: "Meeting với team design",
            folderId: "work_folder",
            tags: "[\"Work\"]",
            isPinned: 0,
            isArchived: 0,
            isLocked: 0,
            attachments: "[]",
            createdAt: now - 600,
            updatedAt: now - 600,
            deletedAt: nil,
            syncVersion: 1
        )

        // 3. Recent Note 2: "Checklist launch app"
        let note2 = NoteItemDTO(
            id: "note_recent_2",
            title: "Checklist launch app",
            bodyBlocks: "[{\"id\":\"1\",\"type\":\"checklist_item\",\"content\":\"Check 1\",\"checked\":true,\"sortOrder\":0}]",
            plainTextIndex: "Checklist launch app",
            folderId: nil,
            tags: "[\"Checklist\"]",
            isPinned: 0,
            isArchived: 0,
            isLocked: 0,
            attachments: "[]",
            createdAt: now - 86400,
            updatedAt: now - 86400,
            deletedAt: nil,
            syncVersion: 1
        )

        // 4. Recent Note 3: "Ý tưởng bài học English"
        let note3 = NoteItemDTO(
            id: "note_recent_3",
            title: "Ý tưởng bài học English",
            bodyBlocks: "[]",
            plainTextIndex: "Ý tưởng bài học English",
            folderId: "learning_folder",
            tags: "[\"Learning\"]",
            isPinned: 1,
            isArchived: 0,
            isLocked: 0,
            attachments: "[]",
            createdAt: now - 172800,
            updatedAt: now - 172800,
            deletedAt: nil,
            syncVersion: 1
        )

        let seedNotes = [pinnedNote, note1, note2, note3]
        for note in seedNotes {
            try insertNoteDTO(note)
        }

        // Pre-populate dummy notes in Work and Personal to make count match Figma:
        // Work folder: 12 notes, 3 pinned -> We already have note1 (not pinned) in work_folder.
        // Let's add 11 more notes to Work: 3 pinned, 8 normal.
        for i in 1...11 {
            let isPinned = i <= 3 ? 1 : 0
            let dummyNote = NoteItemDTO(
                id: "work_dummy_\(i)",
                title: "Work note \(i)",
                bodyBlocks: "[]",
                plainTextIndex: "",
                folderId: "work_folder",
                tags: "[]",
                isPinned: isPinned,
                isArchived: 0,
                isLocked: 0,
                attachments: "[]",
                createdAt: now - Double(i * 1000),
                updatedAt: now - Double(i * 1000),
                deletedAt: nil,
                syncVersion: 1
            )
            try insertNoteDTO(dummyNote)
        }

        // Personal folder: 8 notes, 1 locked.
        for i in 1...8 {
            let isLocked = i == 1 ? 1 : 0
            let dummyNote = NoteItemDTO(
                id: "personal_dummy_\(i)",
                title: "Personal note \(i)",
                bodyBlocks: "[]",
                plainTextIndex: "",
                folderId: "personal_folder",
                tags: "[]",
                isPinned: 0,
                isArchived: 0,
                isLocked: isLocked,
                attachments: "[]",
                createdAt: now - Double(i * 2000),
                updatedAt: now - Double(i * 2000),
                deletedAt: nil,
                syncVersion: 1
            )
            try insertNoteDTO(dummyNote)
        }
    }

    private func insertNoteDTO(_ dto: NoteItemDTO) throws {
        let stmt = try prepare("""
        INSERT OR REPLACE INTO note_items (
            id, title, body_blocks, plain_text_index, folder_id, tags,
            is_pinned, is_archived, is_locked, attachments,
            created_at, updated_at, deleted_at, sync_version
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);
        """)
        defer { sqlite3_finalize(stmt) }

        sqlite3_bind_text(stmt, 1, dto.id, -1, transientDestructor)
        sqlite3_bind_text(stmt, 2, dto.title, -1, transientDestructor)
        sqlite3_bind_text(stmt, 3, dto.bodyBlocks, -1, transientDestructor)
        sqlite3_bind_text(stmt, 4, dto.plainTextIndex, -1, transientDestructor)
        if let folderId = dto.folderId {
            sqlite3_bind_text(stmt, 5, folderId, -1, transientDestructor)
        } else {
            sqlite3_bind_null(stmt, 5)
        }
        sqlite3_bind_text(stmt, 6, dto.tags, -1, transientDestructor)
        sqlite3_bind_int(stmt, 7, Int32(dto.isPinned))
        sqlite3_bind_int(stmt, 8, Int32(dto.isArchived))
        sqlite3_bind_int(stmt, 9, Int32(dto.isLocked))
        sqlite3_bind_text(stmt, 10, dto.attachments, -1, transientDestructor)
        sqlite3_bind_double(stmt, 11, dto.createdAt)
        sqlite3_bind_double(stmt, 12, dto.updatedAt)
        if let deletedAt = dto.deletedAt {
            sqlite3_bind_double(stmt, 13, deletedAt)
        } else {
            sqlite3_bind_null(stmt, 13)
        }
        sqlite3_bind_int(stmt, 14, Int32(dto.syncVersion))

        try step(stmt)
    }

    private func fetchNoteDTOs() throws -> [NoteItemDTO] {
        let sql = "SELECT * FROM note_items WHERE deleted_at IS NULL ORDER BY is_pinned DESC, updated_at DESC;"
        let statement = try prepare(sql)
        defer { sqlite3_finalize(statement) }

        var notes: [NoteItemDTO] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            notes.append(readNoteDTO(from: statement))
        }
        return notes
    }

    private func fetchFolderDTOs() throws -> [NoteFolderDTO] {
        let sql = "SELECT * FROM note_folders ORDER BY name ASC;"
        let statement = try prepare(sql)
        defer { sqlite3_finalize(statement) }

        var folders: [NoteFolderDTO] = []
        while sqlite3_step(statement) == SQLITE_ROW {
            var folder = readFolderDTO(from: statement)
            let counts = try fetchFolderCounts(folderId: folder.id)
            folder.noteCount = counts.noteCount
            folder.pinnedCount = counts.pinnedCount
            folder.lockedCount = counts.lockedCount
            folders.append(folder)
        }
        return folders
    }

    private func fetchFolderCounts(folderId: String) throws -> (noteCount: Int, pinnedCount: Int, lockedCount: Int) {
        let sql = "SELECT COUNT(*), SUM(is_pinned), SUM(is_locked) FROM note_items WHERE folder_id = ? AND deleted_at IS NULL;"
        let statement = try prepare(sql)
        defer { sqlite3_finalize(statement) }
        sqlite3_bind_text(statement, 1, folderId, -1, transientDestructor)

        var noteCount = 0
        var pinnedCount = 0
        var lockedCount = 0
        if sqlite3_step(statement) == SQLITE_ROW {
            noteCount = Int(sqlite3_column_int(statement, 0))
            pinnedCount = Int(sqlite3_column_int(statement, 1))
            lockedCount = Int(sqlite3_column_int(statement, 2))
        }
        return (noteCount, pinnedCount, lockedCount)
    }

    private func deleteNoteDTO(id: String) throws {
        let statement = try prepare("UPDATE note_items SET deleted_at = ?, updated_at = ? WHERE id = ?;")
        defer { sqlite3_finalize(statement) }
        let now = Date().timeIntervalSince1970
        sqlite3_bind_double(statement, 1, now)
        sqlite3_bind_double(statement, 2, now)
        sqlite3_bind_text(statement, 3, id, -1, transientDestructor)
        try step(statement)
    }

    private func prepare(_ sql: String) throws -> OpaquePointer {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK,
              let statement
        else {
            throw NotesStorageError.prepare(lastErrorMessage())
        }
        return statement
    }

    private func step(_ statement: OpaquePointer) throws {
        guard sqlite3_step(statement) == SQLITE_DONE else {
            throw NotesStorageError.step(lastErrorMessage())
        }
    }

    private func readNoteDTO(from statement: OpaquePointer) -> NoteItemDTO {
        NoteItemDTO(
            id: string(statement, 0),
            title: string(statement, 1),
            bodyBlocks: string(statement, 2),
            plainTextIndex: string(statement, 3),
            folderId: optionalString(statement, 4),
            tags: string(statement, 5),
            isPinned: Int(sqlite3_column_int(statement, 6)),
            isArchived: Int(sqlite3_column_int(statement, 7)),
            isLocked: Int(sqlite3_column_int(statement, 8)),
            attachments: string(statement, 9),
            createdAt: sqlite3_column_double(statement, 10),
            updatedAt: sqlite3_column_double(statement, 11),
            deletedAt: optionalDouble(statement, 12),
            syncVersion: Int(sqlite3_column_int(statement, 13))
        )
    }

    private func readFolderDTO(from statement: OpaquePointer) -> NoteFolderDTO {
        NoteFolderDTO(
            id: string(statement, 0),
            name: string(statement, 1),
            colorHex: optionalString(statement, 2),
            noteCount: 0,
            pinnedCount: 0,
            lockedCount: 0,
            createdAt: sqlite3_column_double(statement, 3),
            updatedAt: sqlite3_column_double(statement, 4)
        )
    }

    private func string(_ statement: OpaquePointer, _ index: Int32) -> String {
        guard let text = sqlite3_column_text(statement, index) else { return "" }
        return String(cString: text)
    }

    private func optionalString(_ statement: OpaquePointer, _ index: Int32) -> String? {
        guard sqlite3_column_type(statement, index) != SQLITE_NULL else { return nil }
        return string(statement, index)
    }

    private func optionalDouble(_ statement: OpaquePointer, _ index: Int32) -> Double? {
        guard sqlite3_column_type(statement, index) != SQLITE_NULL else { return nil }
        return sqlite3_column_double(statement, index)
    }

    private func lastErrorMessage() -> String {
        guard let database,
              let message = sqlite3_errmsg(database)
        else {
            return "Unknown database error"
        }
        return String(cString: message)
    }
}

private let transientDestructor = unsafeBitCast(
    -1,
    to: sqlite3_destructor_type.self
)
