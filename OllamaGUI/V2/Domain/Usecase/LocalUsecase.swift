//
//  LocalUsecase.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Foundation
import SwiftData

class LocalUsecase {
    var repository: LocalRepository

    init(repository: LocalRepository) {
        self.repository = repository
    }

    func ignite(context: ModelContext) {
        repository.ignite(context: context)
    }

    func fetchAllRoom() async throws -> [LocalRoomModel] {
        return try await repository.fetchAllRoom().value
    }

    func fetchRoom(room: LocalRoomModel) async throws -> [LocalChatModel] {
        return try await repository.fetchRoom(room: room).value
    }

    func clearRoom(room: LocalRoomModel) async throws -> Bool {
        return try await repository.clearRoom(room: room).value
    }

    func deleteRoom(room: LocalRoomModel) async throws -> Bool {
        return try await repository.deleteRoom(room: room).value
    }

    func changeRoomName(room: LocalRoomModel, to: String) async throws -> Bool {
        return try await repository.changeRoomName(room: room, to: to).value
    }

    func addNewRoom(room: LocalRoomModel) async throws -> Bool {
        return try await repository.addNewRoom(room: room).value
    }

    func updateRoomDate(room: LocalRoomModel, to: Date) async throws -> Bool {
        return try await repository.updateRoomDate(room: room, to: to).value
    }
}
