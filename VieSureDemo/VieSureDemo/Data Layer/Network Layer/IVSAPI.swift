//
//  APIClient.swift
//  VieSureDemo
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
        catch {
            let error: VSError = VSError.makeDecodingError()
            throw error
        }
    }
}
