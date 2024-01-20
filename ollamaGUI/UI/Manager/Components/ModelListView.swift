//
//  ModelListView.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/20/24.
//

import SwiftUI

struct ModelListView: View {
    var model: ModelInfoModel

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
                Button("remove") {}.disabled(true)
            }

        }.padding(.vertical).padding(.horizontal,0).frame(height: 80)
    }
}

#Preview {
    List {
        ModelListView(model: .preview)
        ModelListView(model: .preview)
        ModelListView(model: .preview)
        ModelListView(model: .preview)
        ModelListView(model: .preview)
        ModelListView(model: .preview)
    }.listStyle(.plain)
}
