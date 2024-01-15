//
//  Network.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/11/24.
//

import Alamofire
import Combine
import Foundation

protocol NetworkHelper {
    var method: HTTPMethod { get }
    var url: String { get }
    var baseUrl: String { get }
    var header: HTTPHeaders? { get }
}

struct RealNetworkHelper<U, T>: NetworkHelper where T: Decodable,
    U: DictionaryEncodable,
    U: Encodable
{
    var baseUrl: String
    var url: String
    var method: HTTPMethod
    var header: HTTPHeaders?
    var parameter: U?

    var subject = PassthroughSubject<Loadable<T, NetworkError>, Never>()
    private var workItem: DispatchWorkItem? = nil

    init(
        baseUrl: String,
        url: String,
        method: HTTPMethod,
        header: HTTPHeaders? = .default,
        parameter: U? = nil
    ) {
        self.baseUrl = baseUrl
        self.url = url
        self.method = method
        self.header = header
        self.parameter = parameter
    }

    func cancel(bag: inout Set<AnyCancellable>) {
        subject
            .handleEvents(receiveCancel: {
                workItem?.cancel()
                subject.send(.cancelled)
                subject.send(completion: .finished)
            })
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &bag)
    }

    mutating func request() {
        let body = parameter?.getDictionary()
        guard let b = body else {
            subject.send(.failed(.jsonEncodeError))
            subject.send(completion: .finished)
            return
        }
        workItem = DispatchWorkItem { [self] in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .customISO8601
            AF.request(
                baseUrl + url,
                method: method,
                parameters: b,
                encoding: JSONEncoding.default,
                headers: header ?? HTTPHeader.default
            )
            .validate(statusCode: 200 ..< 300)
            .response {
                _ in
            }
            .responseDecodable(of: T.self, decoder: decoder) { response in
                print(response)
                switch response.result {
                case let .success(data):
                    subject.send(.loaded(data))
                case let .failure(error):
                    subject.send(.failed(.commonError(error: error)))
                }
                subject.send(completion: .finished)
            }
        }
        DispatchQueue.global().async(execute: workItem!)
    }

    mutating func requestStream() {
//        let body = parameter?.getDictionary()
//        guard let b = body else {
//            subject.send(.failed(.jsonEncodeError))
//            subject.send(completion: .finished)
//            return
//        }
        subject.send(.isLoading(last: nil))
        workItem = DispatchWorkItem { [self] in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .customISO8601
            AF.streamRequest(
                baseUrl + url,
                method: method,
                parameters: parameter,
                encoder: JSONParameterEncoder.default,
                headers: header ?? HTTPHeaders.default
            )
            .validate(statusCode: 200 ..< 300)
            .responseStreamDecodable(of: T.self, using: decoder) { stream in
                switch stream.event {
                case let .stream(result):
                    switch result {
                    case let .success(value):
                        subject.send(.isLoading(last: value))
                    case let .failure(error):
                        subject.send(.failed(.commonError(error: error)))
                        subject.send(completion: .finished)
                    }
                case let .complete(completion):
                    print(completion)
                    subject.send(completion: .finished)
                }
            }
        }
        DispatchQueue.global().async(execute: workItem!)
    }
}

/// set default header
extension HTTPHeader {
    static var `default`: HTTPHeaders { HTTPHeaders([
        "Content-Type": "application/json",
        "Accept": "application/json",
    ]) }
}

extension JSONDecoder.DateDecodingStrategy {
    static let customISO8601 = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = Formatter.iso8601withFractionalSeconds
            .date(from: string) ?? Formatter.iso8601.date(from: string)
        {
            return date
        }
        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Invalid date: \(string)"
        )
    }
}

// set formatter
extension Formatter {
    static let iso8601withFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds,
        ]
        return formatter
    }()

    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
}
