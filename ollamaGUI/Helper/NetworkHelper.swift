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

struct RealNetworkHelper<T>: NetworkHelper {
    var baseUrl: String
    var url: String
    var method: HTTPMethod
    var header: HTTPHeaders?

    private var subject = PassthroughSubject<Loadable<T, NetworkError>, Never>()
    private var workItem: DispatchWorkItem? = nil

    var cancellable: AnyCancellable {
        subject
            .handleEvents(receiveCancel: {
                workItem?.cancel()
                subject.send(.cancelled)
                subject.send(completion: .finished)
            })
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }

    mutating func request() {
        workItem = DispatchWorkItem { [self] in
            AF.request(
                url,
                method: method,
                encoding: JSONEncoding.default,
                headers: header ?? HTTPHeader.default
            )
            .validate(statusCode: 200 ..< 300)
            .responseJSON { response in
                switch response.result {
                case let .success(data):
                    return;
                //                    subject.send(.loaded())
                case let .failure(error):
//                    subject.send(.failed(.))
                    return
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
