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
    var isTest: Bool { get }
}

struct RealNetworkHelper<U, T>: NetworkHelper where
    U: Encodable
{
    var baseUrl: String
    var url: String
    var method: HTTPMethod
    var header: HTTPHeaders?
    var isTest: Bool
    var parameter: U?

    var subject = PassthroughSubject<Loadable<T, NetworkError>, Never>()
    var voidPassThrough = PassthroughSubject<Bool, Never>()
    var netWorkSubject = CurrentValueSubject<Bool, Never>(false)
    var testNetworkSubject = CurrentValueSubject<Bool, Never>(false)
    private var workItem: DispatchWorkItem?
    private var networkManager: NetworkReachabilityManager?

    init(
        baseUrl: String,
        url: String,
        method: HTTPMethod,
        header: HTTPHeaders? = .default,
        parameter: U? = nil,
        isTest: Bool = false
    ) {
        self.baseUrl = baseUrl
        self.url = url
        self.method = method
        self.header = header
        self.parameter = parameter
        self.isTest = isTest
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

    func cancelCheckNetwork(bag: inout Set<AnyCancellable>) {
        netWorkSubject.handleEvents(receiveCancel: {
            networkManager?.stopListening()
        })
        .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
        .store(in: &bag)
    }

    mutating func checkNetwork() {
        AF.request(baseUrl, method: .get)
            .response(completionHandler: { [self] res in
                switch res.result {
                case .failure:
                    if !isTest {
                        netWorkSubject.send(false)
                    } else {
                        testNetworkSubject.send(false)
                    }
                default:
                    if !isTest {
                        netWorkSubject.send(true)
                    } else {
                        testNetworkSubject.send(true)
                    }
                }
            })
    }
}

extension RealNetworkHelper where T == Void, U == String {
    mutating func deleteModels() {
        var b: [String: Any] = [:]
        b["name"] = parameter

        print(b)
        AF.request(
            baseUrl + url,
            method: .delete,
            parameters: b,
            encoding: JSONEncoding.default
        )
        .validate(statusCode: 200 ..< 300)
        .response(completionHandler: { [self] res in
            switch res.result {
            case .success:
                voidPassThrough.send(true)
                voidPassThrough.send(completion: .finished)
                return
            case let .failure(error):
                print(error)
                voidPassThrough.send(false)
                voidPassThrough.send(completion: .finished)
                return
            }

        })
    }
}

extension RealNetworkHelper where T == String {
    mutating func getModels() {
        AF.request(baseUrl + url, method: .get)
            .response(completionHandler: { [self] res in
                switch res.result {
                case let .failure(error):
                    subject.send(.failed(.commonError(error: error)))
                    subject.send(completion: .finished)
                    return
                case let .success(data):
                    guard let d = data else {
                        subject.send(.failed(.jsonEncodeError))
                        subject.send(completion: .finished)
                        return
                    }
                    subject.send(.loaded(String(data: d, encoding: .utf8)!))
                    subject.send(completion: .finished)
                }
            })
    }
}

extension RealNetworkHelper where T: Decodable, U == String {
    mutating func pullModel() {
        let model = PullRequestModel(name:parameter!)
        workItem = DispatchWorkItem { [self] in
            AF.streamRequest(
                baseUrl + url,
                method: method,
                parameters:model,
                encoder: JSONParameterEncoder.default,
                headers: header ?? HTTPHeaders.default
            )
            .validate(statusCode: 200 ..< 300)
            .responseStream{ response in
                print(response)
                
            }
            .responseStreamDecodable(of: T.self) { stream in
                switch stream.event {
                case let .stream(result):
                    print(result)
                    switch result {
                    case let .success(value):
                        netWorkSubject.send(true)
                        subject.send(.isLoading(last: value))
                    case let .failure(error):
                        subject.send(.failed(.commonError(error: error)))
                        subject.send(completion: .finished)
                    }
                case let .complete(completion):
                    if let error = completion.error {
                        subject.send(.failed(.commonError(error: error)))
                        subject.send(completion: .finished)

                    } else {
                        netWorkSubject.send(true)
                        subject.send(.finished)
                        subject.send(completion: .finished)
                    }
                }
            }
        }
        DispatchQueue.global().async(execute: workItem!)
        
    }
}

extension RealNetworkHelper where T: Decodable, U: DictionaryEncodable {
    mutating func request() {
        let body = parameter?.getDictionary()
        var b: [String: Any]?
        if parameter != nil {
            guard let bodyTemp = body else {
                subject.send(.failed(.jsonEncodeError))
                subject.send(completion: .finished)
                return
            }
            b = bodyTemp
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
            .response { res in
                switch res.result {
                case let .failure(error):
                    print(error)
                    print("error in this")
                    subject.send(.failed(.commonError(error: error)))
                    subject.send(completion: .finished)
                    return
                default:
                    return
                }
            }
            .validate(statusCode: 200 ..< 300)
            .responseDecodable(of: T.self, decoder: decoder) { response in
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
                        netWorkSubject.send(true)
                        subject.send(.isLoading(last: value))
                    case let .failure(error):
                        subject.send(.failed(.commonError(error: error)))
                        subject.send(completion: .finished)
                    }
                case let .complete(completion):
                    if let error = completion.error {
                        subject.send(.failed(.commonError(error: error)))
                        subject.send(completion: .finished)

                    } else {
                        netWorkSubject.send(true)
                        subject.send(completion: .finished)
                    }
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
