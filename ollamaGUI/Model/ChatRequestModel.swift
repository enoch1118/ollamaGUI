//
//  ChatRequestModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/12/24.
//

import Foundation

struct ChatRequestModel: Encodable, DictionaryEncodable {
    var model: String
    var messages: [MessageModel]
    var stream: Bool

    init(model: String, messages: [MessageModel], stream: Bool) {
        self.model = model
        self.messages = messages
        self.stream = stream
    }

    enum CodingKeys: CodingKey {
        case model
        case messages
        case stream
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(model, forKey: .model)
        try container.encode(stream, forKey: .stream)
        try container.encode(messages, forKey: .messages)
    }

    func getDictionary() -> [String: Any]? {
        let dict = getLeafDictionary()
        guard var d = dict else {
            return nil
        }
        var list: [[String: Any]] = []
        for m in messages {
            let val = m.getLeafDictionary()
            if val == nil {
                continue
            }
            list.append(val!)
        }
        d["messages"] = list
        return d
    }

    init(of: MessageModel, stream: Bool = false) {
        model = "llama2"
        self.stream = stream
        messages = [of]
    }
}
