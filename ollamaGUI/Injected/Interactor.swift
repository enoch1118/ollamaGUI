//
//  Interactor.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/12/24.
//

import Combine
import Foundation

protocol OllamaInteractor {
    func sendChat(chat: ChatRequestModel, cancel: inout Set<AnyCancellable>)
        -> PassthroughSubject<Loadable<ChatModel, NetworkError>, Never>
    
    func sendChatStream(chat: ChatRequestModel, cancel: inout Set<AnyCancellable>)
        -> PassthroughSubject<Loadable<ChatModel, NetworkError>, Never>
    
    
    func checkNetwork(cancel: inout Set<AnyCancellable>)-> CurrentValueSubject<Bool, Never>

}

struct RealOllamaInteractor: OllamaInteractor {
    var baseUrl: String
    
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }

    func sendChat(chat: ChatRequestModel,
                  cancel: inout Set<AnyCancellable>)
        -> PassthroughSubject<Loadable<ChatModel, NetworkError>, Never>
    {
        var helper =
            RealNetworkHelper<ChatRequestModel, ChatModel>(baseUrl: baseUrl,
                                                    url: "chat",
                                                    method: .post,
                                                    parameter: chat)
        helper.cancel(bag: &cancel)
        helper.request()
        return helper.subject
    }
    
    func checkNetwork(cancel: inout Set<AnyCancellable>) -> CurrentValueSubject<Bool, Never> {
        var helper = RealNetworkHelper<ChatRequestModel,ChatModel>(baseUrl: baseUrl, url: "", method: .get)
        helper.checkNetwork()
        helper.cancelCheckNetwork(bag: &cancel)
        return helper.netWorkSubject
    }
    
    
    func sendChatStream(chat: ChatRequestModel,
                  cancel: inout Set<AnyCancellable>)
        -> PassthroughSubject<Loadable<ChatModel, NetworkError>, Never>
    {
        var helper =
            RealNetworkHelper<ChatRequestModel, ChatModel>(baseUrl: baseUrl,
                                                    url: "chat",
                                                    method: .post,
                                                    parameter: chat)
        helper.cancel(bag: &cancel)
        helper.requestStream()
        return helper.subject
    }
}
