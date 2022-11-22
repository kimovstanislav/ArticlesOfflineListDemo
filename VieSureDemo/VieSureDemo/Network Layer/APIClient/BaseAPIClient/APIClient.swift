//
//  APIClient.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 13.11.22.
//

import Foundation

// TODO: add a way to cancel a request? (in a case it's not responding for a while)
class APIClient {
    @discardableResult
    func genericGetRequest(
        url: URL,
        completion: @escaping CompletionResult<Data, APIClient.APIError>
    ) -> URLRequest {
        let request = URLRequest.Factory.makeGetRequest(url: url)
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let error: Error = error {
                print("> APIClient - HTTP GET Request Failed: \(error)")
                let apiError: APIClient.APIError = APIClient.ErrorMapper.convertToAPIError(error)
                completion(.failure(apiError))
            }
            else if let data = data {
                print("> APIClient - HTTP GET Request success.")
                completion(.success(data))
            }
            else {
                print("> APIClient - HTTP GET Request empty data.")
                // Could create a different error here, but don't care for current simple app.
                let unknownApiError = APIClient.APIError.custom(APIClient.CustomError.unknown)
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
            request.timeoutInterval = 30.0
            return request
        }
    }
}
