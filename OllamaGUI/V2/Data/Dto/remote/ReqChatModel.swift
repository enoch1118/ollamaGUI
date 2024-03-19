//
//  ReqChatModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Foundation

struct ReqChatModel: Encodable{
    var model: String
    var messages: [LocalMessageModel]
    var stream: Bool
    var format: String
    var options: OptionModel?

    enum CodingKeys: CodingKey {
        case model
        case messages
        case stream
        case format
        case options
    }

    init(
        model: String,
        messages: [LocalMessageModel],
        stream: Bool,
        format: String,
        options: OptionModel? = nil
    ) {
        self.model = model
        self.messages = messages
        self.stream = stream
        self.format = format
        self.options = options
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(model, forKey: .model)
        try container.encode(messages, forKey: .messages)
        try container.encode(stream, forKey: .stream)
        try container.encode(format, forKey: .format)
        try container.encodeIfPresent(options, forKey: .options)
    }
}
