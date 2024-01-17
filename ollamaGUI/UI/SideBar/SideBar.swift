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
        VStack{
            Spacer().frame(height: 35)
            Button(action:{}){
                Image(systemName: "message").resizable()
            }.buttonStyle(SidebarButton())
            Spacer()
        }
    }
}

#Preview {
    ContentView().injectPreview()
}
