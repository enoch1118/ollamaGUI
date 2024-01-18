//
//  AppSetting.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import Foundation
import Combine

struct AppSetting {
    var entity:AppSettingEntity?
    
    
    func updateBaseUrl(_ url:String)->Void {
        entity?.baseUrl = url
    }
    
    func updateModel(_ model:String)->Void {
        entity?.selectedModel = model
    }
    
    var baseUrl:String{
        entity!.baseUrl
    }
    
    var model:String{
        entity!.selectedModel
    }
}


