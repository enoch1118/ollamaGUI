//
//  ChatEntity.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import Foundation
import SwiftData

// var id: UUID
// var role: RoleEnum
// var content: String
// var images: [String]?
@Model
class MessageEntity {
    var role: RoleEnum
    var content: String
    var images: [Data]?

    init(role: RoleEnum, content: String, images: [Data]? = nil) {
        self.role = role
        self.content = content
        self.images = images
    }
}

#if DEBUG
    extension MessageEntity {
        static var randomMessage: MessageEntity {
            var rols: [RoleEnum] = [.user, .assistant]
            return MessageEntity(
                role: rols.randomElement()!,
                content: RandomGenerator.randomNames.randomElement()!
            )
        }
    }
#endif
