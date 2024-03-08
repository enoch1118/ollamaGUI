//
//  EmbeddingDto.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/8/24.
//

import Foundation

class EmbeddingDto: Encodable {
    var model: String
    var prompt: String

    init(model: String, prompt: String) {
        self.model = model
        self.prompt = prompt
    }

    enum CodingKeys: CodingKey {
        case model
        case prompt
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(model, forKey: .model)
        try container.encode(prompt, forKey: .prompt)
    }
}
