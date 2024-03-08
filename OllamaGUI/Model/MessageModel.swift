//
//  MessageModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/12/24.
//

import Foundation

struct MessageModel: Codable, Hashable {
    var id: UUID
    var role: RoleEnum
    var content: String
    var images: [String]?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        role = try container.decode(RoleEnum.self, forKey: .role)
        content = try container.decode(String.self, forKey: .content)
        images = try container.decodeIfPresent([String].self, forKey: .images)
    }

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

    init(text: String, role: RoleEnum = .user, images: [String]? = nil) {
        id = UUID()
        content = text
        self.role = role
        self.images = images
    }
}
