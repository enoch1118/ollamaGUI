//
//  NetworkError.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/11/24.
//

import Foundation

enum NetworkError:Error {
    case disconnected
}


extension NetworkError {
    var localizedDescription: String{
        switch self{
        case .disconnected:
            return NSLocalizedString("network error", comment: "")
        }
    }
}
