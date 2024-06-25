//
//  OllamaGUIApp.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/9/24.
//

import SwiftData
import SwiftUI

struct VisualEffect: NSViewRepresentable {
    func makeNSView(context _: Self.Context) -> NSView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.state = .active
        view.material = .underWindowBackground
        return view
    }

    func updateNSView(_: NSView, context _: Context) {}
}

@main
struct OllamaGUIApp: App {
    var body: some Scene {
        WindowGroup {
            V3HomeView()
                .frame(minWidth: 390, maxWidth: 390,
                       minHeight: 640, idealHeight: 640)
                .preferredColorScheme(.dark)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowResizability(.contentSize)
//        WindowGroup {
//            RootView()
//                .frame(minWidth: 390, maxWidth: 390, minHeight: 640, idealHeight: 640)
//                .inject()
//                .preferredColorScheme(.dark)
//                .modelContainer(
//                    for: [MessageEntity.self, ChatEntity.self, RoomEntity.self, AppSettingEntity.self, LocalChatModel.self, LocalRoomModel.self, LocalMessageModel.self, LocalRoomOptionModel.self]
//                )
//        }
//        .windowStyle(HiddenTitleBarWindowStyle())
//        .windowResizability(.contentSize)
    }
}
