//
//  TextSpliter.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/7/24.
//

import Foundation

class TextSplitter {
    let chunkSize: Int
    let chunkOverlap: Int

    init(chunkSize: Int, chunkOverlap: Int) {
        self.chunkSize = chunkSize
        self.chunkOverlap = chunkOverlap
    }

    func _splitTextWithRegex(text: String,
                             seperater: String) -> [String]
    {
        text.components(separatedBy: seperater)
    }

    func _joinDocs(docs: [String]) -> String {
        let text = docs.joined()
        return text
    }

    func _mergeSplits(splits: [String]) -> [String] {
        var docs: [String] = []
        var currentDoc: [String] = []
        var total = 0
        for d in splits {
            let _len = d.count
            if total + _len > chunkSize {
                if currentDoc.count > 0 {
                    let doc = _joinDocs(docs: currentDoc)
                    docs.append(doc)
                    while total > chunkOverlap ||
                        (total + _len > chunkSize && total > 0)
                    {
                        total -= currentDoc[0].count
                        currentDoc.removeFirst()
                    }
                }
            }
            currentDoc.append(d)
            total += _len
        }
        let doc = _joinDocs(docs: currentDoc)
        docs.append(doc)
        return docs
    }

    func splitText(text _: String) -> [String] {
        []
    }

    func splitDocument(document: [Document]) -> [Document] {
        var newDocument: [Document] = []
        for doc in document {
            for chunk in splitText(text: doc.page_content) {
                let newDoc = Document(page_content: chunk, metadata: [:])
                newDocument.append(newDoc)
            }
        }
        return newDocument
    }
}

class CharacterTextSplitter: TextSplitter {
    override func splitText(text: String) -> [String] {
        let splits = _splitTextWithRegex(text: text, seperater: "\n\n")
        return _mergeSplits(splits: splits)
    }
}
