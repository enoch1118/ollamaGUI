//
//  ChatBubble.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/10/24.
//

import SwiftUI

struct ChatBubble: View {
    var chat: ChatModel

    var body: some View {
        HStack{
            if chat.isMe {
                Spacer()
            }
            content.clipShape(BubbleShape(role: chat.message?.role ?? .user))
            if !chat.isMe {
                Spacer()
            }
        }.frame(maxWidth: .infinity)
            
    }

    @ViewBuilder
    var content: some View {
        Text(chat.message?.content ?? "")
            .padding(.horizontal, 30)
            .padding(.vertical, 16)
            .background((chat.isMe) ? .blue : .white)
            .foregroundColor((chat.isMe) ? .white : .black)
    }
}

#Preview {
    VStack {
        ChatBubble(chat: .init(type: RoleEnum.user))
        ChatBubble(chat: .init(type: RoleEnum.assistant))
    }
}
