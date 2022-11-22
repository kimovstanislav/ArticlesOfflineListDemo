//
//  APIClient+ErrorMapping.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

extension APIClient {
    enum ErrorMapper {
        static func convertToAPIError(_ error: Error) -> APIClient.APIError {
            if let error = error as NSError? {
                return parseError(error)
            }
            else {
                return APIClient.APIError.custom(APIClient.CustomError.unknown)
            }
        }

        private static func parseError(_ error: NSError) -> APIClient.APIError {
            if error.code == APIClient.APIError.notConnectedToInternet.code {
                return APIClient.APIError.notConnectedToInternet
            }
            else if error.code == APIClient.APIError.cannotConnectToHost.code {
                return APIClient.APIError.cannotConnectToHost
            }
            else if error.code == APIClient.APIError.internalServerError.code {
                return APIClient.APIError.internalServerError
            }

            let defaultErrorMessage = "Unknown error. Please try again."
            let customError = APIClient.CustomError(statusCode: error.code, message: error.localizedFailureReason ?? defaultErrorMessage)
            return APIClient.APIError.custom(customError)
        }
    }
}
