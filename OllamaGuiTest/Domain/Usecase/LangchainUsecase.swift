//
//  LangchainUsecase.swift
//  ollamaGuiTest
//
//  Created by 배상휘 on 3/8/24.
//

import Combine
@testable import ollamaGUI
import XCTest

class LangchainUsecaseTest: XCTestCase {
    var usecase: LangchainUsecase!
    override func setUp() {
        let manager = SessionManager()
        let web = WebDatasourceImpl(session: manager.session)
        let embeding = OllamaDatasourceImpl(
            baseUrl: "http://localhost:11434",
            session: manager.session
        )
        usecase = LangchainUsecase(
            embedingRepository: EmbedingRepositoryImpl(dataSource: embeding),
            crawlingRepository: CrawlingRepositoryImpl(datasource: web)
        )
    }

    override func tearDown() {
        usecase = nil
    }

    func test_도큐먼트생성() {
        let expectation = expectation(description: "split document")
        var res: [Document] = []
        var html = ""

        let url = "https://docs.smith.langchain.com/user_guide"
        var cancel: AnyCancellable!
        cancel = usecase.crawlingWeb(for: url)
            .sink(receiveCompletion: { [weak self] _ in
                      cancel.cancel()
                      cancel = nil
                      cancel = self?.usecase.toSliptDocument(
                          for: html,
                          of: url
                      )
                      .sink(
                          receiveCompletion: { _ in expectation.fulfill() },
                          receiveValue: {
                              res = $0
                              print(res.count)
                          }
                      )
                  },
                  receiveValue: { html = $0 })

        waitForExpectations(timeout: 20)
    }

    func test_임베딩생성() {
        let expectation = expectation(description: "create embedding")
        let url = "https://en.wikipedia.org/wiki/Palworld"

        var bag = Set<AnyCancellable>()
        let html = PassthroughSubject<String, Never>()
        let document = PassthroughSubject<[Document], Never>()
        let result = PassthroughSubject<[[Float]], Never>()
        usecase.crawlingWeb(for: url)
            .sink(receiveCompletion: { _ in }, receiveValue: { html.send($0) })
            .store(in: &bag)

        html.sink(receiveValue: { [weak self] val in
            self?.usecase.toSliptDocument(for: val, of: url)
                .sink(receiveCompletion: { _ in }, receiveValue: {
                    document.send($0)
                }).store(in: &bag)
        }).store(in: &bag)

        document.sink(
            receiveValue: { [weak self] val in
                self?.usecase.toEmbeddings(for: val, model: "mistral")
                    .sink(receiveValue: { val in
                        result.send(val)
                    }).store(in: &bag)
            }
        ).store(in: &bag)

        result.sink(receiveValue: {
            expectation.fulfill()
            print($0)
            XCTAssert(!$0.isEmpty)
        }).store(in: &bag)
        waitForExpectations(timeout: 120)
    }
    
    func test_벡터비교(){
        
    }
}
