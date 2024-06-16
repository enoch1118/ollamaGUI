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
    var format: String?
    var options: ReqOptionModel?

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
        format: String?,
        options: ReqOptionModel? = nil
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
        try container.encodeIfPresent(format, forKey: .format)
        try container.encodeIfPresent(options, forKey: .options)
    }
    
    
    init(ofList: [LocalMessageModel], stream: Bool = false){
        self.model = ""
        self.stream = stream
        self.messages = ofList
        self.options = nil
    }
    
    mutating func applySystem(option: LocalRoomOptionModel?){
        if option?.system == nil {return}
        if option!.system!.isEmpty {return}
        var messages = self.messages
        messages.removeAll(where: {$0.role == .system})
        var lastMessage = messages.popLast()
        messages.append(.initSystem(content: option!.system!))
        messages.append(lastMessage!)
        self.messages = messages
    }
    
    mutating func applyOption(option: LocalRoomOptionModel?, appSetting: AppSetting) {
        let option = option ?? LocalRoomOptionModel.init()
        self.options = .init(topP: option.top_p, topK: option.top_k, temperature: option.temperature)
        self.model = option.model ?? appSetting.model
    }
}
