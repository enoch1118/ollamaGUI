//
//  ChatHeader.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import SwiftUI

struct ChatHeader: View {
    var room:RoomEntity
    var onClean: ()->Void
    var body: some View {
        HStack{
            Image(systemName: "message")
            Text(room.title ?? "untitled")
            Spacer()
            Button(action: {
                onClean()
            }, label: {
                Image(systemName: "trash")
            }).buttonStyle(ClearButton(enabled: true))
        }.padding().background(.ultraThickMaterial)
    }
}

#Preview {
    ChatView(room: RoomEntity()).injectPreview()
}
