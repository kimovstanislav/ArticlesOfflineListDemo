//
//  APIClientResponseParser.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 22.11.22.
//

import Foundation

class APIClientResponseParser {
    static func process<CompletionType: Decodable>(inResult: Result<Data, APIClient.APIError>, completion: CompletionResult<CompletionType, VSError>) {
        let in2 = parseResponse(from: inResult)
        processClientResult(in2, completion: completion)
    }
    
    private static func parseResponse(from result: Result<Data, APIClient.APIError>) -> Result<Data, VSError> {
        switch result {
        case let .success(response):
            return .success(response)
        case let .failure(error):
            return .failure(VSError(apiError: error))
        }
    }
    
    private static func processClientResult<CompletionType: Decodable>(_ result: Result<Data, VSError>, completion: CompletionResult<CompletionType, VSError>) {
        switch result {
        case let .success(data):
            do {
                let decodedData: CompletionType = try JSONDecoder().decode(CompletionType.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(VSError.unknown))
            }
        case let .failure(error):
            completion(.failure(error))
        }
    }
}
