//
//  APIClient.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 13.11.22.
//

import Foundation
import Combine

class APIClient: API {
    let session = URLSession.shared
    
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
    
    func loadArticlesList() async throws -> [APIModel.Response.Article] {
        let url = makeUrl(host: URLs.host, apiVersion: URLs.apiVersion, endpoint: URLs.Endpoints.articlesList)
        return try await performRequest(url: url)
    }
}

extension APIClient {
    private func performRequest<T: Decodable>(url: URL) async throws -> T {
        let data: Data = try await getDataFromApi(url: url)
        let object: T = try decodeApiResponse(data: data)
        return object
    }
    
    private func getDataFromApi(url: URL) async throws -> Data {
        do {
            let (data, _) = try await session.data(from: url)
            return data
        }
        catch let error {
            let vsError = APIClient.ErrorMapper.convertToVSError(error)
            throw vsError
        }
    }
}
