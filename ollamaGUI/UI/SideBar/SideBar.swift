//
//  SideBar.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/9/24.
//

import SwiftUI

struct SideBar: View {
    var body: some View {
        VStack{
            Button(action:{
            }){
                Image(systemName: "message").resizable().frame(width: 24,height: 24)
            }.buttonStyle(SidebarButton())
            
            Button(action:{
            }){
                Image(systemName: "clock").resizable().frame(width: 24,height: 24)
            }.buttonStyle(SidebarButton())
            Spacer()
            Button(action:{
            }){
                Image(systemName: "gear").resizable().frame(width: 24,height: 24)
            }.buttonStyle(SidebarButton())
            Button(action:{
            }){
                Image(.ollamaIcon).resizable().frame(width: 24,height: 24)
            }.buttonStyle(SidebarButton())
            
        
        }
    }
}

#Preview {
    ContentView()
}
