//
//  TagListItem.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/22/24.
//

import Combine
import Foundation
import SwiftUI

struct TagListItem: View {
    @Environment(\.injected) var container

    @State private var showProgress: Bool = false
    @State private var progress: Float?
    @State private var response: PullResponseModel?
    @State private var subject = PassthroughSubject<
        Loadable<PullResponseModel, NetworkError>,
        Never
    >()
    @State private var bag = Set<AnyCancellable>()

    var tag: OllamaTagModel
    var onPull: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(tag.title)
                Spacer()
                Text(tag.updatedAt)
            }
            Text(tag.sha).textLeft.font(.caption).foregroundColor(.gray)
            HStack {
                Text(tag.size).font(.caption).foregroundColor(.gray)
                Spacer()
                Button("pull") {
                    handlePull()
                }.disabled(showProgress)
            }

        }.padding(.vertical).padding(.horizontal, 0).frame(height: 80)
            .sheet(
                isPresented: $showProgress,
                content: {
                    XProgressView(
                        progress: $progress,
                        text: response?.status ?? "initialize",
                        present: $showProgress
                    )
                }
            ).onReceive(
                subject,
                perform: handleReceive
            )
    }
}

extension TagListItem {
    func handleReceive(value: Loadable<PullResponseModel, NetworkError>) {
        switch value {
        case let .isLoading(last: val):
            response = val
            progress = val?.progress
            return
        case let .loaded(val):
            response = val
            progress = val.progress
            showProgress = false
        case .finished:
            showProgress = false
            onPull()

        default:
            return
        }
    }

    func handlePull() {
        subject = container.interactor.pullModel(
            cancel: &bag,
            model: tag,
            setting: container.appSetting
        )
        showProgress.toggle()
    }
}
