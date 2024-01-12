//
//  BubbleShape.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/10/24.
//

import Foundation
import SwiftUI

struct BubbleShape: Shape {
    let role: RoleEnum

    func path(in rect: CGRect) -> Path {
        return (role == .user) ? rightBubble(in: rect) : leftBubble(in: rect)
    }

    func rightBubble(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height

        let path = Path { p in
            p.move(to: CGPoint(x: 16, y: 16))
            p.addCurve(to: CGPoint(x: 32, y: 0),
                       control1: CGPoint(x: 16, y: 8),
                       control2: CGPoint(x: 24, y: 0))
            p.addLine(to: CGPoint(x: w - 8, y: 0))
            p.addLine(to: CGPoint(x: w - 16, y: 8))
            p.addLine(to: CGPoint(x: w - 16, y: h - 16))

            p.addCurve(to: CGPoint(x: w - 32, y: h),
                       control1: CGPoint(x: w - 16, y: h - 8),
                       control2: CGPoint(x: w - 24, y: h))

            p.addLine(to: CGPoint(x: 32, y: h))
            p.addCurve(to: CGPoint(x: 16, y: h - 16),
                       control1: CGPoint(x: 24, y: h),
                       control2: CGPoint(x: 16, y: h - 8))

            p.addLine(to: CGPoint(x: 16, y: h))
        }

        return path
    }

    func leftBubble(in rect: CGRect) -> Path {
            let w = rect.width
            let h = rect.height

            let path = Path { p in
                // Flip the x-coordinates of each point by subtracting them from the width
                p.move(to: CGPoint(x: w - 16, y: 16))
                p.addCurve(to: CGPoint(x: w - 32, y: 0),
                           control1: CGPoint(x: w - 16, y: 8),
                           control2: CGPoint(x: w - 24, y: 0))
                p.addLine(to: CGPoint(x: 8, y: 0))
                p.addLine(to: CGPoint(x: 16, y: 8))
                p.addLine(to: CGPoint(x: 16, y: h - 16))

                p.addCurve(to: CGPoint(x: 32, y: h),
                           control1: CGPoint(x: 16, y: h - 8),
                           control2: CGPoint(x: 24, y: h))

                p.addLine(to: CGPoint(x: w - 32, y: h))
                p.addCurve(to: CGPoint(x: w - 16, y: h - 16),
                           control1: CGPoint(x: w - 24, y: h),
                           control2: CGPoint(x: w - 16, y: h - 8))

                p.addLine(to: CGPoint(x: w - 16, y: h))
            }

            return path
        }

}

#Preview {
    VStack {
        ChatBubble(chat: .init(type: RoleEnum.user))
        ChatBubble(chat: .init(type: RoleEnum.assistant))
    }
}
