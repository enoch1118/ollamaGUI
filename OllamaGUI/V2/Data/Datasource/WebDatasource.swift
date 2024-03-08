//
//  WebDatasource.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/8/24.
//

import Combine
import Foundation

protocol WebDatasource {
    func crawlingWeb(for url: String) -> AnyPublisher<String, NetworkError>
}

class WebDatasourceImpl: WebDatasource {
    var session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func crawlingWeb(for url: String) -> AnyPublisher<String, NetworkError> {
        let req = APICall<Void, String>(session: session, baseUrl: url, url: "",
                                        method: .get)
        return req.callWithoutDecode().eraseToAnyPublisher()
    }
}

class WebDatasourceStub: WebDatasource {
    func crawlingWeb(for _: String) -> AnyPublisher<String, NetworkError> {
        return Just("").setFailureType(to: NetworkError.self)
            .eraseToAnyPublisher()
    }
}
