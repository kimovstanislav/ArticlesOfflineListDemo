//
//  VSError+LocalData.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 22.11.22.
//

import Foundation

extension DetailedError {
    init(localDataError: Error, code: Int, file: String = #file, function: String = #function, line: Int = #line) {
        self.init(
            source: .localData,
            code: code,
            message: localDataError.localizedDescription,
            isSilent: false,
            cause: localDataError,
            file: file,
            function: function,
            line: line
        )
    }
}
