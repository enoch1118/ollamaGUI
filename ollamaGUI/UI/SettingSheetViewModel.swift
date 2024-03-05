//
//  SettingSheetViewModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/5/24.
//

import Foundation

class SettingSheetViewModel: ObservableObject {
    @Published var options: RoomOptionEntity?
    @Published var system: String
    @Published var topk: Float
    @Published var topp: Float
    @Published var temperature: Float
    
    

    init() {
        options = nil
        system = ""
        topk = 40
        topp = 0.9
        temperature = 0.8
    }
    
    
    func reset() {
        options = nil
        system = ""
        topk = 40
        topp = 0.9
        temperature = 0.8
    }
    

    func apply() {
        if options == nil {
            options = RoomOptionEntity(model: nil, system: nil)
        }
        guard let options = options else {
            fatalError()
        }
        options.top_k = Int(topk)
        options.top_p = topp
        options.temperature = temperature
        if !system.isEmpty {
            options.system = system
        }
        print("success")
    }
}
