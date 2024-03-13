//
//  LangchainBloc.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/12/24.
//

import Combine
import Foundation

class LangchainBloc: BaseBloc<LangchainEvent, LangchainState> {
    /// usecase
    var langchainUsecase: LangchainUsecase
    var chatUsecase: ChatUsecase
    var appSetting: AppSetting

    var eventBag = Set<AnyCancellable>()

    init(langchainUsecase: LangchainUsecase, chatUsecase: ChatUsecase,appSetting: AppSetting) {
        self.langchainUsecase = langchainUsecase
        self.chatUsecase = chatUsecase
        self.appSetting = appSetting
        super.init()
        _ignite()
    }

    override func _registerEvent(event: LangchainEvent) {
        super._registerEvent(event: event)
        switch event {
        case let .GET_DOCUMENT_WEB(url):
            onCheckDocument(url: url)
            return
        case let .GENERATE_EMBEDDING(prompt: prompt):
            generateEmbedding(prompt: prompt)
            return
        case .GET_ANSWER:
            getAnswer()
            return
        }
    }

    private func getAnswer() {
        guard case let .readyToAsk(embedding, util, context,
                                   prompt) = stateSubject.value
        else {
            return
        }
        let contextMessage = MessageModel(text:
            """
            answer my question from context after "---"
            ---
            \(context)
            """,
            role: .system)
        let askMessage = MessageModel(text: prompt)
        emit(state: .answer(
            embedding: embedding,
            util: util,
            answer: .isLoading(last: .init(text: "", role: .assistant))
        ))
        let contextReq = ChatRequestModel(ofList: [contextMessage, askMessage])
        chatUsecase.chatV2(req: contextReq, appSetting: appSetting, option: nil)
            .sink(receiveCompletion: { [weak self] comp in
                var state = self?.stateSubject.value
                guard case let .answer(embedding, util, answer) = state else {
                    self?.eventBag.removeAll()
                    return
                }
                switch comp {
                case .finished:
                    self?
                        .emit(state: .answer(embedding: embedding,
                                             util: util,
                                             answer: .loaded(
                                                 answer.value!
                                             )))
                    return
                case let .failure(error):
                        print("error occur! \(error)")
                    self?
                        .emit(state: .answer(embedding: embedding,
                                             util: util,
                                             answer: .failed(error)))
                    return
                }

            }, receiveValue: { [weak self] value in
                var state = self?.stateSubject.value
                guard case let .answer(embedding, util, answer) = state else {
                    self?.eventBag.removeAll()
                    return
                }
                guard case var .isLoading(last: model) = answer else {
                    self?.eventBag.removeAll()
                    return
                }
                model?.appendMessage(text: value.message!.content)
                self?.emit(state: .answer(
                    embedding: embedding,
                    util: util,
                    answer: .isLoading(last: model)
                ))

            }).store(in: &eventBag)
    }

    private func onGetDocument(embedding: WebEmbeddings) {
        langchainUsecase.crawlingWeb(for: embedding.url)
            .sink(receiveCompletion: { [weak self] val in
                      if case .failure = val {
                          self?.emit(state: .error(error: MuseError
                                  .getDocumentError(url: embedding.url)))
                      }
                  },
                  receiveValue: { [weak self] value in
                      print("get document")
                      var emb = embedding
                      emb.html = value
                      self?.splitDocument(embedding: emb)
                  }).store(in: &eventBag)
    }

    private func splitDocument(embedding: WebEmbeddings) {
        var emb = embedding
        langchainUsecase.toSliptDocument(for: embedding.html, of: embedding.url)
            .sink(receiveValue: { [weak self] val in
                emb.doc = val
                self?
                    .emit(state: .getEmbedding(progress: 0,
                                               total: emb.doc.count))
                emb.vector = Array(repeating: [], count: emb.doc.count)
                self?.generateEmbedding(embeddings: emb)
            })
            .store(in: &eventBag)
    }

    private func generateEmbedding(prompt: String) {
        let state = stateSubject.value
        guard case let .idle(embeding, util) = state else {
            return
        }
        var vector: [Float] = []
        langchainUsecase.embedding(for: prompt, model: appSetting.model)
            .sink(
                receiveCompletion: { [weak self] _ in
                    var docs = util.searchIndex(vector)
                    self?
                        .emit(
                            state: .readyToAsk(embedding: embeding, util: util,
                                               context: docs, prompt: prompt)
                        )

                },
                receiveValue: { val in
                    vector = val
                }
            ).store(in: &eventBag)
    }

    private func generateEmbedding(embeddings: Embeddings) {
        let state = stateSubject.value
        let doc = embeddings.doc
        var emb = embeddings
        guard case let .getEmbedding(progress: prog, total: total) = state
        else {
            return
        }
        langchainUsecase.embedding(for: doc[prog], model: appSetting.model)
            .sink(
                receiveCompletion: { [weak self] _ in
                    if prog + 1 < total {
                        self?.generateEmbedding(embeddings: emb)
                    }
                    self?.vectorStore(embeding: emb)
                },
                receiveValue: { [weak self] val in
                    emb.vector[prog] = val
                    self?
                        .emit(state: .getEmbedding(progress: prog + 1,
                                                   total: emb.doc.count))
                }
            ).store(in: &eventBag)
    }

    private func vectorStore(embeding: Embeddings) {
        let usearch = USearchUtil()
        usearch.buildIndex(embeding.vector, document: embeding.doc)
        usearch.saveVector(name: embeding.name)
        emit(state: .idle(embeding: embeding, util: usearch))
    }

    private func onCheckDocument(url: String) {
        let embedding = WebEmbeddings(type: .web, doc: [], url: url)
        let usearch = USearchUtil()

        if usearch.loadVector(name: embedding.name, dimensions: 4096) {
            emit(state: .idle(embeding: embedding, util: usearch))
            return
        }

        onGetDocument(embedding: embedding)
    }
}
