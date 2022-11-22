//
//  APIClient+Parsing.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 14.11.22.
//

import Foundation

extension APIClient {
    enum Parser {
        static func parseResponse<CompletionType: Decodable>(from result: Result<Data, APIClient.APIError>, completion: CompletionResult<CompletionType, VSError>) {
            switch result {
            case let .success(data):
                processResponseData(data, completion: completion)
            case let .failure(error):
                return completion(.failure(VSError(apiError: error)))
            }
        }
        
        private static func processResponseData<CompletionType: Decodable>(_ data: Data, completion: CompletionResult<CompletionType, VSError>) {
            do {
                let decodedData: CompletionType = try JSONDecoder().decode(CompletionType.self, from: data)
                completion(.success(decodedData))
            }
            catch let error {
                // TODO: create a parsing error + code for it?
                let decodingError = VSError(source: .api, code: 666, message: error.localizedDescription)
                completion(.failure(decodingError))
            }
        }
    }
}

// TODO: sync, returning result instead of completion. To remove if not needed in the end.
/*static func XparseResponse<CompletionType: Decodable>(from result: Result<Data, APIClient.APIError>) -> Result<CompletionType, VSError> {
    switch result {
    case let .success(data):
        let result: Result<CompletionType, VSError> = XprocessResponseData(data)
        return result
    case let .failure(error):
        return .failure(VSError(apiError: error))
    }
}

private static func XprocessResponseData<CompletionType: Decodable>(_ data: Data) -> Result<CompletionType, VSError> {
    do {
        let decodedData: CompletionType = try JSONDecoder().decode(CompletionType.self, from: data)
        return .success(decodedData)
    }
    catch {
        return .failure(VSError.unknown)
    }
}*/
