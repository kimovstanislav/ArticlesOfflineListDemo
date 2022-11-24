//
//  ErrorLogger.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 24.11.22.
//

import Foundation

class ErrorLogger {
    static func logError(_ error: VSError) {
        // Could properly log an error here like with Firebase of whatever
        print("Error \(error.code): \(error.message)")
    }
}
