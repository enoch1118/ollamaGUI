//
//  LocalMessageModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Foundation
import SwiftData

@Model
class LocalMessageModel: Encodable {
    var id: UUID
    var role: RoleEnum
    var content: String
    var images: [String]?

    enum CodingKeys: CodingKey {
        case role
        case content
        case images
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(role, forKey: .role)
        try container.encode(content, forKey: .content)
        try container.encodeIfPresent(images, forKey: .images)
    }

    init(id: UUID, role: RoleEnum, content: String, images: [String]? = nil) {
        self.id = id
        self.role = role
        self.content = content
        self.images = images
    }

    static func initSystem(content: String) -> LocalMessageModel {
        LocalMessageModel(id: UUID(), role: .system, content: content)
    }

    init(content: String) {
        id = UUID()
        role = .user
        self.content = content
    }
}
