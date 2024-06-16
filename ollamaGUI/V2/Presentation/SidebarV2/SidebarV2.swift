//
//  SidebarV2.swift
//  ollamaGUI
//
//  Created by 배상휘 on 2/18/24.
//

import SwiftUI

struct SidebarV2: View {
    @Environment(\.injected) var container: DIContainer
    @Binding var rooms: [LocalRoomModel]
    @Binding var selected: LocalRoomModel?

    var onSelect: (LocalRoomModel) -> Void
    var onInsert: () -> Void
    var onDelete: (LocalRoomModel) -> Void
    
    
    @ObservedObject var viewModel:SidebarV2ViewModel = .init()

    var body: some View {
        VStack {
            Spacer().frame(height: 35)
            Button(action: {}) {
                Image(systemName: "message").resizable()
            }.buttonStyle(SidebarButton())
            Spacer()
            Group {
                switch viewModel.state {
                    case .initState:
                        Color.gray
                    case .disconnected:
                        Color.red
                    case .connected:
                        Color.green
                }
            }.frame(width: 15, height: 15)
                .clipShape(Circle())
                .shadow(radius: 5)
            Button(action: {
                viewModel.showSetting.toggle()
            }) {
                Image(systemName: "gear").resizable()
            }.buttonStyle(SidebarButton())
            Spacer().frame(height: 35)

        }.onAppear {
            viewModel.ignite(container: container)
            viewModel.check()
        }
        .sheet(isPresented: $viewModel.showSetting, content: {
            SettingView(showSetting: $viewModel.showSetting)
        })
    }
}
