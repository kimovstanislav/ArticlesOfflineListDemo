//
//  VSError+APIError.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

extension DetailedError {    
    init(apiError: Error, code: Int, title: String, message: String, file: String = #file, function: String = #function, line: Int = #line) {
        self.init(
            source: .api,
            code: code,
            message: message,
            isSilent: false,
            cause: apiError,
            file: file,
            function: function,
            line: line
        )
    }
    
    var isDataSynchronizationError: Bool {
        code == HTTPStatusCode.internalServerError.rawValue || code == URLError.notConnectedToInternet.rawValue || code == URLError.cannotConnectToHost.rawValue
    }
}

extension DetailedError.Factory {
    static func makeDecodingError(cause: Error? = nil) -> DetailedError {
        DetailedError(
                source: .api,
                code: DetailedError.ErrorCode.errorDecodingApiResponse.rawValue,
                title: VSStrings.Error.API.title,
                message: VSStrings.Error.API.decodingApiResponseFailedMessage,
                isSilent: false,
                cause: cause
            )
    }
}
