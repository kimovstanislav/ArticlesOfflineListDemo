//
//  HTTPStatusCodes.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

// Only adding the ones we actually need for this example
enum HTTPStatusCode: Int, Error {
    //
    // Client Error - 4xx
    //
    
    /// - teapot: This HTTP status is used as an Easter egg in some websites.
    case teapot = 418
    
    //
    // Server Error - 5xx
    //
    
    /// - internalServerError: A generic error message, given when an unexpected condition was encountered and no more specific message is suitable.
    case internalServerError = 500
}
