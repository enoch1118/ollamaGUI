//
//  SwiftUIView.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/10/24.
//

import SwiftUI

struct ChatView: View {
    @State var chats: [ChatModel]

    init(chats: [ChatModel] = []) {
        self.chats = chats
    }

    var body: some View {
        VStack{
            ScrollView{
                LazyVStack(spacing: 0) {
                    ForEach(chats, id: \.self) { chat in
                        ChatBubble(chat: chat).padding(.vertical,12)
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            MessageEditor()
        }
        
    }
}

#Preview {
    ContentView()
}

#Preview {
    ChatView(chats: ChatModel.testValue)
}
