//
//  OllmaModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/20/24.
//

import Foundation

struct OllamaModel {
    var id:UUID = UUID()
    var title: String
    var desc: String
    var pulls: String
    var tagsCount: String
    var updatedAt: String

    init(
        title: String,
        desc: String,
        pulls: String,
        tagsCount: String,
        updatedAt: String
    ) {
        self.title = title
        self.desc = desc
        self.pulls = pulls
        self.tagsCount = tagsCount
        self.updatedAt = updatedAt
    }
}

extension OllamaModel {
    static func guardedInit(
        title: String?,
        desc: String?,
        pulls: String?,
        tagCount: String?,
        updatedAt: String?
    ) -> OllamaModel? {
        if title != nil, desc != nil, pulls != nil, tagCount != nil,
           updatedAt != nil
        {
            return Self(
                title: title!,
                desc: desc!,
                pulls: pulls!,
                tagsCount: tagCount!,
                updatedAt: updatedAt!
            )
        }
        return nil
    }

    init() {
        title = "ollmaa"
        desc = "awesome model"
        pulls = "many pulls"
        tagsCount = "many tags"
        updatedAt = "2 weeks ago"
    }
}
