//
//  VSAPIClient+Parsing.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

extension VSAPIClient {
    enum Parser {
        static func parseResponse(from result: Result<Data, APIClient.Error>) -> Result<Data, VSError> {
            switch result {
            case let .success(response):
                return .success(response)
            case let .failure(error):
                return .failure(VSError(apiError: error))
            }
        }
    }
}
