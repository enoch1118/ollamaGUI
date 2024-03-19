//
//  SidebarButton.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/9/24.
//

import SwiftUI

struct SidebarButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 25,height: 25)
            .frame(width: 40, height: 40,alignment: .center)
            .foregroundColor(.sidebarIcon)
            .opacity(configuration.isPressed ? 0.8 : 1)
            .focusEffectDisabled()
    }
    
}

#Preview {
    VStack {
        Button(action: {}) {
            Image(systemName: "message")
        }.buttonStyle(SidebarButton())
    }.frame(width: 500,height: 500)
}
