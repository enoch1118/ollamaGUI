//
//  PullRequestModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/22/24.
//

import Foundation

struct PullRequestModel: Encodable {
    var name: String
    var stream: Bool

    enum CodingKeys: CodingKey {
        case name
    }

    init(name: String) {
        self.name = name
        stream = true
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
    }
}
