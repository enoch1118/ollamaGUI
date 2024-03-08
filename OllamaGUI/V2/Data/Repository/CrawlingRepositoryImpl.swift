//
//  CrawlingRepositoryImpl.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/8/24.
//

import Foundation
import Combine

class CrawlingRepositoryImpl: CrawlingRepository {
    var datasource: WebDatasource

    init(datasource: WebDatasource) {
        self.datasource = datasource
    }

    func crawlingWeb(for url: String) -> AnyPublisher<String, NetworkError> {
        datasource.crawlingWeb(for: url)
    }
}
