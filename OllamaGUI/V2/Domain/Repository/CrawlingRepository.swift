//
//  CrawlingRepository.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/8/24.
//

import Combine
import Foundation

protocol CrawlingRepository {
    func crawlingWeb(for: String) -> AnyPublisher<String, NetworkError>
}
