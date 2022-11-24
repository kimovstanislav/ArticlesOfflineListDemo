//
//  APIClient.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 13.11.22.
//

import Foundation
import Combine

class APIClient {
    func performRequest<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, VSError> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .handleEvents(receiveOutput: { print(NSString(data: $0, encoding: String.Encoding.utf8.rawValue)!) })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { APIClient.ErrorMapper.convertToAPIError($0) }
            .mapError { VSError(apiError: $0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
