//
//  MessageInput.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/10/24.
//

import SwiftUI

struct MessageEditor: View {
    @State var text: String = ""
    @Binding var image: NSImage?
    @Binding var isLoading: Bool
    @ObservedObject var shiftController: KeyPressedController = .init()
    @FocusState var focused: Bool?
    var onSend: (String) -> Void
    var onClean: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            content
            HStack {
                Spacer()
                if image != nil {
                    Image(nsImage: image!).resizable()
                        .frame(width: 50, height: 50)
                }

                Group{
                    if !isLoading {
                        Button("전송") {
                            onSend(text)
                            text = ""
                        }.buttonStyle(CommonButton(enabled: text.count > 0))
                    } else {
                        Button("생성중") {
                        }.buttonStyle(CommonButton(enabled: false))
                    }
                    
                }.frame(height: 44).padding()
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
            .focused($focused, equals: true)
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
                } else if !isLoading && !text.isEmpty{
                    text = ""
                    onSend(oldV)
                }
            }.onAppear {
                self.focused = true
            }
    }
}

#Preview {
    ChatView(room: RoomEntity()).injectPreview()
}

// #Preview {
//    MessageEditor()
// }
