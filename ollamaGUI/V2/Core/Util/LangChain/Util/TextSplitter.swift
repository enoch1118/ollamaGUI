//
//  TextSpliter.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/7/24.
//

import Foundation

class TextSplitter {
    let _chunkSize: Int
    let _chunkOverlap: Int
    let _strip_whitespace = true
    let _addStartIndex = false

    /// 4000-200
    init(chunkSize: Int, chunkOverlap: Int) {
        _chunkSize = chunkSize
        _chunkOverlap = chunkOverlap
    }

    func _splitTextWithRegex(text: String,
                             seperater: String) -> [String]
    {
        text.components(separatedBy: seperater)
    }

    func _joinDocs(_ docs: [String], separator: String) -> String? {
        let text = docs.joined(separator: separator)
        if _strip_whitespace {
            return text.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        if text.isEmpty {
            return nil
        }
        return text
    }

    func splitText(text _: String) -> [String] {
        return []
    }

    func splitTextInner(text _: String, separators _: [String]) -> [String] {
        return []
    }

    func createDocuments(texts: [String],
                         metadatas: [[String: String]]? = nil) -> [Document]
    {
        let _metadatas = metadatas ?? Array(repeating: [:], count: texts.count)
        var documents: [Document] = []

        for (i, text) in texts.enumerated() {
            var splited = splitText(text: text)
            for chunk in splited {
                let metadata = _metadatas[i]
                let newDoc = Document(page_content: chunk, metadata: metadata)
                documents.append(newDoc)
            }
        }

        return documents
    }

    func splitDocument(document: [Document]) -> [Document] {
        var text: [String] = []
        var metaData: [[String: String]] = []
        for doc in document {
            text.append(doc.page_content)
            metaData.append(doc.metadata)
        }
        return createDocuments(texts: text, metadatas: metaData)
    }

    func _lengthFunction(_ string: String) -> Int {
        string.count
    }

    func mergeSplits(_ splits: [String], separator: String) -> [String] {
        var docs: [String] = []
        var currentDoc: [String] = []
        var totalLength = 0
        let separatorLength = _lengthFunction(separator)

        for split in splits {
            let splitLength = _lengthFunction(split)
            if totalLength + splitLength +
                (separatorLength * (currentDoc.count > 0 ? 1 : 0)) > _chunkSize
            {
                if totalLength > _chunkSize {
                    // logger.warning(...) // 경고 로그 구현 필요
                    print("total lenth is bigger than chunk")
                }
                if currentDoc.count > 0 {
                    let doc = _joinDocs(currentDoc, separator: separator)
                    if doc != nil {
                        docs.append(doc!)
                    }
                }
                while totalLength > _chunkOverlap || (
                    totalLength + splitLength +
                        (separatorLength * (currentDoc.count > 0 ? 1 : 0)) >
                        _chunkSize &&
                        totalLength > 0
                ) {
                    totalLength -= _lengthFunction(currentDoc.first!) +
                        (separatorLength * (currentDoc.count > 1 ? 1 : 0))
                    currentDoc.removeFirst()
                }
            }
            currentDoc.append(split)
            totalLength += splitLength +
                (separatorLength * (currentDoc.count > 1 ? 1 : 0))
        }

        let doc = _joinDocs(currentDoc, separator: separator)
        if doc != nil {
            docs.append(doc!)
        }

        return docs
    }
}

class RecursiveCharacterTextSplitter: TextSplitter {
    private var separators = ["\n\n", "\n", " ", ""]
    private var _keepSeparator = true
    private var _isSeparatorRegex = false
    func splitTextWithRegex(text: String, separator: String,
                            keepSeparator: Bool) -> [String]
    {
        if !separator.isEmpty {
            let regex: NSRegularExpression
            if keepSeparator {
                // 분할 시 구분자 유지 정규 표현식 (captured group으로 구분자 포함)
                let pattern = "(?<=\\b)" + separator + "(?=\\b)"
                regex = try! NSRegularExpression(pattern: pattern, options: [])
            } else {
                regex = try! NSRegularExpression(
                    pattern: separator,
                    options: []
                )
            }
            let matches = regex.matches(
                in: text,
                range: NSRange(location: 0, length: text.utf16.count)
            )
            var splits: [String] = []
            var startIndex = text.startIndex
            for match in matches {
                let range = match.range(at: 1) // captured group (구분자 포함)
                let lowerBoundIndex = text.index(
                    startIndex,
                    offsetBy: range.lowerBound
                )
                let upper = text.index(startIndex, offsetBy: range.upperBound)
                if keepSeparator {
                    splits.append(String(text[startIndex ..< lowerBoundIndex]))
                    splits.append(String(text[lowerBoundIndex ..< upper]))
                } else {
                    splits.append(String(text[startIndex ..< lowerBoundIndex]))
                }
                startIndex = text.index(startIndex, offsetBy: range.upperBound)
            }
            splits.append(String(text[startIndex...]))
            return splits.filter { !$0.isEmpty }
        } else {
            return Array(arrayLiteral: text) // 빈 구분자일 경우 문자열을 개별 문자 리스트로 변환
        }
    }

    override func splitText(text: String) -> [String] {
        return splitTextInner(text: text, separators: separators)
    }

    override func splitTextInner(text: String,
                                 separators: [String]) -> [String]
    {
        var finalChunks: [String] = []
        // 적절한 구분자 선택 (반복문 및 로직은 Python과 유사)
        var separator = separators.last!
        var newSeparators: [String] = []
        for (i, _s) in separators.enumerated().reversed() {
            let escapedSeparator = _s
            if _s.isEmpty {
                separator = _s
                break
            }
            if text
                .range(of: escapedSeparator, options: .regularExpression) != nil
            {
                separator = _s
                newSeparators = Array(separators[i...])
                break
            }
        }
        

        // 텍스트 분할 ( _split_text_with_regex 함수를 직접 구현하거나 정규 표현식 라이브러리 활용)
        let splits = text.split(separator: separator).map{String($0)}
//        let splits = splitTextWithRegex(
//            text: text,
//            separator: separator,
//            keepSeparator: _keepSeparator
//        )

        // 청크 크기 조절 및 재분할 (반복문 및 로직은 Python과 유사)
        var goodSplits: [String] = []
        let separatorToUse = _keepSeparator ? "" : separator
        for split in splits {
            if _lengthFunction(split) < _chunkSize {
                goodSplits.append(split)
            } else {
                if !goodSplits.isEmpty {
                    let mergedText = mergeSplits(
                        goodSplits,
                        separator: separatorToUse
                    )
                    finalChunks.append(contentsOf: mergedText)
                    goodSplits = []
                }
                if newSeparators.isEmpty {
                    finalChunks.append(split)
                } else {
                    let otherChunks = splitTextInner(
                        text: split,
                        separators: newSeparators
                    )
                    finalChunks.append(contentsOf: otherChunks)
                }
            }
        }

        if !goodSplits.isEmpty {
            let mergedText = mergeSplits(goodSplits, separator: separatorToUse)
            finalChunks.append(contentsOf: mergedText)
        }

        return finalChunks
    }
}
