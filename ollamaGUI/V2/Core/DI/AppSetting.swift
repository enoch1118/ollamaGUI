//
//  AppSetting.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import Combine
import Foundation

class AppSetting {
    private var subject = CurrentValueSubject<AppSettingEntity?, Never>(nil)
    var ollamaDs: OllamaDatasource

    init(ollamaDs: OllamaDatasource) {
        self.ollamaDs = ollamaDs
    }

    private var entity: AppSettingEntity {
        subject.value!
    }

    func updateBaseUrl(_ url: String) {
        let entity = entity
        entity.baseUrl = url
        ollamaDs.baseUrl = url
        subject.send(entity)
    }

    func updateModel(_ model: String) {
        let entity = entity
        entity.selectedModel = model
        subject.send(entity)
    }

    func updateSetting(_ entity: AppSettingEntity) {
        print("setting setted")
        print(ollamaDs.baseUrl)
        ollamaDs.baseUrl = entity.baseUrl
        subject.send(entity)
    }

    var baseUrl: String {
        entity.baseUrl
    }

    var model: String {
        entity.selectedModel
    }
}
