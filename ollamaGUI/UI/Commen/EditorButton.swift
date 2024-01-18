//
//  CommonButton.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/11/24.
//

import SwiftUI

struct EditorButton: ButtonStyle {
    @Binding var enabled: Bool
    @State private var color:Color = .gray

    

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 20,height: 20)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .frame(minWidth: 40, minHeight: 40,alignment: .center)
            .foregroundColor(enabled ? .blue : color)
            .background(.clear)
            .clipShape(RoundedRectangle(cornerRadius: 3))
            .onHover(perform: { hovering in
                if enabled {
                    return
                }
                if hovering {
                    color = .blue
                }else{
                    color = .gray
                }
                
            })
    }
}

#Preview {
    VStack {
        Button(action: {}) {
            Image("MicIcon")
        }.buttonStyle(EditorButton(enabled: .constant(true)))
        Button(action: {}) {
            Image("MicIcon")
        }.buttonStyle(EditorButton(enabled: .constant(true)))

    }.frame(width: 500, height: 500)
}
