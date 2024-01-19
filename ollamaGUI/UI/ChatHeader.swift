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
            Text((room.title ?? "untitled").removeFirstBreakLine).lineLimit(1)
            Spacer()
            Button(action:{
                
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

