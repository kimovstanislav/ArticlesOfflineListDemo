//
//  APIClient.swift
//  ArticlesOfflineListDemo
//
//  Created by Stanislav Kimov on 22.11.22.
//

import Foundation

protocol IVSAPI {
    /// Throws VSError
    func loadArticlesList() async throws -> [APIModel.Response.Article]
}

extension IVSAPI {
    func decodeApiResponse<T: Decodable>(data: Data) throws -> T {
        do {
            let object: T = try JSONDecoder().decode(T.self, from: data)
            return object
        }
        catch let error {
            let vsError: VSError = VSError.Factory.makeDecodingError(cause: error)
            throw vsError
        }
    }
}
