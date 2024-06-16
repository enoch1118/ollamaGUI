//
//  OllamaDatasource.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/8/24.
//

import Combine
import Foundation

protocol OllamaDatasource {
    var baseUrl: String { get set }
    var session: URLSession { get }
    func getEmbedding(prompt: String, model: String)
        -> AnyPublisher<[Float], NetworkError>
    
    func chat(req: ChatRequestModel) -> AnyPublisher<ChatModel,NetworkError>
    func chatV2(req: ReqChatModel) -> AnyPublisher<ResChatModel,NetworkError>
    func check() -> Future<Bool,Never>
}

class OlamaDatasourceStub: OllamaDatasource {
    var baseUrl: String
    let session: URLSession

    init(baseUrl: String, session: URLSession) {
        self.baseUrl = baseUrl
        self.session = session
    }

    func getEmbedding(prompt _: String,
                      model _: String) -> AnyPublisher<[Float], NetworkError>
    {
        return Just([]).setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    
    func chat(req: ChatRequestModel) -> AnyPublisher<ChatModel,NetworkError> {
        return Just(.init(entity: ChatEntity(message: .randomMessage, createdAt: .now))).setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
    
    func chatV2(req: ReqChatModel) -> AnyPublisher<ResChatModel,NetworkError> {
        fatalError()
    }
    
    func check() -> Future<Bool, Never> {
        return Future{
            $0(.success(true))
        }
    }
}

class OllamaDatasourceImpl: OllamaDatasource {
    var baseUrl: String
    let session: URLSession
    
    init(baseUrl: String, session: URLSession) {
        self.baseUrl = baseUrl
        self.session = session
    }
    
    
    func getEmbedding(prompt: String,
                      model: String) -> AnyPublisher<[Float], NetworkError>
    {
        let api = APICall<EmbeddingDto, EmbeddingResponseDto>(
            session: session,
            baseUrl: baseUrl,
            url: "/api/embeddings",
            method: .post
        )
        
        let dto = EmbeddingDto(model: model, prompt: prompt)
        
        return api.call(data: dto).map { resDto in
            resDto.embedding
        }.eraseToAnyPublisher()
    }
    
    func chatV2(req: ReqChatModel) -> AnyPublisher<ResChatModel, NetworkError> {
        var api = APICall<ReqChatModel,ResChatModel>(
            session: session, baseUrl: baseUrl, url: "/api/chat", method: .post)
        
        return api.callStream(data: req).eraseToAnyPublisher()
    }
    
    
    func chat(req: ChatRequestModel) -> AnyPublisher<ChatModel, NetworkError> {
        var api = APICall<ChatRequestModel,ChatModel>(
            session: session, baseUrl: baseUrl, url: "/api/chat", method: .post)
        
        return api.callStream(data: req).eraseToAnyPublisher()
    }
    
    func check() -> Future<Bool,Never > {
        let api = APICall<Bool,ChatModel>(session: session, baseUrl: baseUrl, url: "", method: .get)
        var cancel = Set<AnyCancellable>()
        return Future { promise in
            api.call().sink(receiveCompletion: { comp in
                switch comp {
                    case .finished:
                        promise(.success(true))
                        cancel.removeAll()
                        
                    case .failure:
                        promise(.success(false))
                        cancel.removeAll()
                }
               
            }, receiveValue: { _ in
            }).store(in: &cancel)
        }
    }
    
}
