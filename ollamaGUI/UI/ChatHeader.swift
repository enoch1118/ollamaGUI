//
//  ChatHeader.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import SwiftUI

struct ChatHeader: View {
    @Environment(\.injected) var container
    var room:RoomEntity
    @Binding var show:Bool
    var onClean: ()->Void
    var body: some View {
        HStack(spacing: 0){
            Image(systemName: "message.fill").padding(.trailing)
            Text(room.title ?? "untitled").lineLimit(1)
            Spacer()
            Button(action:{
                if !container.appSetting.getPin() {
                    for window in NSApplication.shared.windows {
                        window.level = .floating
                    }
                }else{
                    for window in NSApplication.shared.windows {
                        window.level = .normal
                    }
                }
                container.appSetting.togglePin()
            }){
                Image(systemName: "pin")
            }.buttonStyle(ClearButton())
            Button(action: {
                show.toggle()
            }, label: {
                Image(systemName: "xmark")
            }).buttonStyle(SidebarButton())
        }.padding(.leading).padding(.vertical)
    }
}

