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

final class LangchainBlocTest: XCTestCase {
    var bloc: LangchainBloc!
    var usecase: LangchainUsecase!
    var chatusecase: ChatUsecase!
    var appSetting: AppSetting!
    

    override func setUp() {
        var sm = SessionManager()
        var ds = OllamaDatasourceImpl(
            baseUrl: "http://localhost:11434",
            session: sm.session
        )
        var wds = WebDatasourceImpl(session: sm.session)
        var or = OllamaRepositoryImpl(dataSource: ds)
        var cr = CrawlingRepositoryImpl(datasource: wds)
        chatusecase = ChatUsecase(ollamaRepository: or)
        usecase = LangchainUsecase(
            embedingRepository: or,
            crawlingRepository: cr
        )
        var appSetting = AppSetting()
        appSetting.updateSetting(.init(baseUrl: "http://localhost:11434", selectedModel: "mistral"))
        bloc = LangchainBloc(
            langchainUsecase: usecase,
            chatUsecase: chatusecase,
            appSetting: appSetting
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
