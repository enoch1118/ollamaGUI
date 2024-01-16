//
//  AppSetting.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import Foundation
import Combine

struct AppSetting {
    var subject = CurrentValueSubject<AppSettingModel, Never>(.init())

    var publisher: AnyPublisher<AppSettingModel, Never> {
        subject.eraseToAnyPublisher()
    }

    func togglePin() {
        var current = subject.value
        current.pin.toggle()
        subject.send(current)
    }
    
    func getPin()->Bool {
        subject.value.pin
    }

}


struct AppSettingModel{
    var pin = false
}


extension AppSettingModel {
    static fileprivate var `default`:Self{
        Self.init()
    }
}
