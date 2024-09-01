//
//  V3ViewHelper.swift
//  ollamaGUI
//
//  Created by Window on 7/8/24.
//

import SwiftUI




extension View where Self: Shape {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
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
        var path = Path()
        path.addRect(.init(origin: .init(x: rect.origin.x - (padding / 2), y: rect.origin.y - (padding / 2)),
                           size:
                .init(width: rect.width + padding,
                      height: rect.height + padding)))
        return path
    }
}

struct GlowingContainer<Content, S>: View where Content: View, S: Shape {
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    @State var offset: Double = 0
    @Binding var glowing: Bool
    
    let maxValue:Double = 2
    var getRoofValue:Double {
        maxValue * sin(offset * 0.01) + maxValue
    }

    let content: () -> Content
    var shape: S

    init(shape: S,
         offset _: Double,glowing:Binding<Bool>, @ViewBuilder content: @escaping () -> Content)
    {
        self._glowing = glowing
        self.content = content
        self.shape = shape
    }

    var body: some View {
        GeometryReader{ geo in
            content()
                .background(
                    ZStack(alignment: .topLeading){
                        shape
                        if(glowing) { view in
                                view.glow(fill:
                                        AngularGradient(colors:
                                                            [.red, .orange, .yellow, .green, .blue, .purple, .orange, .red],
                                                        center: .center,angle: .degrees(offset)),
                                      lineWidth:  4)
                            
                        }
                            
                        shape
                        if(glowing){ view in
                            view..glow(fill:
                                        AngularGradient(colors:
                                                            [.red, .orange, .yellow, .green, .blue, .purple, .orange, .red],
                                                        center: .center,angle: .degrees(offset)),
                                      lineWidth: 4,blur: !glowing ? 0 : 4 * getRoofValue)

                        }
                                                }
                        
                )
        }.onReceive(timer, perform: { _ in
            offset += 1
        })
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

        GlowingContainer(shape: Capsule(), offset: 0,glowing: .constant(true)) {
            V3PlaceHolder(showLine: false)
        }.padding()
        
        GlowingContainer(shape: Capsule(), offset: 0,glowing: .constant(false)) {
            V3PlaceHolder(showLine: false)
        }.padding()

    }
}
