//
//  UnexpectedCodePath.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

/// Crashes the app when an unexpected code path is executed and logs the error
func unexpectedCodePath(message: String, file: String = #file, line: Int = #line, function: String = #function) -> Never {
    let error = DetailedError(source: .unknown, code: DetailedError.ErrorCode.unexpectedCodePath.rawValue, title: "Unexpected Code Path", message: message)
    // Could also log this error here, if had any logging like Firebase or whatever.
    print("Unexpected code path error: \(error)")
    fatalError(message)
}
