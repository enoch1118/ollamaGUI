//
//  SettingSheet.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/5/24.
//

import Foundation
import SwiftUI


struct SettingSheet: View {
    @ObservedObject var model: SettingSheetViewModel
    @Binding var showSetting: Bool
    @State var roomState: RoomEntity
    
    init(room: RoomEntity,showSetting: Binding<Bool>) {
        self.roomState = room
        self.model = SettingSheetViewModel()
        self._showSetting = showSetting
        model.system = room.option?.system ?? ""
        model.options = room.option
        model.topk = Float(room.option?.top_k ?? 40)
        model.topp = room.option?.top_p ?? 0.9
    }
    
    
    var body: some View {
        ZStack(alignment: .topTrailing){
            VStack(alignment: .leading,spacing: 8){
                Text("System prompt").font(.headline)
                
                TextEditor(text: $model.system)
                    .textEditorStyle(.plain)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(.black))
                    .frame(maxHeight: 200)
                
                HStack{
                    Text("Top-K").font(.headline)
                    Spacer()
                    Text("\(Int(model.topk))")
                }
                Text("Reduces the probability of generating nonsense. A higher value (e.g. 100) will give more diverse answers, while a lower value (e.g. 10) will be more conservative. (Default: 40)").font(.caption)
                Slider(value: $model.topk,in: 0...100)
                HStack{
                    Text("Top-P").font(.headline)
                    Spacer()
                    Text("\(String(format: "%.2f",model.topp))")
                }
                Text("Works together with top-k. A higher value (e.g., 0.95) will lead to more diverse text, while a lower value (e.g., 0.5) will generate more focused and conservative text. (Default: 0.9)").font(.caption)
                Slider(value: $model.topp,in: 0...1)
                HStack{
                    Text("Temperature").font(.headline)
                    Spacer()
                    Text("\(String(format: "%.2f",model.temperature))")
                }
                Text("The temperature of the model. Increasing the temperature will make the model answer more creatively. (Default: 0.8)").font(.caption)
                Slider(value: $model.temperature,in: 0...1)
                Spacer().frame(height: 16)
                
                HStack{
                    Spacer()
                    Button(action: {
                        model.reset()
                        model.apply()
                    }){
                        Text("reset")
                    }.buttonStyle(CommonButton(enabled: false))
                    Button(action: {
                        model.apply()
                        roomState.option = model.options
                        showSetting.toggle()
                    }){
                        Text("apply change")
                    }.buttonStyle(CommonButton())
                }
                
            }
            .padding()
            .frame(width: 400,height: 600)
            
            Button(action: {
                showSetting.toggle()
            }, label: {
                Image(systemName: "xmark")
            }).buttonStyle(SidebarButton())
        }
        
    }
    
}


#Preview {
    SettingSheet(room: .randomRoom,showSetting: .constant(false))
}



