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

    @Binding var show: Bool
    @Binding var position: CGPoint
    @Binding var floating: Bool

    var room: RoomEntity
    @ObservedObject var chatViewModel = ChatViewModel()
    @State private var showFloatingToast = false
    @State private var showSettingSheet = false
    @State private var showLangchainSheet = false
    @State var background: Material = .thickMaterial
    @State var chats: [ChatModel] = []
    @State var isLoading: Bool = false
    @State var cancel = Set<AnyCancellable>()
    @State var subject = PassthroughSubject<
        Loadable<ChatModel, NetworkError>,
        Never
    >()

    /// drag drop var
    @State var image: NSImage? = nil
    @State var isTargeted: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                ChatHeader(
                    room: room,
                    show: $show,
                    onClean: onClean
                )
                Color.white.frame(height: 1).opacity(0.1)
                ScrollView {
                    ScrollViewReader { proxy in
                        Spacer().frame(height: 20)
                        Text("Please let me know what you think.")
                            .font(.caption).foregroundColor(.gray)
                        LazyVStack(spacing: 0) {
                            ForEach(chats, id: \.id) { chat in
                                ChatBubble(chat: chat).padding(.vertical, 12)
                                    .id(chat.id)
                            }
                        }.onChange(of: chats) { _, _ in
                            withAnimation {
                                proxy.scrollTo(chats.last?.id, anchor: .bottom)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }.overlay(alignment: .bottom) {
                StopButton(onCancel: onCancel)
                    .padding()
                    .opacity(isLoading ? 1 : 0)
                    .offset(y: isLoading ? 0 : 20)
                    .animation(.snappy, value: isLoading)
            }
            MessageEditor(
                floating: $floating,
                showSetting: $showSettingSheet,
                showLangchain: $showLangchainSheet,
                image: $image,
                isLoading: $isLoading,
                onSend: onSend,
                onClean: onClean
            ).background {
                Color.white.shadow(radius: 10, y: -5)
            }
        }
        .sheet(isPresented: $showSettingSheet, content: {
            SettingSheet(room: room, showSetting: $showSettingSheet)
        })
        .sheet(isPresented: $showLangchainSheet) {
            LangchainSheet(
                room: room,
                showLangchain: $showLangchainSheet,
                state: $chatViewModel.state,
                addEvent: { event in
                    self.chatViewModel.bloc.addEvent(event: event)
                }
            )
        }
        .ignoresSafeArea()
        .onAppear {
            chats = room.getChatModel
                .sorted(by: { $0.createdAt! < $1.createdAt! })
            print("on appear")
            chatViewModel.ignite(container: container, room: room)
        }
        /// handle combine
        .onReceive(subject, perform: { value in
            switch value {
            case let .loaded(value):
                chats.append(value)
            case .failed:
                isLoading = false
                chats.removeLast()
                let error = ChatModel(
                    text: "please ensure your ollama server is live or selected any model",
                    role: .assistant
                )
                chats.append(error)
            case let .isLoading(last: value):
                guard var lastChat = value else {
                    return
                }
                guard var _ = lastChat.message else {
                    chats.removeLast()
                    let error = ChatModel(
                        text: "please ensure you have select any model",
                        role: .assistant
                    )
                    chats.append(error)
                    return
                }
                let chat = chats.removeLast()
                lastChat.message!
                    .content = (chat.message?.content ?? "") + lastChat.message!
                    .content

                chats.append(lastChat)

                if lastChat.done ?? false {
                    isLoading = false
                    room.title = lastChat.message?.content ?? "title"
                    cancel.removeFirst()
                    room.chats.append(lastChat.toEntity)
                }
            default:
                isLoading = false
                return
            }
        })
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay {
            if !floating {
                OverlayToast(text: "this chat window is unpinned")
            } else {
                OverlayToast(text: "this chat window is pinned")
            }
        }
        .frame(
            minWidth: 400,
            idealWidth: floatingSize.width,
            minHeight: floatingSize.height,
            idealHeight: floatingSize.height
        )
//        .onDrop(of: [.image], isTargeted: $isTargeted, perform: { items in
//            guard let item = items.first else {
//                return false
//            }
//            _ = item.loadDataRepresentation(
//                for: .image,
//                completionHandler: { data, error in
//                    if error == nil, let data {
//                        DispatchQueue.main.async {
//                            image = NSImage(data: data)
//                        }
//                    }
//                }
//            )
//            return true
//
//        })
    }
}

extension ChatView {
    func onSend(text: String) {
        let viewModel = ChatModel(text: text, role: .user)
        if let system = room.option?.system {
            let prevSystem = room.chats.filter { $0.message?.role == .system }
            let systemViewmodel = ChatModel(text: system, role: .system)
            if prevSystem.isEmpty {
                print("prev system is Empty?")
                chats.append(systemViewmodel)
                room.chats.append(systemViewmodel.toEntity)
            } else if prevSystem.first!.message?.content != system {
                print("remove system?")
                chats.removeAll(where: { $0.message?.role == .system })
                room.chats.removeAll(where: { $0.message?.role == .system })
                chats.append(systemViewmodel)
                room.chats.append(systemViewmodel.toEntity)
            }
        }
        chats.append(viewModel)
        let requestModel = ChatRequestModel(
            ofList: chats.map { $0.message! },
            stream: true
        )
        chats.append(.init(text: "", role: .assistant))
        room.chats.append(viewModel.toEntity)
        room.updatedAt = Date.now
        container.updateTrigger.triggerNewMessage()
        isLoading = true

        subject = container.interactor.sendChatStream(
            chat: requestModel,
            cancel: &cancel,
            option: room.option,
            setting: container.appSetting
        )
        print(cancel.count)
    }

    func onCancel() {
        let cancel = cancel.removeFirst()
        cancel.cancel()
    }

    func onClean() {
        if !cancel.isEmpty {
            onCancel()
        }
        chats.removeAll()
        container.dataInteractor.clearRoom(context: context, room: room)
        room.clean()
    }
}

#Preview {
    RootView().injectPreview()
}
