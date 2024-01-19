//
//  DataInteractor.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import Foundation
import SwiftData

protocol DataInteractor {
    func fetchRoom(context: ModelContext) -> [RoomEntity]

    func clearRoom(context: ModelContext, room: RoomEntity)

    func insertRoom(context: ModelContext) -> PersistentIdentifier

    func deleteRoom(context: ModelContext, room: RoomEntity)

    func fetchSetting(context: ModelContext) -> AppSettingEntity
}

struct RealDataInteractor: DataInteractor {
    func insertRoom(context: ModelContext) -> PersistentIdentifier {
        let room = RoomEntity()
        context.insert(room)
        return room.id
    }
    func fetchRoom(context: ModelContext) -> [RoomEntity] {
        let des = FetchDescriptor<RoomEntity>()
        var rooms = try? context.fetch(des)
        if rooms == nil || rooms!.isEmpty {
            context.insert(RoomEntity())
            rooms = try? context.fetch(des)
        }
        if rooms == nil || rooms!.isEmpty {
            fatalError()
        }
        return rooms!.sorted(by: { $0.updatedAt > $1.updatedAt })
    }

    func clearRoom(context: ModelContext, room: RoomEntity) {
        for message in room.chats {
            context.delete(message)
        }
    }

    func deleteRoom(context: ModelContext, room: RoomEntity) {
        context.delete(room)
    }

    func fetchSetting(context: ModelContext) -> AppSettingEntity {
        let des = FetchDescriptor<AppSettingEntity>()
        var setting = try? context.fetch(des)
        if setting?.first == nil {
            context.insert(AppSettingEntity.default)
            setting = try? context.fetch(des)
        }
        if setting?.first == nil {
            fatalError()
        }
        return setting!.first!
    }
    
}

struct StubDataInteractor: DataInteractor {
    func fetchRoom(context _: ModelContext) -> [RoomEntity] {
        [.randomRoom, .randomRoom, .randomRoom]
    }

    func clearRoom(context _: ModelContext, room _: RoomEntity) {}

    func insertRoom(context _: ModelContext) -> PersistentIdentifier {
        let room = RoomEntity()
        return room.id
    }

    func deleteRoom(context _: ModelContext, room _: RoomEntity) {}
    
    func fetchSetting(context: ModelContext) -> AppSettingEntity {
        .default
    }
}
