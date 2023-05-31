//
//  APIClient+ErrorMapping.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

extension APIClient {
    enum ErrorMapper {
        static func convertToVSError(_ error: Error) -> DetailedError {
            if let error = error as NSError? {
                return parseError(error)
            }
            else {
                return DetailedError.unknown
            }
        }

        private static func parseError(_ error: NSError) -> DetailedError{
            if error.code == URLError.notConnectedToInternet.rawValue || error.code == URLError.cannotConnectToHost.rawValue {
                return DetailedError(apiError: error, code: error.code, title: Strings.Error.API.noInternetConnectionTitle, message: Strings.Error.API.noInternetConnectionMessage)
            }
            else if error.code == HTTPStatusCode.internalServerError.rawValue {
                return DetailedError(apiError: error, code: error.code, title: Strings.Error.API.internalServerErrorTitle, message: Strings.Error.API.internalServerErrorMessage)
            }
            return DetailedError(apiError: error, code: error.code, title: Strings.Error.API.title, message: error.localizedDescription)
        }
    }
}
