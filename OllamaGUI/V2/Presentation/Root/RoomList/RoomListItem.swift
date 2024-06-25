//
//  RoomListItem.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Foundation
import SwiftUI

struct RoomListItem: View {
    @Environment(\.modelContext) private var context
    @Environment(\.injected) private var container

    @State var color: Color = .clear
    @State var position: CGPoint = .zero
    @State var show: Bool = false
    @State var floating: Bool = false
    var room: LocalRoomModel
    var onDelete: (LocalRoomModel) -> Void
    var body: some View {
        Button(action: {
            show.toggle()
        }) {
            VStack {
                HStack {
                    Image(systemName: "message.fill").font(.headline)
                    Text((room.title ?? "no title").removeFirstBreakLine)
                        .frame(
                            maxWidth: .infinity,
                            minHeight: 48,
                            alignment: .leading
                        )
                        .font(.body).lineLimit(2)
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .leading
                )
                Spacer()
                HStack {
                    Spacer()
                    if Date.now.hasSame(.day, as: room.updatedAt) {
                        Text(room.updatedAt, style: .time).font(.caption)
                    } else {
                        Text(room.updatedAt, style: .date).font(.caption)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            .padding()
            .frame(height: 75, alignment: .leading)
            .background(color)
            .floatingWindow(
                position: $position,
                show: $show,
                floating: $floating
            ) {
                ChatViewV2(
                    show: $show,
                    position: $position,
                    floating: $floating,
                    room: room
                ).inject(container)
            }
            .contextMenu(ContextMenu(menuItems: {
                Button(action: {
                    show = false
                    onDelete(room)
                }) {
                    Text("delete")
                }
            }))
            .onHover(perform: { hovering in
                if hovering {
                    color = .chatHover
                } else {
                    color = .clear
                }

            })
            .clipped()
        }.buttonStyle(.plain).padding(0).background(.clear)
    }
}

extension RoomListItem {
    func setPosition(_ pos: CGPoint) {
        position = pos
    }

    func setShow(_ show: Bool) {
        self.show = show
    }
}

var leftCenter: CGPoint {
    guard let screen = NSScreen.main?.visibleFrame.size else { return .zero }
    return .init(x: 20 - 400, y: screen.height / 2 - (screen.height * 0.35))
}

var bottomRight: CGPoint {
    guard let screen = NSScreen.main?.visibleFrame.size else { return .zero }
    return .init(x: screen.width - 220, y: 20)
}

var floatingSize: CGSize {
    guard let screen = NSScreen.main?.visibleFrame.size else { return .zero }
    return .init(width: 500, height: screen.height * 0.7)
}
