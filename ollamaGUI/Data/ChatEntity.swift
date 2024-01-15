//
//  ChatEntity.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import Foundation
import SwiftData


//
//var message: MessageModel?
//let stream: Bool?
//let done: Bool?
//let createdAt: Date?
//let images: [String]?
//let model: String?
//
@Model
class ChatEntity{
    @Relationship(deleteRule:.cascade) var message:MessageEntity?
    var createdAt: Date
    
    
    init(message: MessageEntity? = nil, createdAt: Date) {
        self.message = message
        self.createdAt = createdAt
    }
}
