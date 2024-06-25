//
//  BaseBloc.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/12/24.
//

import Combine
import Foundation

/// <E> is Event <S> is State
class BaseBloc<E, S> where S: BaseState {
    var eventListener: PassthroughSubject<E, Never>
    var stateSubject: CurrentValueSubject<S, Never>
    /// cancel of event
    var cancel: Set<AnyCancellable>

    /// cancel of event handle
    var eventBag: Set<AnyCancellable>

    init() {
        stateSubject = .init(.initState)
        eventListener = .init()
        cancel = Set<AnyCancellable>()
        eventBag = Set<AnyCancellable>()
    }

    func _ignite() {
        eventListener.sink(receiveValue: _registerEvent)
            .store(in: &cancel)
    }

    func _registerEvent(event: E) {
        if showLog {
            print(String(describing: event))
        }
    }

    func cancelEventBag() {
        eventBag.removeAll()
    }

    func addEvent(event: E) {
        eventListener.send(event)
    }

    func emit(state: S) {
        stateSubject.send(state)
    }

    var showLog: Bool {
        true
    }
}

protocol BaseState {
    static var initState: Self { get }
}
