//
//  NetworkEvent+State.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Foundation

enum NetworkEvent {
    case checkNetwork
}

enum NetworkState: BaseState {
    case initState
    case disconnected
    case connected
}
