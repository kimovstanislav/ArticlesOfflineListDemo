//
//  VSStrings.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 22.11.22.
//

import Foundation

// If did things properly, would use SwiftGen — https://github.com/SwiftGen/SwiftGen to generate enums for easy access to localized strings.

enum VSStrings {
    enum Error {
        enum API {
            static let title = "Error"
            static let unknownMessage = "Unknown error. Please try again."
            static let formattedErrorCode = "\n(Error code: %d)"
            
            static let noInternetConnectionTitle = "No internet connection"
            static let noInternetConnectionMessage = "No internet connection description"
            static let internalServerErrorTitle = "Server error"
            static let internalServerErrorMessage = "Server error description"
            static let decodingApiResponseFailedMessage = "Api response object decoding failed"
            static let loadingArticlesFromServerErrorMessage = "Failed to load articles from server"
        }
        
        enum LocalData {
        }
    }
    
    enum Button {
        static let close = "Close"
    }
}
