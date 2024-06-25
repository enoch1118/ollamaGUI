//
//  Injection.swift
//  ollamaGUI
//
//  Created by DATES on 6/17/24.
//

import Foundation
import SwiftUI

struct Injection: EnvironmentKey {
    static var defaultValue: Self { Self.default }
    static var previewValue: Self { preview }

    private static var `default`: Injection {
        Self()
    }

    private static var preview: Injection {
        Self()
    }
}
