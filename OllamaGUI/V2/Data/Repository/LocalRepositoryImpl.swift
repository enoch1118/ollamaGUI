//
//  LocalRepositoryImpl.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Combine
import Foundation
import SwiftData

class LocalRepositoryImpl: LocalRepository {
    var context: ModelContext!

    func ignite(context: ModelContext) {
        self.context = context
    }

    func fetchAllRoom() -> Future<[LocalRoomModel], LocalDataError> {
        return Future { promise in
            let sort = SortDescriptor<LocalRoomModel>(\.updatedAt)
            let disc = FetchDescriptor<LocalRoomModel>(sortBy: [sort])
            do {
                let res = try self.context.fetch(disc)
                promise(.success(res))
            } catch {
                promise(.failure(.error(error: error)))
            }
        }
    }

    func fetchRoom(room: LocalRoomModel)
        -> Future<[LocalChatModel], LocalDataError>
    {
        return Future { promise in
            let sort = SortDescriptor<LocalChatModel>(\.createdAt)
            let id = room.id
            let predicate = #Predicate<LocalChatModel> { $0.room!.id == id }
            let disc = FetchDescriptor<LocalChatModel>(predicate: predicate,
                                                       sortBy: [sort])
            do {
                let res = try self.context.fetch(disc)
                promise(.success(res))
            } catch {
                promise(.failure(.error(error: error)))
            }
        }
    }

    func clearRoom(room: LocalRoomModel) -> Future<Bool, LocalDataError> {
        return Future { promise in
            let id = room.id
            let predicate = #Predicate<LocalChatModel> { $0.room!.id == id }

            do {
                try self.context.delete(
                    model: LocalChatModel.self,
                    where: predicate
                )
                promise(.success(true))
            } catch {
                promise(.failure(.error(error: error)))
            }
        }
    }

    func deleteRoom(room: LocalRoomModel) -> Future<Bool, LocalDataError> {
        return Future { promise in
            self.context.delete(
                room
            )
            promise(.success(true))
        }
    }

    func addNewRoom(room: LocalRoomModel) -> Future<Bool, LocalDataError> {
        Future { promise in
            self.context.insert(
                room
            )
            promise(.success(true))
        }
    }

    func changeRoomName(room: LocalRoomModel,
                        to title: String) -> Future<Bool, LocalDataError>
    {
        Future { promise in
            do {
                let target = try self.fetchTarget(target: room)
                target.title = title
                try self.context.save()
                promise(.success(true))
            } catch {
                if error.self is LocalDataError {
                    promise(.failure(error as! LocalDataError))
                    return
                }
                promise(.failure(.error(error: error)))
            }
        }
    }

    func updateRoomDate(room: LocalRoomModel,
                        to date: Date) -> Future<Bool, LocalDataError>
    {
        Future { promise in
            do {
                let target = try self.fetchTarget(target: room)
                target.updatedAt = date
                try self.context.save()
                promise(.success(true))
            } catch {
                if error.self is LocalDataError {
                    promise(.failure(error as! LocalDataError))
                    return
                }
                promise(.failure(.error(error: error)))
            }
        }
    }

    func fetchTarget(target: LocalRoomModel) throws -> LocalRoomModel {
        let id = target.id
        let predict = #Predicate<LocalRoomModel> { $0.id == id }
        let dis = FetchDescriptor(predicate: predict)
        let res = try context.fetch(dis)
        guard let room = res.first else {
            throw LocalDataError.nodata
        }
        return room
    }
}
