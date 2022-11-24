//
//  VSAPIClient.swift
//  VieSureDemo
//
//  Created by Stanislav Kimov on 13.11.22.
//

import Foundation
import Combine

class VSAPIClient: APIClient, IVSAPI {
    enum URLs {
        static let host = "https://run.mocky.io"
        static let apiVersion = "/v3"
        
        enum Endpoints {
            static let articlesList = "/de42e6d9-2d03-40e2-a426-8953c7c94fb8"
        }
    }
    
    private func makeUrl(host: String, apiVersion: String, endpoint: String) -> URL {
        let urlString = "\(host)\(apiVersion)\(endpoint)"
        guard let url = URL(string: urlString) else {
            unexpectedCodePath(message: "Invalid URL.")
        }
        return url
    }

    /// Load articles list - GET 'https://run.mocky.io/v3/de42e6d9-2d03-40e2-a426-8953c7c94fb8'
     func articlesList() -> AnyPublisher<[APIModel.Response.Article], VSError> {
        let url = makeUrl(host: VSAPIClient.URLs.host, apiVersion: VSAPIClient.URLs.apiVersion, endpoint: VSAPIClient.URLs.Endpoints.articlesList)
        guard let request = URLComponents(url: url, resolvingAgainstBaseURL: true)?
            .request else {
            unexpectedCodePath(message: "Failed to create request.")
        }
        return self.performRequest(request)
    }
}

private extension URLComponents {
    var request: URLRequest? {
        url.map { URLRequest.init(url: $0) }
    }
}
