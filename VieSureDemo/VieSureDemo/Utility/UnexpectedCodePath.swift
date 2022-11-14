//
//  UnexpectedCodePath.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

/// Crashes the app when an unexpected code path is executed and logs the error
func unexpectedCodePath(message: String, file: String = #file, line: Int = #line, function: String = #function) -> Never {
    let error = VSError(source: .unknown, code: VSError.ErrorCode.unexpectedCodePath.rawValue, title: "Unexpected Code Path", message: message)
    // Could also log this error here.
    fatalError(message)
}
