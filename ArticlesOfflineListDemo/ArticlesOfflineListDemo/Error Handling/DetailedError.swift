//
//  VSError.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

struct DetailedError: Error {
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
    
    init(source: DetailedError.Source = .unknown, code: Int, title: String = VSStrings.Error.API.title, message: String, isSilent: Bool = false, cause: Error? = nil, file: String = #file, function: String = #function, line: Int = #line) {
        self.source = source
        self.code = code
        self.title = title
        self.message = message + String(format: VSStrings.Error.API.formattedErrorCode, code)
        self.isSilent = isSilent
        self.cause = cause
        location = "\(file):\(line), \(function)"
    }
    
    static let unknown = DetailedError(
        source: .unknown,
        code: ErrorCode.unknown.rawValue,
        title: VSStrings.Error.API.title,
        message: VSStrings.Error.API.unknownMessage
    )
}

extension DetailedError {
    enum Source: String {
        case api, localData, unknown
    }
}

extension DetailedError {
    enum ErrorCode: Int {
        case unknown = -1
        case unexpectedCodePath = 0
        // Let's have API response decoding failed error code 901
        case errorDecodingApiResponse = 901
        // Very rough, just for this example. Say.., 1000+ is for non-api errors. 1000-1100 is for local data errors.
        case errorWritingLocalData = 1001
        case errorReadingLocalData = 1002
        case errorEncryptingLocalData = 1003
        case errorDecryptingLocalData = 1004
    }
}

extension DetailedError {
    enum Factory {}
}
