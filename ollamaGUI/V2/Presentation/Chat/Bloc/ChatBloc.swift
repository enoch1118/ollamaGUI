//
//  ChatBloc.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Foundation

class ChatBloc: BaseBloc<ChatEvent, ChatState> {
    var chatUsecase: ChatUsecase
    var appSetting: AppSetting
    var roomOption: RoomOptionEntity?
    var room: RoomEntity

    init(
        chatUsecase: ChatUsecase,
        appSetting: AppSetting,
        roomOption: RoomOptionEntity? = nil,
        room: RoomEntity
    ) {
        self.chatUsecase = chatUsecase
        self.appSetting = appSetting
        self.roomOption = roomOption
        self.room = room
        super.init()
        _ignite()
    }

    var model: String {
        roomOption?.model ?? appSetting.model
    }

    override func _registerEvent(event: ChatEvent) {
        super._registerEvent(event: event)
        switch event {
        case let .SEND_CHAT(prompt, chats):
            sendChat(prompt, chats)
            return
        }
    }
}

/// handle function
extension ChatBloc {
    private func sendChat(_: String, _ chats: [ChatModel]) {
        print("hey")
        emit(state: .answer(answer: .isLoading(last: .init(text: "",
                                                           role: .assistant))))
        let messages = chats.compactMap { $0.message }
        chatUsecase.chatV2(
            req: .init(ofList: messages, stream: true),
            appSetting: appSetting,
            option: roomOption
        ).sink(receiveCompletion: { [weak self] comp in
                   switch comp {
                   case .finished:
                       print("finished")
                   case let .failure(error):
                       print("error")
                       self?.emit(
                           state: .answer(
                               answer: .loaded(
                                   .init(text: "some error occured: \(error)",
                                         role: .assistant)
                               )
                           )
                       )
                   }
                   self?.cancelEventBag()
               },
               receiveValue: { [weak self] value in
                   let state = self?.stateSubject.value
                   print("value received")
                   guard case let .answer(answer) = state else {
                       print("cancel?")
                       self?.cancelEventBag()
                       return
                   }
                   guard case var .isLoading(last: model) = answer else {
                       print("not loading cancel?")
                       self?.cancelEventBag()
                       return
                   }
                   model?.appendMessage(text: value.message?.content)
                   self?.emit(state: .answer(answer: .isLoading(last: model)))
               }).store(in: &eventBag)
    }
}
