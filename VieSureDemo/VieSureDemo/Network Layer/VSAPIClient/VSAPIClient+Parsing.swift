//
//  VSAPIClient+Parsing.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

// TODO: somehow may better belong inside Error Handling folder with VSError stuff. Need to consider.
extension VSAPIClient {
    enum Parser {
        static func parseResponse(from result: Result<Data, BaseAPIClient.Error>) -> Result<Data, VSError> {
            switch result {
            case let .success(response):
                return .success(response)
            case let .failure(error):
                return .failure(VSError(apiError: error))
            }
        }
    }
}
