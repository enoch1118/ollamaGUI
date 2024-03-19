//
//  ModelInfoModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/19/24.
//

import Foundation

struct ModelInfoModel: Decodable, Hashable {
    var id: UUID
    var name: String
    var modifiedAt: Date
    var size: Int

    enum CodingKeys: String, CodingKey {
        case name
        case modifiedAt = "modified_at"
        case size
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        name = try container.decode(String.self, forKey: .name)
        modifiedAt = try container.decode(Date.self, forKey: .modifiedAt)
        size = try container.decode(Int.self, forKey: .size)
    }

    init(name: String, modifiedAt: Date, size: Int) {
        id = UUID()
        self.name = name
        self.modifiedAt = modifiedAt
        self.size = size
    }
}

#if DEBUG
    extension ModelInfoModel {
        static var preview: ModelInfoModel {
            Self(name: "testModel", modifiedAt: .now, size: 123_242_425)
        }
    }

#endif
