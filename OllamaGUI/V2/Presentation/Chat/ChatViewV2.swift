//
//  ChatViewV2.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/18/24.
//

import SwiftUI

struct ChatViewV2: View {
    /// binding
    @Binding var show: Bool
    @Binding var position: CGPoint
    @Binding var floating: Bool

    /// view environment
    @Environment(\.injected) private var container: DIContainer
    @Environment(\.modelContext) private var context

    /// value
    var room: LocalRoomModel

    /// state
    @ObservedObject var chatViewModel = ChatViewModelV2()

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                header
                Color.white.frame(height: 1).opacity(0.1)
                chats
                editor
            }.overlay(alignment: .bottom) {
                stopButton
            }
        }
        .background(.thickMaterial)
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
        .onAppear(perform: onAppear)
        .sheet(isPresented: $chatViewModel.showSetting, content: {
            SettingSheet(room: chatViewModel.room, showSetting: $chatViewModel.showSetting)
        })
    }
}

extension ChatViewV2 {
    @ViewBuilder
    var editor: some View {
        MessageEditor(
            floating: $floating,
            showSetting: $chatViewModel.showSetting,
            showLangchain: $chatViewModel.showLangchain,
            isLoading: $chatViewModel.isLoading,
            onSend: chatViewModel.onSend,
            onClean: chatViewModel.onClean
        ).background {
            Color.white.shadow(radius: 10, y: -5)
        }
    }

    @ViewBuilder
    var stopButton: some View {
        StopButton(onCancel: chatViewModel.onCancel)
            .padding()
            .opacity(chatViewModel.isLoading ? 1 : 0)
            .offset(y: chatViewModel.isLoading ? 0 : 20)
            .animation(.snappy, value: chatViewModel.isLoading)
    }

    @ViewBuilder
    var chats: some View {
        ScrollView {
            ScrollViewReader { proxy in
                Spacer().frame(height: 20)
                Text("Please let me know what you think.")
                    .font(.caption).foregroundColor(.gray)
                LazyVStack(spacing: 0) {
                    if chatViewModel.room == nil {
                        Color.clear
                    } else {
                        ForEach(chatViewModel.chats, id: \.id) { chat in
                            ChatBubble(chat: chat)
                                .padding(.vertical, 12)
                                .id(chat.id)
                        }
                    }
                    loadingMessage(proxy: proxy)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    func loadingMessage(proxy: ScrollViewProxy) -> some View {
        let id = UUID()
        if chatViewModel.chat != nil {
            ChatBubbleLoading(chat: chatViewModel.chat!).id(id)
                .onChange(of: chatViewModel.chats) { _, _ in
                    withAnimation {
                        proxy.scrollTo(
                            id,
                            anchor: .bottom
                        )
                    }
                }
        }
    }

    @ViewBuilder
    var header: some View {
        ChatHeader(
            room: room,
            show: $show,
            onClean: chatViewModel.onClean
        )
    }
}

extension ChatViewV2 {
    func onAppear() {
        chatViewModel.ignite(container: container, context: context, room: room)
    }
}

#Preview {
    RootView().injectPreview()
}
