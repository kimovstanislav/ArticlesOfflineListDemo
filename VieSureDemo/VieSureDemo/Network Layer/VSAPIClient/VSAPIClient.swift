//
//  VSAPIClient.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 13.11.22.
//

import Foundation
import Combine

class VSAPIClient: APIClient, IVSAPI {
    // TODO: Could create a separate class with all urls and parameters as constant strings, but no need here for a single entry.
    
    // TODO: move to the base APIClient class, maybe? Or not use the base class at all
    private static let agent = Agent()
    
    
    /// GET 'https://run.mocky.io/v3/de42e6d9-2d03-40e2-a426-8953c7c94fb8'
    static func articlesList() -> AnyPublisher<[APIModel.Response.Article], VSError> {
        guard let url = URL(string: "https://run.mocky.io/v3/de42e6d9-2d03-40e2-a426-8953c7c94fb8") else {
            unexpectedCodePath(message: "Invalid URL.")
        }
        let request = URLComponents(url: url, resolvingAgainstBaseURL: true)?
            .request
        return agent.run(request!)
    }
}

// TODO: properly

private extension URLComponents {
    var request: URLRequest? {
        url.map { URLRequest.init(url: $0) }
    }
}

struct Agent {
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, VSError> {
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
