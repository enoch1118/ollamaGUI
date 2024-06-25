//
//  OllmaRepositoryImpl.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/8/24.
//

import Combine
import Foundation

class OllamaRepositoryImpl: OllamaRepository {
    var dataSource: OllamaDatasource

    init(dataSource: OllamaDatasource) {
        self.dataSource = dataSource
    }

    func getEmbeding(prompt: String,
                     model: String) -> AnyPublisher<[Float], NetworkError>
    {
        dataSource.getEmbedding(prompt: prompt, model: model)
    }

    func chat(req: ChatRequestModel) -> AnyPublisher<ChatModel, NetworkError> {
        dataSource.chat(req: req)
    }

    func chatV2(req: ReqChatModel) -> AnyPublisher<ResChatModel, NetworkError> {
        dataSource.chatV2(req: req)
    }

    func check() -> Future<Bool, Never> {
        dataSource.check()
    }
}
