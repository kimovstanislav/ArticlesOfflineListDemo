//
//  APIClient.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 13.11.22.
//

import Foundation

// TODO: add a way to cancel a request? (in a case it's not responding for a while)
// TODO: why NSObject btw? To check.
class BaseAPIClient: NSObject {
    @discardableResult
    func genericGetRequest(
        url: URL,
        completion: @escaping CompletionResult<Data, BaseAPIClient.Error>
    ) -> URLRequest {
        let request = URLRequest.Factory.makeGetRequest(url: url)
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if let error = error {
                print("> BaseAPIClient - HTTP GET Request Failed: \(error)")
                let apiError: BaseAPIClient.Error = BaseAPIClient.ErrorMapper.convertToAPIError(error as! BaseAPIClient.Error)
                completion(.failure(apiError))
            }
            else if let data = data {
                print("> BaseAPIClient - HTTP GET Request success.")
                completion(.success(data))
            }
            else {
                print("> BaseAPIClient - HTTP GET Request empty data.")
                // Could create a different error here, but don't care for current simple app.
                let unknownApiError = BaseAPIClient.Error.custom(BaseAPIClient.CustomError.unknown)
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
