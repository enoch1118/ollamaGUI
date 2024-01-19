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
    @State var modelSubject = PassthroughSubject<Loadable<ModelList,
        NetworkError>, Never>(
    )

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
                }.flexTL
            }.flexTL

            Spacer()

        }.padding().frame(width: 600, height: 600, alignment: .leading)
            .onAppear(perform: fetchModels)
            .onReceive(modelSubject, perform: setModel)
    }
}

extension ModelManagerView {
    @ViewBuilder
    var installed: some View {
        ScrollView{
            VStack {
                ForEach(models, id: \.id) { model in
                    Text(model.name).id(model.id)
                }
            }
        }
    }
}

extension ModelManagerView {
    func fetchModels() {
        modelSubject = container.interactor.getModels(
            cancel: &bag,
            setting: container.appSetting
        )
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
}

#Preview {
    ModelManagerView(openModelManager: .constant(true))
}
