//
//  MessageInput.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/10/24.
//

import SwiftUI

struct MessageEditor: View {
    @State var text: String = ""
    @Binding var floating:Bool
    @Binding var showSetting:Bool
    @Binding var showLangchain:Bool
    @Binding var image: NSImage?
    @Binding var isLoading: Bool
    @ObservedObject var shiftController: KeyPressedController = .init()
    @FocusState var focused: Bool?
    var onSend: (String) -> Void
    var onClean: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            content
            HStack(spacing: 0) {
                Button(action: {
                    onClean()
                }) {
                    Image("MopIcon")
                }.buttonStyle(EditorButton(enabled: .constant(false)))
                Button(action: {
                    floating.toggle()
                }) {
                    Image("PinIcon")
                }.buttonStyle(EditorButton(enabled: $floating))
                Button(action: {
                    showSetting.toggle()
                }) {
                    Image("SettingIcon")
                }.buttonStyle(EditorButton(enabled: .constant(false)))
                Button(action: {
                    showLangchain.toggle()
                }) {
                    Image("ChainIcon")
                }.buttonStyle(EditorButton(enabled: .constant(false)))
                Spacer()
                

                Group{
                    if !isLoading {
                        Button("Send") {
                            onSend(text)
                            text = ""
                        }.buttonStyle(CommonButton(enabled: text.count > 0))
                    } else {
                        Button("Generating") {
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
                Text("Ask anything").foregroundStyle(.gray),
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

// #Preview {
//    MessageEditor()
// }
