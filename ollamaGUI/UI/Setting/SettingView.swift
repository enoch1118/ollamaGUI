//
//  SettingView.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/18/24.
//

import SwiftUI

struct SettingView: View {
    @Binding var showSetting: Bool
    @State var baseUrl: String = ""
    @State var selectedModel: String?
    var body: some View {
        VStack {
            HStack {
                Text("Settings").font(.title)
                    .frame(
                        maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/,
                        alignment: .leading
                    )
                Spacer()
                Button(action: { showSetting = false }, label: {
                    Image(systemName: "xmark")
                }).buttonStyle(SidebarButton())
            }
            Text("Network").font(.title2).textLeft
            HStack {
                Text("Base url")
                Spacer()
                TextField("base url", text: $baseUrl)
            }
            HStack{
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                   Text("test connection")
                })
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                   Text("save")
                })
            }
            Text("Model").font(.title2).textLeft
            HStack {
                Picker("choose a model",selection: $selectedModel){
                    Text("ollama")
                }
            }
            HStack{
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                   Text("model manager")
                })
            }
            Spacer()
        }.padding().frame(width: 400, height: 300,alignment: .leading)
    }
}

#Preview {
    SettingView(showSetting: .constant(true))
}
