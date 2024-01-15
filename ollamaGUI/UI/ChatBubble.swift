//
//  ChatBubble.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/10/24.
//

import MarkdownUI
import SwiftUI

struct ChatBubble: View {
    var chat: ChatModel

    var body: some View {
        HStack {
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
        let message = (chat.message?.content ?? "").removeFirstBreakLine
        Markdown {
            message
        }
        .markdownTheme((chat.isMe) ? .user : .assistant)
        .padding(.horizontal, 30)
        .padding(.vertical, 16)
        .foregroundColor((chat.isMe) ? .white : .black)
                    .background((chat.isMe) ? .blue : .white)


//        Text(.init(message))
//            .padding(.horizontal, 30)
//            .padding(.vertical, 16)
//            .background((chat.isMe) ? .blue : .white)
//            .foregroundColor((chat.isMe) ? .white : .black)
    }
    
}

#Preview {
    VStack {
        ChatBubble(chat: .init(type: RoleEnum.user))
        ChatBubble(chat: .init(type: RoleEnum.assistant))
    }
}
