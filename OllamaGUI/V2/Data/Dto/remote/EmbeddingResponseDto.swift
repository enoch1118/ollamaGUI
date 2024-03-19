//
//  EmbeddingResponseDto.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/8/24.
//

import Foundation

class EmbeddingResponseDto: Decodable {
    var embedding: [Float]

    enum CodingKeys: CodingKey {
        case embedding
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        embedding = try container.decode([Float].self, forKey: .embedding)
    }
}
