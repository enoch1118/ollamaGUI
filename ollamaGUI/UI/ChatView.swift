//
//  SwiftUIView.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/10/24.
//

import Combine
import SwiftUI

struct ChatView: View {
    @Environment(\.injected) var container: DIContainer
    
    @State var chats: [ChatModel] = []
    @State var cancel = Set<AnyCancellable>()
    @State var subject = PassthroughSubject<
        Loadable<ChatModel, NetworkError>,
        Never
    >()
    
    init(chats: [ChatModel] = []) {
        self.chats = chats
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { proxy in
                    LazyVStack(spacing: 0) {
                        ForEach(chats, id: \.id) { chat in
                            ChatBubble(chat: chat).padding(.vertical, 12).id(chat.id)
                        }
                    }.onChange(of: chats) { _, _ in
                        print("change \(chats.last?.id)")
                        withAnimation {
                            proxy.scrollTo(chats.last?.id,anchor: .bottom)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            MessageEditor(onSend: onSend)
            
        }.onReceive(subject, perform: { value in
            switch value {
            case let .loaded(value):
                chats.append(value)
                
            case let .failed(value):
                print(value)
            case .isLoading(last: nil):
                break
            default:
                return
            }
        })
    }
}

extension ChatView {
    func onSend(text: String) {
        let model = MessageModel(text: text)
        let viewModel = ChatModel(text: text)
        chats.append(viewModel)
        let requestModel = ChatRequestModel(of: model)

        subject = container.interactor.sendChat(
            chat: requestModel,
            cancel: &cancel
        )
    }
}

#Preview {
    ContentView()
}

#Preview {
    ChatView(chats: ChatModel.testValue)
}
