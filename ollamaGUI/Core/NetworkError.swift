//
//  NetworkError.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/11/24.
//

import Foundation
import Alamofire

enum NetworkError:Error {
    case disconnected
    case commonError(error:AFError)
    case jsonEncodeError
}


extension NetworkError {
    var localizedDescription: String{
        switch self{
        case .disconnected:
            return NSLocalizedString("network error", comment: "")
        case let .commonError(error):
            return NSLocalizedString("error \(error)", comment: "")
        case .jsonEncodeError:
            return NSLocalizedString("error to encode json", comment: "")
        }
    }
}
