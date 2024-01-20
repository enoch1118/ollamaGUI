//
//  LibraryModelList.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/20/24.
//

import SwiftUI

struct LibraryModelListView: View {
    var model: OllamaModel
    @State var showTags = false
    @Binding var installed:[ModelInfoModel]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(model.title)
                Spacer()
                Text(model.updatedAt)
            }
            Text(model.desc).textLeft.font(.body).foregroundColor(.gray)
            Spacer()
            HStack {
                Text(model.pulls)
                Text(model.tagsCount)
                Spacer()
                Button("show tags") {
                    showTags.toggle()
                }
            }

        }.padding(.vertical).padding(.horizontal,0).frame(height: 80)
            .sheet(isPresented: $showTags, content: {
                TagsView(showTags:$showTags, model: model, installed:installed)
            })
    }
}

#Preview {
    List{
        LibraryModelListView(model: OllamaModel(),installed:.constant([]))
    }.listStyle(.plain)
}
