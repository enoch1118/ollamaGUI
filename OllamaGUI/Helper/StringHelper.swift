//
//  StringHelper.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import Foundation
import SwiftUI

extension String {
    var removeFirstBreakLine: String {
        if starts(with: "\n") {
            return replacing("\n", with: "", maxReplacements: 1)
        }
        return self
    }

    var verifyUrl: Bool {
        let urlPattern =
            "https?://[localhost|(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b]([-a-zA-Z0-9()@:%_\\+.~#?&//=]*)"
        let urlRegex = try! NSRegularExpression(pattern: urlPattern)
        if urlRegex.firstMatch(
            in: self,
            options: [],
            range: NSRange(location: 0, length: utf16.count)
        ) != nil {
            return true
        } else {
            return false
        }
    }

    var base64Data: Data? {
        let utf8Data = data(using: .utf8)
        return utf8Data?.base64EncodedData()
    }
}
