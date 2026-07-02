//
//  NoteDTO.swift
//  SuperApp_PQ
//
//  Created by Phan Quang on 12/06/26.
//

import Foundation

struct NoteItemDTO: Codable {
    let id: String
    var title: String
    var bodyBlocks: String // JSON string of [NoteBlock]
    var plainTextIndex: String
    var folderId: String?
    var tags: String // JSON string of [String]
    var isPinned: Int
    var isArchived: Int
    var isLocked: Int
    var attachments: String // JSON string of [NoteAttachment]
    let createdAt: Double
    var updatedAt: Double
    var deletedAt: Double?
    var syncVersion: Int
}

struct NoteFolderDTO: Codable {
    let id: String
    var name: String
    var colorHex: String?
    var noteCount: Int = 0
    var pinnedCount: Int = 0
    var lockedCount: Int = 0
    let createdAt: Double
    var updatedAt: Double
}
