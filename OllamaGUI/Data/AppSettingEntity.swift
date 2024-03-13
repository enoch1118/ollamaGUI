//
//  AppSettingEntity.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/18/24.
//

import Foundation
import SwiftData

@Model
class AppSettingEntity {
    var baseUrl:String
    var selectedModel:String
    
    init(baseUrl: String, selectedModel: String) {
        self.baseUrl = baseUrl
        self.selectedModel = selectedModel
    }
}


extension AppSettingEntity {
    static var `default`:AppSettingEntity {
        AppSettingEntity(baseUrl: "http://localhost:11434", selectedModel: "llama2")
    }
}
