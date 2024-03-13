//
//  ChatViewModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/13/24.
//

import Foundation
import SwiftUI
import Combine

class ChatViewModel: ObservableObject {
    @Published var state: LangchainState = .initState
    @Published var bloc: LangchainBloc!

    func ignite(container: DIContainer, room: RoomEntity) {
        self.bloc = LangchainBloc(
            langchainUsecase: container.langchainusecase,
            chatUsecase: container.chatusecase,
            appSetting: container.appSetting,
            roomOption: room.option
        )
        print("bloc has been created")
        bloc.stateSubject.assign(to: &$state)
    }
}
