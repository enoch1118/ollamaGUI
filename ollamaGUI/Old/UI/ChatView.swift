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
    @State var isTargeted: Bool = false

    var body: some View {
        Text("old")
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
