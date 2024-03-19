//
//  APICall.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/8/24.
//

import Alamofire
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
    var workItem: DispatchWorkItem!

    private var getUrl: URL {
        URL(string: baseUrl + url)!
    }

    init(session: URLSession, baseUrl: String, url: String, method: APIMethod) {
        self.session = session
        self.baseUrl = baseUrl
        self.url = url
        self.method = method
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

extension APICall where T == String {
    func callWithoutDecode() -> AnyPublisher<T, NetworkError> {
        var request = URLRequest(url: getUrl)
        request.httpMethod = method.method
        print(getUrl)
        return session.dataTaskPublisher(for: request)
            .tryMap { element -> String in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      (200 ..< 400).contains(httpResponse.statusCode)
                else {
                    throw URLError(.badServerResponse)
                }
                var encoding: String.Encoding!
                switch httpResponse.textEncodingName {
                case "euc-kr":
                    encoding = String
                        .Encoding(
                            rawValue: CFStringConvertEncodingToNSStringEncoding(
                                0x0422
                            )
                        )
                default:
                    encoding = .utf8
                }
                guard let ret = String(
                    data: element.data,
                    encoding: encoding
                )
                else {
                    throw URLError(.badServerResponse)
                }
                return ret
            }
            .mapError { error in NetworkError.badRequest(error: error) }
            .eraseToAnyPublisher()
    }
}

extension APICall where U: Encodable {
    func call(data: U) -> AnyPublisher<T, NetworkError> {
        var request = URLRequest(url: getUrl)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .customISO8601
        request.httpMethod = method.method
        request.httpBody = try? JSONEncoder().encode(data)
        return session.dataTaskPublisher(for: request)
            .tryMap { element -> Data in
                guard let httpResponse = element
                    .response as? HTTPURLResponse,
                    (0 ..< 400).contains(httpResponse.statusCode)
                else {
                    throw URLError(.badServerResponse)
                }
                print("get data")
                return element.data
            }
            .map { data in
                data
            }

            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                NetworkError.badRequest(error: error)
            }
            .eraseToAnyPublisher()
    }

    mutating func callStream(data: U) -> AnyPublisher<T, NetworkError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .customISO8601
        let subject = PassthroughSubject<T, NetworkError>()
        workItem = DispatchWorkItem { [self] in
            AF.streamRequest(
                getUrl,
                method: .post,
                parameters: data,
                encoder: JSONParameterEncoder.default,
                headers: HTTPHeaders.default
            ).validate(statusCode: 200 ..< 300)
                .responseStreamDecodable(of: T.self, using: decoder) { stream in
                    switch stream.event {
                    case let .stream(value):
                        switch value {
                        case let .success(res):
                            subject.send(res)
                        case let .failure(res):
                            subject
                                .send(completion: .failure(NetworkError
                                        .badRequest(error: res)))
                        }
                    case let .complete(comp):
                        if let error = comp.error {
                            subject
                                .send(completion: .failure(NetworkError
                                        .badRequest(error: error)))
                            subject.send(completion: .finished)

                        } else {
                            subject.send(completion: .finished)
                        }
                    }
                }
        }
        DispatchQueue.global().async(execute: workItem!)
        return subject.eraseToAnyPublisher()
    }
}
