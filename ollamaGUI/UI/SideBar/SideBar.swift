//
//  SideBar.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/9/24.
//

import SwiftUI

struct SideBar: View {
    @Binding var rooms: [RoomEntity]
    @Binding var selected: RoomEntity?
    var onSelect: (RoomEntity)->Void
    var onInsert: ()->Void
    var onDelete: (RoomEntity)->Void
    
    var body: some View {
        List{
            ForEach(rooms,id:\.self) { room in
                    Label(
                        room.title ?? "new Chat" ,
                        systemImage: "message"
                    )
                    .frame(maxWidth: .infinity,alignment:.leading)
                    .padding(.vertical,4)
                    .padding(.horizontal,8)
                    .background(selected == room ? .gray : .clear)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .onTapGesture {
                        onSelect(room)
                    }
                    .contextMenu(menuItems: {
                        Button(action:{onDelete(room)}, label: {
                            Text("remove")
                        })
                    })

                }
            Label("new Chat",systemImage: "plus").onTapGesture {
                onInsert()
            }.frame(maxWidth: .infinity,alignment:.leading)
            .padding(.horizontal,8)
                .padding(.vertical,4)
            
                        
        }
    }
}

#Preview {
    ContentView()
}
