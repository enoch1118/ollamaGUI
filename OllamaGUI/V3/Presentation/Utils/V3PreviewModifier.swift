//
//  V3PreviewWrapper.swift
//  ollamaGUI
//
//  Created by DATES on 6/17/24.
//

import Foundation
import SwiftUI

struct V3PreviewWrapper: View {
    @ViewBuilder
    var child: some View
    
    init(child: some View) {
        self.child = child
    }
    
    var body: some View {
        child
            .frame(minWidth: 390, maxWidth: 390,
                   minHeight: 640, idealHeight: 640)
            .preferredColorScheme(.dark)
            
        
    }
    
}
