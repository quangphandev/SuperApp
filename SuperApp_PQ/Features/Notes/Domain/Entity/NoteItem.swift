//
//  NoteItem.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 12/06/26.
//

import Foundation

struct NoteItem: Hashable {
    let id: String
    var title: String
    var bodyBlocks: [NoteBlock]
    var plainTextIndex: String
    var folderId: String?
    var tags: [String]
    var isPinned: Bool
    var isArchived: Bool
    var isLocked: Bool
    var attachments: [NoteAttachment]
    let createdAt: Date
    var updatedAt: Date
    var deletedAt: Date?
    var syncVersion: Int
}

struct NoteBlock: Hashable, Codable {
    let id: String
    var type: NoteBlockType
    var content: String
    var checked: Bool?
    var sortOrder: Int
}

enum NoteBlockType: String, Codable {
    case paragraph
    case heading
    case checklistItem = "checklist_item"
    case quote
    case divider
    case attachment
}

struct NoteAttachment: Hashable, Codable {
    let id: String
    var type: NoteAttachmentType
    var uri: String
    var thumbnailUri: String?
    var permissionState: String
    let createdAt: Date
}

enum NoteAttachmentType: String, Codable {
    case image
    case audio
    case file
}

struct NoteFolder: Hashable {
    let id: String
    var name: String
    var colorHex: String?
    var noteCount: Int
    var pinnedCount: Int
    var lockedCount: Int
    let createdAt: Date
    var updatedAt: Date
}

struct NoteDraft: Hashable {
    let title: String
    let bodyBlocks: [NoteBlock]
    let folderId: String?
    let tags: [String]

    init(
        title: String,
        bodyBlocks: [NoteBlock] = [],
        folderId: String? = nil,
        tags: [String] = []
    ) {
        self.title = title
        self.bodyBlocks = bodyBlocks
        self.folderId = folderId
        self.tags = tags
    }
}
