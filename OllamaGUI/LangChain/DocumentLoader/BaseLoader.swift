//
//  BaseLoader.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/7/24.
//
import Foundation
struct Document: Equatable {
    public init(page_content: String, metadata: [String: String]) {
        self.page_content = page_content
        self.metadata = metadata
    }

    public let page_content: String
    public var metadata: [String: String]
    public static func == (lhs: Document, rhs: Document) -> Bool {
        return lhs.page_content == rhs.page_content
    }
}

class BaseLoader {
    public func load() async -> [Document] {
        let type = type()
        do {
            let docs = try await _load()
            return docs
        } catch let LangchainError.loadError(message) {
            print("Catch langchain loader error \(type):\(message)")
            return []
        } catch {
            print("Catch other error \(type)")
            return []
        }
    }

    func _load() async throws -> [Document] {
        []
    }

    func type() -> String {
        "Base"
    }
}
