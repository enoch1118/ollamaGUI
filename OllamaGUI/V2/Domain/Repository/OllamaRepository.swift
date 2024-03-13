//
//  EmbedingRepository.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/8/24.
//

import Foundation
import Combine

protocol OllamaRepository {
    func getEmbeding(prompt: String,model:String)->AnyPublisher<[Float],NetworkError>
    func chat(req:ChatRequestModel)->AnyPublisher<ChatModel,NetworkError>
}
