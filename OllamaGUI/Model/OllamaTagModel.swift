//
//  OllamaTagModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/20/24.
//

import Foundation

struct OllamaTagModel {
    var id: UUID
    var title: String
    var size: String
    var parent: String
    var sha: String
    var updatedAt: String

    init(title: String, size: String, sha: String, updatedAt: String,parent:String) {
        self.id = UUID()
        self.title = title
        self.size = size
        self.sha = sha
        self.updatedAt = updatedAt
        self.parent = parent
    }
}

extension OllamaTagModel {
    init() {
        title = "tag"
        size = "9.999TB"
        sha = "12i391239i12j4i"
        updatedAt = "long long ago"
        parent = "llama2"
        id = UUID()
    }

    static func guardedInit(
        title: String?,
        size: String?,
        sha: String?,
        updatedAt: String?,
        parent:String
    ) -> OllamaTagModel? {
        if title != nil, size != nil, sha != nil, updatedAt != nil {
            return Self(
                title: title!,
                size: size!,
                sha: sha!,
                updatedAt: updatedAt!,
                parent: parent
            )
        }
        return nil
    }
}
