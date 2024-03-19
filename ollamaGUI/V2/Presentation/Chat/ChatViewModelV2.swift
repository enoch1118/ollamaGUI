//
//  ChatViewModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/18/24.
//

import Combine
import SwiftData
import SwiftUI

class ChatViewModelV2: ObservableObject {
    @Published var state: LangchainState = .initState
    @Published var chatState: ChatState = .idle
    @Published var bloc: LangchainBloc!
    @Published var chatBloc: ChatBloc!
    @Published var room: RoomEntity!
    @Published var chat: ChatModel?

    /// view state
    @Published var showSetting: Bool = false
    @Published var showLangchain: Bool = false
    @Published var isLoading: Bool = false

    var linkBag = Set<AnyCancellable>()

    var container: DIContainer!
    var context: ModelContext!

    func ignite(
        container: DIContainer,
        context: ModelContext,
        room: RoomEntity
    ) {
        self.container = container
        self.context = context
        bloc = LangchainBloc(
            langchainUsecase: container.langchainusecase,
            chatUsecase: container.chatusecase,
            appSetting: container.appSetting,
            roomOption: room.option
        )
        chatBloc = ChatBloc(
            chatUsecase: container.chatusecase,
            appSetting: container.appSetting,
            roomOption: room.option,
            room: room
        )
        print("bloc has been created")
        bloc.stateSubject.assign(to: &$state)
        chatBloc.stateSubject.assign(to: &$chatState)
        self.room = room
        linkBlocAndChats()
    }
}

extension ChatViewModelV2 {
    private func linkBlocAndChats() {
        $chatState.sink(
            receiveCompletion: { _ in },
            receiveValue: { [weak self] val in
                guard case let .answer(answer) = val else {
                    return
                }
                switch answer {
                case let .isLoading(last):
                    self?.chat = last
                case let .loaded(value):
                    self?.chat = nil
                    return
                default:
                    return
                }
            }
        ).store(in: &linkBag)
    }
}

extension ChatViewModelV2 {
    func onClean() {
        room.chats.removeAll()
        container.dataInteractor.clearRoom(context: context, room: room)
    }

    func onCancel() {}

    func onSend(text: String) {
//        chats.append(.init(text: text, role: .user))
//        room.chats = chats.map { $0.toEntity }
//        chatBloc.addEvent(event: .SEND_CHAT(prompt: text, chats: chats))
    }
}
