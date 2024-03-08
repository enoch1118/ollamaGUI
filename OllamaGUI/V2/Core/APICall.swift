//
//  APICall.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/8/24.
//

import Combine
import Foundation

enum APIMethod {
    case get
    case post
}

private extension APIMethod {
    var method: String {
        switch self {
        case .get:
            "GET"
        case .post:
            "POST"
        }
    }
}

struct APICall<U, T> where T: Decodable {
    var session: URLSession
    var baseUrl: String
    var url: String
    var method: APIMethod

    private var getUrl: URL {
        URL(string: baseUrl + url)!
    }

    func call() -> AnyPublisher<T, NetworkError> {
        var request = URLRequest(url: getUrl)
        request.httpMethod = method.method
        return session.dataTaskPublisher(for: request)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      (200 ..< 400).contains(httpResponse.statusCode)
                else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in NetworkError.badRequest(error: error) }
            .eraseToAnyPublisher()
    }
}

extension APICall where U: Encodable {
    func call(data: U) -> AnyPublisher<T, NetworkError> {
        var request = URLRequest(url: getUrl)
        request.httpMethod = method.method
        request.httpBody = try? JSONEncoder().encode(data)
        return session.dataTaskPublisher(for: request)
            .tryMap { element -> Data in
                guard let httpResponse = element
                    .response as? HTTPURLResponse,
                    (200 ..< 400).contains(httpResponse.statusCode)
                else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in NetworkError.badRequest(error: error) }
            .eraseToAnyPublisher()
    }
}
