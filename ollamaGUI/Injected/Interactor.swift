//
//  Interactor.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/12/24.
//

import Combine
import Foundation

protocol OllamaInteractor {
    func sendChat(
        chat: ChatRequestModel,
        cancel: inout Set<AnyCancellable>,
        setting: AppSetting
    )
        -> PassthroughSubject<Loadable<ChatModel, NetworkError>, Never>

    func sendChatStream(
        chat: ChatRequestModel,
        cancel: inout Set<AnyCancellable>,
        setting: AppSetting
    )
        -> PassthroughSubject<Loadable<ChatModel, NetworkError>, Never>

    func checkNetwork(
        cancel: inout Set<AnyCancellable>,
        setting: AppSetting,
        baseUrl: String?,
        isTest: Bool
    )
        -> CurrentValueSubject<Bool, Never>

    func getModels(
        cancel: inout Set<AnyCancellable>,
        setting: AppSetting
    ) -> PassthroughSubject<Loadable<ModelList, NetworkError>, Never>

    func fetchModels(cancel _: inout Set<AnyCancellable>)
        -> PassthroughSubject<Loadable<String, NetworkError>, Never>

    func fetchTags(cancel _: inout Set<AnyCancellable>, model: OllamaModel)
        -> PassthroughSubject<Loadable<String, NetworkError>, Never>
}

struct RealOllamaInteractor: OllamaInteractor {
    func fetchTags(cancel: inout Set<AnyCancellable>,
                   model: OllamaModel)
        -> PassthroughSubject<Loadable<String, NetworkError>, Never>
    {
        var helper = RealNetworkHelper<ChatRequestModel, String>(
            baseUrl: "https://ollama.ai",
            url: "/library/\(model.title)/tags",
            method: .get
        )

        helper.cancel(bag: &cancel)
        helper.getModels()
        return helper.subject
    }

    func getModels(cancel: inout Set<AnyCancellable>,
                   setting: AppSetting)
        -> PassthroughSubject<Loadable<ModelList, NetworkError>, Never>
    {
        var helper =
            RealNetworkHelper<ChatRequestModel, ModelList>(baseUrl: setting
                .baseUrl,
                url: "/api/tags",
                method: .get,
                parameter: nil)
        helper.cancel(bag: &cancel)
        helper.request()
        return helper.subject
    }

    func fetchModels(cancel: inout Set<AnyCancellable>)
        -> PassthroughSubject<Loadable<String, NetworkError>, Never>
    {
        var helper = RealNetworkHelper<ChatRequestModel, String>(
            baseUrl: "https://ollama.ai",
            url: "/library",
            method: .get
        )

        helper.cancel(bag: &cancel)
        helper.getModels()
        return helper.subject
    }

    func sendChat(chat: ChatRequestModel,
                  cancel: inout Set<AnyCancellable>,
                  setting: AppSetting)
        -> PassthroughSubject<Loadable<ChatModel, NetworkError>, Never>
    {
        var chatModel = chat
        chatModel.model = setting.model
        var helper =
            RealNetworkHelper<ChatRequestModel, ChatModel>(baseUrl: setting
                .baseUrl,
                url: "/api/chat",
                method: .post,
                parameter: chatModel)
        helper.cancel(bag: &cancel)
        helper.request()
        return helper.subject
    }

    func checkNetwork(cancel: inout Set<AnyCancellable>,
                      setting: AppSetting,
                      baseUrl: String?,
                      isTest: Bool = false) -> CurrentValueSubject<Bool, Never>
    {
        var helper = RealNetworkHelper<ChatRequestModel,
            ChatModel>(
            baseUrl: baseUrl ?? setting.baseUrl,
            url: "",
            method: .get,
            isTest: isTest
        )
        helper.checkNetwork()
        helper.cancelCheckNetwork(bag: &cancel)
        return isTest ? helper.testNetworkSubject : helper.netWorkSubject
    }

    func sendChatStream(chat: ChatRequestModel,
                        cancel: inout Set<AnyCancellable>,
                        setting: AppSetting)
        -> PassthroughSubject<Loadable<ChatModel, NetworkError>, Never>
    {
        var chatModel = chat
        chatModel.model = setting.model
        var helper =
            RealNetworkHelper<ChatRequestModel, ChatModel>(baseUrl: setting
                .baseUrl,
                url: "/api/chat",
                method: .post,
                parameter: chatModel)
        helper.cancel(bag: &cancel)
        helper.requestStream()
        return helper.subject
    }
}
