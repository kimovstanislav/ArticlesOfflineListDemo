//
//  APIClient+Error.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

// MARK: - APIClient.Error

// Not caring for localization in this simple app.
// If cared, would use SwiftGen — https://github.com/SwiftGen/SwiftGen to generate enums for easy access to localized strings.

extension APIClient {
    enum Error: Swift.Error, Equatable {
        case notConnectedToInternet
        case cannotConnectToHost
        case internalServerError
        case custom(APIClient.CustomError)

        var code: Int {
            switch self {
            case .notConnectedToInternet: return URLError.notConnectedToInternet.rawValue
            case .cannotConnectToHost: return URLError.cannotConnectToHost.rawValue
            case .internalServerError: return HTTPStatusCode.internalServerError.rawValue
            case let .custom(error): return error.statusCode
            }
        }

        var title: String {
            switch self {
            case .notConnectedToInternet, .cannotConnectToHost: return "No internet connection"
            case .internalServerError: return "Server error"
            case let .custom(error): return error.title
            }
        }

        var message: String {
            switch self {
            case .notConnectedToInternet, .cannotConnectToHost: return "No internet connection description"
            case .internalServerError: return "Server error description"
            case let .custom(error): return error.message
            }
        }
    }
}


// MARK: - APIClient.CustomError

extension APIClient {
    struct CustomError: Swift.Error, Equatable {
        static let unknown = APIClient.CustomError(
            statusCode: HTTPStatusCode.teapot.rawValue,
            title: "Error",
            message: "Unknown error. Please try again."
        )

        let statusCode: Int
        let title: String
        let message: String

        init(statusCode: Int, title: String = "Error", message: String) {
            self.statusCode = statusCode
            self.title = title
            self.message = message
        }
    }
}
