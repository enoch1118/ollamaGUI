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
            .opacity(configuration.isPressed ? 0.8 : 1)
            .padding(.vertical, 7)
            .padding(.horizontal, 15)
            .frame(minWidth: 48, minHeight: 48)
            .foregroundColor(.white)
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
