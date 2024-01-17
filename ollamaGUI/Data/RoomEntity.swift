//
//  RoomEntity.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import Foundation
import SwiftData

@Model
class RoomEntity {
    var updatedAt: Date
    @Relationship(deleteRule: .cascade) var chats: [ChatEntity]
    var title: String?

    init(updatedAt: Date, chats: [ChatEntity], title: String? = nil) {
        self.updatedAt = updatedAt
        self.chats = chats
        self.title = title ?? "new chat"
    }

    init() {
        updatedAt = Date.now
        chats = []
        title = "new chat"
    }

    var getChatModel: [ChatModel] {
        chats.map { ChatModel(entity: $0) }
    }

    func clean() {
        chats.removeAll()
    }
}

extension [ChatModel] {
    var toEntity: [ChatEntity] {
        map { $0.toEntity }
    }
}

extension ChatModel {
    var toEntity: ChatEntity {
        ChatEntity(
            message: MessageEntity(role: message!.role,
                                   content: message!.content, images: []),
            createdAt: createdAt ?? Date.now
        )
    }
}

#if DEBUG
    extension RoomEntity {
        static var randomRoom: RoomEntity {
            let room = RoomEntity()
            room.title = RandomGenerator.randomNames.randomElement()
            room.chats = [
            ]

            room.updatedAt = RandomGenerator.randomDate()
            return room
        }
    }
#endif
