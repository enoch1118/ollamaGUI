//
//  BaseLoader.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/7/24.
//
import Foundation
struct Document: Equatable,Codable {
    public init(page_content: String, metadata: [String: String]) {
        self.page_content = page_content
        self.metadata = metadata
    }

    public let page_content: String
    public var metadata: [String: String]
    public static func == (lhs: Document, rhs: Document) -> Bool {
        return lhs.page_content == rhs.page_content
    }
    
    
    enum CodingKeys: CodingKey {
        case page_content
        case metadata
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page_content = try container.decode(String.self, forKey: .page_content)
        self.metadata = try container.decode([String : String].self, forKey: .metadata)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.page_content, forKey: .page_content)
        try container.encode(self.metadata, forKey: .metadata)
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
