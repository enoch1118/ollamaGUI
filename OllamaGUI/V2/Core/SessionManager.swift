//
//  SessionManager.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/8/24.
//

import Foundation

class SessionManager {
    var session: URLSession

    init() {
        session = URLSession(configuration: .default)
    }
}
