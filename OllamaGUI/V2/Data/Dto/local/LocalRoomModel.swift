//
//  LocalRoomModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Foundation
import SwiftData

@Model
class LocalRoomModel {
    var updatedAt: Date

    @Relationship(
        deleteRule: .cascade,
        inverse: \LocalChatModel.room
    ) var chats: [LocalChatModel]

    @Relationship(
        deleteRule: .cascade
    ) var option: LocalRoomOptionModel?

    var title: String?

    init(
        updateAt: Date,
        chats: [LocalChatModel],
        title: String? = nil,
        option: LocalRoomOptionModel? = nil
    ) {
        updatedAt = updateAt
        self.chats = chats
        self.title = title
        self.option = option
    }

    func appendResponse(chat: ResChatModel) {
        let local = LocalChatModel(
            message: .init(
                id: chat.id,
                role: chat.message?.role ?? .assistant,
                content: chat.message?.content ?? "error",
                images: chat.images
            ),
            createdAt: .now,
            room: self
        )
        chats.append(local)
        // update title
        title = chat.message?.content
        updatedAt = .now
    }
}
