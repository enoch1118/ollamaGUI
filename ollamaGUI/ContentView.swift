//
//  ContentView.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/9/24.
//

import SwiftUI
import SwiftUIIntrospect
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.injected) private var container
    
    @State var rooms:[RoomEntity] = []
    @State var room:RoomEntity? = nil
    
    let descriptor = FetchDescriptor<RoomEntity>()
    var body: some View {
        NavigationSplitView(
            sidebar: {
                SideBar()
                    .toolbar(removing: .sidebarToggle)
                    .navigationSplitViewColumnWidth(
                        min: 90,
                        ideal: 90,
                        max: 90
                    )
            },
            detail: {
                if room != nil {
                    ChatView(room: room!)
                        .id(room?.id)
                }else{
                    Color.clear
                }
            }
        ).navigationSplitViewStyle(.balanced)
        /// disable sidebar collapse
            .introspect(
                .navigationSplitView,
                on: .macOS(.v14, .v13),
                customize: { splitView in
                    (splitView.delegate as? NSSplitViewController)?
                        .splitViewItems
                        .first?.canCollapse = false
                }
            ).onAppear{
                rooms = container.dataInteractor.fetchRoom(context: context)
                room = rooms.first!
            }
    }
}

#Preview {
    ContentView().injectPreview()
}
