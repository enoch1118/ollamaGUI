//
//  OllamaDatasource.swift
//  ollamaGuiTest
//
//  Created by 배상휘 on 3/8/24.
//

@testable import ollamaGUI
import XCTest

final class OllamaDatasourceTest: XCTestCase {
    var manager: SessionManager!
    var datasource: OllamaDatasource!
    
    override func setUp() {
        manager = SessionManager()
        datasource = OllamaDatasourceImpl(
            baseUrl: "http://localhost:11434",
            session: manager.session
        )
    }
    
    override func tearDown() {
        manager = nil
        datasource = nil
    }
    
    func test_임베딩() {
        let expectation = expectation(description: "get embeded")
        var res:[Float] = []
        let cancel = datasource.getEmbedding(prompt: "hello hi", model: "mistral")
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    expectation.fulfill()
                    XCTAssert(true,"success with \(res)")
                case let .failure(error):
                    XCTAssert(false, "error with \(error.localizedDescription)")
                }
            }, receiveValue: { value in
                res = value
                
            })
        
        waitForExpectations(timeout: 20)
    }
}
