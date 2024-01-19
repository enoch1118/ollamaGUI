//
//  AppSetting.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import Foundation
import Combine

class AppSetting {
    private var subject = CurrentValueSubject<AppSettingEntity?,Never>(nil)
    
    private var entity:AppSettingEntity {
        subject.value!
    }
    
    func updateBaseUrl(_ url:String)->Void {
        let entity = entity
        entity.baseUrl = url
        subject.send(entity)
    }
    
    func updateModel(_ model:String)->Void {
        let entity = entity
        entity.selectedModel = model
        subject.send(entity)
    }
    
    func updateSetting(_ entity:AppSettingEntity) -> Void{
        print("setting setted")
        print(entity.baseUrl)
        subject.send(entity)
    }
    
    var baseUrl:String{
        entity.baseUrl
    }
    
    
    var model:String{
        entity.selectedModel
    }
}


