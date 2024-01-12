//
//  ContentView.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/9/24.
//

import SwiftUI
import SwiftUIIntrospect

struct ContentView: View {
    var body: some View {
        NavigationSplitView(
            sidebar: {
                SideBar()
                    .toolbar(removing: .sidebarToggle)
                    .navigationSplitViewColumnWidth(
                        min: 90,
                        ideal: 90,
                        max: 90
                    )
            },
            detail: {
                ChatView()
            }
        ).navigationSplitViewStyle(.balanced)
        /// disable sidebar collapse
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
}

#Preview {
    ContentView()
}
