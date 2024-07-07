//
//  V3HomeView.swift
//  ollamaGUI
//
//  Created by DATES on 6/17/24.
//

import Foundation
import SwiftUI

struct V3HomeView: View {
    var body: some View {
        GeometryReader{ geo in
            ZStack(alignment:.bottom){
                V3HomeContentView()
                V3ChatInput(text: .constant(""))
                    .padding()
            }
        }
    }
}

struct V3HomeContentView: View {
    var body: some View {
        ScrollView{
            VStack(alignment:.leading){
                Text("Your server is Connected {server addr:port}")
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding()
                
            }
        }
    }
    
}

#Preview {
    V3HomeView()
        .v3PreviewModifier
}
