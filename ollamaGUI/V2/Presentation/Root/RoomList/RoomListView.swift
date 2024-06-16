//
//  RoomListView.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Foundation
import SwiftUI

struct RoomListView: View {
    @Binding var rooms: [LocalRoomModel]
    var onInsert: () -> Void
    var onDelete: (LocalRoomModel) -> Void

    var body: some View {
        VStack {
            HStack {
                Text("Chat").font(.title)
                Spacer()
                    Button(action: onInsert) {
                        Image(systemName: "plus").resizable()
                            .frame(width: 16, height: 16)
                    }.buttonStyle(SidebarButton())
            }
            .padding(.top, 16)
            .padding(.leading)
            .padding(.bottom, 8)
            ScrollView {
                LazyVStack {
                    ForEach(rooms, id: \.id) { room in
                        RoomListItem(room: room, onDelete: onDelete)
                    }
                }
            }.frame(maxWidth: .infinity)
        }.ignoresSafeArea().background(.chat)
    }
}

#Preview {
    RootView().injectPreview()
}
