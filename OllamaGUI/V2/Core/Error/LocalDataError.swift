//
//  LocalDataError.swift
//  ollamaGUI
//
//  Created by 배상휘 on 3/19/24.
//

import Foundation

enum LocalDataError: Error {
    case unknown
    case error(error: Error)
    case nodata
}

extension LocalDataError {
    var localizedDescription: String {
        switch self {
        case .unknown:
            return "some error occur"
        case let .error(error):
            return "some error occur: \(error)"
        case .nodata:
            return "no data found"
        }
    }
}
