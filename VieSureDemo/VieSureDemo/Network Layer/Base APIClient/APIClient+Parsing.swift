//
//  APIClient+Parsing.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

extension APIClient {
    enum Parser {
        static func parseResponse(_ response: Result<Data, Error>) -> Result<Data, APIClient.Error> {
            switch response {
            case let .success(data):
                return .success(data)
            case let .failure(error):
                let apiError = APIClient.ErrorMapper.convertToAPIError(error)
                return .failure(apiError)
            }
        }
    }
}
