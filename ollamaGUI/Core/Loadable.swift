//
//  Loadable.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/11/24.
//

import Foundation

enum Loadable<U, E> where E: Error {
    case initState
    case isLoading(last: U?)
    case loaded(U)
    case cancelled
    case finished
    case failed(E)

    var value: U? {
        switch self {
        case let .isLoading(last): return last
        case let .loaded(value): return value
        default: return nil
        }
    }

    var error: Error? {
        switch self {
        case let .failed(error): return error
        default: return nil
        }
    }

    var status: String? {
        switch self {
        case .initState: return NSLocalizedString("ready to loading",
                                                  comment: "")
        case .isLoading: return NSLocalizedString("is loading",
                                                  comment: "")
        case .finished: return NSLocalizedString("complete",
                                                 comment: "")
        case .cancelled: return NSLocalizedString("user cancelled", comment: "")
        case .loaded: return NSLocalizedString("loaded", comment: "")
        case let .failed(error): return error.localizedDescription
        }
    }
}

extension Loadable: Equatable where U: Equatable {
    static func == (lhs: Loadable<U, E>, rhs: Loadable<U, E>) -> Bool {
        switch (lhs, rhs) {
        case (.initState, .initState): return true
        case let (.isLoading(lhsC), .isLoading(rhsC)):
            return lhsC == rhsC
        case let (.loaded(lhsV), .loaded(rhsV)): return lhsV == rhsV
        case let (.failed(lhsE), .failed(rhsE)):
            return lhsE.localizedDescription == rhsE.localizedDescription
        default: return false
        }
    }
}
