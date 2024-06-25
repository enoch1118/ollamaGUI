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
    @Published var rooms: [LocalRoomModel] = []
    @Published var room: LocalRoomModel? = nil
    @Published var sideBar: NavigationSplitViewVisibility = .all
    @Published var settingLoaded: Bool = false
    @Published var creating: Bool = false

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
    func onSelect(_ room: LocalRoomModel) {
        if self.room == room {
            return
        }

        self.room = room
    }

    func onDelete(_ room: LocalRoomModel) {
        Task {
            self.room = nil
            let _ = try? await container.localUsecase.deleteRoom(room: room)
            let rooms = try! await container.localUsecase.fetchAllRoom()
            withAnimation {
                self.rooms = rooms
            }
            if rooms.isEmpty {
                onInsert()
            } else {
                self.room = rooms.first!
            }
        }
    }

    func onInsert() {
        if creating {
            return
        }
        creating = true
        Task {
            let newRoom: LocalRoomModel = .init(updateAt: .now, chats: [])
            _ = try? await container.localUsecase
                .addNewRoom(room: newRoom)
            let rooms = try! await container.localUsecase.fetchAllRoom()
            withAnimation {
                self.rooms = rooms
            }
            room = rooms.first {
                newRoom.updatedAt == $0.updatedAt
            }
            creating = false
        }
    }
}

private extension RootViewModel {
    // after window setted
    func fetchRoom() {
        Task {
            rooms = try! await container.localUsecase.fetchAllRoom()
        }
    }

    /// need init when appear
    func fetchSetting() {
        let setting = container.dataInteractor.fetchSetting(context: context)
        container.localUsecase.ignite(context: context)
        container.appSetting.updateSetting(setting)
        settingLoaded = true
    }

    func subscribe() {
        container.updateTrigger.publisher.sink(receiveValue: { value in
            if value.newModel {
                self.fetchRoom()
            }
        }).store(in: &bag)
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
