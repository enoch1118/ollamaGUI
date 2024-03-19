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

    init(message: MessageEntity? = nil, createdAt: Date) {
        self.message = message
        self.createdAt = createdAt
    }
}
