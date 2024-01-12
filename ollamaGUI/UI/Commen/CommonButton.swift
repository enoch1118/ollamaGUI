//
//  CommonButton.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/11/24.
//

import SwiftUI

struct CommonButton: ButtonStyle {
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
            .background(enabled ? .blue: .gray)
            .clipShape(RoundedRectangle(cornerRadius: 3))
    }
}

#Preview {
    VStack {
        Button(action: {}) {
            Text("전송")
        }.buttonStyle(CommonButton())
        Button(action: {}) {
            Text("전송")
        }.buttonStyle(CommonButton(enabled: false))

    }.frame(width: 500, height: 500)
}
