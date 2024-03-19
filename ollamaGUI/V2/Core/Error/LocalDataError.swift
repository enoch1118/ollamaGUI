//
//  LocalDataError.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Foundation

enum LocalDataError: Error {
    case unknown
}

extension LocalDataError {
    var localizedDescription: String {
        switch self {
        case .unknown:
            return "some error occur"
        }
    }
}
