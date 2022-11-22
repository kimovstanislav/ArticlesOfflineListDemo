//
//  VSError.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

struct VSError: Error {
    let source: Source
    /// The status code of the error
    let code: Int
    /// The error title
    let title: String
    /// The error message
    let message: String
    /// Indicates whether the error will be shown to the user
    let isSilent: Bool
    /// The underlying error that caused this error
    let cause: Error?
    /// Error location in code, for internal logging
    let location: String
    
    init(source: VSError.Source = .unknown, code: Int, title: String = "Error", message: String, isSilent: Bool = false, cause: Error? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        self.source = source
        self.code = code
        self.title = title
        self.message = message + "\n(Error code: \(code)"
        self.isSilent = isSilent
        self.cause = cause
        location = "\(file):\(line), \(function)"
    }
    
    static let unknown = VSError(
        source: .unknown,
        code: ErrorCode.unknown.rawValue,
        title: "Error",
        message: "Unknown error. Please try again."
    )
}

extension VSError {
    enum Source: String {
        case api, localData, unknown
    }
}

extension VSError {
    enum ErrorCode: Int {
        case unknown = -1
        case unexpectedCodePath = 0
        // Very rough, just for this example. Say.., 1000+ is for non-api errors. 1000-1100 is for local data errors.
        case errorWritingLocalData = 1001
        case errorReadingLocalData = 1002
    }
}
