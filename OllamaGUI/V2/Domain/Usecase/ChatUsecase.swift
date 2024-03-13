//
//  ChatUsecase.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/11/24.
//

import Foundation
import Combine

class ChatUsecase {
    var ollamaRepository: OllamaRepository
    var bag = Set<AnyCancellable>()
    
    init(ollamaRepository: OllamaRepository) {
        self.ollamaRepository = ollamaRepository
    }
    
    func cancelChat() {
        bag.removeAll()
    }
    
    func chatV2(req: ChatRequestModel, appSetting: AppSetting,option: RoomOptionEntity?) -> AnyPublisher<ChatModel,NetworkError> {
        var dto = req
        dto.model = appSetting.model
        dto = dto.applyOption(option: option)
        return ollamaRepository.chat(req: dto).eraseToAnyPublisher()
    }
    
    func chat(req: ChatRequestModel, appSetting:AppSetting, options:RoomOptionEntity?) -> CurrentValueSubject<Loadable<ChatModel,NetworkError>,Never>{
        var dto = req
        dto.model = appSetting.model
        dto = dto.applyOption(option: options)
        let subject = CurrentValueSubject<Loadable<ChatModel,NetworkError>,Never>(.initState)
        
        
        ollamaRepository.chat(req: dto)
            .sink(receiveCompletion: { [weak self] com in
                switch com {
                    case .finished:
                        subject.send(.finished)
                        subject.send(completion: .finished)
                        self?.bag.removeAll()
                    case let .failure(error):
                        subject.send(.failed(error))
                        self?.bag.removeAll()
                }
            }, receiveValue: { val in
                subject.send(.isLoading(last: val))
                
            })
            .store(in: &bag)
       return subject
    }
    
}
