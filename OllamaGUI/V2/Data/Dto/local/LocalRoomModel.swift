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
    
    @Relationship(
        deleteRule: .cascade,
        inverse: \LocalChatModel.room
    ) var chats: [LocalChatModel]
    
    @Relationship(
        deleteRule: .cascade,
        inverse: \LocalRoomOptionModel.room
    ) var option: LocalRoomOptionModel?

    
    var title: String?
   
    init(
        updateAt: Date,
        chats: [LocalChatModel],
        title: String? = nil,
        option: LocalRoomOptionModel? = nil
    ) {
        self.updateAt = updateAt
        self.chats = chats
        self.title = title
        self.option = option
    }
}
