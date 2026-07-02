//
//  NoteMapper.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 12/06/26.
//

import Foundation

enum NoteMapper {

    nonisolated static func mapNote(_ dto: NoteItemDTO) -> NoteItem {
        let blocks = decode([NoteBlock].self, from: dto.bodyBlocks) ?? []
        let tags = decode([String].self, from: dto.tags) ?? []
        let attachments = decode([NoteAttachment].self, from: dto.attachments) ?? []

        return NoteItem(
            id: dto.id,
            title: dto.title,
            bodyBlocks: blocks,
            plainTextIndex: dto.plainTextIndex,
            folderId: dto.folderId,
            tags: tags,
            isPinned: dto.isPinned != 0,
            isArchived: dto.isArchived != 0,
            isLocked: dto.isLocked != 0,
            attachments: attachments,
            createdAt: Date(timeIntervalSince1970: dto.createdAt),
            updatedAt: Date(timeIntervalSince1970: dto.updatedAt),
            deletedAt: dto.deletedAt.map { Date(timeIntervalSince1970: $0) },
            syncVersion: dto.syncVersion
        )
    }

    nonisolated static func mapFolder(_ dto: NoteFolderDTO, noteCount: Int, pinnedCount: Int, lockedCount: Int) -> NoteFolder {
        NoteFolder(
            id: dto.id,
            name: dto.name,
            colorHex: dto.colorHex,
            noteCount: noteCount,
            pinnedCount: pinnedCount,
            lockedCount: lockedCount,
            createdAt: Date(timeIntervalSince1970: dto.createdAt),
            updatedAt: Date(timeIntervalSince1970: dto.updatedAt)
        )
    }

    nonisolated static func makeNoteDTO(from item: NoteItem) -> NoteItemDTO {
        return NoteItemDTO(
            id: item.id,
            title: item.title,
            bodyBlocks: encode(item.bodyBlocks),
            plainTextIndex: item.plainTextIndex,
            folderId: item.folderId,
            tags: encode(item.tags),
            isPinned: item.isPinned ? 1 : 0,
            isArchived: item.isArchived ? 1 : 0,
            isLocked: item.isLocked ? 1 : 0,
            attachments: encode(item.attachments),
            createdAt: item.createdAt.timeIntervalSince1970,
            updatedAt: item.updatedAt.timeIntervalSince1970,
            deletedAt: item.deletedAt?.timeIntervalSince1970,
            syncVersion: item.syncVersion
        )
    }

    nonisolated static func makeNoteDTO(from draft: NoteDraft) -> NoteItemDTO {
        let now = Date().timeIntervalSince1970
        let plainText = draft.bodyBlocks.map { $0.content }.joined(separator: " ")

        return NoteItemDTO(
            id: UUID().uuidString,
            title: draft.title,
            bodyBlocks: encode(draft.bodyBlocks),
            plainTextIndex: plainText,
            folderId: draft.folderId,
            tags: encode(draft.tags),
            isPinned: 0,
            isArchived: 0,
            isLocked: 0,
            attachments: "[]",
            createdAt: now,
            updatedAt: now,
            deletedAt: nil,
            syncVersion: 1
        )
    }

    private nonisolated static func decode<T: Decodable>(_ type: T.Type, from json: String) -> T? {
        guard let data = json.data(using: .utf8) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(type, from: data)
    }

    private nonisolated static func encode<T: Encodable>(_ value: T) -> String {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(value),
              let json = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return json
    }
}
