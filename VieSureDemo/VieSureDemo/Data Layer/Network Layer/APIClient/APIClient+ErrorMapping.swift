//
//  APIClient+ErrorMapping.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

extension APIClient {
    enum ErrorMapper {
        static func convertToVSError(_ error: Error) -> VSError {
            if let error = error as NSError? {
                return parseError(error)
            }
            else {
                return VSError.unknown
            }
        }

        private static func parseError(_ error: NSError) -> VSError{
            if error.code == URLError.notConnectedToInternet.rawValue || error.code == URLError.cannotConnectToHost.rawValue {
                return VSError(apiError: error, code: error.code, title: VSStrings.Error.API.noInternetConnectionTitle, message: VSStrings.Error.API.noInternetConnectionMessage)
            }
            else if error.code == HTTPStatusCode.internalServerError.rawValue {
                return VSError(apiError: error, code: error.code, title: VSStrings.Error.API.internalServerErrorTitle, message: VSStrings.Error.API.internalServerErrorMessage)
            }
            return VSError(apiError: error, code: error.code, title: VSStrings.Error.API.title, message: error.localizedDescription)
        }
    }
}
