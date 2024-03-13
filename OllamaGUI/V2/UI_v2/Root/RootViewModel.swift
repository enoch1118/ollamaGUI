//
//  RootViewModel.swift
//  ollamaGUI
//
//  Created by 배상휘 on 2/18/24.
//

import Combine
import Foundation
import SwiftData
import SwiftUI

class RootViewModel: ObservableObject {
    @Published var window: NSWindow?
    @Published var rooms: [RoomEntity] = []
    @Published var room: RoomEntity? = nil
    @Published var sideBar: NavigationSplitViewVisibility = .all
    @Published var settingLoaded: Bool = false

    private var container: DIContainer!
    private var context: ModelContext!

    private var bag = Set<AnyCancellable>()

    func setup(_ container: DIContainer, _ context: ModelContext) {
        self.context = context
        self.container = container
    }

    func beforeWindowSet() {
        fetchSetting()
        subscribeWindow()
    }

    func afterWindowSet() {
        fetchRoom()
        subscribe()
    }
}

extension RootViewModel {
    func onSelect(_ room: RoomEntity) {
        if self.room == room {
            return
        }

        self.room = room
    }

    func onDelete(_ room: RoomEntity) {
        withAnimation {
            self.room = nil
            container.dataInteractor.deleteRoom(context: context, room: room)
            rooms = container.dataInteractor
                .fetchRoom(context: context)
            if rooms.isEmpty {
                onInsert()
            } else {
                self.room = rooms.first!
            }
        }
    }

    func onInsert() {
        withAnimation {
            let id = container.dataInteractor.insertRoom(context: context)
            rooms = container.dataInteractor
                .fetchRoom(context: context)
            room = rooms.first {
                id == $0.id
            }
        }
    }
}

private extension RootViewModel {
    // after window setted
    func fetchRoom() {
        rooms = container.dataInteractor.fetchRoom(context: context)
        room = rooms.first
    }

    /// need init when appear
    func fetchSetting() {
        let setting = container.dataInteractor.fetchSetting(context: context)
        container.appSetting.updateSetting(setting)
        settingLoaded = true
    }

    func subscribe() {
        container.updateTrigger.publisher.sink(receiveValue: { value in
            if value.newModel {
                self.fetchMessage()
            }
        }).store(in: &bag)
    }

    func fetchMessage() {
        rooms = rooms.sorted(by: { $0.updatedAt > $1.updatedAt })
        container.updateTrigger.newModelHandled()
    }

    func subscribeWindow() {
        $window.sink { value in
            guard let win = value else {
                return
            }
            win.isReleasedWhenClosed = false
        }.store(in: &bag)
    }
}
