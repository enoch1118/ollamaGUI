//
//  UpdateTrigger.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/18/24.
//

import Foundation
import Combine


struct UpdateTrigger {
    var subject = CurrentValueSubject<TriggerModel, Never>(.init())

    var publisher: AnyPublisher<TriggerModel, Never> {
        subject.eraseToAnyPublisher()
    }

    func triggerNewMessage() {
        var current = subject.value
        current.newMessage = true
        subject.send(current)
    }
    
    func newMessageHandled() {
        var current = subject.value
        current.newMessage = false
        subject.send(current)
    }
    
    func triggerNewModel(){
        var current = subject.value
        current.newModel = true
        subject.send(current)
    }
    
    func newModelHandled(){
        var current = subject.value
        current.newModel = false
        subject.send(current)
    }
    
    var hasNewMessage:Bool {
        subject.value.newMessage
    }
    var hasNewModel:Bool {
        subject.value.newModel
    }
    
}



struct TriggerModel{
    var newMessage = false
    var newModel = false
}


extension TriggerModel{
    static fileprivate var `default`:Self{
        Self.init()
    }
}
