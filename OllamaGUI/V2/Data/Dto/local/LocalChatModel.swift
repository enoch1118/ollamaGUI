//
//  LocalChatModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Foundation
import SwiftData

@Model
class LocalChatModel {
    @Relationship(deleteRule: .cascade) var message: LocalMessageModel?
    var createdAt: Date
    var room: LocalRoomModel?

    init(message: LocalMessageModel? = nil, createdAt: Date, room: LocalRoomModel?) {
        self.message = message
        self.createdAt = createdAt
        self.room = room
    }

    var isSystem: Bool {
        message?.role == .system
    }

    var isMe: Bool {
        message?.role == .user
    }

    init(message: LocalMessageModel, room: LocalRoomModel) {
        self.message = message
        createdAt = .now
        self.room = room
    }
}
