//
//  MessageInput.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/10/24.
//

import SwiftUI

struct MessageEditor: View {
    @State var text: String = ""
    var onSend:(String)->Void
    
    var body: some View {
        VStack(spacing: 0){
            content
            HStack{
                Spacer()
                Button("전송"){
                    onSend(text)
                    text = ""
                }.buttonStyle(CommonButton()).padding(.horizontal,8).padding(.vertical,8)
            }
        }
        .background(.white)
        .frame(maxWidth: .infinity, minHeight: 0, idealHeight: 100)
    }

    @ViewBuilder
    var content: some View {
        TextEditor(text: $text)
            .placeHolder(Text("무엇이든 물어보세요").foregroundStyle(.gray), show: text.isEmpty)
            .font(.body)
            .frame(height: 50)
            .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .scrollContentBackground(.hidden)
            .textFieldStyle(.plain)
            .focusEffectDisabled()
            .padding(.horizontal)
            .padding(.top)
            .foregroundColor(.black)
    }
}

#Preview {
    ChatView(chats: ChatModel.testValue)
}

// #Preview {
//    MessageEditor()
// }
