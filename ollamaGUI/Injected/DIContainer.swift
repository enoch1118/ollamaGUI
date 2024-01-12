//
//  DIContainer.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/11/24.
//

import Foundation
import SwiftUI

struct DIContainer: EnvironmentKey {
    static var defaultValue: Self { Self.default }

    private static let `default` = Self(
        interactor: RealOllamaInteractor(baseUrl: "http://localhost:11434/api/")
    )

    let interactor: OllamaInteractor
}

extension EnvironmentValues {
    var injected: DIContainer {
        get { self[DIContainer.self] }
        set { self[DIContainer.self] = newValue }
    }

    var isPreview: Bool {
        get { self[PreviewKey.self] }
        set { self[PreviewKey.self] = newValue }
    }
}

extension View {
    func inject() -> some View {
        let container = DIContainer.defaultValue
        return inject(container)
    }

    func inject(_ container: DIContainer) -> some View {
        return environment(\.injected, container)
    }

    func injectPreview() -> some View {
        let container = DIContainer.defaultValue
        return environment(\.injected, container).environment(\.isPreview, true)
    }
}

struct PreviewKey: EnvironmentKey {
    static let defaultValue = false
}
