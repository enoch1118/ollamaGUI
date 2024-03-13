//
//  ModelListView.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/20/24.
//

import Combine
import SwiftUI

struct ModelListView: View {
    @Environment(\.injected) var container
    var model: ModelInfoModel

    @State var showProgress: Bool = false
    @State var showAlert: Bool = false
    @State var cancel = Set<AnyCancellable>()
    @State var subject = PassthroughSubject<Bool, Never>()

    var fetchModel: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(model.name)
                Spacer()
                Text(model.modifiedAt, style: .date)
            }
            Spacer()
            HStack {
                Spacer()
                Text(model.size.getSize)
                Button("remove") {
                    handleClick()
                }
            }

        }.padding(.vertical).padding(.horizontal, 0).frame(height: 80)
            .onReceive(subject, perform: handleReceive)
            .sheet(isPresented: $showProgress, content: {
                XProgressView(
                    progress: .constant(nil),
                    text: "delete model \(model.name)",
                    present: $showProgress
                )
            }).alert(isPresented: $showAlert, content: {
                Alert(
                    title: Text("error"),
                    message: Text("some error occurred when delete model"),
                    dismissButton: .default(Text("ok"))
                )
            })
    }
}

extension ModelListView {
    func handleClick() {
        subject = container.interactor.deleteModel(
            cancel: &cancel,
            model: model,
            setting: container.appSetting
        )
    }

    func handleReceive(_ value: Bool) {
        showProgress = value
        if showProgress {
            fetchModel()
        } else {
            showAlert.toggle()
        }
    }
}

#Preview {
    List {
//        ModelListView(model: .preview)
//        ModelListView(model: .preview)
//        ModelListView(model: .preview)
//        ModelListView(model: .preview)
//        ModelListView(model: .preview)
//        ModelListView(model: .preview)
    }.listStyle(.plain)
}
