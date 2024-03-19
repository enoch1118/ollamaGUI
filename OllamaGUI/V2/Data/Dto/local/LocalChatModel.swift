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
    @Relationship(deleteRule: .cascade) var message: MessageEntity?
    var createdAt: Date
    var room: LocalRoomModel

    init(message: MessageEntity? = nil, createdAt: Date, room: LocalRoomModel) {
        self.message = message
        self.createdAt = createdAt
        self.room = room
    }
}
