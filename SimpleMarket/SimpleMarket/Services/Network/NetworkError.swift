//
//  NetworkError.swift
//  SimpleMarket
//
//  Created by Kariny on 24/04/21.
//

import Foundation

enum NetworkError: Error {
    case internetUnavailable
    case invalidURL
    case unexpectedDataError
    case unknownError

    var errorMessage: String {
        switch self {
        case .internetUnavailable:
            return NSLocalizedString("Internet Unavailable Message", comment: "Search description")
        default:
            return NSLocalizedString("Unknown Error Message", comment: "Search description")
        }
    }
}
