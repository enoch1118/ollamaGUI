//
//  ollamaGUIApp.swift
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
struct ollamaGUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 390,maxWidth: 390, minHeight: 640,idealHeight:640)
                .inject()
                .preferredColorScheme(.dark)
                .modelContainer(
                    for: [MessageEntity.self, ChatEntity.self, RoomEntity.self]
                )
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowResizability(.contentSize)
    }
}
