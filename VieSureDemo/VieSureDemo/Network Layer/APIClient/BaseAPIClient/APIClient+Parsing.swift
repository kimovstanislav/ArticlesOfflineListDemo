//
//  APIClient+Parsing.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

extension APIClient {
    enum Parser {
//        static func parseResponse<CompletionType: Decodable>(from result: Result<Data, APIClient.Error>) -> Result<CompletionType, VSError> {
//            switch result {
//            case let .success(data):
//                do {
//                    let decodedData: CompletionType = try JSONDecoder().decode(CompletionType.self, from: data)
//                    return .success(decodedData)
//                }
//                catch {
//                    return .failure(VSError.unknown)
//                }
//            case let .failure(apiError):
//                return .failure(VSError(apiError: apiError))
//            }
//        }
        
//        static func parseResponse(_ response: Result<Data, Error>) -> Result<Data, APIClient.Error> {
//            switch response {
//            case let .success(data):
//                return .success(data)
//            case let .failure(error):
//                let apiError = APIClient.ErrorMapper.convertToAPIError(error)
//                return .failure(apiError)
//            }
//        }
    }
}
