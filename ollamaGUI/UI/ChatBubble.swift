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
            content.clipShape(BubbleShape(role: chat.role))
            if !chat.isMe {
                Spacer()
            }
        }.frame(maxWidth: .infinity)
            
    }

    @ViewBuilder
    var content: some View {
        Text(chat.content)
            .padding(.horizontal, 30)
            .padding(.vertical, 16)
            .background((chat.role == .user) ? .blue : .white)
            .foregroundColor((chat.role == .user) ? .white : .black)
    }
}

#Preview {
    VStack {
        ChatBubble(chat: .init(type: RoleEnum.user))
        ChatBubble(chat: .init(type: RoleEnum.assistant))
    }
}
