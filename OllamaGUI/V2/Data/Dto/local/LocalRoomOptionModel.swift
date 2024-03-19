//
//  LocalRoomOptionModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Foundation
import SwiftData

@Model
class LocalRoomOptionModel {
    var room: LocalRoomModel
    var model: String?
    var system: String?
    var top_p: Float
    var top_k: Int
    var temperature: Float?
    init(
        model: String? = nil,
        system: String? = nil,
        top_p: Float = 0.9,
        top_k: Int = 40,
        temperature: Float? = 0.8,
        room: LocalRoomModel
    ) {
        self.model = model
        self.system = system
        self.top_p = top_p
        self.top_k = top_k
        self.temperature = temperature
        self.room = room
    }
}
