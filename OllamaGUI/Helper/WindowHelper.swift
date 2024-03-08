//
//  WindowHelper.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/18/24.
//

import Foundation
import SwiftUI

struct WindowAccessor: NSViewRepresentable {
    @Binding var window: NSWindow?

    func makeNSView(context _: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.window = view.window
        }
        return view
    }

    func updateNSView(_: NSView, context _: Context) {}
}
