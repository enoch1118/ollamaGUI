//
//  ModelList.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/19/24.
//

import Foundation

struct ModelList: Decodable{
    var models: [ModelInfoModel]
    
    enum CodingKeys: CodingKey {
        case models
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.models = try container.decode([ModelInfoModel].self, forKey: .models)
    }
}
