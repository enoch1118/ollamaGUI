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
    
    
    /// drag drop var
    @State var image:NSImage? = nil
    @State var isTargeted: Bool = false
    
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
                        withAnimation {
                            proxy.scrollTo(chats.last?.id,anchor: .bottom)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            MessageEditor(image:$image,onSend: onSend)
            
                
        }
        /// handle combine
        .onReceive(subject, perform: { value in
            switch value {
            case let .loaded(value):
                chats.append(value)
                
            case let .failed(value):
                print(value)
            case let .isLoading(last: value):
                guard var lastChat = value else{
                    return
                }
                var chat = chats.removeLast()
                lastChat.message!.content = (chat.message?.content ?? "") + lastChat.message!.content
                chats.append(lastChat)
            default:
                return
            }
        })
        .onDrop(of: [.image], isTargeted: $isTargeted, perform: { items in
            guard let item = items.first else {
                return false
            }
            _ = item.loadDataRepresentation(
                for: .image,
                completionHandler: { data, error in
                    if error == nil, let data {
                        DispatchQueue.main.async {
                            image = NSImage(data: data)
                        }
                    }
                }
            )
            return true

        })
    }
}

extension ChatView {
    func onSend(text: String) {
        let model = MessageModel(text: text)
        let viewModel = ChatModel(text: text,role: .user)
        chats.append(viewModel)
        let requestModel = ChatRequestModel(of: model,stream: true)
        chats.append(.init(text: "", role: .assistant))

        subject = container.interactor.sendChatStream(
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
