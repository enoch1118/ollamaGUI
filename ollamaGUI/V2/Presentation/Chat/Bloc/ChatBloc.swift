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
    var tts: TTSUtil
    var roomOption: LocalRoomOptionModel?
    var room: LocalRoomModel

    init(
        chatUsecase: ChatUsecase,
        appSetting: AppSetting,
        roomOption: LocalRoomOptionModel? = nil,
        room: LocalRoomModel
    ) {
        self.chatUsecase = chatUsecase
        self.appSetting = appSetting
        tts = .init()
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
        case let .SEND_CHATV2(prompt):
            sendChatV2(prompt)
            return
        }
    }
}

/// handle function
extension ChatBloc {
    private func sendChatV2(_ text: String) {
        emit(state: .answerV2(answer: .isLoading(last: .init(text: "",
                                                             role: .assistant))))
        room.chats.append(.init(message: .init(content: text), room: room))
        let messages = room.chats.sorted { $0.createdAt < $1.createdAt }
            .compactMap { $0.message }
        chatUsecase.chatV3(
            req: .init(ofList: messages, stream: true),
            appSetting: appSetting,
            option: roomOption
        ).sink(receiveCompletion: { [weak self] comp in
                   switch comp {
                   case .finished:
                       let state = self?.stateSubject.value
                       guard case let .answerV2(answer) = state else {
                           print("cancel?")
                           self?.cancelEventBag()
                           return
                       }
                       self?.emit(
                           state: .answerV2(
                               answer: .loaded(
                                   .init(
                                       text: answer.value?.message?
                                           .content ?? "",
                                       role: .assistant
                                   )
                               )
                           )
                       )
                       self?.room.appendResponse(chat: answer.value!)
//                       self?.tts.speak(answer.value?.message?.content ?? "")
                       print("finished")
                   case let .failure(error):
                       print("error \(error)")
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
                   guard case let .answerV2(answer) = state else {
                       print("cancel?")
                       self?.cancelEventBag()
                       return
                   }
                   guard case let .isLoading(model) = answer else {
                       print("not loading cancel?")
                       self?.cancelEventBag()
                       return
                   }
                   model?.appendMessage(text: value.message?.content)
                   self?.emit(state: .answerV2(answer: .isLoading(last: model)))
               }).store(in: &eventBag)
    }

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
