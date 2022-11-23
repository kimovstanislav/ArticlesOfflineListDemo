//
//  APIClient+Error.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

// MARK: - APIClient.Error

// TODO: see that APIError and VSError are both not overengineered later.
extension APIClient {
    enum APIError: Error, Equatable {
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
            case .notConnectedToInternet, .cannotConnectToHost: return VSStrings.Error.API.noInternetConnectionTitle
            case .internalServerError: return VSStrings.Error.API.internalServerErrorTitle
            case let .custom(error): return error.title
            }
        }

        var message: String {
            switch self {
            case .notConnectedToInternet, .cannotConnectToHost: return VSStrings.Error.API.noInternetConnectionMessage
            case .internalServerError: return VSStrings.Error.API.internalServerErrorMessage
            case let .custom(error): return error.message
            }
        }
    }
    
    struct CustomError: Error, Equatable {
        let statusCode: Int
        let title: String
        let message: String

        init(statusCode: Int, title: String = VSStrings.Error.API.title, message: String) {
            self.statusCode = statusCode
            self.title = title
            self.message = message
        }
        
        static let unknown = APIClient.CustomError(
            statusCode: HTTPStatusCode.teapot.rawValue,
            title: VSStrings.Error.API.title,
            message: VSStrings.Error.API.unknownMessage
        )
    }
}
