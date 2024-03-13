//
//  RootView.swift
//  ollamaGUI
//
//  Created by 배상휘 on 2/18/24.
//

import SwiftUI
import SwiftUIIntrospect

struct RootView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.injected) private var container

    @ObservedObject private var viewModel = RootViewModel()

    var body: some View {
        Group {
            if viewModel.window != nil && viewModel.settingLoaded {
                root.onAppear {
                    viewModel.afterWindowSet()
                }
            } else {
                EmptyView()
            }
        }
        .onAppear {
            viewModel.setup(container, context)
            viewModel.beforeWindowSet()
        }.background {
            WindowAccessor(window: $viewModel.window)
        }
    }
}

extension RootView {
    @ViewBuilder
    private var root: some View {
        NavigationSplitView(
            columnVisibility: $viewModel.sideBar, sidebar: {
                sidebar
            },
            detail: {
                room
            }
        )
        .navigationSplitViewStyle(.balanced)
        .background(.chatHover)
        .introspect(
            .navigationSplitView,
            on: .macOS(.v14, .v13),
            customize: { splitView in
                (splitView.delegate as? NSSplitViewController)?
                    .splitViewItems
                    .first?.canCollapse = false
            }
        )
    }

    @ViewBuilder
    private var room: some View {
        RoomView(
            rooms: $viewModel.rooms,
            onInsert: viewModel.onInsert,
            onDelete: viewModel.onDelete
        )
    }

    @ViewBuilder
    private var sidebar: some View {
        ZStack {
            Color.sidebar.ignoresSafeArea()
            SideBar(
                rooms: $viewModel.rooms,
                selected: $viewModel.room,
                onSelect: viewModel.onSelect,
                onInsert: viewModel.onInsert,
                onDelete: viewModel.onDelete
            )
        }.toolbar(removing: .sidebarToggle)
            .navigationSplitViewColumnWidth(
                min: 65,
                ideal: 65,
                max: 65
            )
    }
}


#Preview {
    RootView()
}
