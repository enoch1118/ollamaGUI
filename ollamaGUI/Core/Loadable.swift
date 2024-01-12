//
//  Loadable.swift
//  ollamaGUI
//
//  Created by 배상휘 on 1/11/24.
//

import Foundation

enum Loadable<T, U, E> where T: DescribableEnum, E: Error {
    case initState
    case isLoading(last: U?, status: T)
    case loaded(U)
    case failed(E)

    var value: U? {
        switch self {
        case let .isLoading(last, _): return last
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
        case let .isLoading(_, status): return status.description
        case .loaded: return NSLocalizedString("loaded", comment: "")
        case let .failed(error): return error.localizedDescription
        }
    }
}

extension Loadable: Equatable where U: Equatable {
    static func == (lhs: Loadable<T, U, E>, rhs: Loadable<T, U, E>) -> Bool {
        switch (lhs, rhs) {
        case (.initState, .initState): return true
        case let (.isLoading(lhsV, lhsC), .isLoading(rhsV, rhsC)):
            return lhsV == rhsV && lhsC.description == rhsC.description
        case let (.loaded(lhsV), .loaded(rhsV)): return lhsV == rhsV
        case let (.failed(lhsE), .failed(rhsE)):
            return lhsE.localizedDescription == rhsE.localizedDescription
        default: return false
        }
    }
}
