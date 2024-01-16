//
//  DataInteractor.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/15/24.
//

import Foundation
import SwiftData

protocol DataInteractor {
    func fetchRoom(context:ModelContext)->[RoomEntity]
    
    func clearRoom(context:ModelContext,room:RoomEntity)
    
    func insertRoom(context:ModelContext)->PersistentIdentifier
    
    
    func deleteRoom(context:ModelContext,room:RoomEntity)
}

struct RealDataInteractor: DataInteractor {
    func insertRoom(context: ModelContext) ->PersistentIdentifier{
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
        return rooms!
    }
    
    func clearRoom(context:ModelContext,room:RoomEntity)->Void{
        for message in room.chats {
            context.delete(message)
        }
    }
    
    
    func deleteRoom(context: ModelContext, room: RoomEntity) {
        context.delete(room)
    }
}


struct StubDataInteractor: DataInteractor{
    func fetchRoom(context: ModelContext) -> [RoomEntity] {
        [RoomEntity()]
    }
    
    
    func clearRoom(context: ModelContext, room: RoomEntity) {}
    
    
    func insertRoom(context: ModelContext) ->PersistentIdentifier{
        let room = RoomEntity()
        return room.id
    }
    
    func deleteRoom(context: ModelContext, room: RoomEntity) {
    }
}
