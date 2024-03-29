//
//  ModelManager.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/19/24.
//

import Combine
import SwiftUI

struct ModelManagerView: View {
    @Environment(\.injected) private var container

    @State var models: [ModelInfoModel] = []
    @State var libraryModels : [OllamaModel] = []
    @State var modelSubject = PassthroughSubject<Loadable<ModelList,
        NetworkError>, Never>(
    )
    @State var ollamaSubject = PassthroughSubject<
        Loadable<String, NetworkError>,
        Never
    >()

    @Binding var openModelManager: Bool

    @State var bag = Set<AnyCancellable>()
    var body: some View {
        VStack {
            HStack {
                Text("ModelManager").font(.title)
                    .frame(
                        maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/,
                        alignment: .leading
                    )
                Spacer()
                Button(action: { openModelManager = false }, label: {
                    Image(systemName: "xmark")
                }).buttonStyle(SidebarButton())
            }
            HStack {
                VStack {
                    Text("Installed").font(.title2).textLeft
                    installed
                }.flexTL
                VStack {
                    Text("Library").font(.title2).textLeft
                    library
                }.flexTL
            }.flexTL

            Spacer()

        }.padding().frame(width: 600, height: 600, alignment: .leading)
            .onAppear(perform: fetchModels)
            .onReceive(modelSubject, perform: setModel)
            .onReceive(ollamaSubject, perform: fetchModel)
    }
}

extension ModelManagerView {
    @ViewBuilder
    var installed: some View {
        List {
            ForEach(models, id: \.id) { model in
                ModelListView(model: model,fetchModel:fetchModels)
                    .listRowInsets(EdgeInsets(top: 10, leading: -10, bottom: 10,
                                              trailing: -10))
            }
        }
        .clipped()
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    var library: some View{
        List {
            ForEach(libraryModels, id: \.id) { model in
                LibraryModelListView(model: model,installed: $models,onUpdate:onUpdate)
                    .listRowInsets(EdgeInsets(top: 10, leading: -10, bottom: 10,
                                              trailing: -10))
            }
        }
        .clipped()
        .frame(maxWidth: .infinity)
        
    }
}

extension ModelManagerView {
    func onUpdate() {
        fetchModels()
        container.updateTrigger.triggerNewModel()
    }
    func fetchModels() {
        modelSubject = container.interactor.getModels(
            cancel: &bag,
            setting: container.appSetting
        )

        ollamaSubject = container.interactor.fetchModels(cancel: &bag)
    }

    func setModel(_ value: Loadable<ModelList,
        NetworkError>)
    {
        switch value {
        case let .loaded(list):
            models = list.models
            return
        default:
            return
        }
    }

    func fetchModel(_ value: Loadable<String,
        NetworkError>)
    {
        switch value {
        case let .loaded(data):
            libraryModels = data.getModelsFromOllama()
            return
        default:
            return
        }
    }
}

#Preview {
    ModelManagerView(openModelManager: .constant(true))
}
