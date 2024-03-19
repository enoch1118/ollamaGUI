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

    private static var `default`: DIContainer {
        let session = SessionManager()
        let ollamaDs = OllamaDatasourceImpl(baseUrl: "", session: session.session)
        let ollamaRp = OllamaRepositoryImpl(
            dataSource: ollamaDs
        )
        return Self(
            ollamaDs: ollamaDs,
            langchainusecase: .init(
                embedingRepository: ollamaRp,
                crawlingRepository: CrawlingRepositoryImpl(
                    datasource: WebDatasourceImpl(session: session.session)
                )
            ),
            chatusecase: .init(ollamaRepository: ollamaRp),
            interactor: RealOllamaInteractor(),
            dataInteractor: RealDataInteractor(),
            appSetting: .init(ollamaDs: ollamaDs),
            updateTrigger: .init()
        )
    }

    private static var preview: DIContainer {
        let session = SessionManager()
        let ollamaDs = OllamaDatasourceImpl(baseUrl: "", session: session.session)
        let ollamaRp = OllamaRepositoryImpl(
            dataSource: OlamaDatasourceStub(
                baseUrl: "",
                session: session.session
            )
        )
        return Self(
            ollamaDs: ollamaDs,
            langchainusecase: .init(
                embedingRepository: ollamaRp,
                crawlingRepository: CrawlingRepositoryImpl(
                    datasource: WebDatasourceStub()
                )
            ),

            chatusecase: .init(ollamaRepository: ollamaRp),
            interactor: RealOllamaInteractor(),
            dataInteractor: StubDataInteractor(),
            appSetting: .init(ollamaDs: ollamaDs),
            updateTrigger: .init()
        )
    }

    let ollamaDs: OllamaDatasource
    let langchainusecase: LangchainUsecase
    let chatusecase: ChatUsecase
    let interactor: OllamaInteractor
    let dataInteractor: DataInteractor
    let appSetting: AppSetting
    let updateTrigger: UpdateTrigger
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
