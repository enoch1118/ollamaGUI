//
//  ProgressView.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/22/24.
//

import SwiftUI

struct XProgressView: View {
    @Binding var progress: Float?
    var text: String

    @Binding var present: Bool
    var body: some View {
        VStack {
            Text(text).font(.body).padding()
            if progress != nil {
                ProgressView(value: progress)
                    .frame(maxWidth: .infinity, minHeight: 20, maxHeight: 20)
                    .padding(.bottom).padding(.horizontal)
            } else {
                ProgressView()
                    .controlSize(.small).padding(.bottom)
            }
        }.frame(width: 300, height: 100)
    }
}

#Preview {
    XProgressView(
        progress: .constant(nil),
        text: "this is Text",
        present: .constant(true)
    )
}

#Preview {
    XProgressView(
        progress: .constant(0.5),
        text: "this is Text",
        present: .constant(true)
    )
}
