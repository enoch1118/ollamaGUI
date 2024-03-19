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
    var temperature: Float?
    
    init(top_p: Float, top_k: Int,temperature:Float?) {
        self.top_p = top_p
        self.top_k = top_k
        self.temperature = temperature
    }
    
    enum CodingKeys: CodingKey {
        case top_p
        case top_k
        case temperature
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.top_p, forKey: .top_p)
        try container.encode(self.top_k, forKey: .top_k)
        try container.encodeIfPresent(self.temperature, forKey: .temperature)
    }
    
    
    func getDictionary() -> [String : Any]? {
        let dict = getLeafDictionary()
        guard let d = dict else {
            return nil
        }
        return d
    }
}
