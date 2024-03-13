//
//  NetworkError.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/11/24.
//

import Alamofire
import Foundation

enum NetworkError: Error {
    case disconnected
    case commonError(error: AFError)
    case badRequest(error: Error?)
    case inValidStatus(status: Int)
    case jsonEncodeError
}

extension NetworkError {
    var localizedDescription: String {
        switch self {
        case let .badRequest(error):
            return NSLocalizedString(
                "bad request \(error?.localizedDescription ?? "no data")",
                comment: ""
            )
        case let .inValidStatus(status):
            return NSLocalizedString(
                "invalid status code \(status)",
                comment: ""
            )
        case .disconnected:
            return NSLocalizedString("network error", comment: "")
        case let .commonError(error):
            return NSLocalizedString("error \(error)", comment: "")
        case .jsonEncodeError:
            return NSLocalizedString("error to encode json", comment: "")
        }
    }
}
