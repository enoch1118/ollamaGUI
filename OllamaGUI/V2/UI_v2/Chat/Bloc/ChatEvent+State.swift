//
//  ChatEvent+State.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Foundation

enum ChatEvent {
    case SEND_CHAT(prompt: String,chats:[ChatModel])
}

enum ChatState: BaseState {
    case initState
    case idle
    case answer(answer: Loadable<ChatModel, NetworkError>)
}
