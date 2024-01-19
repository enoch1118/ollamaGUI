//
//  ModelInfoModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/19/24.
//

import Foundation

struct ModelInfoModel:Decodable,Hashable {
    var id:UUID
    var name:String
    var modifiedAt: Date
    var size:Int64
    
    enum CodingKeys: String,CodingKey {
        case name
        case modifiedAt = "modified_at"
        case size
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.modifiedAt = try container.decode(Date.self, forKey: .modifiedAt)
        self.size = try container.decode(Int64.self, forKey: .size)
    }
}
