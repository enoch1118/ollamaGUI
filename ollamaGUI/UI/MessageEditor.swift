//
//  MessageInput.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/10/24.
//

import SwiftUI

struct MessageEditor: View {
    @State var text: String = ""
    @Binding var image:NSImage?
    @ObservedObject var shiftController: KeyPressedController = .init()
    var onSend: (String) -> Void

    var body: some View {
        VStack(spacing: 0) {
            content
            HStack {
                Spacer()
                if image != nil{
                    Image(nsImage: image!).resizable().frame(width: 50,height: 50)
                }
                
                Button("전송") {
                    onSend(text)
                    text = ""
                }.buttonStyle(CommonButton(enabled: text.count > 0)).padding()
            }
        }
        .background(.white)
        .frame(maxWidth: .infinity, minHeight: 0, idealHeight: 100)
    }

    @ViewBuilder
    var content: some View {
        TextEditor(text: $text)
            .placeHolder(
                Text("무엇이든 물어보세요").foregroundStyle(.gray),
                show: text.isEmpty
            )
            .font(.body)
            .frame(height: 50)
            .fixedSize(
                horizontal: false,
                vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/
            )
            .scrollContentBackground(.hidden)
            .textFieldStyle(.plain)
            .focusEffectDisabled()
            .padding(.horizontal)
            .padding(.top)
            .foregroundColor(.black)
            .onChange(of: text) { oldV, _ in
                guard let isReturn = text.last, isReturn == "\n" else {
                    return
                }
                if shiftController.isShiftPressed {
                    return
                } else {
                    text = ""
                    onSend(oldV)
                }
            }
    }
}

#Preview {
    ChatView(chats: ChatModel.testValue)
}

// #Preview {
//    MessageEditor()
// }
