//
//  KeyPressedController.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import Foundation
import Cocoa

class KeyPressedController: ObservableObject {
    @Published var isShiftPressed = false

    init() {
        NSEvent
            .addLocalMonitorForEvents(matching: .flagsChanged) { [weak self] event -> NSEvent? in
                if event.modifierFlags.contains(.shift) {
                    self?.isShiftPressed = true
                } else {
                    self?.isShiftPressed = false
                }
                return event
            }
    }
}
