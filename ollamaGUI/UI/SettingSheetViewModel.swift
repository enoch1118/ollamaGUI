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
    
    
    @Published var helpText:String

    init() {
        options = nil
        system = ""
        helpText = ""
        topk = 40
        topp = 0.9
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
        if !system.isEmpty {
            options.system = system
        }
        helpText = "success"
        print("success")
    }
}
