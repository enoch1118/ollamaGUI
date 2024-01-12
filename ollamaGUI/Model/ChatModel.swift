//
//  ChatModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/10/24.
//

import Foundation

struct ChatModel: Decodable, Encodable, Hashable{
    let id:UUID
    
    let role: RoleEnum
    let content: String
    let stream: Bool?
    let done: Bool?
    
    let images: [String]?
    let createdAt: Date?
    let totalDuration: Int?
    let loadDuration: Int?
    let promptEvalCount: Int?
    let promptEvalDuration: Int?
    let evalCount: Int?
    let evalDuration: Int?
    let model: String?

    enum CodingKeys: String, CodingKey {
        case role
        case content
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
        role = try container.decode(RoleEnum.self, forKey: .role)
        content = try container.decode(String.self, forKey: .content)
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
        try container.encode(role, forKey: .role)
        try container.encode(content, forKey: .content)
        try container.encode(images, forKey: .images)
        try container.encode(stream, forKey: .stream)
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


///  helper
extension ChatModel{
    var isMe:Bool {
        role == .user
    }
    
}

#if DEBUG
extension ChatModel {
    init(type:RoleEnum){
        role = type
        content = "this is test value and text from \(type)"
        stream = false
        done = nil
        images = nil
        createdAt = nil
        totalDuration = nil
        loadDuration = nil
        promptEvalCount = nil
        promptEvalDuration = nil
        evalCount = nil
        evalDuration = nil
        model = nil
        id = UUID()
    }
    
    
    
    static var testValue:[ChatModel] {
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
