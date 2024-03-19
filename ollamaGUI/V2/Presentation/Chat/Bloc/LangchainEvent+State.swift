//
//  LangchainEvent+State.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/12/24.
//

import Foundation

enum LangchainEvent {
    case GET_DOCUMENT_WEB(url: String)
    case REGENERATE_DOCUMENT(url: String)
    case GENERATE_EMBEDDING(prompt: String)
    case GET_ANSWER
}

enum LangchainState : BaseState{
    case initState
    case getDocument(url: String)
    case getEmbedding(progress: Int, total: Int)
    case idle(embeding: Embeddings,util: USearchUtil)
    case generating
    case readyToAsk(embedding: Embeddings, util: USearchUtil, context: [Document], prompt: String)
    case answer(embedding: Embeddings, util: USearchUtil, answer: Loadable<ChatModel,NetworkError>)
    case generateAnswer(answer: String)
    case error(error: MuseError)
}

