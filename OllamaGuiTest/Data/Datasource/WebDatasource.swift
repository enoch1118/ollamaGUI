//
//  WebDatasource.swift
//  ollamaGuiTest
//
//  Created by 배상휘 on 3/8/24.
//

@testable import ollamaGUI
import XCTest

final class WebDatasourceTest: XCTestCase {
    var manager: SessionManager!
    var datasource: WebDatasource!

    override func setUp() {
        manager = SessionManager()
        datasource = WebDatasourceImpl(
            session: manager.session
        )
    }

    override func tearDown() {
        manager = nil
        datasource = nil
    }

    func test_크롤링테스트() {
        let expectation = expectation(description: "crawling google")
        var res = ""
        let cancel = datasource.crawlingWeb(for: "https://google.com")
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    expectation.fulfill()
                    print(res)
                    XCTAssert(true, "success with \(res)")
                case let .failure(error):
                    XCTAssert(false, "error with \(error.localizedDescription)")
                    expectation.fulfill()
                }
            }, receiveValue: { value in
                res = value

            })

        waitForExpectations(timeout: 20)
    }
    
    func test_크롤링테스트2() {
        let expectation = expectation(description: "crawling wiki")
        var res = ""
        let cancel = datasource.crawlingWeb(for: "https://en.wikipedia.org/wiki/Palworld")
            .sink(receiveCompletion: {
                switch $0 {
                case .finished:
                    expectation.fulfill()
                    print(res)
                    XCTAssert(true, "success with \(res)")
                case let .failure(error):
                    XCTAssert(false, "error with \(error.localizedDescription)")
                    expectation.fulfill()
                }
            }, receiveValue: { value in
                res = value

            })

        waitForExpectations(timeout: 20)
    }
}
