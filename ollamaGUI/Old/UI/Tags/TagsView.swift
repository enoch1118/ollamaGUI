//
//  TagsView.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/20/24.
//

import Combine
import SwiftUI

struct TagsView: View {
    @Environment(\.injected) var container

    @Binding var showTags: Bool
    var model: OllamaModel
    var installed: [ModelInfoModel]
    var onUpdate:()->Void

    @State private var subject = PassthroughSubject<
        Loadable<String, NetworkError>,
        Never
    >()
    @State private var bag = Set<AnyCancellable>()

    @State var tags: [OllamaTagModel] = []

    var body: some View {
        VStack {
            info
            List {
                ForEach(tags, id: \.id) { tag in
                    TagListItem(tag: tag ,onPull:onUpdate)
                        .listRowInsets(EdgeInsets(top: 10, leading: -10,
                                                  bottom: 10,
                                                  trailing: -10))
                }
            }
            Spacer()
        }.padding().frame(width: 300, height: 600, alignment: .leading)
            .onAppear(perform: fetch)
            .onReceive(subject, perform: handleSubject)
    }
}

extension TagsView {
    func handleSubject(_ val: Loadable<String, NetworkError>) {
        switch val {
        case let .loaded(data):
            tags = data.getTagsFromOllama(parent: model.title)
            return
        default:
            return
        }
    }

    func fetch() {
        subject = container.interactor.fetchTags(cancel: &bag, model: model)
    }
}

extension TagsView {
    @ViewBuilder
    var info: some View {
        VStack {
            HStack {
                Text("Tags").font(.title)
                    .frame(
                        maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/,
                        alignment: .leading
                    )
                Spacer()
                Button(action: { showTags = false }, label: {
                    Image(systemName: "xmark")
                }).buttonStyle(SidebarButton())
            }
            VStack(spacing: 0) {
                HStack {
                    Text(model.title)
                    Spacer()
                    Text(model.updatedAt).font(.caption).foregroundStyle(.gray)
                }
                Text(model.desc).textLeft.font(.body).foregroundColor(.gray)
                    .padding(.vertical)
                HStack {
                    Text(model.pulls).font(.caption)
                    Text(model.tagsCount).font(.caption)
                    Spacer()
                }

            }.padding(.top)
        }
    }
}

//#Preview {
//    TagsView(
//        showTags: .constant(true),
//        model: .init(),
//        installed: [.preview, .preview]
//    )
//}
