//
//  V3ViewHelper.swift
//  ollamaGUI
//
//  Created by Window on 7/8/24.
//

import SwiftUI

extension View where Self: Shape {
    func glow(
        fill: some ShapeStyle,
        lineWidth: Double,
        blur: Double = 3.0
    ) -> some View {
        stroke(style: .init(lineWidth: lineWidth / 2, lineCap: .round))
            .fill(fill)
            .overlay {
                self
                    .stroke(style: .init(lineWidth: lineWidth, lineCap: .round))
                    .fill(fill)
                    .blur(radius: blur)
                    .clipShape(BigRect(padding: 40).subtracting(Capsule(), eoFill: true))
            }
            .overlay {
                self
                    .stroke(style: .init(lineWidth: lineWidth, lineCap: .round))
                    .fill(fill)
                    .blur(radius: blur)
                    .clipShape(BigRect(padding: 40).subtracting(Capsule(), eoFill: true))
            }
    }
}

private struct BigRect: Shape {
    var padding : Double
    
    func path(in rect: CGRect) -> Path {
        var oriX = rect.minX
        var oriY = rect.minY
        var path = Path()
        path.addRect(.init(origin: .init(x: rect.origin.x - (padding / 2), y: rect.origin.y - (padding / 2)),
                           size:
                .init(width: rect.width + padding,
                      height: rect.height + padding)))
        return path
    }
}

private struct GlowingContainer<Content, S>: View where Content: View, S: Shape {
    @State var offset: Double = 0

    let content: () -> Content
    var shape: S

    init(shape: S,
         offset _: Double, @ViewBuilder content: @escaping () -> Content)
    {
        self.content = content
        self.shape = shape
    }

    var body: some View {
        GeometryReader{ geo in
            content()
                .background(
                    ZStack(alignment: .topLeading){
                        shape
                            .glow(fill:
                                    AngularGradient(colors:
                                                        [.red, .orange, .yellow, .green, .blue, .purple, .orange, .red],
                                                    center: .center),
                                  lineWidth: 4)
                        shape
                            .glow(fill:
                                    AngularGradient(colors:
                                                        [.red, .orange, .yellow, .green, .blue, .purple, .orange, .red],
                                                    center: .center),
                                  lineWidth: 4,blur: 8)
                    }
                        
                )
        }
    }
}

#Preview {
    VStack {
        V3PlaceHolder()
            .background {
                Capsule()
                    .glow(fill:
                        AngularGradient(colors: [.red, .orange, .yellow, .green, .blue, .purple, .orange, .red], center: .center),
                        lineWidth: 4)
            }

        GlowingContainer(shape: Capsule(), offset: 0) {
            V3PlaceHolder(showLine: false)
        }.padding()
    }
}
