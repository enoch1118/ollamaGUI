//
//  SideBar.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/9/24.
//

import Combine
import SwiftUI

struct SideBar: View {
    @Environment(\.injected) var container: DIContainer
    @Binding var rooms: [RoomEntity]
    @Binding var selected: RoomEntity?

    @State private var cancel = Set<AnyCancellable>()
    @State private var subject = CurrentValueSubject<Bool, Never>(false)
    @State private var status: Bool = false
    @State private var showSetting: Bool = false
    var onSelect: (RoomEntity) -> Void
    var onInsert: () -> Void
    var onDelete: (RoomEntity) -> Void

    var body: some View {
        VStack {
            Spacer().frame(height: 35)
            Button(action: {}) {
                Image(systemName: "message").resizable()
            }.buttonStyle(SidebarButton())
            Spacer()
            Group {
                if status {
                    Color.green
                } else {
                    Color.red
                }
            }.frame(width: 15, height: 15)
                .clipShape(Circle())
                .shadow(radius: 5)
            Button(action: {
                showSetting.toggle()
            }) {
                Image(systemName: "gear").resizable()
            }.buttonStyle(SidebarButton())
            Spacer().frame(height: 35)

        }.onAppear {
            subject = container.interactor.checkNetwork(
                cancel: &cancel,
                setting: container.appSetting,
                baseUrl: nil,
                isTest: false
            )
        }.onReceive(subject, perform: { status in
            self.status = status
        })
        .sheet(isPresented: $showSetting, content: {
            SettingView(showSetting: $showSetting)
        })
    }
}

#Preview {
    RootView().injectPreview()
}
