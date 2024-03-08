//
//  LangchainUsecase.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/8/24.
//

import Combine
import Foundation

class LangchainUsecase {
    var embedingRepository: EmbedingRepository
    var crawlingRepository: CrawlingRepository

    init(
        embedingRepository: EmbedingRepository,
        crawlingRepository: CrawlingRepository
    ) {
        self.embedingRepository = embedingRepository
        self.crawlingRepository = crawlingRepository
    }

    func crawlingWeb(for url: String) -> AnyPublisher<String, NetworkError> {
        crawlingRepository.crawlingWeb(for: url).eraseToAnyPublisher()
    }

    func toSliptDocument(for html: String,
                         of url: String) -> AnyPublisher<[Document], Never>
    {
        return Future<[Document], Never> { promise in
            Task {
                let loader = HTMLLoader(html: html, url: url)
                let doc = await loader.load()
                let spliter = RecursiveCharacterTextSplitter(
                    chunkSize: 2000,
                    chunkOverlap: 200
                )
                let splited = spliter.splitDocument(document: doc)
                promise(.success(splited))
            }
        }.eraseToAnyPublisher()
    }

    func toEmbeddings(for docs: [Document],
                      model: String) -> AnyPublisher<[[Float]], Never>
    {
        let count = docs.count
        let subject = CurrentValueSubject<Int, Never>(0)
        var res: [[Float]] = []
        var bag = Set<AnyCancellable>()
        return Future<[[Float]], Never> { [weak self] promise in
            subject.sink(receiveValue: { val in
                if count == val {
                    promise(.success(res))
                }
                else{
                    print("\(val)/\(count)")
                    self?.embedingRepository.getEmbeding(
                        prompt: docs[val].page_content,
                        model: model
                    )
                    .sink(
                        receiveCompletion: { _ in subject.send(subject.value + 1) },
                        receiveValue: {
                            res.append($0)
                        }
                    ).store(in: &bag)
                }
            }).store(in: &bag)
            self?.embedingRepository.getEmbeding(
                prompt: docs[0].page_content,
                model: model
            )
            .sink(
                receiveCompletion: { _ in subject.send(subject.value + 1) },
                receiveValue: {
                    res.append($0)
                    print("receive")
                }
            ).store(in: &bag)
        }.eraseToAnyPublisher()
    }
}
