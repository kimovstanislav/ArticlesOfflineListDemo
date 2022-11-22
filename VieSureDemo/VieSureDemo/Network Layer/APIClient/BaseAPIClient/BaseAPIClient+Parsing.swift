//
//  APIClient+Parsing.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

extension BaseAPIClient {
    enum Parser {
        static func parseResponse(_ response: Result<Data, Error>) -> Result<Data, BaseAPIClient.Error> {
            switch response {
            case let .success(data):
                return .success(data)
            case let .failure(error):
                let apiError = BaseAPIClient.ErrorMapper.convertToAPIError(error)
                return .failure(apiError)
            }
        }
    }
}
