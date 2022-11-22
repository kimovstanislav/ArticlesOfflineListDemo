//
//  APIClient+ErrorMapping.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

extension BaseAPIClient {
    typealias APIError = BaseAPIClient.Error
    
    enum ErrorMapper {
        static func convertToAPIError(_ error: Error) -> APIError {
            if let error = error as NSError? {
                return parseError(error)
            }
            else {
                return APIError.custom(BaseAPIClient.CustomError.unknown)
            }
        }

        private static func parseError(_ error: NSError) -> APIError {
            if error.code == APIError.notConnectedToInternet.code {
                return APIError.notConnectedToInternet
            }
            else if error.code == APIError.cannotConnectToHost.code {
                return APIError.cannotConnectToHost
            }
            else if error.code == APIError.internalServerError.code {
                return APIError.internalServerError
            }

            let defaultErrorMessage = "Unknown error. Please try again."
            let customError = BaseAPIClient.CustomError(statusCode: error.code, message: error.localizedFailureReason ?? defaultErrorMessage)
            return APIError.custom(customError)
        }
    }
}
