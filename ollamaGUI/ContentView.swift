//
//  ContentView.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/9/24.
//

import SwiftData
import SwiftUI
import SwiftUIIntrospect

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.injected) private var container

    @State var rooms: [RoomEntity] = []
    @State var room: RoomEntity? = nil
    @State var sideBar: NavigationSplitViewVisibility = .all
    let descriptor = FetchDescriptor<RoomEntity>()
    var body: some View {
        NavigationSplitView(
            columnVisibility: $sideBar, sidebar: {
                ZStack{
                    Color.sidebar.ignoresSafeArea()
                    SideBar(rooms:$rooms,selected: $room, onSelect: onSelect,onInsert:onInsert,onDelete:onDelete)
                }.toolbar(removing: .sidebarToggle)
                    .navigationSplitViewColumnWidth(
                        min: 65,
                        ideal: 65,
                        max:65)
            },
            detail: {
                RoomView(rooms:$rooms,onInsert: onInsert,onDelete: onDelete)
            }
        )
        .navigationSplitViewStyle(.balanced)
        .background(.chatHover)
            /// disable sidebar collapse
            .introspect(
                .navigationSplitView,
                on: .macOS(.v14, .v13),
                customize: { splitView in
                    (splitView.delegate as? NSSplitViewController)?
                        .splitViewItems
                        .first?.canCollapse = false
                }
            ).onAppear {
                rooms = container.dataInteractor.fetchRoom(context: context)
                room = rooms.first!
            }.onReceive(container.appSetting.publisher, perform: { value in
                if value.pin {
                    sideBar = .detailOnly
                } else {
                    sideBar = .all
                }

            })
    }
}


extension ContentView {
    func onSelect(_ room:RoomEntity)->Void{
        if self.room == room {
            return
        }
        self.room = room
    }
    
    
    func onDelete(_ room:RoomEntity)->Void{
        withAnimation{
            self.room = nil
            container.dataInteractor.deleteRoom(context: context, room: room)
            rooms = container.dataInteractor.fetchRoom(context: context)
            if rooms.isEmpty {
                onInsert()
            }else{
                self.room = rooms.first!
            }
        }
    }
    
    
    func onInsert() ->Void{
        withAnimation{
            let id = container.dataInteractor.insertRoom(context: context)
            rooms = container.dataInteractor.fetchRoom(context: context)
            room = rooms.first{
                id == $0.id
            }
        }
        
    }
}

#Preview {
    ContentView().injectPreview()
}
