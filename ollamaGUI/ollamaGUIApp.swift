//
//  ollamaGUIApp.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/9/24.
//

import SwiftData
import SwiftUI

@main
struct ollamaGUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().frame(minWidth: 500, maxWidth: 500, minHeight: 600)
                .inject()
                .modelContainer(
                    for: [MessageEntity.self, ChatEntity.self, RoomEntity.self]
                )
        }
        .windowToolbarStyle(UnifiedCompactWindowToolbarStyle())
        .windowStyle(HiddenTitleBarWindowStyle())
        .windowResizability(.contentSize)
    }
}
