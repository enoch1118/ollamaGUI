//
//  ChatUsecase.swift
//  ollamaGuiTest
//
//  Created by 배상휘 on 3/11/24.
//

import Foundation

import Combine
@testable import ollamaGUI
import XCTest
import SwiftData

class ChatUsecaseTest: XCTestCase {
    var container:ModelContainer!
    var chatUsecase:ChatUsecase!
    var appSetting:AppSetting!
    
    override func setUp() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try? ModelContainer(for:
            MessageEntity.self, ChatEntity.self, RoomEntity.self,AppSettingEntity.self
        , configurations: config)
        
        let sessionManager = SessionManager()
        appSetting = AppSetting()
        appSetting.updateSetting(.init(baseUrl: "http://localhost:11434", selectedModel: "mistral"))
        let ollamaDataSource  = OllamaDatasourceImpl(baseUrl: appSetting.baseUrl, session: sessionManager.session)
        let ollamaRepository = OllamaRepositoryImpl(dataSource: ollamaDataSource)
        chatUsecase = ChatUsecase(ollamaRepository: ollamaRepository)
    }
    
    
    override func tearDown() {
       chatUsecase = nil
        container = nil
    }
    
    
    func test_채팅() {
        let ex = expectation(description: "wait for complete")
        let req = ChatRequestModel(of: .init(text: "hello"))
        var bag = Set<AnyCancellable>()
        chatUsecase.chat(req: req, appSetting: appSetting, options: nil)
            .sink(
                receiveCompletion: { comp in
                    switch comp {
                        case .finished:
                            ex.fulfill()
                    }
                    
                }
                ,receiveValue: { val in
                    switch val{
                        case let .failed(err):
                            print(err.localizedDescription)
                            ex.fulfill()
                            return
                        default:
                            print(val)
                    }
            }).store(in: &bag)
        
        waitForExpectations(timeout: 20)
    }
    
    
    
    
}
