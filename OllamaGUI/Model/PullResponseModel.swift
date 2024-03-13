//
//  PullResponseModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/22/24.
//

import Foundation

struct PullResponseModel: Decodable {
    var status:String
    var digest:String?
    var total:Double?
    var completed:Double?
    
    init(status: String, digest: String? = nil, total: Double? = nil, completed: Double? = nil) {
        self.status = status
        self.digest = digest
        self.total = total
        self.completed = completed
    }
    
    enum CodingKeys: CodingKey {
        case status
        case digest
        case total
        case completed
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.digest = try container.decodeIfPresent(String.self, forKey: .digest)
        self.total = try container.decodeIfPresent(Double.self, forKey: .total)
        self.completed = try container.decodeIfPresent(Double.self, forKey: .completed)
    }
}


extension PullResponseModel {
    var progress:Float? {
        if total == nil || completed == nil {
            return nil
        }
        return Float(completed!) / Float(total!)
    }
}
