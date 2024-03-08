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
        let req = APICall<EmbeddingDto, EmbeddingResponseDto>(
            session: session,
            baseUrl: baseUrl,
            url: "/api/embeddings",
            method: .post
        )

        let dto = EmbeddingDto(model: model, prompt: prompt)

        return req.call(data: dto).map { resDto in
            resDto.embedding
        }.eraseToAnyPublisher()
    }
}
