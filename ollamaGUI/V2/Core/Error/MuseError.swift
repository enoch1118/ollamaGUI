//
//  File.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/12/24.
//

import Foundation

enum MuseError: Error {
    case getDocumentError(url: String)
}

extension MuseError {
    var localizedDescription: String {
        switch self {
        case let .getDocumentError(url):
            return "get document from \(url) failed"
        }
    }
}
