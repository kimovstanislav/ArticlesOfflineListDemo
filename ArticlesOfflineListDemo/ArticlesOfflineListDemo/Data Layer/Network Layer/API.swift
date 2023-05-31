//
//  APIClient.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 22.11.22.
//

import Foundation

protocol API {
    /// Throws VSError
    func loadArticlesList() async throws -> [APIModel.Response.Article]
}

extension API {
    func decodeApiResponse<T: Decodable>(data: Data) throws -> T {
        do {
            let object: T = try JSONDecoder().decode(T.self, from: data)
            return object
        }
        catch let error {
            let vsError: DetailedError = DetailedError.Factory.makeDecodingError(cause: error)
            throw vsError
        }
    }
}
