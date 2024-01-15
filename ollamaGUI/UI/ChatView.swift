//
//  SwiftUIView.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/10/24.
//

import Combine
import SwiftUI

struct ChatView: View {
    @Environment(\.injected) private var container: DIContainer
    @Environment(\.modelContext) private var context
    
    var room: RoomEntity
    @State var chats: [ChatModel] = []
    @State var cancel = Set<AnyCancellable>()
    @State var subject = PassthroughSubject<
        Loadable<ChatModel, NetworkError>,
        Never
    >()
    
    
    /// drag drop var
    @State var image:NSImage? = nil
    @State var isTargeted: Bool = false
    
    init(room:RoomEntity) {
        self.room = room
        self.chats = []
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack (alignment: .top){
                ChatHeader(room: room,onClean: onClean).zIndex(1000)
                ScrollView {
                    ScrollViewReader { proxy in
                        Spacer().frame(height: 70)
                        Text("무슨 생각을 하고 계신지 알려주세요.").font(.caption).foregroundColor(.gray)
                        LazyVStack(spacing: 0) {
                            ForEach(chats, id: \.id) { chat in
                                ChatBubble(chat: chat).padding(.vertical, 12)
                                    .id(chat.id)
                            }
                        }.onChange(of: chats) { _, _ in
                            withAnimation {
                                proxy.scrollTo(chats.last?.id,anchor: .bottom)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            MessageEditor(image:$image,onSend: onSend,onClean: onClean).background{
                Color.white.shadow(radius:10,y:-5)
            }
            
                
        }
        .ignoresSafeArea()
        .onAppear{
            chats = room.getChatModel.sorted(by: {$0.createdAt! < $1.createdAt!})
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
                let chat = chats.removeLast()
                lastChat.message!.content = (chat.message?.content ?? "") + lastChat.message!.content
                
                chats.append(lastChat)
                
                if lastChat.done ?? false {
                    room.chats.append(lastChat.toEntity)
                }
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
        room.chats.append(viewModel.toEntity)

        subject = container.interactor.sendChatStream(
            chat: requestModel,
            cancel: &cancel
        )
    }
    
    
    func onClean() {
        chats.removeAll()
        container.dataInteractor.clearRoom(context: context, room: room)
        room.clean()
    }
}

#Preview {
    ContentView().injectPreview()
}

#Preview {
    ChatView(room: RoomEntity()).injectPreview()
}
