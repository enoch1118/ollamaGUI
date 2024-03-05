//
//  RoomOption.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/5/24.
//

import Foundation
import SwiftData

@Model
class RoomOptionEntity {
    var model: String?
    var system: String?
    var top_p: Float
    var top_k: Int
    init(model: String?,
         system: String?,
         top_p: Float = 0.9,
         top_k: Int = 40) {
        self.model = model
        self.system = system
        self.top_p = top_p
        self.top_k = top_k
    }
}
