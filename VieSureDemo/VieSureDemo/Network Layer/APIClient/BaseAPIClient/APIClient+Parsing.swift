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
                // TODO: is the source API or not in this case? To read more on this.
                let decodingError = VSError(source: .api, code: VSError.ErrorCode.errorDecodingApiResponse.rawValue, message: error.localizedDescription)
                completion(.failure(decodingError))
            }
        }
    }
}
