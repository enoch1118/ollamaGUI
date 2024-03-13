//
//  Langchain+ChatUsecase.swift
//  ollamaGuiTest
//
//  Created by 배상휘 on 3/12/24.
//

import Combine
import Foundation
@testable import ollamaGUI
import SwiftData
import XCTest

class LangChainChatUsecaseTest: XCTestCase {
    var container: ModelContainer!
    var chatUsecase: ChatUsecase!
    var appSetting: AppSetting!
    var langchainUsecase: LangchainUsecase!

    override func setUp() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try? ModelContainer(for:
            MessageEntity.self, ChatEntity.self, RoomEntity.self,
            AppSettingEntity.self,
            configurations: config)

        let sessionManager = SessionManager()
        appSetting = AppSetting()
        appSetting
            .updateSetting(.init(baseUrl: "http://localhost:11434",
                                 selectedModel: "mistral"))
        let ollamaDataSource = OllamaDatasourceImpl(
            baseUrl: appSetting.baseUrl,
            session: sessionManager.session
        )
        let webDataSource = WebDatasourceImpl(session: sessionManager.session)
        let ollamaRepository =
            OllamaRepositoryImpl(dataSource: ollamaDataSource)
        let crawlingRepository =
            CrawlingRepositoryImpl(datasource: webDataSource)
        chatUsecase = ChatUsecase(ollamaRepository: ollamaRepository)
        langchainUsecase = LangchainUsecase(
            embedingRepository: ollamaRepository,
            crawlingRepository: crawlingRepository
        )
    }

    override func tearDown() {
        chatUsecase = nil
        langchainUsecase = nil
        appSetting = nil
        container = nil
    }

    func test_EmbeddingChat() {
        
    }
}
