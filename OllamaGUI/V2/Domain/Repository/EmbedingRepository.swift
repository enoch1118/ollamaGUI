//
//  EmbedingRepository.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/8/24.
//

import Foundation
import Combine

protocol EmbedingRepository {
    func getEmbeding(prompt: String,model:String)->AnyPublisher<[Float],NetworkError>
}
