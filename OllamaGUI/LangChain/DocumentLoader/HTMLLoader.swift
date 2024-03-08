//
//  HTMLLoader.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/7/24.
//

import Foundation
import SwiftSoup

class HTMLLoader: BaseLoader {
    let html: String
    let url: String

    public init(html: String, url: String) {
        self.html = html
        self.url = url
    }

    override func _load() async throws -> [Document] {
        do {
            let doc: SwiftSoup.Document = try SwiftSoup.parse(html)
            let text = try doc.text()
            let metadata: [String: String] = ["url": url]
            return [Document(page_content: text, metadata: metadata)]
        } catch let Exception.Error(_, message) {
            throw LangchainError
                .loadError(message: "parse html fail with \(message)")
        } catch {
            throw LangchainError
                .loadError(message: "parse html fail with \(error)")
        }
    }
}
