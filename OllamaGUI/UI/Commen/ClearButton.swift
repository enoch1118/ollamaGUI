//
//  ClearButton.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import Foundation
import SwiftUI

struct ClearButton: ButtonStyle {
    private var enabled: Bool = true

    init(enabled: Bool = true) {
        self.enabled = enabled
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.8 : 1)
            .padding(.vertical, 8)
            .padding(.horizontal, 15)
            .frame(minWidth: 48, minHeight: 0)
            .foregroundColor(.white)
            .focusEffectDisabled()
            .background(.clear)
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }
}

#Preview {
    VStack {
        Button(action: {}) {
            Text("전송")
        }.buttonStyle(ClearButton())
        Button(action: {}) {
            Text("전송")
        }.buttonStyle(ClearButton(enabled: false))

    }.frame(width: 500, height: 500)
}
