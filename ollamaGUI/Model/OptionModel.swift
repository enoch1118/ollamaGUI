//
//  OptionModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/5/24.
//

import Foundation

struct OptionModel:Encodable,DictionaryEncodable {
    var top_p: Float
    var top_k: Int
    
    init(top_p: Float, top_k: Int) {
        self.top_p = top_p
        self.top_k = top_k
    }
    
    enum CodingKeys: CodingKey {
        case top_p
        case top_k
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.top_p, forKey: .top_p)
        try container.encode(self.top_k, forKey: .top_k)
    }
    
    
    func getDictionary() -> [String : Any]? {
        let dict = getLeafDictionary()
        guard var d = dict else {
            return nil
        }
        return d
    }
}
