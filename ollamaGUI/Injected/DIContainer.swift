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
    static var previewValue: Self { Self.preview }

    private static let `default` = Self(
        interactor: RealOllamaInteractor(baseUrl: "http://localhost:11434/api/"),
        dataInteractor: RealDataInteractor(),
        appSetting: .init(),
        updateTrigger: .init()
    )
    
    private static let preview = Self(
        interactor: RealOllamaInteractor(baseUrl: "http://localhost:11434/api/"),
        dataInteractor: StubDataInteractor(),
        appSetting: .init(),
        updateTrigger: .init()
    )

    let interactor: OllamaInteractor
    let dataInteractor: DataInteractor
    let appSetting:AppSetting
    let updateTrigger:UpdateTrigger

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
        let container = DIContainer.previewValue
        return environment(\.injected, container).environment(\.isPreview, true)
    }
}

struct PreviewKey: EnvironmentKey {
    static let defaultValue = false
}
