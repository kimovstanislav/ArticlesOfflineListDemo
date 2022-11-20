//
//  APIClient.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 13.11.22.
//

import Foundation

class APIClient: NSObject {
    @discardableResult
    func genericGetRequest(
        url: URL,
        completion: @escaping CompletionResult<Data, APIClient.Error>
    ) -> URLRequest {
        let request = URLRequest.Factory.makeGetRequest(url: url)
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let error = error {
                print("> APIClient - getArticles HTTP Request Failed: \(error)")
                let apiError: APIClient.Error = APIClient.ErrorMapper.convertToAPIError(error as! APIClient.Error)
                completion(.failure(apiError))
            }
            else if let data = data {
                print("> APIClient - HTTP Request success.")
                completion(.success(data))
            }
            else {
                print("> APIClient - HTTP Request empty data.")
                // Could create a different error here, but don't care for current simple app.
                let unknownApiError = APIClient.Error.custom(APIClient.CustomError.unknown)
                completion(.failure(unknownApiError))
            }
        }
        task.resume()
        return request
    }
}

extension URLRequest {
    enum Factory {
        static func makeGetRequest(url: URL) -> URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 10.0
            return request
        }
    }
}
