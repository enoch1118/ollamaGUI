//
//  SettingView.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/18/24.
//

import Combine
import SwiftUI

struct SettingView: View {
    @Environment(\.injected) var container: DIContainer
    @Environment(\.modelContext) var context

    @Binding var showSetting: Bool
    @State var baseUrl: String = ""
    @State var savedUrl: String = ""
    @State var baseUrlErrorMsg: String? = nil
    @State var selectedModel: String = ""
    @State var models: [ModelInfoModel]? = nil
    @State var openModelManager = false

    @State private var networkPassed: Bool? = nil
    @State private var networkSubject = CurrentValueSubject<Bool, Never>(false)
    @State private var modelSubject = PassthroughSubject<
        Loadable<ModelList, NetworkError>,
        Never
    >()
    @State private var updateSubject = CurrentValueSubject<TriggerModel,
        Never>(.init())
    @State private var bag = Set<AnyCancellable>()

    var body: some View {
        VStack {
            HStack {
                Text("Settings").font(.title)
                    .frame(
                        maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/,
                        alignment: .leading
                    )
                Spacer()
                Button(action: { showSetting = false }, label: {
                    Image(systemName: "xmark")
                }).buttonStyle(SidebarButton())
            }
            Text("Network").font(.title2).textLeft
            inputUrl
            Text("Model").font(.title2).textLeft
            selectModel

        }.padding().frame(width: 400, height: 300, alignment: .leading)
            .onReceive(networkSubject, perform: { val in
                networkPassed = val
            }).onAppear {
                updateSubject = container.updateTrigger.subject
                selectedModel = container.appSetting.model
                savedUrl = container.appSetting.baseUrl
                modelSubject = container.interactor.getModels(
                    cancel: &bag,
                    setting: container.appSetting
                )
            }.sheet(isPresented: $openModelManager, content: {
                ModelManagerView(openModelManager: $openModelManager)
            }).onReceive(updateSubject, perform: { value in
                if value.newModel {
                    modelSubject = container.interactor.getModels(
                        cancel: &bag,
                        setting: container.appSetting
                    )
                    container.updateTrigger.newModelHandled()
                }

            })
    }
}

extension SettingView {
    @ViewBuilder
    var selectModel: some View {
        Group {
            HStack {
                Picker("choose a model", selection: $selectedModel) {
                    if models != nil {
                        ForEach(models!.map { $0.name },
                                id: \.hashValue) { val in
                            Text(val).tag(val)
                        }
                    }
                }
            }
            HStack {
                Spacer()
                Button(
                    action: {
                        openModelManager.toggle()
                    },
                    label: {
                        Text("model manager")
                    }
                )
            }
            Spacer()
        }.onReceive(modelSubject, perform: { value in
            switch value {
            case let .loaded(list):
                models = list.models
                return
            default:
                return
            }
        }).onChange(of: selectedModel) { _, newValue in
            container.appSetting.updateModel(newValue)
        }
    }
}

extension SettingView {
    @ViewBuilder
    var inputUrl: some View {
        Group {
            VStack {
                HStack {
                    Text("Base url")
                    Spacer()
                    TextField(savedUrl, text: $baseUrl)
                        .onChange(of: baseUrl) { _, new in
                            if new.isEmpty {
                                return
                            }
                            if new.verifyUrl {
                                baseUrlErrorMsg = nil
                            } else {
                                baseUrlErrorMsg = "invalid url"
                            }
                        }
                }
                if baseUrlErrorMsg !=
                    nil
                {
                    Label(
                        baseUrlErrorMsg!,
                        systemImage: "exclamationmark.triangle"
                    ).textLeft
                        .foregroundColor(.red)
                }
            }
            HStack {
                Spacer()
                Button(
                    action: {
                        networkSubject = container.interactor.checkNetwork(
                            cancel: &bag,
                            setting: container.appSetting,
                            baseUrl: baseUrl,
                            isTest: true
                        )
                    },
                    label: {
                        HStack(alignment: .lastTextBaseline) {
                            if networkPassed != nil {
                                Circle()
                                    .foregroundColor(networkPassed! ? .green :
                                        .red)
                                    .frame(width: 8, height: 8,
                                           alignment: .center)
                            }
                            Text("test connection")
                        }
                    }
                )
                .disabled(baseUrlErrorMsg != nil || baseUrl.isEmpty)
                Button(
                    action: {
                        container.appSetting.updateBaseUrl(baseUrl)
                        savedUrl = container.appSetting.baseUrl
                        baseUrl = ""

                    },
                    label: {
                        Text("save")
                    }
                )
                .disabled((baseUrlErrorMsg != nil || baseUrl.isEmpty) ||
                    !(networkPassed ?? true))
            }
        }
    }
}

#Preview {
    SettingView(showSetting: .constant(true))
}
