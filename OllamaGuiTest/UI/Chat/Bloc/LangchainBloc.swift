//
//  LangchainBlocTest.swift
//  ollamaGuiTest
//
//  Created by 배상휘 on 3/13/24.
//

import Combine
import Foundation
@testable import ollamaGUI
import XCTest
import SwiftData

final class LangchainBlocTest: XCTestCase {
    var bloc: LangchainBloc!
    var container: ModelContainer!
    var usecase: LangchainUsecase!
    var chatusecase: ChatUsecase!
    var appSetting: AppSetting!

    override func setUp() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try? ModelContainer(for:
            MessageEntity.self, ChatEntity.self, RoomEntity.self,AppSettingEntity.self
        , configurations: config)
        let sm = SessionManager()
        let ds = OllamaDatasourceImpl(
            baseUrl: "http://localhost:11434",
            session: sm.session
        )
        let wds = WebDatasourceImpl(session: sm.session)
        let or = OllamaRepositoryImpl(dataSource: ds)
        let cr = CrawlingRepositoryImpl(datasource: wds)
        chatusecase = ChatUsecase(ollamaRepository: or)
        usecase = LangchainUsecase(
            embedingRepository: or,
            crawlingRepository: cr
        )
        var roomOption: RoomOptionEntity?
        appSetting = AppSetting(ollamaDs:ds)
        appSetting
            .updateSetting(.init(baseUrl: "http://localhost:11434",
                                 selectedModel: "mistral"))
        bloc = LangchainBloc(
            langchainUsecase: usecase,
            chatUsecase: chatusecase,
            appSetting: appSetting!,
            roomOption: roomOption
        )
    }

    override func tearDown() {
        bloc = nil
        usecase = nil
        chatusecase = nil
    }

    func test_GET_DOCUMENT() {
        let expectation = expectation(description: "get doc")
        var cancel = Set<AnyCancellable>()
        bloc
            .addEvent(
                event: .GET_DOCUMENT_WEB(
                    url: "https://stackoverflow.com/questions/41640405/ios-share-on-instagram-the-file-couldn-t-be-saved-because-the-specified-url-typ"
                )
            )

        bloc.stateSubject.sink(receiveValue: { val in
            if case .idle = val {
                XCTAssert(true, "successfully get idle state")
                expectation.fulfill()
            }
        }).store(in: &cancel)

        waitForExpectations(timeout: 100)
    }

    func test_GETNERATE_EMBEDDING() {
        let expectation = expectation(description: "get doc")
        var cancel = Set<AnyCancellable>()
        bloc
            .addEvent(
                event: .GET_DOCUMENT_WEB(
                    url: "https://stackoverflow.com/questions/41640405/ios-share-on-instagram-the-file-couldn-t-be-saved-because-the-specified-url-typ"
                )
            )

        bloc.stateSubject.sink(receiveValue: { [weak self] val in
            if case .idle = val {
                self?.bloc
                    .addEvent(
                        event: .GENERATE_EMBEDDING(
                            prompt: "how to create url by file path"
                        )
                    )
                XCTAssert(true, "successfully get idle state")
            }
            if case .readyToAsk = val {
                XCTAssert(true, "successfully get prompt context")
                expectation.fulfill()
            }
        }).store(in: &cancel)

        waitForExpectations(timeout: 100)
    }

    func test_GET_ANSWER() {
        let expectation = expectation(description: "get doc")
        var cancel = Set<AnyCancellable>()
        bloc
            .addEvent(
                event: .GET_DOCUMENT_WEB(
                    url: "https://stackoverflow.com/questions/41640405/ios-share-on-instagram-the-file-couldn-t-be-saved-because-the-specified-url-typ"
                )
            )

        bloc.stateSubject.sink(receiveValue: { [weak self] val in
            if case .idle = val {
                self?.bloc
                    .addEvent(
                        event: .GENERATE_EMBEDDING(
                            prompt: "how to create url by file path"
                        )
                    )
                XCTAssert(true, "successfully get idle state")
            }
            if case .readyToAsk = val {
                self?.bloc.addEvent(event: .GET_ANSWER)
                XCTAssert(true, "successfully get prompt context")
            }

            if case let .answer(_, _, answer) = val {
                if case let .loaded(message) = answer {
                    XCTAssert(true, "successfully get answer")
                    print(message.message ?? "no answer!!")
                    expectation.fulfill()
                }
            }

        }).store(in: &cancel)

        waitForExpectations(timeout: 100)
    }
}
