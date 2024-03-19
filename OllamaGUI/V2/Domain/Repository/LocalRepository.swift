//
//  LocalRepository.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Combine
import Foundation
import SwiftData

protocol LocalRepository {
    func ignite(context: ModelContext)
    func fetchAllRoom() -> Future<[LocalRoomModel], LocalDataError>
    func fetchRoom(room: LocalRoomModel)
        -> Future<[LocalChatModel], LocalDataError>
    func clearRoom(room: LocalRoomModel) -> Future<Bool, LocalDataError>
    func deleteRoom(room: LocalRoomModel) -> Future<Bool, LocalDataError>
    func addNewRoom(room: LocalRoomModel) -> Future<Bool, LocalDataError>
    func changeRoomName(room: LocalRoomModel, to: String)
        -> Future<Bool, LocalDataError>

    func updateRoomDate(room: LocalRoomModel, to: Date)
        -> Future<Bool, LocalDataError>
}
