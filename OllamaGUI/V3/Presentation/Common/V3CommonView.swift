//
//  V3CommonView.swift
//  ollamaGUI
//
//  Created by 배상휘 on 7/7/24.
//

import Foundation
import SwiftUI


struct V3PlaceHolder: View {
    var body: some View {
        VStack {
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                Path{ path in
                    path.move(to: CGPoint(x:0,y:0))
                    path.addLine(to: CGPoint(x:w,y:h))
                }.stroke(.black)
                
                Path{ path in
                    path.move(to: CGPoint(x:w,y:0))
                    path.addLine(to: CGPoint(x:0,y:h))
                }.stroke(.black)

            }
            
        }.background(Rectangle().fill(.clear).border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/))
    }
}

struct V3MuseContainer:View {
    var body: some View {
        V3PlaceHolder()
            .clipShape(Capsule())
            .background{
                Capsule()
                    .strokeBorder(
                        AngularGradient(colors: [
                            .red,.orange,.yellow,.green,.blue,.purple,
                            .red,.orange,.yellow,.green,.blue,.purple
                            ], center: .center)
                    )
                    .blur(radius: 3)
                    .clipShape(Capsule())
              }
    }
}


#Preview {
    VStack{
        V3PlaceHolder().padding()
        V3MuseContainer().padding()
        
    }
}
