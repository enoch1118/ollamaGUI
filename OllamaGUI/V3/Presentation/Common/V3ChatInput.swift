//
//  V3ChatInput.swift
//  ollamaGUI
//
//  Created by 배상휘 on 7/7/24.
//

import Foundation
import SwiftUI

struct V3ChatInput: View {
    @Binding var text:String
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "message.circle")
                    .imageScale(.large)
                    .padding()
                TextField("Ask Ollama",text:$text)
                    .textFieldStyle(.plain)
                    .frame(maxWidth: .infinity,minHeight: 44)
                    .scrollContentBackground(.hidden).frame(width: .infinity)
            }
        }.background(Capsule()
            .fill(.thickMaterial)
            .shadow(color: .black,radius: 4)
        )
        .frame(width: .infinity,height: 44)
    }
}


#Preview {
    V3ChatInput(text: .constant("text editor")).padding()
}
