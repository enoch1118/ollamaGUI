//
//  RoomItem.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/17/24.
//

import SwiftUI

struct RoomItem: View {
    @State var color: Color = .clear
    @State var position:CGPoint = .zero
    @State var show:Bool = false
    var room: RoomEntity
    var onDelete:(RoomEntity)->Void
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "message.fill").font(.headline)
                Text(room.title ?? "no title").lineLimit(1)
                Text("\(room.chats.count)").font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer().frame(height: 8)
            HStack {
                Text(room.chats.last?.message?.content ?? "").font(.caption)
                Spacer()
                if Date.now.hasSame(.day, as: room.updatedAt) {
                    Text(room.updatedAt, style: .time).font(.caption)
                } else{
                    Text(room.updatedAt, style: .date).font(.caption)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
                
            
        }
        .padding()
        .frame(height: 75, alignment: .leading)
        .onTapGesture(count: 2, perform: {
                position = leftCenter
                show = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15){
                    position = .init(x: leftCenter.x + 400, y: leftCenter.y)
                }
            })
        .background(color)
        .floatingWindow(position:$position, show: $show){
            ChatView(room: room)
        }
        .contextMenu(ContextMenu(menuItems: {
            Button(action:{
              onDelete(room)
            }){
                Text("delete")
            }
        }))
        .onHover(perform: { hovering in
            if hovering {
                color = .chatHover
            } else {
                color = .clear
            }

        }).clipped()
    }
}


var leftCenter: CGPoint{
    guard let screen = NSScreen.main?.visibleFrame.size else{return .zero}
    return .init(x: 20 - 400, y: screen.height / 2 - 300)
}

var bottomRight: CGPoint{
    guard let screen = NSScreen.main?.visibleFrame.size else{return .zero}
    return .init(x: screen.width - 220, y: 20)
}

#Preview {
    ContentView().injectPreview()
//    RoomItem(room: .randomRoom)
}
