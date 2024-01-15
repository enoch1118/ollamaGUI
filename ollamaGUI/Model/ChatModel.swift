//
//  ChatModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/10/24.
//

import Foundation

struct ChatModel: Codable, Hashable,Equatable {
    let id: UUID

    var message: MessageModel?
    let stream: Bool?
    let done: Bool?
    let createdAt: Date?
    let images: [String]?
    let model: String?
    
    let totalDuration: Int?
    let loadDuration: Int?
    let promptEvalCount: Int?
    let promptEvalDuration: Int?
    let evalCount: Int?
    let evalDuration: Int?

    enum CodingKeys: String, CodingKey {
        case message
        case images
        case stream
        case createdAt = "created_at"
        case done
        case totalDuration = "total_duration"
        case loadDuration = "load_duration"
        case promptEvalCount = "prompt_eval_count"
        case promptEvalDuration = "prompt_eval_duraion"
        case evalCount = "eval_count"
        case evalDuration = "eval_duration"
        case model
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        message = try container.decodeIfPresent(
            MessageModel.self,
            forKey: .message
        )
        images = try container.decodeIfPresent([String].self, forKey: .images)
        stream = try container.decodeIfPresent(Bool.self, forKey: .stream)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        done = try container.decodeIfPresent(Bool.self, forKey: .done)
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
        model = try container.decodeIfPresent(String.self, forKey: .model)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(message, forKey: .message)
        try container.encodeIfPresent(images, forKey: .images)
        try container.encodeIfPresent(stream, forKey: .stream)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(done, forKey: .done)
        try container.encodeIfPresent(totalDuration, forKey: .totalDuration)
        try container.encodeIfPresent(loadDuration, forKey: .loadDuration)
        try container.encodeIfPresent(promptEvalCount, forKey: .promptEvalCount)
        try container.encodeIfPresent(
            promptEvalDuration,
            forKey: .promptEvalDuration
        )
        try container.encodeIfPresent(evalCount, forKey: .evalCount)
        try container.encodeIfPresent(evalDuration, forKey: .evalDuration)
        try container.encodeIfPresent(model, forKey: .model)
    }
}



extension ChatModel {
    static func ==(lhs:Self,rhs:Self) ->Bool{
        return lhs.id == rhs.id
    }
}

///  helper
extension ChatModel {
    var isMe: Bool {
        message?.role == .user
    }

    init(text: String,role: RoleEnum) {
        message = MessageModel(text: text,role: role)
        id = UUID()
        done = nil
        images = nil
        createdAt = Date.now
        totalDuration = nil
        loadDuration = nil
        promptEvalCount = nil
        promptEvalDuration = nil
        evalCount = nil
        evalDuration = nil
        model = nil
        stream = nil
    }
    
    
    init(entity:ChatEntity) {
        let me = entity.message ?? MessageEntity(role: .user, content: "error")
        message = MessageModel(text: me.content,role: me.role,images: [])
        createdAt = entity.createdAt
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
}

#if DEBUG
    extension ChatModel {
        init(type: RoleEnum) {
            message = MessageModel(text: "this is test", role: type)
            stream = false
            done = nil
            images = nil
            createdAt = Date.now
            totalDuration = nil
            loadDuration = nil
            promptEvalCount = nil
            promptEvalDuration = nil
            evalCount = nil
            evalDuration = nil
            model = nil
            id = UUID()
        }

        static var testValue: [ChatModel] {
            [
                ChatModel(type: RoleEnum.assistant),
                ChatModel(type: RoleEnum.user),
                ChatModel(type: RoleEnum.assistant),
                ChatModel(type: RoleEnum.user),
                ChatModel(type: RoleEnum.user),
                ChatModel(type: RoleEnum.assistant),
            ]
        }
    }

#endif
