//
//  VSError+APIError.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

extension VSError {
    init(apiError: APIClient.Error, file: String = #file, function: String = #function, line: Int = #line) {
        self.init(
            source: .api,
            code: apiError.code,
            title: apiError.title,
            message: apiError.message,
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
