//
//  OllamaTagModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/20/24.
//

import Foundation

struct OllamaTagModel {
    var title: String
    var size: String
    var sha: String
    var updatedAt: String

    init(title: String, size: String, sha: String, updatedAt: String) {
        self.title = title
        self.size = size
        self.sha = sha
        self.updatedAt = updatedAt
    }
}

extension OllamaTagModel {
    init() {
        title = "tag"
        size = "9.999TB"
        sha = "12i391239i12j4i"
        updatedAt = "long long ago"
    }

    func guardedInit(
        title: String?,
        size: String?,
        sha: String?,
        updatedAt: String?
    ) -> Self? {
        if title != nil, size != nil, sha != nil, updatedAt != nil {
            return Self(
                title: title!,
                size: size!,
                sha: sha!,
                updatedAt: updatedAt!
            )
        }
        return nil
    }
}
