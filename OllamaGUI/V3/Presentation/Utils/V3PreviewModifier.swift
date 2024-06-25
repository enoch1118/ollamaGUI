//
//  V3PreviewModifier.swift
//  ollamaGUI
//
//  Created by DATES on 6/17/24.
//

import Foundation
import SwiftUI

struct V3PreviewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth: 390, maxWidth: 390,
                   minHeight: 640, idealHeight: 640)
            .preferredColorScheme(.dark)
            .presentedWindowStyle(HiddenTitleBarWindowStyle())
    }
}

extension View {
    var v3PreviewModifier: some View {
        modifier(V3PreviewModifier())
    }
}
