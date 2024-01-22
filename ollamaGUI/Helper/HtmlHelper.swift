//
//  HtmlHelper.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/20/24.
//

import Foundation
import SwiftSoup

extension String {
    func getTagsFromOllama(parent:String) -> [OllamaTagModel] {
        var tags: [OllamaTagModel] = []
        let docN = try? SwiftSoup.parse(self)
        guard let doc = docN else {
            return []
        }
        let lisN = try? doc.select("section.w-full.max-w-full>div")
        guard let lis = lisN else {
            return []
        }
        for li in lis {
            let titleN = try? li.select("div>.group>div").first()?.text()
            guard let title = titleN else { continue }
            let descN = try? li.select("div>.group>div").last()?.select("span")
                .first()?.text()
            guard let desc = descN else { continue }
            let list = desc.split(separator: " • ").map { String($0) }
            let tag = OllamaTagModel.guardedInit(
                title: title,
                size: list[0],
                sha: list[1],
                updatedAt: list[2],
                parent: parent
            )
            guard let t = tag else { continue }
            tags.append(t)
        }
        return tags
    }

    func getModelsFromOllama() -> [OllamaModel] {
        var models: [OllamaModel] = []
        let docN = try? SwiftSoup.parse(self)
        guard let doc = docN else {
            return []
        }
        let lisN = try? doc.select("#repo>ul>li")
        guard let lis = lisN else {
            return []
        }
        for li in lis {
            let title = getTitle(li: li)
            let desc = getDesc(li: li)
            let pulls = getPulls(li: li)
            let tagsCount = getTagsCount(li: li)
            let updatedAt = getUpdateAt(li: li)
            let modelN = OllamaModel.guardedInit(
                title: title,
                desc: desc,
                pulls: pulls,
                tagCount: tagsCount,
                updatedAt: updatedAt
            )
            guard let model = modelN else {
                continue
            }
            models.append(model)
        }
        return models
    }

    private func getTagsCount(li: SwiftSoup.Element) -> String? {
        let pElms = try? li.select("span")
        let desc = try? pElms?.get(1).text()
        return desc
    }

    private func getPulls(li: SwiftSoup.Element) -> String? {
        let pElms = try? li.select("span")
        let desc = try? pElms?.first()?.text()
        return desc
    }

    private func getUpdateAt(li: SwiftSoup.Element) -> String? {
        let pElms = try? li.select("span")
        let desc = try? pElms?.last()?.text()
        return desc
    }

    private func getDesc(li: SwiftSoup.Element) -> String? {
        let pElms = try? li.select("p")
        let desc = try? pElms?.first()?.text()
        return desc
    }

    private func getTitle(li: SwiftSoup.Element) -> String? {
        let titleElm = try? li.select("h2")
        let title = try? titleElm?.first()?.text()
        return title
    }
}
