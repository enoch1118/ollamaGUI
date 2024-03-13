//
//  LangchainUsecase.swift
//  ollamaGuiTest
//
//  Created by 배상휘 on 3/8/24.
//

import Combine
@testable import ollamaGUI
import XCTest
import USearch

class LangchainUsecaseTest: XCTestCase {
    var usecase: LangchainUsecase!
    var interactor: OllamaInteractor!
    override func setUp() {
        let manager = SessionManager()
        let web = WebDatasourceImpl(session: manager.session)
        let embeding = OllamaDatasourceImpl(
            baseUrl: "http://localhost:11434",
            session: manager.session
        )
        
        interactor = RealOllamaInteractor()
        usecase = LangchainUsecase(
            embedingRepository: OllamaRepositoryImpl(dataSource: embeding),
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
        
        let expectation = expectation(description: "create embedding")
        let url = "https://en.wikipedia.org/wiki/Palworld"

        var documentsResult:[Document] = []
        var bag = Set<AnyCancellable>()
        var usearch = USearchUtil()
        let html = PassthroughSubject<String, Never>()
        let document = PassthroughSubject<[Document], Never>()
        let result = PassthroughSubject<[[Float]], Never>()
        usecase.crawlingWeb(for: url)
            .sink(receiveCompletion: { _ in }, receiveValue: { html.send($0) })
            .store(in: &bag)

        html.sink(receiveValue: { [weak self] val in
            self?.usecase.toSliptDocument(for: val, of: url)
                .sink(receiveCompletion: { _ in }, receiveValue: {
                    documentsResult = $0
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
            usearch.buildIndex($0, document: documentsResult)
            usearch.saveVector(name: url.base64Data!.base64EncodedString())
            self.usecase.getEmbeddings(for: "when palworld release", model: "mistral")
                .sink(receiveCompletion: { _ in}, receiveValue: { val in
                    print(usearch.searchIndex(val))
                    expectation.fulfill()
                }).store(in: &bag)
        }).store(in: &bag)
        
        waitForExpectations(timeout: 120)
        
        
    }
    
    func test_usearchTest() {
        let vectorA: [Float32] = [0.3, 0.5, 1.2]
        let vectorB: [Float32] = [0.4, 0.2, 1.2]
        let index = USearchIndex.make(metric: .IP, dimensions: UInt32(vectorA.count), connectivity: 1, quantization: .F32)
        let _ = index.reserve(10)
        let _ = index.add(key: 1, vector: vectorA)
        let _ = index.add(key: 2, vector: vectorB)
    }
    
    
    func test_fileSave() {
        let vectorA: [Float32] = [0.3, 0.5, 1.2]
        let vectorB: [Float32] = [0.4, 0.2, 1.2]
        let index = USearchIndex.make(metric: .IP, dimensions: UInt32(vectorA.count), connectivity: 1, quantization: .F32)
        let _ = index.reserve(10)
        let _ = index.add(key: 1, vector: vectorA)
        let _ = index.add(key: 2, vector: vectorB)
        let home = FileManager.default.homeDirectoryForCurrentUser
        let folder = home.appendingPathComponent(".Muse",isDirectory: true)
        print(folder)
        if !FileManager.default.fileExists(atPath: folder.path){
            do{
                try FileManager.default.createDirectory(at:folder,withIntermediateDirectories: true)
            }catch {
                print("unable to create \(error)")
            }
        }
        
        let vector = folder.appendingPathComponent("vectors", isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: vector.path){
            do{
                try FileManager.default.createDirectory(at:vector,withIntermediateDirectories: true)
            }catch {
                print("unable to create \(error)")
            }
        }
        
        let test = vector.appendingPathComponent("test.vc")
        
        if !FileManager.default.fileExists(atPath: test.path) {
            FileManager.default.createFile(atPath: test.path, contents: nil)
        }
        
        index.save(path: test.path)
        
        
    }
    
    func test_loadFile() {
        let home = FileManager.default.homeDirectoryForCurrentUser
        let file = home.appendingPathComponent(".Muse",isDirectory: true).appendingPathComponent("vectors",isDirectory: true).appendingPathComponent("test.vc")
        
        if !FileManager.default.fileExists(atPath: file.path){
            print("no file")
            return
        }
        
        let index = USearchIndex.make(metric: .IP, dimensions: UInt32(3), connectivity: 1, quantization: .F32)
        index.reserve(10)
        index.load(path: file.path)
        print(index.description)
    }
    
    func test_loadVector() {
        let url = "https://en.wikipedia.org/wiki/Palworld"
        let name = url.base64Data!.base64EncodedString()
        var usearch = USearchUtil()
        usearch.buildIndex([[1.0,2.0]], document: [Document(page_content: "hello", metadata: ["hey":"hey"])])
        print(usearch.saveVector(name: name))
        print(usearch.document)
        print(usearch.vector)
        
        
        
        usearch = USearchUtil()
        
        print(usearch.loadVector(name: name,dimensions: 2))
        print(usearch.document)
        print(usearch.vector)
    }
    
    
}
