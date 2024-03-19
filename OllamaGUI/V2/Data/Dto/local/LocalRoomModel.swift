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
    var updateAt: Date
    @Relationship(deleteRule: .cascade) var chats: [LocalChatModel]
    var title: String?
    @Relationship(deleteRule: .cascade) var option: LocalRoomOptionModel?

    init(
        updateAt: Date,
        chats: [ChatEntity],
        title: String? = nil,
        option: RoomOptionEntity? = nil
    ) {
        self.updateAt = updateAt
        self.chats = chats
        self.title = title
        self.option = option
    }
}
