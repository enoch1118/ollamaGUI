//
//  LangchainSheet.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/13/24.
//

import Foundation
import SwiftUI

struct LangchainSheet: View {
    var room: RoomEntity
    @Binding var showLangchain: Bool
    @Binding var state: LangchainState
    @State var text: String = ""
    @State var prompt: String = ""
    var addEvent: (LangchainEvent) -> Void

    init(
        room: RoomEntity,
        showLangchain: Binding<Bool>,
        state: Binding<LangchainState>,
        addEvent: @escaping (LangchainEvent) -> Void
    ) {
        self.room = room
        _showLangchain = showLangchain
        _state = state
        self.addEvent = addEvent
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Langchain (Preview)").font(.title)
                    Text("can only test in this sheet").font(.title)
                    Text("Langchain url").font(.headline)
                    TextField("enter url", text: $text)
                    getDocumentButton

                    Text("prompt").font(.headline)
                    TextField("enter prompt", text: $prompt)
                    getAnswer

                    Text("result:").font(.headline)
                    if case let .answer(embedding, util, answer) = state {
                        Text(answer.value?.message?.content ?? "")
                    }
                }
            }

            .padding()
            .frame(width: 400, height: 600)

            Button(action: {
                showLangchain.toggle()
            }, label: {
                Image(systemName: "xmark")
            }).buttonStyle(SidebarButton())
        }
    }
}

extension LangchainSheet {
    @ViewBuilder
    var getDocumentButton: some View {
        switch state {
        case .initState:
            Button {
                addEvent(.GET_DOCUMENT_WEB(url: text))
            } label: {
                Text("get document")
            }
        case .idle:
            HStack {
                Button {
                    addEvent(.GET_DOCUMENT_WEB(url: text))
                } label: {
                    Text("get document")
                }

                Button {
                    addEvent(.REGENERATE_DOCUMENT(url: text))
                } label: {
                    Text("regenerate")
                }
            }

        case let .getEmbedding(progress, total):
            ProgressView(value: Float(progress), total: Float(total))
                .progressViewStyle(.linear)
                .frame(maxWidth: .infinity, minHeight: 20, maxHeight: 20)

        case let .answer(_, _, value):
            switch value {
            case .loaded:
                Button {
                    addEvent(.REGENERATE_DOCUMENT(url: text))
                } label: {
                    Text("regenerate")
                }
            default:
                ProgressView()
            }

        default:
            EmptyView()
        }
    }

    @ViewBuilder
    var getAnswer: some View {
        switch state {
        case .idle:
            Button {
                addEvent(.GENERATE_EMBEDDING(prompt: prompt))
            } label: {
                Text("get answer")
            }
        case .generating:
            EmptyView()

        case let .answer(_, _, value):
            switch value {
            case .loaded:
                Button {
                    addEvent(.GENERATE_EMBEDDING(prompt: prompt))
                } label: {
                    Text("get answer")
                }
            default:
                ProgressView()
            }

        case .readyToAsk:
            ProgressView()
                .onAppear {
                    addEvent(.GET_ANSWER)
                }
        case let .error(error: error):
            HStack {
                Text("error with \(error)")
                Button {
                    addEvent(.GENERATE_EMBEDDING(prompt: prompt))
                } label: {
                    Text("get answer")
                }
            }
        default:
            Text("\(state)")
        }
    }
}
