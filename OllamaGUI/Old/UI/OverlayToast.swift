//
//  OverlayToast.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/18/24.
//

import SwiftUI

struct OverlayToast: View {
    var text: String = "preview"

    @State private var width: Double = 0
    @State private var opacity: Double = 0
    @State private var offsetY: Double = 20

    var body: some View {
        GeometryReader { geo in

            Text(text)
                .font(.body)
                .lineLimit(1)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: width)
                .position(CGPoint(x: geo.size.width / 2,
                                  y: geo.size.height - 170))
                .offset(y: offsetY)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.snappy) {
                        width = Double(text.count * 14 + 16)
                        opacity = 1
                        offsetY = 0
                    }

                    DispatchQueue.global()
                        .asyncAfter(deadline: .now() + 3) { [self] in
                            DispatchQueue.main.async { [self] in
                                withAnimation(.snappy) {
                                    width = 0
                                    opacity = 0
                                    offsetY = 20
                                }
                            }
                        }
                }
        }
    }
}

#Preview {
    ChatView(
        show: .constant(true),
        position: .constant(.zero),
        floating: .constant(true),
        room: .randomRoom
    )
}
