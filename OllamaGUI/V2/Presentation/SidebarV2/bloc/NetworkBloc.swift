//
//  NetworkBloc.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Foundation

class NetworkBloc: BaseBloc<NetworkEvent, NetworkState> {
    var usecase: ChatUsecase

    init(container: DIContainer) {
        usecase = container.chatusecase
        super.init()
        _ignite()
    }

    override func _registerEvent(event: NetworkEvent) {
        super._registerEvent(event: event)
        switch event {
        case .checkNetwork:
            Task {
                let res = await usecase.check().value
                if res {
                    print("this")
                    emit(state: .connected)
                } else {
                    print("no")
                    emit(state: .disconnected)
                }
            }
        }
    }
}
