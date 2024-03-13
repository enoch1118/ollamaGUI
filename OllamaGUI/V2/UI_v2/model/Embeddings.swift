//
//  Embeddings.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/12/24.
//

import Foundation

enum EmbeddingsType {
    case web
}

protocol Embeddings {
    var type: EmbeddingsType { get }
    var doc: [Document] { get set }
    var vector: [[Float]] { get set }
    var name: String { get }
}

struct WebEmbeddings: Embeddings {
    var type: EmbeddingsType
    var doc: [Document]
    var html: String
    var url: String
    var vector: [[Float]]

    init(type: EmbeddingsType, doc: [Document], url: String) {
        self.type = type
        self.doc = doc
        self.url = url
        vector = []
        html = ""
    }

    var name: String {
        url.base64Data!.base64EncodedString()
    }
}
