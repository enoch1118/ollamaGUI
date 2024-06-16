//
//  ResChatModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Foundation

class ResChatModel: Decodable {
    var id: UUID

    var message: MessageModel?
    let stream: Bool?
    let done: Bool?
    var createdAt: Date?
    let images: [String]?
    let model: String?

    let totalDuration: Int?
    let loadDuration: Int?
    let promptEvalCount: Int?
    let promptEvalDuration: Int?
    let evalCount: Int?
    let evalDuration: Int?

    enum CodingKeys: CodingKey {
        case id
        case message
        case stream
        case done
        case createdAt
        case images
        case model
        case totalDuration
        case loadDuration
        case promptEvalCount
        case promptEvalDuration
        case evalCount
        case evalDuration
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        message = try container.decodeIfPresent(
            MessageModel.self,
            forKey: .message
        )
        stream = try container.decodeIfPresent(Bool.self, forKey: .stream)
        done = try container.decodeIfPresent(Bool.self, forKey: .done)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        images = try container.decodeIfPresent([String].self, forKey: .images)
        model = try container.decodeIfPresent(String.self, forKey: .model)
        totalDuration = try container.decodeIfPresent(
            Int.self,
            forKey: .totalDuration
        )
        loadDuration = try container.decodeIfPresent(
            Int.self,
            forKey: .loadDuration
        )
        promptEvalCount = try container.decodeIfPresent(
            Int.self,
            forKey: .promptEvalCount
        )
        promptEvalDuration = try container.decodeIfPresent(
            Int.self,
            forKey: .promptEvalDuration
        )
        evalCount = try container.decodeIfPresent(Int.self, forKey: .evalCount)
        evalDuration = try container.decodeIfPresent(
            Int.self,
            forKey: .evalDuration
        )
    }

    init(text: String, role: RoleEnum) {
        message = .init(text: text, role: role)
        createdAt = .now
        id = UUID()
        done = nil
        images = nil
        totalDuration = nil
        loadDuration = nil
        promptEvalCount = nil
        promptEvalDuration = nil
        evalCount = nil
        evalDuration = nil
        model = nil
        stream = nil
    }

    func appendMessage(text: String?) {
        message!.content = message!.content + (text ?? "")
    }
}
