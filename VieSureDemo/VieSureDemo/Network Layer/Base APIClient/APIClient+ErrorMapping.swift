//
//  APIClient+ErrorMapping.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

extension APIClient {
    enum ErrorMapper {
        static func convertToAPIError(_ error: Error) -> APIClient.Error {
            if let error = error as NSError? {
                return parseError(error)
            }
            else {
                return APIClient.Error.custom(APIClient.CustomError.unknown)
            }
        }

        private static func parseError(_ error: NSError) -> APIClient.Error {
            if error.code == APIClient.Error.notConnectedToInternet.code {
                return APIClient.Error.notConnectedToInternet
            }
            else if error.code == APIClient.Error.cannotConnectToHost.code {
                return APIClient.Error.cannotConnectToHost
            }
            else if error.code == APIClient.Error.internalServerError.code {
                return APIClient.Error.internalServerError
            }

            let defaultErrorMessage = "Unknown error. Please try again."
            let customError = APIClient.CustomError(statusCode: error.code, message: error.localizedFailureReason ?? defaultErrorMessage)
            return APIClient.Error.custom(customError)
        }
    }
}
