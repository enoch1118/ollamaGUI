//
//  StopButton.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import SwiftUI

struct StopButton: View {
    
    var onCancel:()->Void
    var body: some View {
        Button(action: {onCancel()}, label: {
            Label("STOP",systemImage: "stop.fill")
        }).buttonStyle(CommonButton())
    }
}

