//
//  RoomView.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/17/24.
//

import SwiftUI

struct RoomView: View {
    @Binding var rooms: [RoomEntity]
    var onInsert: () -> Void
    var onDelete: (RoomEntity) -> Void

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
                        RoomItem(room: room, onDelete: onDelete)
                    }
                }
            }.frame(maxWidth: .infinity)
        }.ignoresSafeArea().background(.chat)
            
    }
}

#Preview {
    ContentView().injectPreview()
}
